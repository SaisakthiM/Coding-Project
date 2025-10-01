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


propTypes = a mechanism that ensures that the passed value is of the correct datatype.
age: PropTypes.number
that's how the type is stored, remember, 
it will only gives a warning on console.log it does not block the flow of program

Student.propTypes = {
    name: PropTypes.string,
    age: PropTypes.number,
    isStudent:  PropTypes.bool,

}


defaultProps = default values for props in case passed from the parent component name: "Guest" they are not
Note: This method is now deprecated and only used in class component

import React, { Component } from "react";
import PropTypes from "prop-types";

class Student extends Component {
  render() {
    const { name, age, isStudent } = this.props;
    return (
      <div className="student">
        <p>Name: {name}</p>
        <p>Age: {age}</p>
        <p>Student: {isStudent ? "Yes" : "No"}</p>
      </div>
    );
  }
}

// Type checking
Student.propTypes = {
  name: PropTypes.string,
  age: PropTypes.number,
  isStudent: PropTypes.bool,
};

// Default values for props
Student.defaultProps = {
  name: "Guest",
  age: 0,
  isStudent: false,
};

export default Student;


conditional rendering = allows you to control what gets rendered
                        in your application based on certain conditions
                        (show, hide, or change components)

We can also use destructuring isntead of props 
and add propTypes which is way easier

import PropTypes from 'prop-types';

function UserGreeeting({ isLoggedIn = true, username = "Guest" }) {
  const welcomePrompt = <h2 className="welcome-class">Welcome {username}</h2>;
  const loginPrompt = <h2 className="login-prompt">Please log in</h2>;

  return isLoggedIn ? welcomePrompt : loginPrompt;
}

// Correct propTypes
UserGreeeting.propTypes = {
    user: PropTypes.shape({
    isLoggedIn: PropTypes.bool,
    username: PropTypes.string,
  }),
};

export default UserGreeeting

rendering lists : 
remember these glorius sentence in React

"You can render one, Return one and reuse anywhere"
it's like RRR but not environment of nature but for environment of the React
"it is the only library to react to a error, not to over-react. suits it's name"

these lines describes react on what it is

ok come back to the first line, i said that you can render one right,
but a list has many elements which opposes the idea of it, 
so what it does is that it iterates the array and add all the elements and rendering it as a single string

so you can do it with magic of mapping each elements with a li tag and using it, 
now when it iterates, it gets rendered into list which is much better

now get to rendering Objects, react will not iterate through objects like it did with arrays,
instead it throws a error that plain objects cannot be rendered


State Management : 
The Single most important thing in react is simply the state management
ok what is even a state
take a page with a heading title with name on it just name
now there is a input box to enter your name and a button saying "change the title"
you enter your name and clivk the button
now magic the name changes 
how is that
it's state, the preveous state where "name" is displayed is the previous state
the new name you entered is the final state
in react, you can define a state using "const [name, setName] = useState("name")"
the name stores the initial state "name" and 

Note: very importnat, if you misconfigured the state of the app, most of the times
the entire application will not work, but other apps do

Hooks :
Hooks are special functions that let your components use React features 
(state is one of those features). The useState Hook lets you declare a state variable. 
It takes the initial state and returns a pair of values: 
the current state, and a state setter function that lets you update it.

Shallow Copy
Definition: A shallow copy creates a new object or array only at the top level, 
while nested objects/arrays still reference the original.

Example:
const newState = { ...state, nested: { ...state.nested, value: 42 } };
Top-level properties are new, but deeper nested objects can still be shared.

Deep Copy
Definition: A deep copy creates a completely independent clone, including all nested objects and arrays.

Example:
const newState = JSON.parse(JSON.stringify(state));
Changes at any level do not affect the original object.






































































*/

/*
HTML Entities : 
| Entity      | Symbol  | Description                    |
| ----------- | ------- | ------------------------------ |
| `&amp;`     | &       | Ampersand                      |
| `&lt;`      | <       | Less than                      |
| `&gt;`      | >       | Greater than                   |
| `&quot;`    | "       | Double quote                   |
| `&apos;`    | '       | Single quote / apostrophe      |
| `&nbsp;`    | (space) | Non-breaking space             |
| `&ensp;`    |         | En space (half-em width space) |
| `&emsp;`    |         | Em space (full width space)    |
| `&thinsp;`  |         | Thin space                     |
| `&dollar;`  | \$      | Dollar sign                    |
| `&euro;`    | €       | Euro sign                      |
| `&pound;`   | £       | Pound sterling                 |
| `&yen;`     | ¥       | Yen                            |
| `&cent;`    | ¢       | Cent                           |
| `&plus;`    | +       | Plus                           |
| `&minus;`   | −       | Minus                          |
| `&times;`   | ×       | Multiplication                 |
| `&divide;`  | ÷       | Division                       |
| `&equals;`  | =       | Equals                         |
| `&ne;`      | ≠       | Not equal                      |
| `&le;`      | ≤       | Less than or equal             |
| `&ge;`      | ≥       | Greater than or equal          |
| `&larr;`    | ←       | Left arrow                     |
| `&uarr;`    | ↑       | Up arrow                       |
| `&rarr;`    | →       | Right arrow                    |
| `&darr;`    | ↓       | Down arrow                     |
| `&harr;`    | ↔       | Left-right arrow               |
| `&middot;`  | ·       | Middle dot                     |
| `&bull;`    | •       | Bullet point                   |
| `&hellip;`  | …       | Ellipsis                       |
| `&dagger;`  | †       | Dagger                         |
| `&Dagger;`  | ‡       | Double dagger                  |
| `&permil;`  | ‰       | Per mille                      |
| `&sect;`    | §       | Section sign                   |
| `&para;`    | ¶       | Paragraph sign                 |
| `&hearts;`  | ♥       | Heart                          |
| `&spades;`  | ♠       | Spade                          |
| `&clubs;`   | ♣       | Club                           |
| `&diams;`   | ♦       | Diamond                        |
| `&star;`    | ★       | Star                           |
| `&check;`   | ✔       | Check mark                     |
| `&times;`   | ✖       | Cross mark                     |
| `&copy;`    | ©       | Copyright                      |
| `&reg;`     | ®       | Registered trademark           |
| `&trade;`   | ™       | Trademark                      |
| `&#169;`    | ©       | Copyright (numeric)            |
| `&#174;`    | ®       | Registered (numeric)           |
| `&#9733;`   | ★       | Star (numeric)                 |
| `&#9829;`   | ♥       | Heart (numeric)                |
| `&#8252;`   | ‼       | Double exclamation (numeric)   |
| `&#10003;`  | ✔       | Check mark (numeric)           |
| `&#x2764;`  | ❤️      | Heart (Unicode hex)            |
| `&#x2714;`  | ✔       | Check mark (Unicode hex)       |
| `&#x1F600;` | 😀      | Grinning face emoji            |




*/