function List({items, category}) {
    const fruits = items;

	// fruits.sort((a,b) => a.name.localeCompare(b.name)); : Alphabetical Order
	// fruits.sort((a,b) => b.name.localeCompare(a.name)); :  Reverse Alphabetical Order
	// fruits.sort((a,b) => b.calories-a.calories); : Numerical 
	// fruits.sort((a,b) => a.calories-b.calories); : Reverse Numerical 

    const list_fruits = fruits.map((fruit) => (
	<li key={fruit.name}>{fruit.name}:&nbsp; {fruit.calories}</li>
	));
	

    return (<>
	<h3 className="list-category">{category}</h3>
	<ul className="list-items">{list_fruits}</ul>
	</>);
    
}

export default List;