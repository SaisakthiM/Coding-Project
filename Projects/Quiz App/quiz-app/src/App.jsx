import React, { useState } from "react";
import Quiz from "./components/Quiz";


export default function App() {
	const [score, setScore] = useState(0);
	const handleAnswer = (correct) => (
		correct ? setScore(prev => prev+1) : null
	);
	return (<>
		
	</>)
}








































