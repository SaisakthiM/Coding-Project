fn main() {
    let values = vec![1,2,3];

    for x in values.iter() {
        println!("{x}");
    }

    println!("{:?}", values);

}
fn make_word() -> &String {
    let s = String::from("hello");
    &s
}

fn longest(words: &Vec<String>) -> String {
    let mut longest: String = String::from("");
    for word in words.iter() {
        if word.len() > longest.len() {
            longest = String::from(word);
        }
    }
    return longest;
}