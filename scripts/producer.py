import time
import json
import order
import logging
import argparse
from datetime import datetime, timezone

from confluent_kafka import Producer

parser = argparse.ArgumentParser()
parser.add_argument('--loglevel', required=False, default='WARNING', help='log level for printing')
parser.add_argument('--interval', required=False, type=int, help='interval for producing the messages, default to 20s',
                    default=20)
args = parser.parse_args()

logger = logging.getLogger(__name__)
logging.basicConfig(level=getattr(logging, args.loglevel))

bootstrap_servers = 'localhost:29092'
topic = 'orders'

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


# process all pending state transitions into new state assuming there's a new state to transition to
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
    logger.info("processing %d pending callbacks", len(new_callbacks))

    callbacks = new_callbacks


try:
    logger.info("starting producer...")

    while True:
        try:
            logger.info("processing current time interval: %s...", datetime.now(timezone.utc).isoformat())
            process_pending_callbacks()
            if order.should_have_order():
                logger.debug("have order during this interval...")
                new_order = order.generate_order()
                logger.debug("order: %s", new_order)
                produce_to_kafka(topic, new_order)
                next_order = order.order_to_next_state(new_order)
                logger.debug("next order: %s", new_order)
                if next_order is not None:
                    logger.debug("appending next order")
                    callbacks.append(new_order)
                    logger.debug("callbacks: %s", callbacks)
                logger.info("published new order event...")
            else:
                logger.debug("no order during this interval...")
                logger.info("no new order event during this interval...")
        except KeyboardInterrupt as kie:
            raise kie
        except Exception as e:
            logger.error(e, exc_info=1)
        time.sleep(args.interval)
except KeyboardInterrupt:
    pass
finally:
    producer.flush()
