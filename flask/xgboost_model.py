import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
import xgboost as xgb
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import joblib  # For saving the model

# Load your dataset
data = pd.read_csv(r'C:\Users\hp\AndroidStudioProjects\cardiac_care_app\flask\heart_disease_data.csv')  # Replace with your dataset file

print(data.head())

# Define features and target variable for classification
X = data[['age', 'sex', 'cp', 'trestbps', 'chol', 'thalach', 'exang']]  # Features for classification
y = data['target']  # Target variable

# Split the dataset into training and testing sets for classification
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the classification model
classification_model = xgb.XGBClassifier(use_label_encoder=False, eval_metric='logloss')
classification_model.fit(X_train, y_train)

# Make predictions and evaluate the model
y_pred = classification_model.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)
print("Classification Accuracy:", accuracy)
print("Classification Report:\n", classification_report(y_test, y_pred))
print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))

# Save the classification model
joblib.dump(classification_model, r'C:\Users\hp\AndroidStudioProjects\cardiac_care_app\flask\models\classification_model.pkl')  # Save the classification model in .pkl format

# Dummy heart rate data for regression model
heart_rate_history = np.random.randint(60, 100, size=100).tolist()  # Replace with your actual historical data

X_future = []
y_future = []

# Create future data for prediction based on the last 3 heart rates
for i in range(3, len(heart_rate_history)):
    X_future.append(heart_rate_history[i-3:i])  # Last 3 heart rates
    y_future.append(heart_rate_history[i])  # The current heart rate to predict

X_future = np.array(X_future)
y_future = np.array(y_future)

# Train the regression model
regression_model = xgb.XGBRegressor()
regression_model.fit(X_future, y_future)

# Save the regression model
joblib.dump(regression_model, r'C:\Users\hp\AndroidStudioProjects\cardiac_care_app\flask\models\regression_model.pkl')  # Save the regression model in .pkl format

# Make a future prediction based on the last input
last_input = X_future[-1].reshape(1, -1)  # Get the last input for prediction
future_prediction = regression_model.predict(last_input)  # Predict the next heart rate value

print(f"Predicted Future Heart Rate: {future_prediction[0]}")  # Display the predicted future heart rate

print("Models saved successfully!")
