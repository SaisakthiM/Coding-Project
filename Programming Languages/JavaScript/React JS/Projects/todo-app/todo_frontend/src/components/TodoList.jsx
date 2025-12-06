import React from "react";
import { useQuery, gql } from "@apollo/client";

const GET_TODOS = gql`
  query {
    allTodos {
      id
      name
      isCompleted
      createdAt
    }
  }
`;

export default function TodoList() {
  const { loading, error, data } = useQuery(GET_TODOS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      <h2>Todo List</h2>
      <ul>
        {data.allTodos.map((todo) => (
          <li key={todo.id}>
            {todo.name} — {todo.isCompleted ? "✅ Completed" : "🕒 Pending"}
          </li>
        ))}
      </ul>
    </div>
  );
}
