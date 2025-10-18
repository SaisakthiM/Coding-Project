import { useState } from 'react';
import "./App.css"

function App() {
	const [page, setPage] = useState(0);
	
	return (
		<div className='wrapper'>
		<div className='container'>
			{page === 0 && (
			<>
				<h1>TODO App</h1>
				<p>This is a TODO App where you can record what to do in future</p>
				<p>Are You ready</p>
				<div className="button_home">
				<button onClick={() => setPage(1)}>Let's Start</button>
				</div>
			</>
			)}
			{page === 1 && (
			<>
				<h1>Your Tasks</h1>
				<p>Start adding tasks below:</p>
				<input type="text" placeholder="Enter a task" />
				<div className="button_home">
				<button onClick={() => setPage(2)}>Next</button>
				</div>
			</>
			)}
			{page === 2 && (
			<>
				<h1>All Done!</h1>
				<p>You've reached the summary screen.</p>
				<div className="button_home">
				<button onClick={() => setPage(0)}>Restart</button>
				</div>
			</>
			)}
		</div>
		
		</div>
	);
}

export default App;