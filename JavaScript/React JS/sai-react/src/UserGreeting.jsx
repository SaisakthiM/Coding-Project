function UserGreeeting(props){
    const welcomePrompt = <h2 className="welcome-class">Welcome {props.username}</h2>;
    const loginPrompt = <h2 className="login-prompt">Please log in</h2>;

    return (props.isLoggedIn ? welcomePrompt : loginPrompt)
}
export default UserGreeeting