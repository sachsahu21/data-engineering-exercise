import time
import json
import order
import logging
import argparse
from datetime import datetime, timezone

from confluent_kafka import Producer

parser = argparse.ArgumentParser()
parser.add_argument('--loglevel', required=False, default='WARNING', help='log level for printing')
parser.add_argument('--interval', required=False, type=int, help='interval for producing the messages, default to 60s', default=60)
args = parser.parse_args()

logger = logging.getLogger(__name__)
logging.basicConfig(level=getattr(logging, args.loglevel))

# Kafka broker details
bootstrap_servers = 'localhost:29092'
topic = 'orders'

# Create Kafka Producer
producer_conf = {
    'bootstrap.servers': bootstrap_servers,
    'client.id': 'orders-producer'
}

producer = Producer(producer_conf)

# global to store all callbacks to be sent
callbacks = []


# Function to push messages to Kafka topic
def produce_to_kafka(order_topic, published_order):
    logger.debug("producing to kafka: %s", published_order)
    producer.produce(order_topic, value=json.dumps(published_order).encode('utf-8'))
    producer.flush()


def process_pending_callbacks():
    global callbacks
    new_callbacks = []
    for callback in callbacks:
        callback_order = callback
        callback_order['updated_at'] = datetime.now(timezone.utc).isoformat()
        produce_to_kafka(topic, callback)
        callback_next_order = order.order_to_next_state(callback)
        if callback_next_order is not None:
            new_callbacks.append(callback_next_order)
        logger.debug("new callbacks: %s", callbacks)

    callbacks = new_callbacks


# Push messages periodically
try:
    logger.info("starting producer...")

    while True:
        try:
            logger.info("processing batch...")
            process_pending_callbacks()
            if order.should_have_order():
                logger.debug("have order this batch...")
                new_order = order.generate_order()
                logger.debug("order: %s", new_order)
                produce_to_kafka(topic, new_order)
                next_order = order.order_to_next_state(new_order)
                logger.debug("next order: %s", new_order)
                if next_order is not None:
                    logger.debug("appending next order")
                    callbacks.append(new_order)
                    logger.debug("callbacks: %s", callbacks)
            else:
                logger.debug("no order this batch...")
        except KeyboardInterrupt as kie:
            raise kie
        except Exception as e:
            logger.error(e, exc_info=1)
        time.sleep(args.interval)
except KeyboardInterrupt:
    pass
finally:
    producer.flush()
