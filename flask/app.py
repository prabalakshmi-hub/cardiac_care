from flask import Flask, jsonify, request
import joblib
import numpy as np
import requests
import os
import logging

# Initialize the Flask application
app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)

# Load the models
classification_model = joblib.load(r"C:\Users\hp\AndroidStudioProjects\cardiac_care_app\flask\models\classification_model.pkl")
regression_model = joblib.load(r"C:\Users\hp\AndroidStudioProjects\cardiac_care_app\flask\models\regression_model.pkl")

@app.route('/')
def home():
    return "Cardiac Care Monitoring API is Running"

# Function to retrieve data from ThingSpeak
def get_data_from_thingspeak():
    try:
        # Use the correct method to fetch the API key, either from environment variables or hard-code it
        api_key = '1QTUTSRVFEYIC64B'  # Temporarily hard-coded for testing. Replace this with os.getenv('THINGSPEAK_API_KEY') for production.
        channel_id = "2675255"  # Replace with your actual channel ID
        url = f"https://api.thingspeak.com/channels/{channel_id}/feeds.json?api_key={api_key}&results=1"

        logging.info(f"Requesting data from ThingSpeak: {url}")

        # Send a GET request to ThingSpeak
        response = requests.get(url)
        logging.info(f"Response Status Code: {response.status_code}")
        logging.info(f"Response Content: {response.text}")

        # Check if the request was successful
        response.raise_for_status()

        data = response.json()

        # Extract the required parameters from the ThingSpeak response
        feed = data['feeds'][0]  # Get the most recent feed
        age = int(feed['field1'])        # Age
        sex = int(feed['field2'])        # Sex (0 = female, 1 = male)
        cp = int(feed['field3'])         # Chest Pain Type
        trestbps = int(feed['field4'])   # Resting Blood Pressure
        chol = int(feed['field5'])       # Cholesterol Level
        thalach = int(feed['field6'])    # Max Heart Rate Achieved
        exang = int(feed['field7'])      # Exercise-Induced Angina (0 = no, 1 = yes)

        # Combine all these into an array suitable for model prediction
        current_data = np.array([[age, sex, cp, trestbps, chol, thalach, exang]])
        return current_data

    except (requests.HTTPError, KeyError, ValueError) as e:
        logging.error(f"Error retrieving data from ThingSpeak: {e}")
        return None  # Return None for error handling

# Predict current health status using the classification model
@app.route('/predict_status', methods=['GET'])
def predict_status():
    current_data = get_data_from_thingspeak()
    if current_data is None:
        return jsonify({'error': 'Failed to retrieve data from ThingSpeak'}), 500

    try:
        # Predict current status (Normal or Abnormal) using the classification model
        prediction = classification_model.predict(current_data)
        status = 'Abnormal' if prediction == 1 else 'Normal'
        return jsonify({'current_status': status})
    except Exception as e:
        logging.error(f"Error during status prediction: {e}")
        return jsonify({'error': 'Prediction failed'}), 500

# Predict future heart rate using the regression model
@app.route('/predict_future', methods=['GET'])
def predict_future():
    try:
        # Generate random heart rate history for prediction (replace with actual history if available)
        heart_rate_history = np.random.randint(60, 100, size=100).tolist()
        X_future = np.array(heart_rate_history[-3:]).reshape(1, -1)
        future_prediction = regression_model.predict(X_future)
        return jsonify({'predicted_future_heart_rate': float(future_prediction[0])})
    except Exception as e:
        logging.error(f"Error during future prediction: {e}")
        return jsonify({'error': 'Future prediction failed'}), 500

# Dummy login endpoint for testing
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    # Dummy login logic for demonstration
    if username == "test" and password == "password":
        return jsonify({'message': 'Login successful'})
    else:
        return jsonify({'error': 'Invalid username or password'}), 401

# Dummy signup endpoint for testing
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    # Dummy signup logic for demonstration
    return jsonify({'message': f'Signup successful for {username}'})

if __name__ == '__main__':
    # Set debug to True during development, and False in production
    app.run(debug=True)
