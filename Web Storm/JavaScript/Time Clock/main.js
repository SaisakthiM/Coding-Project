let currentTime = null; // store fetched API time
let timer = null;       // API timer interval

let localTime = null;   // store initial local time
let localTimer = null;  // local timer interval

async function getTime(region, city) {
    const inputBox = document.querySelector(".result_text");

    try {
        if (!region || !city) {
            inputBox.value = "Please enter both region and city.";
            return;
        }

        inputBox.classList.add("loading");
        inputBox.value = "Loading...";

        const apiKey = "b4effe8ab1494bcfa6cadfacabd74325"; // replace with your API key
        const location = `${region}/${city}`;
        const url = `https://timezone.abstractapi.com/v1/current_time/?api_key=${apiKey}&location=${location}`;

        let response = await fetch(url);

        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }

        let data = await response.json();
        console.log("API Response:", data);

        currentTime = new Date(data.datetime);

        if (timer) clearInterval(timer);
        if (localTimer) clearInterval(localTimer);

        function updateDisplay() {
            const datePart = currentTime.toLocaleDateString();
            const timePart = currentTime.toLocaleTimeString();
            inputBox.value = `${datePart} ${timePart}`;
        }

        updateDisplay();

        timer = setInterval(() => {
            currentTime.setSeconds(currentTime.getSeconds() + 1);
            updateDisplay();
        }, 1000);

    } catch (error) {
        console.error("Error fetching time:", error);
        inputBox.value = "Invalid region/city or API error!";
    } finally {
        inputBox.classList.remove("loading");
    }
}

function startLocalTimeUpdate() {
    const inputBox = document.querySelector(".result_text");

    if (timer) clearInterval(timer);
    if (localTimer) clearInterval(localTimer);

    localTime = new Date();

    updateLocalTimeDisplay();

    localTimer = setInterval(() => {
        localTime.setSeconds(localTime.getSeconds() + 1);
        updateLocalTimeDisplay();
    }, 1000);
}

function updateLocalTimeDisplay() {
    const inputBox = document.querySelector(".result_text");

    const month = localTime.getMonth() + 1;
    const day = localTime.getDate();
    const year = localTime.getFullYear();

    let hours = localTime.getHours();
    const minutes = localTime.getMinutes();
    const seconds = localTime.getSeconds();
    const ampm = hours >= 12 ? 'PM' : 'AM';

    hours = hours % 12;
    hours = hours ? hours : 12;

    const minStr = minutes < 10 ? '0' + minutes : minutes;
    const secStr = seconds < 10 ? '0' + seconds : seconds;

    const display_date = `${month}/${day}/${year} ${hours}:${minStr}:${secStr} ${ampm}`;

    inputBox.value = display_date;
}

// Event listener for API fetch button
document.querySelector(".button_clock").addEventListener("click", function (e) {
    e.preventDefault();
    let user_city = document.querySelector(".city_input").value.trim();
    let user_region = document.querySelector(".region_input").value.trim();

    getTime(user_region, user_city);
});

// Event listener for local time button
document.querySelector("#local_button button").addEventListener("click", function(e) {
    e.preventDefault();
    startLocalTimeUpdate();
});
