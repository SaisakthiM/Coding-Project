document.getElementById("buttonTemp").addEventListener("click", function () {
    const inputs = document.querySelectorAll(".readInput");
    const radios = document.querySelectorAll(".radioCle");
    const errorBox = document.getElementById("errorBox");
    const resultInput = document.getElementById("input2");

    // Clear previous result and errors
    resultInput.value = "";
    errorBox.innerText = "";

    const celsius = inputs[0].value.trim();
    const fahrenheit = inputs[1].value.trim();
    const radioSelected = [...radios].find(r => r.checked);

    // Error conditions
    if (!radioSelected) {
        errorBox.innerText = "Please select a conversion option.";
        return;
    }

    if ((celsius && fahrenheit) || (!celsius && !fahrenheit)) {
        errorBox.innerText = "Please fill only one input value.";
        return;
    }

    // Conversion logic
    let result;
    if (celsius && radios[0].checked) {
        result = (parseFloat(celsius) * 9 / 5) + 32;
    } else if (fahrenheit && radios[1].checked) {
        result = (parseFloat(fahrenheit) - 32) * 5 / 9;
    } else {
        errorBox.innerText = "Input, Conversion do not match.";
        return;
    }

    resultInput.value = result.toFixed(2); // Rounded to 2 decimal places
});
