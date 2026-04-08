import React from "react"
import { BrowserRouter, Route, Routes } from "react-router-dom"
import { Home } from "./components/Home"
import { Weather } from "./components/Weather"
import "./style.css"


export default function App() {
  return (
    <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home></Home>}></Route>
      <Route path="/weather" element={<Weather></Weather>}></Route>
    </Routes>
    </BrowserRouter>
  )
}