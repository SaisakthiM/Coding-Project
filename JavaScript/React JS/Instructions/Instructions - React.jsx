/*

What is React : 
React is a library of JavaScript used for building web-apps easily 
Angular-JS is a framework of JavaScript which is also used to build web apps

How to create a react-app :
To create a react-app, we can use vite-react which is a build tool
we can create apps in instant instead of manually creating one by one
the commands for creating one is : npm run vite@latest

                                From here on you will be asked many options like react angular
                                select react and Vanilla JS

Here is a Tree Structure of a basic react app named 'my-react-app'

my-react-app
│
├── node_modules/                # Contains all installed dependencies (auto-generated)
│
├── public/                      # Static assets (served as-is)
│   └── vite.svg                 # Example static asset (Vite logo)
│
├── src/                         # Main source code of your React app
│   ├── assets/                  # (Optional) Images, fonts, and other static assets
│   │   └── react.svg            # Example React logo
│   │
│   ├── App.css                  # Styling for the App component
│   ├── App.jsx                  # Root React component (UI starts here)
│   ├── index.css                # Global styles for the project
│   └── main.jsx                 # Entry point: renders <App /> into the DOM
│
├── .eslintrc.cjs                # ESLint configuration (for linting rules)
├── .gitignore                   # Files/folders to be ignored by Git
├── index.html                   # Entry HTML file, root of the React app
├── package-lock.json            # Auto-generated file locking dependency versions
├── package.json                 # Project metadata, scripts, and dependencies
├── README.md                    # Project documentation
└── vite.config.js               # Vite configuration file (plugins, build settings, etc.)


and their uses is given in the tree structure

Creating a Header:
first clear all the content in app.js and delete app.css, we don't need that anymore

then create a file called Header
Note: The function you see inside App is called component, so call it app component instead of function

now create a Header component
Note: Header component also should be capital, jsx is case-sensitive

in Header.jsx : 
function Header() {
    return (
        <header>
            <h1>My Website</h1>
        </header>
    );
}

export default Header

in App.jsx:
import Header from './Header.jsx'

function App() {
    return (<Header>

    </Header>);
}

export default App

yay! you created your first website with react
Fact: instead of using <Header></Header>, you can also use <Header/>
Note: <Header> calls the header component and prints it out in website

Using JS in React: 
You can use JS inside React HTML using {}
for eg : 
function Footer() {
    return (
        <footer>
            <p/> {new Date()} &copy; Sai-Websites Copy-Right
        </footer>
    );
}
see, we can use Date function using {} brackets which tells react that we are using vanilla JS

Card Components : 
You saw a card right, a thick rectangle piece which is solid
yes, it is in react and we can call it Card-Component

function Card() {
    return (
        <div className="card>
        </div>
    );
}

Do you know why we used className instead of class 
it is because class is a reserved keyword and you cannot use it in a jsx file

now we can start with applying styles

HOW TO STYLE REACT COMPONENTS WITH CSS
(not including external frameworks or preprocessors)
1. EXTERNAL
2. MODULES
3. INLINE

External : the normal way of css we use here
Modules : we can also pack the css as modules and import it

In button.moodule.css :
.Button {
    background-color: rgb(0, 26, 255);
	border: none;
	border-radius: 15px;
	width: 80px;
	height: 40px;
	color :hsl(162, 65%, 55%);
}
In Button.jsx : 
import styles from './Button.module.css'

function Button() {
    return (<button className={styles.Button}>Click me</button>);
}
export default Button

Inline : we can also use css in the comonent itself but it is not recommended mostly
function Button() {
    const styles = {
        backgroundColor: "rgb(0, 26, 255)",
	border: "none",
	borderRadius: "15px",
	width: "80px",
	height: "40px",
	color : "hsl(162, 65%, 55%)",
    }
    return (<button style={styles}>Click me</button>);
}
export default Button

this is inline


props : read-only properties that are shared between components. 
        A parent component can send data to a child component. <Component key=value />

this can be used to get input form
the props is similar to a object in JS. it stores the parameter as key and value as value

function Student(props) {
    return (<div>
        <p> Name: {props.name}</p>
        <p>Age : {props.age}</p>
    </div>);
}   
export default Student;

import Student from "./Student"
function App() {
    return (<Student name="Saisakthi" age='17'></Student>);
}

export default App

as you can see, thr App gave a input name = Saisakthi
here name is stored as key and saisakthi as value, 
the Student Component can access the input value by mentioning the key
Note: The values are just similar to Object, it is not a Object itself, it is actually props which stores these





































































*/