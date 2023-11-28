import random
import uuid
import providers
import constants
from datetime import timezone, datetime

from faker import Faker

fake = Faker()
fake.seed_instance(1123)  # fixed seed
fake.add_provider(providers.OrderPriceProvider)
fake.add_provider(providers.OrderEntityProvider)
fake.add_provider(providers.OrderDCProvider)
fake.add_provider(providers.OrderCountryProvider)
fake.add_provider(providers.OrderPaymentMethodProvider)


def generate_order():
    return {
        'customer': {
            'name': fake.name(),
            'address': fake.address(),
            'mobile_number': fake.phone_number()
        },
        'shipping_address': fake.address(),
        'country': fake.order_country(),
        'user_agent': fake.user_agent(),
        'currency': fake.currency_code(),
        'total_price': fake.price(),
        'order_id': str(uuid.uuid4()),
        'is_member': fake.pybool(),
        'payment_method': fake.payment_method(),
        'quantity': random.randint(1, 20),
        'status': constants.OrderState.PLACED.name,
        'entity': fake.entity(),
        'shipped_distribution_center': fake.dc(),
        'created_at': datetime.now(timezone.utc).isoformat(),
        'updated_at': datetime.now(timezone.utc).isoformat()
    }


def next_state(curr_state):
    transition = constants.STATE_TRANSITIONS[constants.OrderState(curr_state)]
    if transition is None:
        return None
    return random.choices(transition['states'], transition['weights'], k=1)


def order_to_next_state(curr_order):
    state = next_state(curr_order['status'])
    if state is None:
        return None
    curr_order['status'] = state[0].name
    return curr_order


def should_have_order(percent=50):
    return random.randrange(0, 100) > percent


