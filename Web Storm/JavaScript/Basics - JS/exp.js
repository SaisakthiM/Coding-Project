function rest_operator(){
    function foods(...foods) {
        console.log(foods);
    }
    let food1 = "pizza";
    let food2 = "burger";
    let food3 = "ham";
    let food4 = "cheese";

    const sum = (...arr) => arr.reduce((a, b) => a + b, 0);

    let a = 1;
    let b = 2;
    let c = 3;
    let d = 4;

    console.log(sum(a,b,c,d));

    foods(food1, food2, food3, food4);
}
rest_operator()

function callback() {
    // Ex 1
    hello(goodbye);
    function hello(callback) {
        callback();
        setTimeout(function() {
            console.log("Hello!");
        }, 3000)
        
    }
    function goodbye() {
        console.log("Goodbye!");
    }

    // Ex 2
    function sum(callback, x, y){
        let result = x+y;
        callback(result);
    }
    function display(result) {
        console.log(result);
    }
    sum(display, 2, 3)
}
callback()