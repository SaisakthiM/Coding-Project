import { useState } from "react";
import { gql, useQuery, useMutation } from "@apollo/client";
import Select from "react-select";

// GraphQL Queries & Mutations
const GET_TODOS = gql`
  query {
    allTodos {
      id
      name
      taskDescription
      isCompleted
    }
  }
`;

const CREATE_TODO = gql`
  mutation($name: String!, $task_description: String!, $is_completed: Boolean!) {
    createTodo(
      name: $name
      task_description: $task_description
      is_completed: $is_completed
    ) {
      id
      name
      taskDescription
      isCompleted
    }
  }
`;

const UPDATE_TODO = gql`
  mutation($id: Int!, $name: String!, $task_description: String!, $is_completed: Boolean!) {
    updateTodo(
      id: $id
      name: $name
      task_description: $task_description
      is_completed: $is_completed
    ) {
      id
      name
      taskDescription
      isCompleted
    }
  }
`;

function App() {
  const [page, setPage] = useState(0);
  const [taskName, setTaskName] = useState("");
  const [taskDescription, setTaskDescription] = useState("");
  const [isCompleted, setIsCompleted] = useState(false);
  const [selectedTaskId, setSelectedTaskId] = useState(null);

  const { data, loading, refetch } = useQuery(GET_TODOS);
  const [createTodo] = useMutation(CREATE_TODO);
  const [updateTodo] = useMutation(UPDATE_TODO);

  const tasks = data?.allTodos || [];

  const clearInputs = () => {
    setTaskName("");
    setTaskDescription("");
    setIsCompleted(false);
    setSelectedTaskId(null);
  };

  const handleAddTask = async () => {
    if (!taskName.trim()) {
      alert("Please enter a task name");
      return;
    }
    try {
      await createTodo({
        variables: {
          name: taskName,
          task_description: taskDescription,
          is_completed: isCompleted,
        },
      });
      await refetch();
      clearInputs();
      setPage(5);
    } catch (err) {
      console.error("Error adding task:", err);
      alert("Failed to add task. Please try again.");
    }
  };

  const handleSaveTask = async () => {
    if (!selectedTaskId) return;
    if (!taskName.trim()) {
      alert("Please enter a task name");
      return;
    }
    try {
      await updateTodo({
        variables: {
          id: parseInt(selectedTaskId),
          name: taskName,
          task_description: taskDescription,
          is_completed: isCompleted,
        },
      });
      await refetch();
      clearInputs();
      setPage(5);
    } catch (err) {
      console.error("Error updating task:", err);
      alert("Failed to update task. Please try again.");
    }
  };

  if (loading) return <div className="wrapper"><div className="container"><p>Loading tasks...</p></div></div>;

  const taskOptions = tasks.map((task) => ({
    value: task.id,
    label: `${task.name} — ${task.isCompleted ? "✅" : "🕒"}`,
  }));

  return (
    <div className="wrapper">
      <div className="container">
        {/* Home Page */}
        {page === 0 && (
          <>
            <h1>TODO App</h1>
            <div className="button_home">
              <button onClick={() => setPage(1)}>Let's Start</button>
              <button onClick={() => setPage(5)}>See Your Previous Tasks</button>
              {tasks.length > 0 && (
                <button onClick={() => setPage(6)}>Modify a Task</button>
              )}
            </div>
          </>
        )}

        {/* Page 1: Task Name */}
        {page === 1 && (
          <>
            <h1>Task Name</h1>
            <input
              type="text"
              placeholder="Enter task name"
              value={taskName}
              onChange={(e) => setTaskName(e.target.value)}
            />
            <div className="button_home">
              <button onClick={() => setPage(2)}>Next</button>
              <button onClick={() => { clearInputs(); setPage(0); }}>Cancel</button>
            </div>
          </>
        )}

        {/* Page 2: Task Description */}
        {page === 2 && (
          <>
            <h1>Task Description</h1>
            <input
              type="text"
              placeholder="Enter task description"
              value={taskDescription}
              onChange={(e) => setTaskDescription(e.target.value)}
            />
            <div className="button_home">
              <button onClick={() => setPage(3)}>Next</button>
              <button onClick={() => setPage(1)}>Back</button>
            </div>
          </>
        )}

        {/* Page 3: Task Progress */}
        {page === 3 && (
          <>
            <h1>Task Progress</h1>
            <p>Is your task finished?</p>
            <div className="button_home">
              <button 
                onClick={() => setIsCompleted(true)}
                style={{ 
                  backgroundColor: isCompleted ? "#4CAF50" : undefined,
                  color: isCompleted ? "white" : undefined
                }}
              >
                ✅ Yes
              </button>
              <button 
                onClick={() => setIsCompleted(false)}
                style={{ 
                  backgroundColor: !isCompleted ? "#FF9800" : undefined,
                  color: !isCompleted ? "white" : undefined
                }}
              >
                🕒 No
              </button>
            </div>
            <div className="button_home" style={{ marginTop: "20px" }}>
              <button onClick={handleAddTask}>Add Task</button>
              <button onClick={() => setPage(2)}>Back</button>
            </div>
          </>
        )}

        {/* Page 5: Recorded Tasks */}
        {page === 5 && (
          <>
            <h1>Recorded Tasks</h1>
            {tasks.length === 0 ? (
              <p>No tasks recorded yet.</p>
            ) : (
              <ul>
                {tasks.map((task) => (
                  <li key={task.id}>
                    <strong>{task.name}</strong> — {task.taskDescription} —{" "}
                    {task.isCompleted ? "✅ Completed" : "🕒 Pending"}
                  </li>
                ))}
              </ul>
            )}
            <div className="button_home">
              <button onClick={() => { clearInputs(); setPage(1); }}>Add More Tasks</button>
              {tasks.length > 0 && (
                <button onClick={() => { clearInputs(); setPage(6); }}>Modify a Task</button>
              )}
              <button onClick={() => { clearInputs(); setPage(0); }}>Home</button>
            </div>
          </>
        )}

        {/* Page 6: Modify Task */}
        {page === 6 && (
          <>
            <h1>Modify a Task</h1>
            {tasks.length === 0 ? (
              <p>No tasks available to modify.</p>
            ) : (
              <>
                <Select
                  options={taskOptions}
                  value={taskOptions.find((opt) => opt.value === selectedTaskId)}
                  onChange={(selected) => {
                    setSelectedTaskId(selected.value);
                    const task = tasks.find((t) => t.id === selected.value);
                    setTaskName(task.name);
                    setTaskDescription(task.taskDescription);
                    setIsCompleted(task.isCompleted);
                  }}
                  styles={{
                    control: (base) => ({
                      ...base,
                      borderRadius: 10,
                      backgroundColor: "rgba(255,255,255,0.3)",
                      backdropFilter: "blur(10px)",
                      border: "2px solid rgba(255,255,255,0.5)",
                    }),
                    option: (base, state) => ({
                      ...base,
                      borderRadius: 10,
                      backgroundColor: state.isFocused
                        ? "rgba(255,235,53,0.5)"
                        : "rgba(255,255,255,0.9)",
                      color: "#222",
                    }),
                  }}
                  placeholder="Select a task to modify"
                />

                {selectedTaskId && (
                  <div style={{ marginTop: "20px" }}>
                    <input
                      type="text"
                      placeholder="Task Name"
                      value={taskName}
                      onChange={(e) => setTaskName(e.target.value)}
                    />
                    <input
                      type="text"
                      placeholder="Task Description"
                      value={taskDescription}
                      onChange={(e) => setTaskDescription(e.target.value)}
                    />
                    <div style={{ margin: "20px 0" }}>
                      <p>Task Status:</p>
                      <div className="button_home">
                        <button 
                          onClick={() => setIsCompleted(true)}
                          style={{ 
                            backgroundColor: isCompleted ? "#4CAF50" : undefined,
                            color: isCompleted ? "white" : undefined
                          }}
                        >
                          ✅ Completed
                        </button>
                        <button 
                          onClick={() => setIsCompleted(false)}
                          style={{ 
                            backgroundColor: !isCompleted ? "#FF9800" : undefined,
                            color: !isCompleted ? "white" : undefined
                          }}
                        >
                          🕒 Pending
                        </button>
                      </div>
                    </div>
                    <div className="button_home">
                      <button onClick={handleSaveTask}>Save Changes</button>
                      <button onClick={() => { clearInputs(); setPage(5); }}>Cancel</button>
                    </div>
                  </div>
                )}
              </>
            )}
            <div className="button_home">
              <button onClick={() => { clearInputs(); setPage(5); }}>Back to Tasks</button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

export default App;