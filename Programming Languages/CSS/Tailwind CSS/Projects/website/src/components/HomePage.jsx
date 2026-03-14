import "../index.css";
import { Link } from "react-router-dom"; // make sure it's react-router-dom

export default function HomePage() {
  return (
    <div className="bg-linear-65 from-purple-500 to-pink-500 h-screen flex justify-center items-center">
      <div className="border-2 w-3xl h-64 border-[rgb(28,87,93)] p-4">
        <h1 className="flex justify-center p-10 text-3xl text-[rgb(4,32,2)]">Home Page</h1>
        <h2 className="flex justify-center font-semibold text-[rgb(109,192,255)]">
          This is the home page for my Tailwind project
        </h2>

        <ol className="list-decimal list-inside mt-4 ml-4 grid grid-cols-2 grid-rows-2 gap-2">
          <li>
            <Link 
              to="/about" 
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
              Go to the About Page
            </Link>
          </li>
          <li>Another item</li>
        </ol>
      </div>
    </div>
  );
}
