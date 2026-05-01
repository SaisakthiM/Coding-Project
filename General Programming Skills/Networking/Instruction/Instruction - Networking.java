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

so this is the level, most of us stay on level 6 or 7 some on 5 
but the real deal is below there at 4

at 4, the networks the base of it all is ip and mac address
let's learn that
 */

/* 

IP Address and MAC Address 

so simply put, IP address is a unique address for a computer or generally a device
it is comprised of 32 bit unique integer seperated as 8 bits

like this 

192.168.8.1

this is a unique ip address 
you can think why it is in like 192 not 01010111
it is converted one 

2**8 = 256 - 1 = 255 

this is the limit of the decimal number can be fitted in a 8 bit place 
the range is 0.0.0.0 to 255.255.255.255
that is 0-255 ** 4 = 4228250625 unique number of combination
you can think this is a large number but after dot com boom, many devices including smartphone and IoT were created and this was not at all enough
this version was IPv4 and it was solved using classes and IPv6 
so what are classes

it is a classification of IP address intended to solve the issue.

Class A (0.0.0.0 - 127.255.255.255): Designed for large networks, supporting over 16 million hosts per network.T
he first 8 bits represent the network, and 24 bits for hosts.

Class B (128.0.0.0 - 191.255.255.255): Used for medium-sized networks, supporting 65,534 hosts. 
The first 16 bits are for the network and 16 bits for hosts.C

lass C (192.0.0.0 - 223.255.255.255): Used for small networks, supporting 254 hosts. 
The first 24 bits are for the network and 8 bits for hosts.

Class D (224.0.0.0 - 239.255.255.255): Reserved for multicast groups, where data is sent to multiple devices simultaneously.

Class E (240.0.0.0 - 255.255.255.255): Reserved for experimental, research, or future use

These are the 5 classes for IPv4 and it solved issue for some time 

now the new IPv6 has a massive range of 128 bit seperated by 8 and hex decimal is used 
all devices use this hybrid of IPv4 classes and IPv6 as fallback model now here is a example

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 2c:58:b9:34:2c:bd brd ff:ff:ff:ff:ff:ff
    altname enp4s0
    altname enx2c58b9342cbd
4: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 60:45:2e:9a:47:d2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.227/24 brd 192.168.31.255 scope global dynamic noprefixroute wlan0
       valid_lft 22591sec preferred_lft 22591sec
    inet6 2409:40f4:112f:6117:14a2:5919:4a8e:e225/64 scope global dynamic noprefixroute 
       valid_lft 11032sec preferred_lft 11032sec
    inet6 fe80::4964:5854:1b7f:5b54/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: br-b7593951107d: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether ce:32:f6:d5:66:39 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-b7593951107d
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether fe:28:d4:1f:87:bd brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever

see that inet, it is IPv4 and inet6 is IPv6

the ether part is the unique MAC address (Media Access Control) for a device







*/