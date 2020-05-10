#include <Arduino.h>
#include "idris_arduino.h"
void idrard_digitalWrite(int pin, int val)
{
    digitalWrite(pin, val);
}

void idrard_pinMode(int pin, int mode)
{
    pinMode(pin, mode);
}

void idrard_delay(int ms) {
    delay(ms);
}
