import Student from "./Student"
function App() {
    return (<>
        <Student name="Saisakthi" age="{17}" isStudent={true}></Student>
        <Student name="patrick" age={14} isStudent={true}></Student>
        <Student name="kate" age={26} isStudent={false}></Student>
        <Student name="mao" age={89} isStudent={false}></Student>
    </>);
}

export default App