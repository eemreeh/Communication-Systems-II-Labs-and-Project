#include <SoftwareSerial.h>
#include <ServoTimer2.h>

ServoTimer2 servo1;

//6 derece = 50
int TS = 100; // ms - sampling period 
const int QUANT = 512; // quantization level
const int ENCOD = 9; // encoding bit number
const int QUANT2 = 32;
const int ENCOD2 = 5;
unsigned int r_rep = 4000; // compared value (desired sampling period / 16us) 

#define tx 2
#define rx 3
#define triggerPin 11
#define echoPin 12

int servopos = 750;
int goBack = 1;
int data2;

long duration, distance_cm;
int data;
char datastring[256];
char seq[ENCOD + ENCOD2 + 1];
SoftwareSerial bt(tx, rx);

void setup() {
  servo1.attach(9);

  cli(); //stop interrupts
  TCCR1A = 0; //reset control registers
  TCCR1B = 0;
  TCNT1  = 0;//initialize counter value to 0
  TCCR1B |= (1 << WGM12); // turn on CTC mode
  TCCR1B |= (1 << CS02) | (1 << CS00); // set prescalar to 256
  TIMSK1 |= (1 << OCIE1A); // enable compare match mode
  OCR1A = r_rep;
  sei(); // enable interrupts

  pinMode(triggerPin, OUTPUT);
  pinMode(echoPin, INPUT);

  bt.begin(9600);
    
  seq[ENCOD+ENCOD2] = '\0';
}
int button = '0';

void loop() {
}

ISR(TIMER1_COMPA_vect) {       // this part does sampling
  if(bt.available() > 0){
    button = bt.read();
  }
  if(button == '1'){
    if (servopos >= 2250) goBack = 0;
    else if (servopos <= 750) goBack = 1;
  
    if(goBack) servopos += 1500/30;
    else servopos -= 1500/30;
  }
  else{
    servopos = 2250-750;
  }  
  
  
  data2 = (servopos-750)/50;
  
  // sampling - how much period we will use - Ts value determines it
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(5);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);

  pinMode(echoPin, INPUT);
  duration = pulseIn(echoPin, HIGH);

  distance_cm = (duration / 2) / 29.1; //29.1 i değiştirebilirsin

  if (distance_cm >= 512) distance_cm = 511;

  // quantization - which level approximation we will use
  // actually the data is quantized for L = 1024 but we can change it
  data = (distance_cm * QUANT) / 512;  // quantization

  // encoding - which data form we send the signal
  for (int i = 0; i < ENCOD; i++) { //  encoding
    seq[ENCOD - 1 - i] = data % 2 + 48;
    data = data / 2;
  }

  for (int i = 0; i < ENCOD2; i++) { //  encoding
    seq[ENCOD2 + ENCOD - 1 - i] = data2 % 2 + 48;
    data2 = data2 / 2;
  }
  
  bt.write(seq);

  servo1.write(servopos);
}
