import './App.css'
import Fetcher from './components/Fetcher'
import { useState } from 'react'

export default function App() {
	const [showFetcher, setShowFetcher] = useState(false)

	const handleClick = () => {
		setShowFetcher(true)
	}

	return (
		<div className="wrapper">
			<div className="container">
				<nav>
					<h1>Random Quote Generator</h1>
				</nav>

				<div className="headers">
					<h2>
						This React app generates a random quote using a <br />
						Quotes Generator API.
					</h2>
				</div>

				<div className="button-wrapper">
					<button className="button_quote" onClick={handleClick}>
						Generate a Quote
					</button>
				</div>

				{showFetcher && <Fetcher />}
			</div>
		</div>
	)
}