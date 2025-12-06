package main
import "fmt"

func Introduction() {
	var name string;
	fmt.Print("This is a Quiz and Cube game. Enter your name : ");
	fmt.Scan(&name);
	fmt.Print(`
	Here are the rules before starting :
	I) Quiz Game
	1) You will be asked 10 random questions from CS and each right answer will get you 3 mark 
	2) Wrong answer will get you -2 marks
	3) If you leave unattempted, you will get no marks

	II) Cube game or Dice Game:
	1) You will be asked to enter the number of edges you want to roll
	2) Also asked to no of times you want to roll 
	3) Then the Computer too rolls the no of times with you
	4) Who has the Total sum wins

	If you win both perfectly you name will be entered in this legendary leaderboard
	for now one is there but you have a chance
	I) 
	
	Good Luck!
	`)
}