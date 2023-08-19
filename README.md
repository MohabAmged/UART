# UART
The Universal Asynchronous serial Receiver and Transmitter (UART) is a highly flexible serial communication device Wrote In VHDL And Synthesized For Spartan-7 . 
The main features are:
- Full Duplex Operation (Independent Serial Receive and Transmit Registers).
- Asynchronous Operation. 
- 8 Bit Frame & 1 Stop bit. 
- No Parity.

# Frame 
The Uart Transmit and Receive a Frame Consists of 1 Stop Bit + 8 Data Bits + 1 Stop bit only. ( Can't Be Configured For Now )

![image](https://github.com/MohabAmged/UART/assets/68222258/d1603262-bc81-4010-9b32-de71985d6f43)

# Block Diagram 
The Architecture of my Uart is a very simple one it consits of 
- Baud Genrator
- Receiver Module
- Transmitter Module
 
![image](https://github.com/MohabAmged/UART/assets/68222258/3214dc8d-8b1a-47b7-afb5-68588b295755)

# Baud Rate Genrator 
- Divisor Registers (16 Bits )
- Counter
- Clock Input
- Baud Rate Clock Output
- Schematic  :
 
![Screenshot 2023-08-19 091102](https://github.com/MohabAmged/UART/assets/68222258/275ba8c0-a9a4-4ea7-8c26-33f257b0af46)

# Transmitter
- TX Register
- TX Shift Register
- Finite State Machine Coding Style.
- Schematic  :

 ![image](https://github.com/MohabAmged/UART/assets/68222258/d9d33cb3-49db-4ad6-b7c7-9d6d1f36f2d6)

# Receiver
- RX Register
- RX Shift Register
- Finite State Machine Coding Style.
- Schematic  :

![image](https://github.com/MohabAmged/UART/assets/68222258/460c48b4-5bcc-41fe-bf97-8c2ac558f4dc)

# Full Design Schematic

![Screenshot (309)](https://github.com/MohabAmged/UART/assets/68222258/4a8a9afe-5f76-4230-b709-27cc4e2f7283)

# Simulation Results
Sending and Receiving The Same Frame To The Module To Verify It's Function.

![Screenshot (307)](https://github.com/MohabAmged/UART/assets/68222258/87af7cd0-7ac8-4a24-8f6a-cf6e6eda8a1e)

![Screenshot (306)](https://github.com/MohabAmged/UART/assets/68222258/21ef8f59-26c0-46e3-89ab-21bf04abc4ea)

# Reference
https://www.ti.com/lit/ug/sprugp1/sprugp1.pdf?ts=1692370927336 

# Future Work 
- Adding Configurations Capabilities ( like Sending 5 , 6 , 7 bits And 2 Stop Bits ).
- Adding Fifo.
- Adding Parity Check.


