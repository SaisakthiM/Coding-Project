const button = document.getElementById("subscribe_button");
subscribe = 0;
button.addEventListener("click", function() {
    alert("Thank you for subscribing!");
    button.style.backgroundColor = "green";
    button.innerHTML = "Subscribed!";
    button.disabled = false;
    button.style.cursor = "not-allowed";   
    
});
subscribe += 1 
document.writeln("You have subscribed " + subscribe + " times.");

