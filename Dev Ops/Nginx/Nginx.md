/*

Before we dive deeper into what is nginx and how it is used we have to know a bit of backend first

1) Web Server : a web server is generally a physical device server which is used purely for 
handling request from users(i.e request and response)

so now all these are just physical but handles software request 
how will and how can it handle
here comes nginx

Nginx is a high performace web server program specialized handling http request 

This is NGINX as web server

now, NGINX also evolved into the space of a proxy server
proxy just means taking the work of one's behalf

so now there are many uses to NGINX as a proxy server

1) Security : 
Imagine if we expose all the servers needed to run the app into public
yep, it's chaos
instead we can privatize that and just only use the main server configured with NGINX
so if we can protect this, we can now protect all easier
by also only accepting SSL certified and protected via HTTPS

2) Load Balancer : 
So imagine there is many servers and multiple users send a request to a server
now the server get's overloaded. 
so in this case we can also use NGINX as a load balancer

3) Caching : 
Imagine there is a traffic spike on a single repetitive request
so nginx as a proxy redirects the request and the request fetches the data and send it back
sound's good but think of millions of request now
it's unnecessary
what NGINX also can do is store the most fetched request and instead of redirecting, it just sends the data directly
to the client if it sees that it has that data
























 */