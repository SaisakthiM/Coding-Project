import styles from './Button.module.css'

function Button() {
    const styles = {
        backgroundColor: "rgb(0, 26, 255)",
	border: "none",
	borderRadius: "15px",
	width: "80px",
	height: "40px",
	color : "hsl(162, 65%, 55%)",
    }
    return (<button style={styles}>Click me</button>);
}
export default Button