#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
#endif
#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7


#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h" //Can be download from the bottom of this article

#define MAX 100

#include <math.h>
#include <stdio.h>

// Reverses a string 'str' of length 'len'
void reverse(char* str, int len)
{
	int i = 0, j = len - 1, temp;
	while (i < j) {
		temp = str[i];
		str[i] = str[j];
		str[j] = temp;
		i++;
		j--;
	}
}
int intToStr(int x, char str[], int d)
{
	int i = 0;
	if(x==0)
	{
		str[i++] = '0';
	}
	while (x) {
		str[i++] = (x % 10) + '0';
		x = x / 10;
	}
	
	// If number of digits required is more, then
	// add 0s at the beginning
	while (i < d)
	str[i++] = '0';
	
	reverse(str, i);
	str[i] = '\0';
	return i;
}


// Converts a floating-point/double number to a string.
void ftoa(float n, char* res, int afterpoint)
{
	// Extract integer part
	int ipart = (int)n;
	
	// Extract floating part
	float fpart = n - (float)ipart;
	
	// convert integer part to string
	int i = intToStr(ipart, res, 0);
	
	// check for display option after point
	if (afterpoint != 0) {
		res[i] = '.'; // add dot
		
		// Get the value of fraction part upto given no.
		// of points after dot. The third parameter
		// is needed to handle cases like 233.007
		fpart = fpart * pow(10, afterpoint);
		
		intToStr((int)fpart, res + i + 1, afterpoint);
	}
}


int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	Lcd4_Init();
	
	unsigned char result_L;
	unsigned char result_H;
	DDRB = 0xFF;
	
	ADMUX = 0b00100101; //REFS0-1 = 00 -> AREF
						// ADLAR = 1 -> Left adjust
						// MUX4:0 = 00101 -> ADC5 AS INPUT
	ADCSRA = 0b10000100; // ADEN = 1
							// ADSC = 0
							// ADATE = 0
							// ADIF = 0
							// ADIE = 0
							// ASPS2:0 = 100 (prescaler = 16)
	
	Lcd4_Set_Cursor(1,1);
	Lcd4_Write_String("Voltage :");
	while(1)
	{
		
		ADCSRA |= (1 << ADSC);
		
		while (ADCSRA & (1<<ADSC))
		{	
		}
		
		result_L = ADCL;
		result_H = ADCH;
		float voltage = ((result_H<<2)|(result_L>>6))*(4.00/1024); //ADC 10 Bits /multiplying with step size   
		
		char buf[MAX];
		ftoa(voltage+0.00,buf,2);
		Lcd4_Set_Cursor(1,11);
		Lcd4_Write_String(buf);
		free(buf);
		                                                                                                                                 
	}
	return 0;
}