function Item({name, ispacked}) {
    let k = ispacked ? (<li className="item"><del>{name} ✅</del></li>) : (<li className="item">{name} ❌</li>);
    return k;
}

export default function PackingList() {
    return (
        <section>
            <h1>Sally Ride's Packing List</h1>
            <ul>
                <Item ispacked={true} name={"space suit"}/>
                <Item ispacked={true} name={"helmet"}/>
                <Item ispacked={false} name={"photo"}/>
            </ul>
        </section>
    )
}