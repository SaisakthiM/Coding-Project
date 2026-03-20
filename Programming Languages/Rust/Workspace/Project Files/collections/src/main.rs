fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    vec.push(2);
    vec.push(3);
    vec.push(2);
    vec.as_ptr();
    let vec1 = vec.split_off(2);
    println!("{:?}", vec[0]);
    println!("{:?}", vec1);
}
