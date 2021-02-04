#define trigPin1 3
#define echoPin1 2
#define trigPin2 4
#define echoPin2 5
long duration, distance, RightSensor,LeftSensor;
int a=0,b=0;
void setup()
{
Serial.begin (9600);
pinMode(trigPin1, OUTPUT);
pinMode(echoPin1, INPUT);
pinMode(trigPin2, OUTPUT);
pinMode(echoPin2, INPUT);
pinMode(9, INPUT);
pinMode(10, INPUT);
}

void loop() {
SonarSensor(trigPin1, echoPin1);
RightSensor = distance;
SonarSensor(trigPin2, echoPin2);
LeftSensor = distance;
if(digitalRead(9)==HIGH)
  a=1;
else
  a=0;
if(digitalRead(10)==HIGH)
  b=1;
else
  b=0;
Serial.print(RightSensor);
Serial.print(" - ");
Serial.print(LeftSensor);
Serial.print(" - ");
Serial.print(a);
Serial.print(" - ");
Serial.println(b);
}

void SonarSensor(int trigPin,int echoPin)
{
digitalWrite(trigPin, LOW);
delayMicroseconds(2);
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
duration = pulseIn(echoPin, HIGH,500000);
distance = (duration/2) / 29.1;

}
