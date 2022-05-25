# Multi-Peripheral-Implementation

The purpose of this project was to connect several different peripheral devices to the Basys 3 FPGA board. This was to be accomplished by connecting a Keypad, LCD, 
RGB as well as utilizing the onboard LEDs available on the Basys 3 board. 
The idea was that the user would input either a “1” or  a “2” on the keypad to perform a certain task. The LCD would then display this selection and send the “On” 
signal to the desired tasks module. If the RGB was selected, the RGB, which was connected to one of the Pmod Connectors, would toggle through 
the eight available options on the RGB every one second. If “2” was selected then half of the onboard LEDs would light up with a 90% duty cycle while the other half 
would light up with a 5% duty cycle. Every one second, this assignment would change to where the ones assigned with 90% would get 5% and vice versa. 

Overall, the project outcome was exactly as expected. Every module worked seamlessly with one another. 
Arguably the most difficult part of this project was designing the LCD. Knowing how to initialize the LCD, as well as creating the state machine for the 
LCD was a daunting task that did not leave any room for error. Aside from this aspect of the project, everything worked out fairly well.
