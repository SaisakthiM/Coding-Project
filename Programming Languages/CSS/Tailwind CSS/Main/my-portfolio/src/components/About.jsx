import "./styles.css"

export default function About() {
    return (
        <div className="bg-[radial-gradient(at_50%_25%,rgb(0,8,119),rgba(0,0,0,1)_75%)] min-h-screen text-white">

            {/* Header */}
            <nav className="text-5xl pt-10 flex justify-center pb-5">
                <h1>About Me (Complete)</h1>
            </nav>

            <hr className="border-0 h-px bg-white/40 my-8"></hr>

            {/* Two Column Layout */}
            <div className="max-w-7xl mx-auto px-5 grid grid-cols-2 gap-10">

                {/* Left Column – Your Content */}
                <div>
                    <ol className="list-decimal list-inside space-y-4">
                        <li className="text-3xl">
                            How I Started Coding - My Journey to Coding
                        </li>
                        <p className="text-lg leading-relaxed text-white/90 space-y-4">
                            I started using computers when i was like 13 years. i used a old one which was free in my free-time.
                            That time i didn't know what programming was, but I knew one thing: to tinker and play with it.
                            And that's how mine started, playing, breaking Windows in weeks. Many times I can't even count how much time 
                            I broke somethings in Windows. Then I started programming in Python at 14. It was a mystery time. 
                            That time I didn't know much about programming and I thought it was like a hobby. I didn't have knowledge that programming gives us money and that was CS.
                            And also it was the happiest times for me coding without worry. Then my DevOps interest started with one wish: installing Mac on Windows with VirtualBox. 
                            I heard about MacBook and how its software is best, so I thought why not try it on mine. I tried actually seeing tutorials day and night and doing it. 
                            By the time I used it in VMware which was laggy, so I deleted. I actually learnt how computers work like semiconductors and more importantly, about virtualization. 
                            I was also coding sometimes which helped me to use all these fast. But I never would have thought that there is a profession in what I did, let alone DevOps demand is increasing. 
                            The moment I learned there is a demand, I jumped all on it. Before that it was a hobby, now it will be my profession. 
                            So then I learned Docker, which was actually easier than I thought (others mentioned it's tough to learn). Yes, it is, but not for me—not for one who configured and researched about it for 2 years.
                            Then times passed, I learnt JS and Java. Java was a bit tough because it is OOP and I absolutely hate that. But still I did not ignore the usecase of Java and how it carries all legacy programs. 
                            So I threw away that and learnt it. Now I am here, learning frontend, which is actually tough because I am a backend guy.
                        </p>
                    </ol>
                </div>

                {/* Right Column – Future & Weaknesses */}
                <div className="border-l border-white/40 pl-8">
                   <ol className="space-y-4">
                        <li className="text-3xl">
                            2. How it is Going - To the Future (and also my weaknesses)
                        </li>
                        <div className="text-lg leading-relaxed text-white/90 space-y-4">
                            <p>
                                Now I am learning Tailwind and React. It is going well, but yeah, really after seeing the job market, 
                                I don't think it is easy to get a job. Even my mind goes into self doubt that maybe I won't get a job. 
                                I know all these and that, but I don't think many care about it. Even if you know all the things you need for a company, they are not hiring.
                            </p>
                            <p>
                                My weakness? My curiosity. Yes, the thing which made me pick interest in computers is the same thing which is holding me back, 
                                and it will never be so much true if you just see my folder. I want to change that. Another weakness is my soft skills. 
                                I don't think mine are enough for a corporate world full of competition and one slip-up costs a job. That inner fear, that I am not enough, I have it all the time. 
                                That's what is holding me back and will hold me back.
                            </p>
                            <p>
                                And the other main weakness is obsession. Yes, this is my biggest so far. I am obsessed with computers, so I am good at computer work but also worse in other things naturally, like soft skills and communication. 
                                So I am trying my best to at least reduce my obsession over computers and have it in a natural amount. This is my current state.
                            </p>
                            <p>
                                What's my future, you might ask? My plan is to become a DevOps engineer, manage applications, and invent tools which other developers use. That's my ultimate goal.
                            </p>
                        </div>
                    </ol>
                </div>

            </div>

        </div>
    )
}
