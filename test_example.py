# Example file for testing Neocomplete
# Select any function below and use :NeocompleteGenerate to transform it

def add(a, b):
    return a + b


def divide(a, b):
    return a / b


def fetch_data(url):
    import requests
    response = requests.get(url)
    return response.json()


def process_list(items):
    result = []
    for item in items:
        if item > 0:
            result.append(item * 2)
    return result


class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age


# Try these prompts:
# 1. Select add() -> "add type hints and docstring"
# 2. Select divide() -> "add error handling for division by zero"
# 3. Select fetch_data() -> "add error handling and timeout"
# 4. Select process_list() -> "use list comprehension"
# 5. Select User class -> "add __repr__ and __eq__ methods"
