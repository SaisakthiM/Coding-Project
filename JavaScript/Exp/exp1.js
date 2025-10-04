async function fetchData() {
  let data;
  try {
    data = await fetch("https://jsonplaceholder.typicode.com/posts/1");
    console.log("Data received:", data);
  } catch (error) {
    console.error("Error:", error);
  }
  return data;
}

fetchData().then(result => console.log("Final:", result));