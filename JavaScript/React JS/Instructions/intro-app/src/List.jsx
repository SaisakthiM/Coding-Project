import PropTypes from "prop-types";
function List({
	items = [
		{ name: "item1", calories: 10 },
		{ name: "item2", calories: 20 },
		{ name: "item3", calories: 30 }
	],
	category = "list_of_items"
}) 
	{
	const fruits = [...items];

	const list_fruits = fruits.map((fruit) => (
		<li key={fruit.name}>
		{fruit.name}: {fruit.calories}
		</li>
	));

	return (
		<>
		<h3 className="list-category">{category}</h3>
		<ul className="list-items">{list_fruits}</ul>
		</>
	);
}
List.propTypes = {
	items: PropTypes.arrayOf(
		PropTypes.shape({
		name: PropTypes.string.isRequired,
		calories: PropTypes.number.isRequired
		})
	),
	category: PropTypes.string
};

export default List;
