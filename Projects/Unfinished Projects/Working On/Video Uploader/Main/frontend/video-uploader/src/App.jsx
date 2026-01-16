import { BrowserRouter, Routes, Route } from "react-router-dom"
import HomePage from "./components/HomePage.jsx"
export default function App() {
  return (
    <Routes>
      <Route path="/home" element={<HomePage></HomePage>}></Route>
    </Routes>
  )
}
