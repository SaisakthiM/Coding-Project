import { Link } from "react-router-dom"
import "./Home.css"

export function Home() {
    return (
        <div className="home-wrapper">
            <div className="home-container">
                <div className="hero">
                    <span className="badge">v1.0</span>
                    <h1>API Service</h1>
                    <p className="subtitle">
                        A unified interface for fetching weather and location data.
                        Use Geocoding to convert a city into coordinates, then pass
                        them into the Weather API.
                    </p>
                </div>

                <div className="note-card">
                    <span className="note-icon">💡</span>
                    <p>Weather API requires latitude & longitude. Use the <strong>Geocoding API</strong> first to get coordinates from a city name.</p>
                </div>

                <div className="api-grid">
                    <Link to="/geo/cod" className="api-card">
                        <div className="api-card-icon">🌐</div>
                        <div className="api-card-content">
                            <h2 id="geocod">Geocoding API</h2>
                            <p>Convert a city name, state, and country code into latitude and longitude coordinates.</p>
                        </div>
                        <span className="api-card-arrow">→</span>
                    </Link>

                    <Link to="/weather" className="api-card">
                        <div className="api-card-icon">🌤️</div>
                        <div className="api-card-content">
                            <h2>Weather API</h2>
                            <p>Fetch real-time weather data for any location using its coordinates.</p>
                        </div>
                        <span className="api-card-arrow">→</span>
                    </Link>
                </div>
            </div>
        </div>
    )
}