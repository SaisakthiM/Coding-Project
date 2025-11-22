/* This is a HTTP Server */
import http from 'http';

class Intro {
    http_text () {
        const server = http.createServer((req,res) => {
            res.write('Hi This is a message');
            res.end();
        }).listen(8080, () => {console.log("Server running on 8080")});
    }
    http_json () {
        const server = http.createServer((req,res) => {
            res.setHeader('Content-Type', 'application/json')
            res.end(`{
                name : sai,
                class : 12
            }`);
        }).listen(8080, () => {console.log("Server running on 8080")});
    }
    http_html() {
        const server = http.createServer((req,res) => {
            res.setHeader('Content-Type', 'text/html')
            res.end('<h1>Hello World</h1>');
        }).listen(8080, () => {console.log("Server running on 8080")});
    }
    

}