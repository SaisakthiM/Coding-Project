import './App.css'
import Navbar from "./components/Navbar"
import Features from "./components/Features"
import Hero from "./components/Hero"
import Pricing from "./components/Pricing"
import Testimonials from "./components/Testimonials"
import Footer from "./components/Footer"

function App() {


  return (
    <>
      <div className="bg-blue-700">
          <Navbar></Navbar>
          <Hero></Hero>
          <Features></Features>
          <Pricing></Pricing>
          <Testimonials></Testimonials>
          <Footer></Footer>
      </div>
    </>
  )
}

export default App
