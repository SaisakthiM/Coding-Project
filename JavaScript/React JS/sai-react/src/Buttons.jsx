function Buttons() {
    const handleClick = (e) => e.target.textContent = "Ouch";
    return (<button onClick={handleClick}>click me😃</button>);
}
export default Buttons