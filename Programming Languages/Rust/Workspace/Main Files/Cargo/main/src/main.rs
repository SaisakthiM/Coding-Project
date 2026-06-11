use std::clone;
use std::collections::{HashMap, hash_map};
use std::hash::Hasher;
use std::io::{self, Split};
use std::fs::read_to_string;
use std::num::ParseIntError;
use std::ops::Div;

fn main() {
    let content = read_to_string("hi.txt")
        .unwrap_or_else(|_| String::new());

    let mut counts: HashMap<char, usize> = HashMap::new();

    for ch in content.chars() {
        *counts.entry(ch).or_insert(0) += 1;
    }

    println!("{counts:?}");
}


fn get_input(x: &mut String) {
    io::stdin().read_line(x).expect("Failed to read line");
}

fn filter_even_numbers(values: &Vec<i32>) -> Vec<i32> {
    let iterable = values.iter();
    let mut filtered_numbers: Vec<i32> = vec![];
    for items in iterable {
        if items % 2 == 0 {
            filtered_numbers.push(*items);
        }
    }
    return filtered_numbers;

}

fn string_lengths(words: &Vec<String>) -> Vec<usize> {
    let mut lenght_words: Vec<usize> = vec![];
    for word in words.iter() {
        lenght_words.push(word.len());
    }
    return lenght_words;
}

fn sum(values: &[i32]) -> i32 {
    let mut sum: i32 = 0;
    for &value in values.iter() {
        sum += value
    }
    return sum;
}

fn uppercase_all(words: &Vec<String>) -> Vec<String> {
    let mut res: Vec<String> = vec![];
    for word in words.iter() {
        res.push(word.to_owned().to_uppercase());
    }
    return  res;
}

fn count_occurrences(values: &[i32]) -> HashMap<i32, usize> {
    let mut map: HashMap<i32, usize> = HashMap::from([]);
    for value in values.iter() {
        map.entry(*value).and_modify(|count| {*count += 1}).or_insert(1);
    }
    return map;
}

struct User {
    name: String,
    age: u32,
}

fn adults(users: &Vec<User>) -> Vec<String> {
    let mut res: Vec<String> = vec![];
    for user in users.iter() {
        if user.age >= 18 {
            res.push(String::from(&user.name));
        }
    }
    return res;
}

trait Area {
    fn area(&self) -> f64;
}

struct Rectangle {
    width: f64,
    height: f64
}

impl Area for Rectangle {
    fn area(&self) -> f64 {
        return self.width * self.height;
    }
}

fn youngest(users: &Vec<User>) -> Option<&User> {
    users.iter().min_by(|a, b| a.age.cmp(&b.age))
}

fn parse_number(s: &str) -> Result<i32, ParseIntError> {
    s.parse::<i32>()
}

enum OrderStatus {
    Pending,
    Paid,
    Shipped,
    Delivered,
}

fn can_ship(status: &OrderStatus) -> bool {
    match status {
        &OrderStatus::Pending => true,
        &OrderStatus::Paid => true,
        &OrderStatus::Shipped => false,
        &OrderStatus::Delivered => false,
    }
}

fn even_numbers(values: &[i32]) -> Vec<i32> {
    values.iter().filter(|&&x| x.div(2) == 0).copied().collect()
}

fn convert(values: Vec<String>) -> Vec<usize> {
    values.iter().map(|x| x.len()).collect()
}

fn get_adult_name(values: Vec<User>) -> Vec<String> {
    values.iter().filter(|x| x.age > 18).clone().map(|x| x.name.clone()).collect()
}