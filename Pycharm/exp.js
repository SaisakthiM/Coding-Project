function fetchUserData() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Fetching user data...");
      resolve({ name: "Sai", id: 101 });
    }, 1000);
  });
}

function fetchPosts(userId) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Fetching posts for user", userId);
      resolve(["Post 1", "Post 2"]);
    }, 1000);
  });
}

function fetchComments(post) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Fetching comments for", post);
      resolve(["Nice!", "Great post!"]);
    }, 1000);
  });
}

// ❌ Code to debug
fetchUserData()
  .then(user => {
    fetchPosts(user.id);
  })
  .then(posts => {
    fetchComments("Post 1");
  })
  .then(comments => {
    console.log("Comments:", comments[0]);
  })
  .catch(err => console.error("Error:", err));
