import "./styles.css"

function Basic() {
    return (
        <div className="h-screen bg-[rgb(42,59,66)]">
      <h1 className="text-3xl font-bold flex justify-center align-middle text-amber-400">Hello World</h1>
      <div className="grid grid-cols-9 gap-2 h-32">
        <div className="bg-red-500">1</div>
        <div className="bg-blue-500">2</div>
        <div className="bg-green-500">3</div>
        <div className="bg-yellow-500">4</div>
      </div>
      <div>
        <div className="mx-auto max-w-md overflow-hidden rounded-xl bg-white shadow-md md:max-w-2xl">
  <div className="md:flex">
    <div class="md:shrink-0">
      <img
        class="h-48 w-full object-cover md:h-full md:w-48"
        src="/img/building.jpg"
        alt="Modern building architecture"
      />
    </div>

+
     <div class="p-8 ">
      <div class="text-sm font-semibold tracking-wide text-indigo-500 uppercase">Company retreats</div>
            <a href="#" class="mt-1 block text-lg leading-tight font-medium text-black hover:underline">
              Incredible accommodation for your team
            </a>
            <p class="mt-2 text-gray-500">
              Looking to take your team away on a retreat to enjoy awesome food and take in some sunshine? We have a list of
              places to do just that.
            </p>
          </div>
        </div>
      </div>
      </div>
      <div>
        <br></br>
        <h1 className="flex justify-center sm:text-left w-0.5 h-0.5">smart phone</h1>
      </div>
      <br></br>
      <br></br>
      <div className="flex flex-wrap-reverse">
      <div className="flex justify-center h-">01</div>
      <div>02</div>
      <div>03</div>
    </div>
    </div>
    )
}

export default Basic;