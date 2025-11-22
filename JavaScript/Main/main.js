import {getCircumference, getArea, getVolume} from './Modules.js';

// Show current date and time
document.getElementById("js_button").onclick = function() {
    document.getElementById("date_time").innerHTML = new Date();
};

// Replace demo content with string length
document.getElementById("demo").innerHTML = "Hi bro".length;

// Handle name form submission (first_name & last_name)
const form = document.getElementById("string");
form.addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent page reload

    const form_data = new FormData(form);
    const first_name = form_data.get("first_name");
    const last_name = form_data.get("last_name");

    for (const [key, value] of form_data.entries()) {
        console.log(`${key}: ${value}`);
    }

    console.log(`First Name: ${first_name}, Last Name: ${last_name}`);
});

// Convert 0.1 to base 12 and display
document.getElementById('number_add').innerHTML = 0.1.toString(12);

// Update header with input username
document.getElementById("mySubmit").onclick = function() {
    const username = document.getElementById("user_text").value;
    document.getElementById("myH1").textContent = `Hello, ${username}`;
};

// Display numbers using for loop
document.getElementById("myForLoop").onclick = function() {
    const value = parseInt(document.getElementById("input_num").value);
    for (let x = 0; x < value; x++) {
        document.getElementById("resultFor").textContent += x;
    }
};

// Counter functionality
let count = 0;
document.getElementById("increaseCount").onclick = function () {
    count += 1;
    document.getElementById("countLabel").textContent = count;
};

document.getElementById("resetCount").onclick = function() {
    count = 0;
    document.getElementById("countLabel").textContent = count;
};

document.getElementById("decreaseCount").onclick = function() {
    count -= 1;
    document.getElementById("countLabel").textContent = count;
};

// Random number generator (0–10) displayed for 1 sec
document.getElementById("generate_random").onclick = function() {
    const randomNum = Math.floor(Math.random() * 11);
    const span = document.createElement("span");
    span.textContent = randomNum;
    document.getElementById("label_random").appendChild(span);

    setTimeout(() => {
        span.remove();
    }, 1000);
};

// TODO: You can continue adding logic for checkbox and radio buttons

document.getElementById("subscriptionForm").addEventListener("submit", function(e) {
    e.preventDefault();
    
    const isSubscribed = document.getElementById("myCheckBox").checked;
    const isPayment = document.querySelector('input[name="payment"]:checked');
    
    // Clear previous messages
    const messageBox = document.getElementById("messageBox");
    messageBox.innerHTML = "";

    if (!isSubscribed) {
        // Create an error message instead of using alert()
        const noSubscriptionMessage = document.createElement('p');
        noSubscriptionMessage.textContent = "Please subscribe to continue.";
        messageBox.appendChild(noSubscriptionMessage);
        return;
    } 
    
    if (!isPayment) {
        // Create an error message instead of using alert()
        const paymentErrorMessage = document.createElement('p');
        paymentErrorMessage.textContent = "You need to choose a payment method";
        messageBox.appendChild(paymentErrorMessage);
        return;
    } 
    
    // Create success messages if everything is fine
    const resultSubscribed = document.createElement("p");
    resultSubscribed.textContent = "You are Subscribed and your payment method has been set up successfully!";
    messageBox.appendChild(resultSubscribed);
});

/* Checking the Day */

document.getElementById("check_day").onclick = function () {
        let days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        let day = days[new Date().getDay()].toLowerCase();
        let responseDiv = document.getElementById("responseDiv");
        console.log(day);
        // clear previous content 
        responseDiv.innerHTML = '';
      
        switch(day) {
          case "monday":
            responseDiv.innerHTML = "It's Monday, the start of the workweek.";
            break;
          case "tuesday":
            responseDiv.innerHTML = "Taco Tuesday!";
            break;
          case "wednesday":
            responseDiv.innerHTML = "Hump day.";
            break;
          case "thursday":
            responseDiv.innerHTML = "The final weekday of the week.";
            break;
          case "friday":
            responseDiv.innerHTML = "Friday, go to work!";
            break;
          case "saturday":
            responseDiv.innerHTML = "Weekend is coming";
            break;
          case "sunday":
            responseDiv.innerHTML = "Sunday Funday";
            break;
          default:
            responseDiv.innerHTML = "Invalid day entered.";
        }
    }


// Method Chaining
document.getElementById("username_enter").onclick = function() {
    let username = window.prompt("Enter Username : ") || "";
    username = username.trim();
    if (username.length > 0) {
        username = username[0].toUpperCase() + username.slice(1).toLowerCase();
    }
    console.log(username);
    
}

// Guessing Number

document.getElementById("guess_submit").onclick = function() {
    const num = document.getElementById("guess_number").value;
    const resultDiv = document.getElementById("guess_result");
    resultDiv.innerHTML = "";

    if (num.trim() === "" || isNaN(Number(num))) {
        resultDiv.innerHTML = "Please Enter a Number";
        return; // ❗ stop execution here
    }

    const computer_guess = Math.floor(Math.random() * 10);
    if (computer_guess == Number(num)) {
        resultDiv.innerHTML = `<p id="resultMessage" style="background-color: white; transition: background-color 0.5s ease, color 0.5s ease; display: inline; color: black;">Yay! You guessed it right</p>`;
        setTimeout(() => {
            const msg = document.getElementById("resultMessage");
            msg.style.backgroundColor = "rgba(60, 179, 113, 0.7)"; // Medium Sea Green with transparency
            msg.style.color = "rgb(255, 255, 255)"; // White text
        }, 10);

    } else {
        resultDiv.innerHTML = `<p id="resultMessage" style="background-color: white; transition: background-color 0.5s ease, color 0.5s ease; display: inline; color: black;">You guessed it wrong! Better luck next time</p>`;
        setTimeout(() => {
            const msg = document.getElementById("resultMessage");
            msg.style.backgroundColor = "rgba(220, 80, 80, 0.7)";
            msg.style.color = "rgb(255, 255, 255)";
        }, 10);
    }
};

// Temperature Conversion Program
document.getElementById("tempSubmit").addEventListener('click', function(event) {
    event.preventDefault(); // Prevents the page from refreshing on submit
    
    const tempVal = document.getElementById("tempValue").value;
    var resultTemp = document.getElementById("tempResult");
    
    let celsiusToFahrenheit = () => (Number(tempVal) * 9/5) + 32;
    let fahrenheitToCelsius = () => (Number(tempVal) - 32) * 5/9;
    
    if (!tempVal || isNaN(Number(tempVal))) { // Checking for invalid input
        resultTemp.innerHTML = "Invalid Input.";
        return;
    }
    
    let CtoF_Radio = document.getElementById("CtoF_Radio").checked;
    let FtoC_Radio = document.getElementById("FtoC_Radio").checked;
    
    if (CtoF_Radio) { // Checks which radio button is selected and performs conversion accordingly
        resultTemp.innerHTML = `The Conversion result is: ${celsiusToFahrenheit()}`;
    } else if(FtoC_Radio){
        resultTemp.innerHTML = `The Conversion result is: ${fahrenheitToCelsius()}`;
    } else { // If neither radio button is selected
        resultTemp.innerHTML = "Please select a conversion type.";
    }  
});



/* Dice Roller Program */

document.getElementById("RollDice").onclick = function() {
    event.preventDefault();
    let diceNum = Math.floor(Math.random() * 6) + 1;

    // Set the numeric result
    document.getElementById("resultDice").value = diceNum;

    // Determine image path
    let imgPath = "";
    switch (diceNum) {
        case 1:
            imgPath = "../Images/Dice-1.png";
            break;
        case 2:
            imgPath = "../Images/Dice-2.png";
            break;
        case 3:
            imgPath = "../Images/Dice-3.png";
            break;
        case 4:
            imgPath = "../Images/Dice-4.png";
            break;
        case 5:
            imgPath = "../Images/Dice-5.png";
            break;
        case 6:
            imgPath = "../Images/Dice-6.png";
            break;
    }

    // Set the image
    document.getElementById("dice_images").innerHTML = `<img src="${imgPath}" alt="Dice-${diceNum}" style="width: 100px;">`;
};

/* Random Password Generator */

let passwordStr = "aB9@Z#qL2!dFx$MvRp7KhsY0U~oN&C_Tjl8Egn3Iw?bcAJXeDtkVyWzGPmSf14iOHru56[]{}";


document.getElementById("passwordButton").addEventListener("click", function(e) {
    let userLen = parseInt(document.getElementById("lenPassword").value);
    let resultPassword = "";
    let passwordStrength = "";
    if (isNaN(userLen) || userLen <= 0) {
    alert("Please enter a valid password length.");
    return;
}


    // Generate password of user-specified length
    while (resultPassword.length < userLen) {
        let idx = Math.floor(Math.random() * passwordStr.length);
        resultPassword += passwordStr[idx];
    }

    // Evaluate strength based on generated password length
    switch (true) {
        case (userLen >= 1 && userLen <= 4):
            passwordStrength = "Very Weak";
            break;
        case (userLen >= 5 && userLen <= 7):
            passwordStrength = "Weak";
            break;
        case (userLen >= 8 && userLen <= 10):
            passwordStrength = "Moderate";
            break;
        case (userLen >= 11):
            passwordStrength = "Strong";
            break;
        default:
            passwordStrength = "Empty Password";
    }

    // Show result
    document.getElementById("resultPasswordDiv").innerHTML = `
        <div style="font-family: Arial, sans-serif; line-height: 1.5;">
            <p style="font-size: 18px; margin: 0; color:#00BFFF">
                <strong>Password:</strong> ${resultPassword}
            </p>
            <p style="font-size: 20px; margin: 4px 0; color: ${
                passwordStrength === "Very Weak" ? "#d32f2f" :
                passwordStrength === "Weak" ? "#f57c00" :
                passwordStrength === "Moderate" ? "#1976d2" : 
                passwordStrength === "Strong" ? "#388e3c" : "#757575"
            };">
                <strong>Strength:</strong> ${passwordStrength}
            </p>
        </div>
    `;
});

/* Element Selector */

const myHeading = "I am Food";
document.getElementById("element_selector").innerHTML = `<h1 id="my-heading"> ${myHeading} </h1>`
let heading = document.getElementById("my-heading");
heading.style.backgroundColor = "yellow";
heading.style.textAlign = "center"








