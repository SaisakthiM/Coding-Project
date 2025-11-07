import { useContext } from "react"
import "../styles.css"
import { UserProvider } from "./UserProvider"
import { UserContext } from "./UserContext"

export default function RegistrationComplete() {
    let {beforeLogin, setBeforeLogin} = useContext(UserContext)
    let handleBeforeLogin = () => {
        setBeforeLogin(true)
    }
    return (
        <div className="wrapper">
            <div className="complete">
                    <div>
                        <h1>Registration Completed 🎉</h1>
                    	<h2>Go to Login Page</h2>
                    	<button onClick={handleBeforeLogin}>Click Here</button>
                    </div>
            </div>
        </div>
    )
}