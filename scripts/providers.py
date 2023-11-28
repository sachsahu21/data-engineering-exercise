import constants

from faker.providers import BaseProvider


class OrderPriceProvider(BaseProvider):
    PRICE = [1, 2, 3.5, 3, 4]

    def price(self):
        return self.random_element(self.PRICE)

    def all_prices(self):
        return self.PRICE


class OrderEntityProvider(BaseProvider):
    ENTITIES = [e.name for e in constants.Entity]

    def entity(self):
        return self.random_element(self.ENTITIES)

    def all_entities(self):
        return self.ENTITIES


class OrderDCProvider(BaseProvider):
    DCS = [e.name for e in constants.DistributionCenter]

    def dc(self):
        return self.random_element(self.DCS)

    def all_dcs(self):
        return self.DCS


class OrderCountryProvider(BaseProvider):
    COUNTRIES = ['SG', 'MY', 'PH', 'TH', 'VN', 'PK', 'HK', 'TW', 'ID']

    def order_country(self):
        return self.random_element(self.COUNTRIES)

    def all_order_countries(self):
        return self.COUNTRIES


class OrderPaymentMethodProvider(BaseProvider):
    PMS = [e.name for e in constants.PaymentMethod]

    def payment_method(self):
        return self.random_element(self.PMS)

    def all_payment_methods(self):
        return self.PMS
