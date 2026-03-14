import { BrowserRouter, Routes, Route } from "react-router-dom"
import HomePage from "./components/HomePage.jsx"
import Upload from "./components/Upload.jsx"
import Download from "./components/Downlaod.jsx"
export default function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage></HomePage>}></Route>
      <Route path="/upload" element={<Upload></Upload>}></Route>
      <Route path="/download" element={<Download></Download>}></Route>
    </Routes>
  )
}
