import Header from './Header.jsx'
import Footer from './Footer.jsx';
import Food from './Food.jsx';
import Card from './Card.jsx';
import Button from './Buttons/Button.jsx';

function App() {
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
    </div>);
}

export default App
