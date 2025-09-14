window.addEventListener("DOMContentLoaded", () => {
    const button = document.getElementById("button_event");
    const input = document.getElementById("user_text");
    const note1 = document.getElementById("note1");
    const note2 = document.getElementById("note2");

    button.addEventListener("click", function() {
        const text = input.value.trim();
        if (!text) return;

        if (!note1.textContent.length) {
            note1.textContent = text;
        } else if (!note2.textContent.length) {
            note2.textContent = text;
        } else {
            alert("Only 2 tasks allowed!");
        }

        input.value = "";
    });
});
