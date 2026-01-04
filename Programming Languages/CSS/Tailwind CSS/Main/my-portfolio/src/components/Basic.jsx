import { Link } from "react-router-dom";
import "./styles.css";

function Basic() {
  return (
    <div className="bg-[radial-gradient(at_50%_25%,rgb(44,44,44,0.5),rgba(17,24,39,1)_75%)] min-h-screen text-white">
      
      {/* Navbar */}
      <nav className="p-6">
        <h1 className="text-5xl text-gray-300 flex justify-center mb-6">
          Sai Portfolio
        </h1>

        <ul className="flex justify-center gap-10 text-2xl">
          <li>
            <Link to="/about" className="hover:text-purple-400 transition">
              About
            </Link>
          </li>
          <li>
            <Link to="/projects" className="hover:text-purple-400 transition">
              Projects
            </Link>
          </li>
          <li>
            <Link to="/contact" className="hover:text-purple-400 transition">
              Contact
            </Link>
          </li>
        </ul>
      </nav>

      <hr className="border-gray-600" />

      {/* Hero Section */}
      <section className="mt-16 text-center">
        <h1 className="text-5xl font-bold text-gray-200">
          Hi, I am Sai
        </h1>
        <h2 className="text-3xl text-slate-300 mt-6">
          This is my portfolio
        </h2>
      </section>

      {/* Content */}
      <section className="mt-16 max-w-4xl mx-auto">
        <ol className="list-decimal list-inside space-y-10 text-3xl">
          
          <li>
            About Me
            <ul className="list-disc list-inside mt-4 space-y-2 text-2xl">
              <li>I am from India, Tamil Nadu</li>
              <li>17-year-old programmer interested in Computer Architecture and DevOps</li>
              <li>Self-taught engineer</li>
            </ul>
          </li>

          <li>
            Specialties and Focus
            <ul className="list-disc list-inside mt-4 space-y-2 text-2xl">
              <li>Backend: Django, Spring Boot</li>
              <li>Languages: Java, Python, JavaScript</li>
              <li>Tools: Docker, Kubernetes (learning), MySQL, Proxmox, VMware, Linux</li>
              <li>Frontend: HTML, CSS, React (Intermediate)</li>
              <li>Focusing on : Tailwind CSS and Kubernetes</li>
            </ul>
          </li>

        </ol>
      </section>

    </div>
  );
}

export default Basic;
