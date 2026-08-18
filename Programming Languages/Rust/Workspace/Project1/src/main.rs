use std::env;
use std::fs::File;
use std::io::Read;

fn read_content(contents: String)  {
    let mut lines: u32 = 0;
    let mut words: u32 = 0;
    let mut characters: u32 = 0;
    let mut space_counter: u32 = 0;

    for character in contents.chars() {
        if character != ' ' {
            space_counter = 0;
        }
        if character == '\n' {
            lines += 1;
        }
        if character == ' ' && space_counter == 0{
            words += 1;
            space_counter += 1;
        }
        characters += 1;
    }
    print!("Lines : {lines}!");
    print!("Words : {words}!");
    print!("Character : {characters}!");

}

fn main(){
    let args: Vec<String> = env::args().collect();
    let file = File::open(&args[1]);
    let mut content = String::new();
    match file.expect("Error").read_to_string(&mut content)  {
        Ok(_) => read_content(content),
        Err(_) => print!("Error opening the file"),
    }


}



