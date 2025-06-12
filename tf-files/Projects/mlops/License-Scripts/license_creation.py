import jwt
import datetime

# Define the data as a Python dictionary
data = {
    "license": {
        "product-name": "mlops",
        "product-version": "1.0b",
        "activation-date": "2024-03-01",
        "expiration-date": "2026-12-31",
        "heartbeat": 60,
        "maximum-users": 100,
        "maximum-business-unit": 5,
        "organization": "cloudangles",
        "features": {
            "properties": {
                "model-hub": True,
                "serving": True,
                "monitoring": True
            }
        }
    }
}

jwt_secret = 'KUjgytfkultyouyVKUvyi869o*^&Gfoujyhfvulujyhv'

# Generate the JWT token without an expiration time
token = jwt.encode(data, jwt_secret, algorithm="HS256")

print(token)