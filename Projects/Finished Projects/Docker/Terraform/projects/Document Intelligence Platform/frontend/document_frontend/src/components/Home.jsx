import { Link } from 'react-router-dom'

export function Home() {
    return (
        <>
            <div className="wrapper">
                <div className="container">
                    <h1>Document Intelligence Platform</h1>
                    <p className="subtitle">Upload, process, and explore documents with AI</p>
                </div>
            </div>

            <div className="content">
                <p>Upload your documents and books to get AI-powered summaries, insights, and reading recommendations — all in one place.</p>
            </div>

            <div className="nav-links">
                <Link to="/upload" className="nav-card">
                    <span className="nav-icon">↑</span>
                    <span className="nav-label">Upload</span>
                    <span className="nav-desc">Add a new document or book</span>
                </Link>
                <Link to="/library" className="nav-card">
                    <span className="nav-icon">☰</span>
                    <span className="nav-label">Library</span>
                    <span className="nav-desc">View your uploaded files</span>
                </Link>
                <Link to="/ask" className="nav-card">
                    <span className="nav-icon">?</span>
                    <span className="nav-label">Ask</span>
                    <span className="nav-desc">Chat about your documents</span>
                </Link>
            </div>
        </>
    );
}