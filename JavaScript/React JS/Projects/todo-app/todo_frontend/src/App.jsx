import TodoList from "./components/TodoList.jsx";

export default function App() {
  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>My TODOs</h1>
      <TodoList />
    </div>
  );
}
