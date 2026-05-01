## Security Test - Terraform Ecosystem

This File has all the tests conducted to this terraform ecosystem and the fix for those issue 

## Scans : 

* Nmap Scan 

```
nmap -sV -sC -p 80,443,8080,8000,9000,9001 localhost
Starting Nmap 7.98 ( https://nmap.org ) at 2026-05-01 16:54 +0530
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000099s latency).
Other addresses for localhost (not scanned): ::1

PORT     STATE  SERVICE    VERSION
80/tcp   open   http       nginx 1.29.8
|_http-server-header: nginx/1.29.8
|_http-title: Site doesn't have a title (application/octet-stream, application/json).
443/tcp  closed https
8000/tcp closed http-alt
8080/tcp open   tcpwrapped
9000/tcp closed cslistener
9001/tcp closed tor-orport

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.36 seconds
```

As you can see, there are several ports opened like nginx one and tcpwrapped
but there are important ports which are closed like tor-orport and https 

so we can conclude from this nmap scan that major ports are closed like mqsql or postgresql ports

* gobuster enumerate dir scan

``` 

```



