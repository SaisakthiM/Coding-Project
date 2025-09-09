document.getElementById("button_event").addEventListener("click", function(e) {
    let text = document.getElementById("user_text").value;
    document.getElementById("tasks1").innerHTML = text;
});