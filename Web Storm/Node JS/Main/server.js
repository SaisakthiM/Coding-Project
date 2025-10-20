import http from 'http';

const server = http.createServer((req,res) => {
    res.setHeader('Content-Type', 'text/html')
    res.end('<h1>Hello World</h1>');
}).listen(8080, () => {console.log("Server running on 8080")});