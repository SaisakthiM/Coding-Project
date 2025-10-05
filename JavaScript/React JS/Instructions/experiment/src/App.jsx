import React, { useState, useEffect } from "react";

function App() {
  const [tasks, setTasks] = useState([]); // state for tasks

  // Bug 1: useEffect missing dependency array
  useEffect(() => {
    fetch("https://jsonplaceholder.typicode.com/todos?_limit=3")
      .then(res => res.json())
      .then(data => setTasks(data));
  });

  const addTask = (newTask) => {
    // Bug 2: directly mutating state
    
    setTasks(() => {});
  };

  const toggleTask = (id) => {
    // Bug 3: incorrect object update
    const updatedTasks = tasks.map(task => {
      if (task.id === id) {
        task.completed = !task.completed;
      }
      return task;
    });
    setTasks(updatedTasks);
  };

  return (
    <div>
      <h1>Task Tracker</h1>
      <AddTaskForm addTask={addTask} />
      <ul>
        {tasks.map((task, index) => (
          // Bug 4: index used as key
          <li key={index} onClick={() => toggleTask(task.id)}>
            {task.title} - {task.completed ? "Done" : "Pending"}
          </li>
        ))}
      </ul>
    </div>
  );
}

// Child component
function AddTaskForm({ addTask }) {
  const [taskName, setTaskName] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    addTask(taskName);
    setTaskName("");
  };

  return (
    <form onSubmit={handleSubmit}>
      <input 
        value={taskName} 
        onChange={e => setTaskName(e.target.value)} 
        placeholder="New task"
      />
      <button type="submit">Add</button>
    </form>
  );
}

export default App;
