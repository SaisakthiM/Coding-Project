window.addEventListener("DOMContentLoaded", () => {
    const button = document.getElementById("button_event");
    const input = document.getElementById("user_text");
    const note1 = document.getElementById("note1");
    const note2 = document.getElementById("note2");
    const note3 = document.getElementById("note3");
    const check1 = document.getElementById("check1");
    const check2 = document.getElementById("check2");
    const check3 = document.getElementById("check3");
    

    button.addEventListener("click", function() {
        const text = input.value.trim();
        if (!text) return;

        if (!note1.textContent.length) {
            note1.textContent = text;
        } else if (!note2.textContent.length) {
            note2.textContent = text;
        } else if (!note3.textContent.length) {
            note3.textContent = text;
        }
        else {
            alert("Only 3 tasks allowed!");
        }

        input.value = "";
    });

    if (check1.ariaChecked) {
        alert("It is checked");
    }
});
