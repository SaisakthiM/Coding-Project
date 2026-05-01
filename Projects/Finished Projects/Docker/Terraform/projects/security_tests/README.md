

## Security Test - Terraform Ecosystem
This File has all the tests conducted to this terraform ecosystem and the fix for those issue

### Scans or Reconnaissance:

#### * Nmap Scan
```bash
nmap -sV -sC -p 80,443,8080,8000,9000,9001 localhost
Starting Nmap 7.98 ( [https://nmap.org](https://nmap.org) ) at 2026-05-01 16:54 +0530
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000099s latency).
Other addresses for localhost (not scanned): ::1

PORT STATE SERVICE VERSION
80/tcp open http nginx 1.29.8
|_http-server-header: nginx/1.29.8
|_http-title: Site doesn't have a title (application/octet-stream, application/json).
443/tcp closed https
8000/tcp closed http-alt
8080/tcp open tcpwrapped
9000/tcp closed cslistener
9001/tcp closed tor-orport

Service detection performed. Please report any incorrect results at [https://nmap.org/submit/](https://nmap.org/submit/) .
Nmap done: 1 IP address (1 host up) scanned in 11.36 seconds
```
As you can see, there are several ports opened like nginx one and tcpwrapped but there are important ports which are closed like tor-orport and https so we can conclude from this nmap scan that major ports are closed like mqsql or postgresql ports

#### _ gobuster enumerate dir scan
```bash
gobuster dir -u http://localhost/ -w /usr/share/dirb/wordlists/common.txt -t 20 --exclude-length 137
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url: http://localhost/
[+] Method: GET
[+] Threads: 20
[+] Wordlist: /usr/share/dirb/wordlists/common.txt
[+] Negative Status codes: 404
[+] Exclude Length: 137
[+] User Agent: gobuster/3.8.2
[+] Timeout: 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
blog (Status: 301) [Size: 169] [--> http://localhost/blog/]
social (Status: 301) [Size: 169] [--> http://localhost/social/]
Progress: 4613 / 4613 (100.00%)
===============================================================
Finished
===============================================================
```
There are actually 9 links in there with 9 different project only 2 was found, this concludes the project is not that easily exposed without the clear list

#### _ Script to scan all the ports
As you know, this project aldready uses nginx so we have a clear mapping of all ports now it's time to test all those response with curl

```bash
#!/bin/bash

paths=(

# Frontend apps
"/notes/"
"/bank/"
"/quiz/"
"/video/"
"/hospital/"
"/blog/"
"/social/"
"/api-service/"
"/document/"
"/intro/"

# API endpoints
"/notes/api/"
"/bank/api/"
"/video/api/"
"/api-service/api/"
"/document/api/"
"/hospital/api/"

# Blog specific
"/blog/admin/"
"/blog/admin/login/"
"/blog/api/"

# Social media
"/social/api/"
"/social/api/auth/me/"
"/social/api/metrics"
"/social/minio/"

# Spring Boot actuator
"/bank/api/actuator"
"/bank/api/actuator/health"
"/bank/api/actuator/env"
"/bank/api/actuator/mappings"

# Sensitive files
"/blog/robots.txt"
"/blog/.env"
"/.git/config"
"/document/api/admin/"
)

echo "=== Gateway Recon ==="
for path in "${paths[@]}"; do
  code=$(curl -o /dev/null -sw "%{http_code}" --max-time 3 http://localhost"$path")
  echo "$code => $path"
done
```

**and the result was**

```sh
./scan.sh
=== Gateway Recon ===
200 => /notes/
200 => /bank/
200 => /quiz/
200 => /video/
200 => /hospital/
200 => /blog/
200 => /social/
200 => /api-service/
200 => /document/
200 => /intro/
200 => /notes/api/
404 => /bank/api/
404 => /video/api/
200 => /api-service/api/
000 => /document/api/
404 => /hospital/api/
404 => /blog/admin/
404 => /blog/admin/login/
404 => /blog/api/
404 => /social/api/
401 => /social/api/auth/me/
404 => /social/api/metrics
403 => /social/minio/
404 => /bank/api/actuator
404 => /bank/api/actuator/health
404 => /bank/api/actuator/env
404 => /bank/api/actuator/mappings
404 => /blog/robots.txt
404 => /blog/.env
200 => /.git/config
000 => /document/api/admin/
```
don't get fooled by 200 OK response in /.git/config, the gateway is configured so any unknown path is served a response with working page like this ![alt text](image.png) so now almost all the other paths are secure at most, so there is no worry here

#### * Nikto Scan
```bash
nikto -h http://localhost

- Nikto v2.6.0
---------------------------------------------------------------------------
- Your Nikto installation is out of date.
- Target IP: 127.0.0.1
- Target Hostname: localhost
- Target Port: 80
- Platform: Unknown
- Start Time: 2026-05-01 19:30:58 (GMT5.5)
---------------------------------------------------------------------------
- Server: nginx/1.29.8
- No CGI Directories found (use '-C all' to force check all possible dirs). CGI tests skipped.
- [013587] /: Suggested security header missing: referrer-policy. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)
- [013587] /: Suggested security header missing: strict-transport-security. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
- [013587] /: Suggested security header missing: content-security-policy. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [013587] /: Suggested security header missing: x-content-type-options. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options)
- [013587] /: Suggested security header missing: permissions-policy. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy)
- [750004] /actuator/env: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/mappings: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/metrics: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/beans: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/configprops: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/loggers: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/threaddump: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/auditevents: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/httptrace: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/scheduledtasks: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/heapdump: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/jolokia: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [750004] /actuator/prometheus: Spring Boot Actuator endpoint exposed (valid JSON response). See: [https://docs.spring.io/spring-boot/docs/current/actuator-api/html/](https://docs.spring.io/spring-boot/docs/current/actuator-api/html/)
- [999967] /: Web Server returns a valid response with junk HTTP methods which may cause false positives.
- [001214] /doc: The /doc directory is browsable. This may be /usr/doc. See: [https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0678](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0678)
- [001582] /bank/: This might be interesting.
- [002739] /.htpasswd: Contains authorization information.
- [007203] /userdata.json: This might be interesting.
- [007204] /login.json: This might be interesting.
- [007205] /master.json: This might be interesting.
- [007206] /masters.json: This might be interesting.
- [007207] /connections.json: This might be interesting.
- [007208] /connection.json: This might be interesting.
- [007210] /PasswordsData.json: This might be interesting.
- [007211] /users.json: This might be interesting.
- [007212] /conndb.json: This might be interesting.
- [007213] /conn.json: This might be interesting.
- [007215] /accounts.json: This might be interesting.
- [007303] /JAMonAdmin.jsp: JAMon - Java Application Monitor Admin interface identified. Versions 2.7 and earlier contain XSS vulnerabilities. See: [https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-6235](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-6235)
- [007342] /: X-Frame-Options header is deprecated and was replaced with the Content-Security-Policy HTTP header with the frame-ancestors directive. See: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options)
- [007352] /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: [https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/](https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/)
- 8638 requests: 0 errors and 36 items reported on the remote host
- End Time: 2026-05-01 19:31:16 (GMT5.5) (18 seconds)
---------------------------------------------------------------------------
- 1 host(s) tested
```
this was the response, again no major leaking points here there are medium security concerns tho like /doc and /.htpasswd and another thing about the spring boot exposure there is a intresting fact about my project that is uniform catch-all response if any user gives out a request to a unmapped part of nginx it gives a 200 OK response instead of other response which can expose the state of the paths and sub-paths

```bash
location / {
return 200 '{"status":"gateway running","apps":["/notes/","/bank/","/quiz/","/video/","/hospital/","/blog/","/social/","/api-service/","/document/"]}';
add_header Content-Type application/json;
add_header Server ""; # hide nginx version
add_header X-Powered-By ""; # hide tech stack
}
```
so all those path enumeration is totally useless against this method but there is a catch, if the path changes locally for that app like this ![alt text](image-1.png) and the page refreshes ![alt text](image-2.png) the page is gone, this is a tradeoff we get, to fix this, we have to add base='/social/' in frontend but I had never the time because then it changes rest of the frontend configs too

### Severity Ratings

#### _ Low : Exposed /.git/config
`200 => /.git/config`
**The Fix :** It was a side-effect of uniform catch-all response that's why we got the 200 OK it is working as intended

#### _ Medium : Missing Security Header in Nginx
**The Fix :** add this to nginx.conf
```bash
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

#### * High : Exposed Spring Boot Actuator
**The Fix :** Aldready done, the uniform catch all response

### Exploits and Tests
#### * Response Test
