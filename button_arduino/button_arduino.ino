// ikeda

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(7, INPUT);
  pinMode(6, INPUT);
  pinMode(5, INPUT);
  pinMode(4, INPUT);
}
int a, b, c, d, sum;
void loop() {
  // put your main code here, to run repeatedly:
  int sw7 = digitalRead(7);
  int sw6 = digitalRead(6);
  int sw5 = digitalRead(5);
  int sw4 = digitalRead(4);
  if (sw7 == HIGH) {
    d = 1;
  } else  if (sw7 == LOW) {
    d = 0;
  }
  if (sw6 == HIGH) {
    c = 1;
  } else  if (sw6 == LOW) {
    c = 0;
  }
  if (sw5 == HIGH) {
    b = 1;
  } else  if (sw5 == LOW) {
    b = 0;
  }
  if (sw4 == HIGH) {
    a = 1;
  } else  if (sw4 == LOW) {
    a = 0;
  }
  sum = a * 8 + b * 4 + c * 2 + d;
  Serial.write(sum);
  delay(10);
}
