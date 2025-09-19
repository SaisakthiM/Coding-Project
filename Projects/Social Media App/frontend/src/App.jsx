// SocialFuse — React + Tailwind, split into components
// ────────────────────────────────
// File: src/App.jsx


import React, { useState } from "react";
import Navbar from "./components/Navbar";
import Stories from "./components/Stories";
import Suggested from "./components/Suggested";
import Feed from "./components/Feed";
import PlayerSidebar from "./components/PlayerSidebar";
import ProfileCard from "./components/ProfileCard";
import PlayerModal from "./components/PlayerModal";
import FloatingCreate from "./components/FloatingCreate";
import SidebarLayout from "./components/SideBarLayout";


export default function App() {
  const [query, setQuery] = useState("");
  const [dark, setDark] = useState(false);
  const [selectedVideo, setSelectedVideo] = useState(null);


  return (
    <div className={`min-h-screen ${dark ? "bg-gray-900 text-gray-100" : "bg-gray-50 text-gray-900"}`}>
      <Navbar query={query} setQuery={setQuery} dark={dark} setDark={setDark} />


      <main className="max-w-6xl mx-auto px-4 grid grid-cols-1 lg:grid-cols-4 gap-6">
        <aside className="lg:col-span-1">
          <Stories />
          <Suggested />
        </aside>


        <section className="lg:col-span-2">
          <Feed query={query} setSelectedVideo={setSelectedVideo} />
        </section>


        <aside className="lg:col-span-1">
          <PlayerSidebar selectedVideo={selectedVideo} />
          <ProfileCard selectedVideo={selectedVideo} />
        </aside>
      </main>


      <PlayerModal selectedVideo={selectedVideo} setSelectedVideo={setSelectedVideo} />


      <FloatingCreate />
      <SidebarLayout></SidebarLayout>


      <footer className="max-w-6xl mx-auto px-4 py-6 text-center text-sm text-gray-500">
        Built with ❤️ — SocialFuse prototype
      </footer>
    </div>
  );
}