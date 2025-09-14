package main

import "fmt"

func main() {
	fmt.Println("hello there!")

	// initialize variables here
	var smsSendingLimit int = 0
	var costPerSMS float64 = 0.0
	var hasPermission bool = false
	var username string = ""
	

	fmt.Printf("%v %.2f %v %q\n", smsSendingLimit, costPerSMS, hasPermission, username)
	
	messageStart := "Happy birthday! You are now"
	age := 21
	messageEnd := "years old!"
	fmt.Println(messageStart, age, messageEnd)

	numMessagesFromDoris := 72
	costPerMessage := .02
	totalCost := costPerMessage * float64(numMessagesFromDoris)
	fmt.Printf("Doris spent %.2f on text messages today\n", totalCost)
}