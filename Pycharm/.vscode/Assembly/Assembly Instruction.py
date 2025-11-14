"""
; Assembly Language:
; ====================
; Before Learning :
;
; A Computer have its processing units called processor
;
; A Processor is a set of transistor, very,very small 
; at sometime it has the size of 2nm. so a general processor contains
; billions of transistor. Each transistor is a switch that can be ON or OFF.
; Each transistor is connected to other transistor and it forms a logic gate.
; Multiple Logic gates craetes circuits
; A circuit is a path through which the current flows.
;
;billions of transistor. Each transistor is a switch that can be ON or OFF. this potint plays an important role
;
;the ON state or when current passes through , it is assigned value 1
; when OFF state , it is assigned 0 value
;
; this combination is also called binaries and each value is byte.
;
; combination of 8 bits is a byte.
;
; RAM (Random Access Memory):
;   As processors compute millions of computation in seconds , it also needs an storage place temporarily called RAM
;   This RAM Temporarily stores information and it is a Volatile Storage which means memory gets erased when it gets turned off
;
; Registers :
;    Registers are small amount of memory that is built into the processor. It is a volatile
;   It is built close to cpu to process so that
;
; Foundattion of Assembly Programming :
; Binary Numbers :
;
; There are different types of numeric system with different bases in computer programming 
;
; 1) Decimals (base = 10) : * it is the most commonly used in our daily life
;                           * each of the digits (from left to right) represents 10**n where n is its index position 
;                           * eg if we take number 15 , the 5 is the ones place because if we apply 10**0 it is 1 and (1) is the tenth place
;                           * if we add 1 * 10**0 and 5 * 10**1 we get the same 15.
; 2) Binary (base = 2) : * it is the only numeric system that computer can understand.
;                        * take a processor from an old compueter , break it and zoom as much as you can . you will find transistors 
;                        * an transistor is an semi-comductor which can either block or flow current 
;                        * the humans assigned blocking path of current the number and flow of current 1
;                        * so the compueter is not actually reading the number byt either blocking and passing trillions of transitors at once
;                        
;                        * take a number like 1010. now apply the same rule as we did to decimal
;                        * 0 * (2**0) + 1 * (2**1) + 0 * (2**2) + 1 * (2 ** 3) = 2 + 8 = 10
;                        * see , we got decimal value
;
; 3) octal (base = 8) : * Although is the least used in code or real life , there is no harm learning it 
;
; 4) hexa-decimal (base = 16) : * it is the third most used and it becomes most used in assembly beacuse of it also uses alphabets
;                               * unlike the above , the first 9 terms are 0-9 and next 6 are a-f
;
;
;
; x86 Architecture : 
;                   
; 1) CPU : It has many component inside it :                   
; * ALU
; * Control Unit
; * Registers
; * Clocks
;
; 2) Buses : Buses are wires which helps in communication between various devices 
;
; * Control Bus : It is a bus which heps to synchornize the data between various hardware 
; * Address Bus : It helps to transfer momory address between Memory Storage and CPU. So that cpu can use the data stored in Memory Storage
; * Data Bus : It helps to transfer the data from RAM to CPU and transfer instruction between Storage , CPU , I/O Devices
; 
; 
  CPU contains the Following units : 
  1) A high-frequency clock
  2) A Control unit
  3) ALU
  4) Storage locators known as registers
  
  Registers : they are close to cpu which cpu uses to store temp data and use it in fastest way
  
  CPU Clocks : 
  . Operations between CPU and bus are synchronized by an internal clock 
  . Ticks at a constant rate
  . Basic unit for instruction is a machine/clock cycle
  .Measured in oscillations per second (1 GHz = 1 billion times per second)
  
  My understanding : it is a clock where syncronise the data processed by the processor and transported by bus at given tick 
  In 1 Tick , 1 data is processed and 1 data is transported completing an cycle
  
  Control unit : 
  
  1) Uses a binary decoder to convert coded instructions into timing and control signals
  2) Direct the operation of other units (memory, ALU,  1/0)
  
  
  ================== Instruction Execution Cycle ==========================
  
  • The CPU completes a predefined set of steps
  to execute an instruction
  • The steps are:
  
  1. Fetch an instruction from the instruction queue
  2. Decode the instruction and check for operands
  3. If operands are involved, fetch the operands from memory/registers
  4. Execute the instruction and update status flags
  5. Store the result if required
  
  Called a fetch decode execute procedure
  
  
  Reading Forom Memory :
  
  Memory access is slower than register access
  
  • Requires the following steps:
  1. Place the address of the value you want to read on the address bus
  2. Changes the processor's RD pin (called assert)
  3. Wait one clock cycle for memory to respond
  4. Copy the data from the data bus to the destination
  Each step takes approximately one clock cycle
  • To compare, register access usually takes only one clock cycle
  
  Understandings : This process is similar to booking an hotel . 
  The first step involves the address bus allocating the space for the upcoming data
  The second step involves locking or using an pin to ensure that no other can access and the pin is give to data bus . 
  They wait for the tick and then the data using the key get into memory 
  
  and this overall process takes 4 clock cycle but for registers it only take 1 clock cycle
  
  Caching : 
  
  To reduce read/write time for memory, caches are used
  • In x86:
  • Level-1 cache is stored on the CPU
  • Level-2 cache is stored outside and accessed by high-speed data bus
  • Constructed using static RAM, which does not need to be refreshed constantly
  
  Modes Of Operation :
  
  Protected Mode: The native processor state
  Real Address Mode: Implements early Intel programming environment with the ability to switch modes
  System Management Mode: Provides an operating system with mechanisms for power management and security
  
  In protected mode , multiple processes can run but each is given its own section andcant interact with other processes . 
  This helps in reducing illegal processes among processes
  
  In real address mode , you can directly access the hardware using x86 assembly implemented in early intel processor.
  
  
  =============================================== Register Fundamentals ============================================================
  
  x86 is a 32-bit processor, each register is 32 bits in size 
  • Registers are divided into three categories: general-purpose, segment, and control registers
  • General-purpose registers are used for arithmetic and logical operations
  • Segment registers are used to store segment selectors
  • Control registers are used to control the processor's operation
  • Example registers: EAX, EBX, ECX,EDX
  • You can access just 16 bits by dropping the E, giving AX, BX,CX,DX
  • You can access 8-bit high: AH,BH,CH,DH ; high - right half of 16 bits
  • You can access 8-bit low: AL, BL, CL,DL ; low - left half of 16 bits
  
  Emamples :
  
  eax : Extended accumulator, automatically used by multiplication and division instructions
  ebx : General purpose
  ecx : Used as a loop counter by the CPU
  edx : General purpose
  esi : High speed memory transfer
  edi : High speed memory transfer
  ebp : Used to reference function parameters and local variables on the stack
  esp : A pointer to the current stack address
  
  Special Purpose Registers : 
  
  • EIP: The instruction pointer, points to the address of the next instruction
  • EFLAGS: Flags to denote the status of an operation:
  • CF (carry flag)
  • OF (overflow flag)
  • SF (sign flag)
  • ZF (zero flag)
  • AC (auxiliary carry)
  • PF (parity flag)
  
  
  
  ======================================= Programming =======================================================
  
  code int 80h : it is just the number 80 in hexa decimal used as an exit code status
               : int means interrupt not integer
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  """
  
  
