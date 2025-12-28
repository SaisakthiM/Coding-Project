/* 
So what is this about 

here we will learn about what is networks and how it actually works 

so let's start actually with the main part
THE OSI MODEL 
this is important actually 
without this there is no thing such as networking 

*/

/*


THE OSI MODEL (Open System Interconnections)

OSI_Model
│
├─ Layer 1: Physical
│   ├─ Role: Transmits raw bits
│   ├─ Medium: Cables, fiber, radio waves
│   └─ Focus: Electrical / optical signals
│
├─ Layer 2: Data Link
│   ├─ Role: Frame delivery
│   ├─ Addressing: MAC addresses
│   ├─ Protocols: Ethernet, ARP
│   └─ Devices: Switches
│
├─ Layer 3: Network
│   ├─ Role: Packet routing
│   ├─ Addressing: IP (IPv4 / IPv6)
│   ├─ Protocols: IP, ICMP
│   └─ Devices: Routers
│
├─ Layer 4: Transport
│   ├─ Role: End-to-end communication
│   ├─ Protocols: TCP, UDP
│   ├─ Features:
│   │   ├─ Reliability (TCP)
│   │   ├─ Flow control
│   │   └─ Port numbers
│   └─ Security: Rate limiting, DoS handling
│
├─ Layer 5: Session
│   ├─ Role: Session management
│   ├─ Responsibilities:
│   │   ├─ Session creation
│   │   ├─ Maintenance
│   │   └─ Termination
│   └─ Examples: Sessions, cookies, tokens
│
├─ Layer 6: Presentation
│   ├─ Role: Data representation
│   ├─ Functions:
│   │   ├─ Encoding / decoding
│   │   ├─ Encryption / decryption
│   │   └─ Compression
│   └─ Examples: TLS, UTF-8, JSON
│
└─ Layer 7: Application
    ├─ Role: User-facing network services
    ├─ Protocols:
    │   ├─ HTTP / HTTPS
    │   ├─ FTP
    │   ├─ SMTP
    │   └─ DNS
    └─ Focus: APIs, web apps, authentication

this is the tree which represents the OSI model 
we are working on the level 2,3,4 most of the times
sometimes 5 if you are in web like cookies and those stuff

 */