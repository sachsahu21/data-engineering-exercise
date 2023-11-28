import random
from enum import Enum


class DistributionCenter(Enum):
    SG_DC1 = 1
    SG_DC2 = 2
    SG_DC3 = 3
    MY_DC1 = 4
    MY_DC2 = 5
    PH_DC1 = 6
    PH_DC2 = 7
    TH_DC1 = 8
    VN_DC1 = 9
    HK_DC1 = 10
    HK_DC2 = 11


class Entity(Enum):
    ACME_SG = 1
    ACME_MY = 2
    ACME_PH = 3
    POCO_TH = 4
    POCO_VN = 5
    MQLO_HK = 6


class OrderState(Enum):
    PLACED = 'PLACED'
    CANCELLED = 'CANCELLED'
    PROCESSING = 'PROCESSING'
    SHIPPED = 'SHIPPED'
    AT_LAST_MILE_PROVIDER = 'AT_LAST_MILE_PROVIDER'
    DELIVERED = 'DELIVERED'
    REFUNDED = 'REFUNDED'
    PAYMENT_FAILED = 'PAYMENT_FAILED'


class PaymentMethod(Enum):
    CASH_ON_DELIVERY = 'CASH_ON_DELIVERY'
    APPLEPAY = 'APPLEPAY'
    GOOGLE_PAY = 'GOOGLE_PAY'
    CREDIT_CARD = 'CREDIT_CARD'
    PAYPAL = 'PAYPAL'
    ALIPAY = 'ALIPAY'
    ATOME = 'ATOME'


# State transitions
# Placed -> Processing -> Shipped -> Last Mile -> Delivered
# Placed -> Cancelled -> Refunded
# Placed -> Shipped -> Cancelled -> Refunded
# Assume:
# 1. once u reached shipped u cant cancel
STATE_TRANSITIONS = {
    OrderState.PLACED: {
        'states': [OrderState.PROCESSING, OrderState.CANCELLED, OrderState.PAYMENT_FAILED],
        'weights': [200, 50, 1]
    },
    OrderState.PROCESSING: {
        'states': [OrderState.SHIPPED, OrderState.CANCELLED],
        'weights': [2, 1]
    },
    OrderState.SHIPPED: {
        'states': [OrderState.AT_LAST_MILE_PROVIDER],
        'weights': [1]
    },
    OrderState.AT_LAST_MILE_PROVIDER: {
        'states': [OrderState.DELIVERED],
        'weights': [1]
    },
    OrderState.DELIVERED: None,  # terminal state
    OrderState.CANCELLED: {
        'states': [OrderState.REFUNDED],
        'weights': [1]
    },
    OrderState.REFUNDED: None,  # terminal state
    OrderState.PAYMENT_FAILED: None
}
