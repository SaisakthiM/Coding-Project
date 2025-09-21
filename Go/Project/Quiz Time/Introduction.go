package main
import "fmt"

func Introduction() {
	var name string;
	fmt.Print("This is a Quiz game. Enter your name : ");
	fmt.Scan(&name);
	fmt.Print(`
	Here are the rules before starting :
	1) You will be asked 10 random questions from CS and each right answer will get you 3 mark 
	2) Wrong answer will get you -2 marks
	3) If you leave unattempted, you will get no marks
	
	Good Luck!
	`)
}