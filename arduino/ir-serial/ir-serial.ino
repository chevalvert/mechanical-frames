#define SENSOR_A 4
#define SENSOR_B 5

int state_A = 0, pstate_A = 0;
int state_B = 0, pstate_B = 0;


void setup() {
  pinMode(SENSOR_A, INPUT);
  pinMode(SENSOR_B, INPUT);

  digitalWrite(SENSOR_A, HIGH);
  digitalWrite(SENSOR_B, HIGH);

  Serial.begin(9600);
}

void loop() {
  state_A = digitalRead(SENSOR_A);
  state_B = digitalRead(SENSOR_B);

  if (state_A != pstate_A) Serial.println((state_A == LOW) ? "A0" : "A1");
  if (state_B != pstate_B) Serial.println((state_A == LOW) ? "B0" : "B1");


  pstate_A = state_A;
  pstate_B = state_B;

  delay(25);
}


