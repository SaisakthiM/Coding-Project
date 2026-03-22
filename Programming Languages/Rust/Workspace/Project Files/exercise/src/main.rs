#![allow(unused)]
#![allow(non_snake_case)]

use std::{ascii::escape_default, cmp::Ordering, io::{Read, Write, stdin, stdout}};
use rand::prelude::*;
fn add_2() {
    let mut x : String = String::from("");
    let mut y : String = String::from("");

    println!("Enter value 1 : ");
    stdin().read_line(&mut x).expect("Error : cannot recieve input");

    println!("Enter value 2 : ");
    stdin().read_line(&mut y).expect("Error : cannot recieve input");

    let fin1: i32 = x.trim().parse().expect("wrong input");
    let fin2: i32 = y.trim().parse().expect("wrong input");

    println!("{}", fin1+fin2);
}

fn int_to_str(a: i32) -> String{
    let x : String = i32::to_string(&a);
    return x;
}

enum Calc {
    Addition, 
    Subtraction,
    Multiplication, 
    Division
}

fn calculator(a: i64, b: i64, operation: Calc) -> i64{
    match operation {
        Calc::Addition => a+b,
        Calc::Subtraction => a-b,
        Calc::Multiplication => a*b,
        Calc::Division => a/b,
    }
}

fn is_odd_even(a: u32) -> String{
    if a % 2 == 0 {
        String::from("It is Even number")
    }
    else {
        String::from("It is Odd number")
    }
}

fn loops(a: u32) {
    for i in (1..a).step_by(2) {
        println!("{}", i);
    }
}

fn calculate_age(DOB : i32) -> i32 {
    let CURRENT_YEAR = 2026;
    return CURRENT_YEAR - DOB;
}

fn calculate_area() -> f64{
    let mut diameter: String = String::from("");
    println!("Enter an diameter : ");
    stdin().read_line(&mut diameter).expect("Error cannot get input");
    let val: f64 = diameter.trim().parse().expect("error might happen");
    let area: f64 = (3.14 * val * val)/4.0;
    return area;

}

fn is_prime(val: u64) -> bool{
    for i in 2..=(val as f64).sqrt() as u64 {
        if val % i == 0 {
            return false;
        }
    }
    return true;
}



fn get_input() {
    let mut input = String::from("");
    println!("Enter a number : ");
    stdin().read_line(&mut input).expect("Error cannot read the line");
    let fin: i32 = input.trim().parse().expect("Cannot parse into int");
    let mut rng = rand::rng();
    let val = rng.random_range(1..=10);

    let cmpare = || {
        match fin.cmp(&val) {
            Ordering::Less => "less",
            Ordering::Greater => "more",
            Ordering::Equal => "win",
        };
    };

    if val == fin {
        println!("Your prediction was right, the number is : {}", fin);
    }
    
    else {
        let mut input: String = String::from("");
        println!("Do you want to see the Number (Yes/No) : ");
        stdin().read_line(&mut input).expect("Error cannot read the line");
        match input.as_str() {
            "Yes" => println!("Your prediction was Wrong, the number is : {}, Your Guess is : {}", val, input),
            "No" => {
                print!("Your Guess was : {:?}", cmpare());
            }
            _ => println!("Wrong Option")
        }
        
    }
    

}

fn main() {
    get_input();
}
