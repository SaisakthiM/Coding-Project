import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import Welcome from "./components/Welcome.jsx"
import "./style.css"
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
	return (
		<BrowserRouter>
			<Routes>
				<Route path='/' element={<Welcome></Welcome>}></Route>
			</Routes>
		</BrowserRouter>
	)
}

export default App
