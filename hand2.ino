//Right Hand
#include <SoftwareSerial.h>
#define btnSave 2
#define btnA 3
#define btnB 4
#define btnC 5
int bpsave;
int bpA;
int bpB;
int bpC;
SoftwareSerial QuartzBT(10,11); //10->RX, 11->TX
void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
QuartzBT.begin(9600);  //Default Baud for comm, it may be different for your Module.
Serial.println("The bluetooth gates are open.\n Connect to HC-05 from any other bluetooth device with 1234 as pairing key!.");
pinMode(btnA, INPUT);
pinMode(btnB, INPUT);
pinMode(btnC, INPUT);
bpsave=0;
bpA=0;
bpB=0;
bpC=0;
}

void loop() {
  // put your main code here, to run repeatedly:
 int btnS = digitalRead(btnSave);
 int btn1 = digitalRead(btnA);
 int btn2 = digitalRead(btnB);
 int btn3 = digitalRead(btnC);
 if(btn1==1&&bpA==0){
    Serial.println("A High");
    QuartzBT.print("A");
  }

  if(btn2==1&&bpB==0){
    Serial.println("B High");
    QuartzBT.print("B");
  }

  if(btn3==1&&bpC==0){
    Serial.println("C High");
    QuartzBT.print("C");
  }

  if(btnS==1&&bpsave==0){
    Serial.println("S High");
    QuartzBT.print("S");
  }

  bpsave = btnS;
  bpA = btn1;
  bpB = btn2;
  bpC = btn3;
}
