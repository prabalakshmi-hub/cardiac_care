#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "Praba";          // Your Wi-Fi SSID 
const char* password = "banu1234";  // Your Wi-Fi Password 
const char* apiKey = "ULB8DN5YFC5ECKDQ";     // Your ThingSpeak Write API Key 
const char* serverName = "https://api.thingspeak.com/update";  // ThingSpeak Update URL

struct HeartData {
  int age;        // Age
  int sex;       // Sex (0 = female, 1 = male)
  int cp;        // Chest Pain Type
  int trestbps;  // Resting Blood Pressure
  int chol;      // Cholesterol Level
  int thalach;   // Max Heart Rate Achieved
  int exang;     // Exercise-Induced Angina
  // Add more fields if necessary
};

HeartData dataBuffer[9];
int bufferIndex = 0;

void connectToWiFi() {
  Serial.print("Connecting to WiFi...");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("Connected to WiFi!");
}

void sendDataToThingSpeak(HeartData data) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    String url = String(serverName) + "?api_key=" + apiKey +
                 "&field1=" + String(data.age) +
                 "&field2=" + String(data.sex) +
                 "&field3=" + String(data.cp) +
                 "&field4=" + String(data.trestbps) +
                 "&field5=" + String(data.chol) +
                 "&field6=" + String(data.thalach) +
                 "&field7=" + String(data.exang);

    // Add more fields if necessary
    // Ensure to match the number of fields in your ThingSpeak channel

    url += "&field8=0"; // Placeholder for the 8th field if needed

    http.begin(url);
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("Server Response: " + response);
    } else {
      Serial.println("Error sending GET request.");
    }
    http.end();
  } else {
    Serial.println("WiFi not connected.");
  }
}

void generateHeartData() {
  if (bufferIndex < 9) {
    dataBuffer[bufferIndex].age = random(30, 80);
    dataBuffer[bufferIndex].sex = random(0, 2);
    dataBuffer[bufferIndex].cp = random(0, 4);
    dataBuffer[bufferIndex].trestbps = random(100, 200);
    dataBuffer[bufferIndex].chol = random(150, 300);
    dataBuffer[bufferIndex].thalach = random(100, 200);
    dataBuffer[bufferIndex].exang = random(0, 2);

    bufferIndex++;
    Serial.println("Data stored in buffer.");
  }

  if (bufferIndex >= 9) {
    for (int i = 0; i < bufferIndex; i++) {
      sendDataToThingSpeak(dataBuffer[i]);
    }
    bufferIndex = 0; // Reset buffer index after sending
  }
}

void setup() {
  Serial.begin(115200);
  connectToWiFi();
}

void loop() {
  generateHeartData();
  delay(5000);  // Generate new data every 5 seconds
}
