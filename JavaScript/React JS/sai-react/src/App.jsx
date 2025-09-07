import List from './List.jsx'
function App() {
	const fruits = [{name: "apple", calories: 22}, {name: "orange", calories: 82}, {name: "banana", calories: 19}, {name: "coconut", calories: 37}, {name: "pineapple", calories: 41}];
	const vegetables = [
  { name: "carrot", calories: 41 },
  { name: "broccoli", calories: 55 },
  { name: "spinach", calories: 23 },
  { name: "potato", calories: 77 },
  { name: "tomato", calories: 18 }
];

	return (
		<>
		<List items={fruits} category='Fruits'></List>
		<List items={vegetables} category="vegetables"></List>
		<List></List>
		</>
	);
}

export default App;
