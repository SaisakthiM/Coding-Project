use std::io;

fn main() {
    let mut g1 = String::new();
    let mut g2 = String::new();

    println!("Enter input 1 :");
    io::stdin()
        .read_line(&mut g1)
        .expect("Failed to read line");

    println!("Enter input 1 :");
    io::stdin()
        .read_line(&mut g2)
        .expect("Failed to read line");

    println!("You entered: {}", g1.trim());

    
}
