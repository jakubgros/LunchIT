import json


class PlacedOrderDataModel:

    def __init__(self, objAsJson):
        self.validate_json(objAsJson)

        self.data = json.loads(objAsJson)

    @staticmethod
    def validate_json(objAsJson):
        assert ("order_request_id" in objAsJson.keys())
        assert ("meals" in objAsJson.keys())

        for meal in objAsJson['meals']:
            assert ("food_name" in meal.keys())
            assert (meal.foodName is not None)
            assert (meal.foodName != "")

            assert ("price" in meal.keys())
            assert (meal.price is not None)
            assert (meal.price > 0)

            assert ("quantity" in meal.keys())
            assert (meal.quantity is not None)
            assert (meal.quantity > 0)
            assert (isinstance(meal.quantity, int))

            assert ("comment" in meal.keys())
            assert (meal.comment is not None)
