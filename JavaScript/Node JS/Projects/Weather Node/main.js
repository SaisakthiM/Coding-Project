function goToResults() {
    const latitude = document.getElementById("input_latitude").value;
    const longitude = document.getElementById("input_longitude").value;

    if (!latitude || !longitude) {
        alert("Please enter both latitude and longitude");
        return;
    }

    // Store data temporarily
    localStorage.setItem("latitude", latitude);
    localStorage.setItem("longitude", longitude);

    // Redirect to results page
    window.location.href = "result.html";
}
