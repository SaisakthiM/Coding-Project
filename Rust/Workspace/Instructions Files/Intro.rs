use std::io;

fn main() {
    println!("Guess a number : ");
    let mut guess = String::new();
    let r2 = &mut guess;
    println!("{r2}");
    io::stdin().read_line(&mut guess).expect("Failed to read line");
    println!("You guessed: {guess}");
    let a: i32 = 10;
}
