use std::{any::{Any, TypeId}, fs::read, ptr::NonNull, string};
use std::any::type_name;
use std::fs;

fn is_even(num: i32) -> bool{
    if num % 2 == 0 {
        return true;
    }
    else {
        return false;
    }
}

fn fibonacci(num: u32) -> u32{
    if num <= 1 {
        return num;
    }
    else {
        return fibonacci(num-1) + fibonacci(num-2);
    }
}

fn fib(num: u64) -> u64 {
    let mut first: u64 = 0;
    let mut second: u64 = 1;
    if num == 0 {
        return 0;
    }
    if num == 1 {
        return 1;
    }
    for i in 1..num-2 {
        let temp = second;
        second = second + first;
        first = temp;
    }
    return second;
}

fn get_str_len(string: &str) -> usize {
    return string.len();
}

struct User {
    username : String,
    password: String,
    email: String,
    contact: u64
}

struct Rect {
    width: u32,
    height: u32,
}

impl Rect {
    fn area(&self) -> u32 {
        self.width * self.height
    }
    fn perimeter(&self, num: i32) -> u32{
        2 * (self.width +  self.height)
    }
    fn debug() -> i32 {
        1
    }
}

enum Direction {
    North ,
    South, 
    East, 
    West
}

enum Shape {
    Rectangle(f64, f64), 
    Circle(f64)
}

fn area(shape: Shape) -> f64{
    match shape {
        Shape::Rectangle(a, b) => a*b,
        Shape::Circle(a) => 3.14 * a*a,
    }
}


fn return_string(input: Option<String>) -> Option<String> {
    match input {
        Some(s) => Some(s),
        None => None,
    }
}

fn main() {
    println!("{}", is_even(2));
    println!("{}", fibonacci(3));
    println!("{}", fib(3));
    println!("{}", get_str_len("his"));
    let user = User {
        username: String::from("sai"),
        password: String::from("saisakthi"),
        email: String::from("s"),
        contact: 9988877223 };
    println!("{:?}", user.username);
    let rect = Rect {
        width : 4,
        height: 8,
    };
    println!("{}", rect.area());
    println!("{}", rect.perimeter(2));
    print!("{}", Rect::debug());

    let rectangle =  Shape::Rectangle(32.2, 44.5);
    let circle =  Shape::Circle(3.2);

    println!("{}",area(rectangle));
    println!("{}",area(circle));
    println!("{:?}",return_string(Some(String::from("hi"))));
    let a: Option<String> = None;
    println!("{:?}", a);
    let file = fs::read_to_string("i.txt");
    let mut a = 10;
    let mut b = &mut a;

    ret(b);
    println!("{}",b);
    println!("{}",b);
}

fn ret(c: &mut i32) {
    *c = 10;
    println!("{}",c);
}
