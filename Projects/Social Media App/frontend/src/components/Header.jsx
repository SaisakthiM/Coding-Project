import { useState } from "react";
import { Bell, Search } from "lucide-react";

export default function Header() {
  const [search, setSearch] = useState("");

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-indigo-600 text-white shadow-md">
        <div className="flex items-center justify-between px-6 py-4">
          {/* Left Section - Logo */}
          <div className="flex items-center space-x-6">
            <div className="text-2xl font-bold">
              <span className="text-white">🌊</span>
            </div>

            {/* Navigation Links */}
            <nav className="hidden md:flex space-x-6">
              <a href="#" className="font-medium hover:text-gray-200">Home</a>
              <a href="#" className="font-medium hover:text-gray-200">Profile</a>
              <a href="#" className="font-medium hover:text-gray-200">Resources</a>
              <a href="#" className="font-medium hover:text-gray-200">Company Directory</a>
              <a href="#" className="font-medium hover:text-gray-200">Openings</a>
            </nav>
          </div>

          {/* Right Section - Search, Notification, Avatar */}
          <div className="flex items-center space-x-6">
            {/* Search Bar */}
            <div className="relative hidden md:block">
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search"
                className="pl-10 pr-4 py-2 rounded-md bg-indigo-500 placeholder-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-300"
              />
              <Search className="absolute left-3 top-2.5 text-gray-200 h-5 w-5" />
            </div>

            {/* Notification Icon */}
            <button className="relative">
              <Bell className="h-6 w-6 text-white hover:text-gray-200" />
            </button>

            {/* User Avatar */}
            <img
              src="https://i.pravatar.cc/40"
              alt="User Avatar"
              className="h-10 w-10 rounded-full border-2 border-white"
            />
          </div>
        </div>
      </header>

      {/* Content Section with Two Boxes */}
      <main className="flex space-x-6 px-8 py-8">
        {/* Left Box */}
        <div className="flex-1 bg-white rounded-lg shadow-md border border-gray-200 h-96">
          <div className="w-full h-full bg-gray-50 rounded-lg border border-dashed border-gray-300"></div>
        </div>

        {/* Right Box */}
        <div className="w-1/3 bg-white rounded-lg shadow-md border border-gray-200 h-96">
          <div className="w-full h-full bg-gray-50 rounded-lg border border-dashed border-gray-300"></div>
        </div>
      </main>
    </div>
  );
}