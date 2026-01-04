
import './App.css'
import { Route, Routes } from "react-router-dom";
import Basic from './components/Basic.jsx'
import About  from './components/About.jsx';
import Projects from './components/Project.jsx';
function App() {
	return (
    <Routes>
      <Route path="/" element={<Basic />} />
      <Route path="/about" element={<About />} />
      <Route path="/projects" element={<Projects></Projects>}></Route>
    </Routes>
  );
}

export default App
