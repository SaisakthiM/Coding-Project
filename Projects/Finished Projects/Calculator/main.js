const display = document.getElementById("display");

function appendToDisplay(input) {
    display.value += input;
}
function clearDisplay() {
    display.value = "";
} 
function calculate() {
    const expression = display.value;
    const result = eval(expression);
    display.value = result;

    // Send to Flask
    fetch('http://localhost:5000/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ expression: expression, result: result.toString() })
    }).then(res => res.json())
      .then(data => console.log(data));
}
function showHistory() {
    fetch('http://localhost:5000/history')
        .then(res => res.json())
        .then(data => {
            if (!Array.isArray(data) || data.length === 0) {
                display.value = "No history.";
                return;
            }

            historyData = data;
            historyIndex = 0;
            updateDisplayWithHistory();
        })
        .catch(err => {
            console.error("Error fetching history:", err);
            display.value = "Error loading history";
        });
}

function updateDisplayWithHistory() {
    if (historyIndex >= 0 && historyIndex < historyData.length) {
        const entry = historyData[historyIndex];
        display.value = `${entry.expression} = ${entry.result}`;
    }
}

function prevHistory() {
    if (historyData.length === 0) return;
    if (historyIndex > 0) {
        historyIndex--;
        updateDisplayWithHistory();
    }
}

function nextHistory() {
    if (historyData.length === 0) return;
    if (historyIndex < historyData.length - 1) {
        historyIndex++;
        updateDisplayWithHistory();
    }
}


