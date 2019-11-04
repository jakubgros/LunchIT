import json


class UnitOrderDataModel:

    def __init__(self, objAsJson):
        self.validate_json(objAsJson)

        self.data = json.loads(objAsJson)

    @staticmethod
    def validate_json(objAsJson):
        assert ("orderRequestId" in objAsJson.keys())
        assert ("meals" in objAsJson.keys())

        for meal in objAsJson['meals']:
            assert ("foodName" in meal.keys())
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
