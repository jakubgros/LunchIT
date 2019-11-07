import json


class PlacedOrderDataModel:

    def __init__(self, jsonDict):
        self.validate_json(jsonDict)

        self.data = jsonDict

    @staticmethod
    def validate_json(jsonDict):
        pass #TODO
