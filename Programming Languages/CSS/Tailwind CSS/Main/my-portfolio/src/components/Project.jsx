export default function Projects() {
  return (
    <div className="bg-[radial-gradient(at_50%_25%,rgb(0,121,4),rgba(0,0,0,1)_75%)] min-h-screen text-white">
       <nav className="pt-5"> 
        <h1 className="text-5xl flex justify-center pb-5">Projects</h1>
      </nav>
      <hr className="pb-5"></hr>
      <div className="grid grid-cols-[1fr_auto_1fr] h-screen">

  <div className="p-10">Left</div>

  {/* Separator */}
  <div className="w-px bg-white/40"></div>

  <div className="p-10">Right</div>

</div>


      </div>
      )
}
