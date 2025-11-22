import React, { useState } from 'react';

function Counter() {
    const [count, setCount] = useState(0);

    let [incrementCount, decrementCount,resetCount] = [
        () => setCount(prev => { return prev + 1; }),
        () => setCount(prev => { return prev - 1; }),
        () => setCount(0)
    ];

    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={incrementCount}>+</button>
            <button onClick={decrementCount}>-</button>
            <button onClick={resetCount}>reset</button>
        </div>
    );
}

export default Counter;
