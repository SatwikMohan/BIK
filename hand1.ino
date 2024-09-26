//Left Hand
#include <SoftwareSerial.h>
#define btna 3
#define btnb 4
#define btnc 5
int bpa;
int bpb;
int bpc;
SoftwareSerial QuartzBT(10,11); //10->RX, 11->TX
void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
QuartzBT.begin(9600);  //Default Baud for comm, it may be different for your Module.
Serial.println("The bluetooth gates are open.\n Connect to HC-05 from any other bluetooth device with 1234 as pairing key!.");
pinMode(btna, INPUT);
pinMode(btnb, INPUT);
pinMode(btnc, INPUT);
bpa=0;
bpb=0;
bpc=0;
}

void loop() {
  // put your main code here, to run repeatedly:
 int btn1 = digitalRead(btna);
 int btn2 = digitalRead(btnb);
 int btn3 = digitalRead(btnc);
 if(btn1==1&&bpa==0){
    Serial.println("a High");
    QuartzBT.print("a");
  }

  if(btn2==1&&bpb==0){
    Serial.println("b High");
    QuartzBT.print("b");
  }

  if(btn3==1&&bpc==0){
    Serial.println("c High");
    QuartzBT.print("c");
  }
  bpa = btn1;
  bpb = btn2;
  bpc = btn3;
}
