class Lesson {
    constructor(name, subtitle) {
        this.name = name;
        this.subtitle = subtitle;
        this.steps = [];
        this.index = 0;

        this.addStep({text: "Press to begin"})
    }
    addStep({text = "", puzzlecards = [], extra = ""}) {
        this.steps.push({text, puzzlecards, extra});

    }
    init() {
        const nextButton = document.createElement("button");
        nextButton.innerHTML = "Next";
        nextButton.onclick = () => Test.next();
        document.getElementById("layout").appendChild(nextButton);

        const prevButton = document.createElement("button");
        prevButton.innerHTML = "Previous";
        prevButton.onclick = () => Test.prev();
        document.getElementById("layout").appendChild(prevButton);
        
        text.innerHTML = this.steps[this.index].text;
    }
    load() {
        text.innerHTML = this.steps[this.index].text;
        puzzleCardRow.innerHTML = "";
        for (let i = 0; i < this.steps[this.index].puzzlecards.length; i++) {
            const [A, B] = this.steps[this.index].puzzlecards[i];
            const Card = new puzzleCard(A, B, puzzleCardRow);
        }
        extra.innerHTML = this.steps[this.index].extra;
    }
    next() {
        if (this.index >= this.steps.length - 1) {
            return;
        }
        this.index++;
        this.load();
    }
    prev() {
        if (this.index <= 0) {
            return;
        }
        this.index--;
        this.load();
    }
}

const Test = new Lesson("Lesson 1", "Subtitle 1")
Test.addStep({
    text: "This is a test introduction to Ta form, most comonly used for past tense.",
    puzzlecards: [["Start with the plain form", "買う"], ["delete the last kana", "買<span style='text-decoration: line-through;'>う</span>"], ["replace with", "買った"]],
    extra: "オレンジを買った<br>I bought an orange"
})