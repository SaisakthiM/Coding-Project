function List() {
    const fruits = [{name: "apple", calories: 22}, {name: "orange", calories: 82}, {name: "banana", calories: 19}, {name: "coconut", calories: 37}, {name: "pineapple", calories: 41}];
	// fruits.sort((a,b) => a.name.localeCompare(b.name)); : Alphabetical Order
	// fruits.sort((a,b) => b.name.localeCompare(a.name)); :  Reverse Alphabetical Order
	// fruits.sort((a,b) => b.calories-a.calories); : Numerical 
	// fruits.sort((a,b) => a.calories-b.calories); : Reverse Numerical 

	fruits.filter(fruit => fruit.name.startsWith('b'));
    const list_fruits = fruits.map((fruit) => (
	<li key={fruit.name}>{fruit.name}:&nbsp; {fruit.calories}</li>
	));
	

    return (<ul>{list_fruits}</ul>);
    
}

export default List;