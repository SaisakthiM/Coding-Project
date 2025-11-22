import axios from "axios";
import { useQuery } from "@tanstack/react-query";
import "./Fetcher.css";

export default function Fetcher() {
    const apiKey = "b06M6OgOB21mpt5D/kt+4A==cqCxjUjzmF3vkAie";

    const fetchQuote = async () => {
        const res = await axios.get("https://api.api-ninjas.com/v1/quotes", {
            headers: { "X-Api-Key": apiKey },
        });
        console.log(res.data[0]);
        return res.data[0];
    };

    const { data, isLoading, error, refetch } = useQuery({
        queryKey: ["quote"],
        queryFn: fetchQuote,
        enabled: false,
    });

    return (
        <div className="fetcher-wrapper">
            <div className="fetcher-container">
                <div className="quote-content">
                    {isLoading ? (
                        <p className="message">Loading...</p>
                    ) : error ? (
                        <p className="message">Error fetching quote. Check console.</p>
                    ) : data ? (
                        <>
                            <h3 className="quote-text">"{data.quote}"</h3>
                            <p className="quote-author">— {data.author}</p>
                        </>
                    ) : (
                        <p className="message">Click the button to generate a quote.</p>
                    )}
                </div>

                <button className="fetcher-button" onClick={() => refetch()}>
                    Generate Quote
                </button>
            </div>
        </div>
    );
}