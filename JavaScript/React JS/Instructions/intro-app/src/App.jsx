import Header from './Header.jsx'
import Footer from './Footer.jsx';
import Food from './Food.jsx';
import Card from './Card.jsx';
import Button from './Buttons/Button.jsx';

function App() {
  const fruits = [{name: "apple", calories: 22}, {name: "orange", calories: 82}, {name: "banana", calories: 19}, {name: "coconut", calories: 37}, {name: "pineapple", calories: 41}];
	const vegetables = [
  { name: "carrot", calories: 41 },
  { name: "broccoli", calories: 55 },
  { name: "spinach", calories: 23 },
  { name: "potato", calories: 77 },
  { name: "tomato", calories: 18 }
];
	return (<div>
        <Header></Header>
        <Food></Food>
        <Footer></Footer>
        <Card></Card>
        <Button></Button>
        <Student name="Saisakthi" age={17} isStudent={true} />
        <Student name="Patrick" age={14} isStudent={true} />
        <Student name="Kate" age={26} isStudent={false} />
        <Student name="Mao" age={89} isStudent={false} />
        <Student /> {/* Uses default props */}
        <UserGreeeting isLoggedIn={true} username="Sai"></UserGreeeting>
        <UserGreeeting></UserGreeeting>
        <List items={fruits} category='Fruits'></List>
        <List items={vegetables} category="vegetables"></List>
        <List></List>
        <Button name="sai"></Button>
        <ProfilePicture></ProfilePicture>
    </div>);
}

export default App
