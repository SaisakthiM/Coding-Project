from flask import Flask, request, render_template_string
import csv
from io import TextIOWrapper

app = Flask(__name__)

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <title>Bank Analyzer</title>
    <script src=\"https://cdn.jsdelivr.net/npm/chart.js\"></script>
    <style>
        body {
            background: linear-gradient(145deg, #1a1a1a, #0f0f0f);
            font-family: 'Segoe UI', sans-serif;
            color: #f1f1f1;
            padding: 40px;
            text-align: center;
        }
        h1 {
            color: #39ff14;
            margin-bottom: 20px;
        }
        form {
            margin: 30px auto;
        }
        input[type=\"file\"] {
            background: #1f1f1f;
            color: #fff;
            padding: 10px;
            border-radius: 6px;
            border: none;
        }
        input[type=\"submit\"] {
            background: #39ff14;
            color: #000;
            padding: 12px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            margin-left: 10px;
            transition: background 0.3s;
        }
        input[type=\"submit\"]:hover {
            background: #00e600;
        }
        .stats {
            margin-top: 30px;
        }
        .stats h3 {
            margin: 10px 0;
        }
        table {
            margin: 30px auto;
            border-collapse: collapse;
            width: 90%;
            background-color: #1f1f1f;
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            border: 1px solid #333;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #2b2b2b;
        }
        .chart-container {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
            margin-top: 40px;
        }
        canvas {
            width: 350px !important;
            height: 250px !important;
        }
    </style>
</head>
<body>
    <h1>Bank Analyzer</h1>
    <form method=\"POST\" enctype=\"multipart/form-data\">
        <input type=\"file\" name=\"file\" required>
        <input type=\"submit\" value=\"Analyze\">
    </form>

    {% if rows %}
        <div class=\"stats\">
            <h3>Total Credit: ₹{{ total_credit }}</h3>
            <h3>Total Debit: ₹{{ total_debit }}</h3>
            <h2>Current Balance: ₹{{ balance }}</h2>
        </div>

        <div class=\"chart-container\">
            <canvas id=\"barChart\"></canvas>
            <canvas id=\"pieChart\"></canvas>
            <canvas id=\"doughnutChart\"></canvas>
        </div>

        <h2>Transaction Details</h2>
        <table>
            <tr>
                {% for header in headers %}
                    <th>{{ header }}</th>
                {% endfor %}
            </tr>
            {% for row in rows %}
                <tr>
                    {% for cell in row %}
                        <td>{{ cell }}</td>
                    {% endfor %}
                </tr>
            {% endfor %}
        </table>

        <script>
            const totalCredit = {{ total_credit|tojson }};
            const totalDebit = {{ total_debit|tojson }};

            new Chart(document.getElementById(\"barChart\"), {
                type: 'bar',
                data: {
                    labels: ['Credit', 'Debit'],
                    datasets: [{
                        label: 'Amount (₹)',
                        data: [totalCredit, totalDebit],
                        backgroundColor: ['#4bc0c0', '#ff6384'],
                        borderRadius: 10
                    }]
                },
                options: {
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true }
                    }
                }
            });

            new Chart(document.getElementById(\"pieChart\"), {
                type: 'pie',
                data: {
                    labels: ['Credit', 'Debit'],
                    datasets: [{
                        label: 'Transaction Split',
                        data: [totalCredit, totalDebit],
                        backgroundColor: ['#4bc0c0', '#ff6384']
                    }]
                }
            });

            new Chart(document.getElementById(\"doughnutChart\"), {
                type: 'doughnut',
                data: {
                    labels: ['Credit', 'Debit'],
                    datasets: [{
                        label: 'Overview',
                        data: [totalCredit, totalDebit],
                        backgroundColor: ['#4bc0c0', '#ff6384']
                    }]
                }
            });
        </script>
    {% endif %}
</body>
</html>"""

@app.route("/", methods=["GET", "POST"])
def upload_file():
    rows = []
    total_credit = 0
    total_debit = 0
    headers = []
    if request.method == "POST":
        file = request.files["file"]
        if file:
            csv_file = TextIOWrapper(file, encoding='utf-8')
            reader = csv.reader(csv_file)
            headers = next(reader)
            for row in reader:
                rows.append(row)
                try:
                    amount = float(row[2])
                    if row[3].lower() == 'credit':
                        total_credit += amount
                    elif row[3].lower() == 'debit':
                        total_debit += abs(amount)
                except:
                    continue
    balance = total_credit - total_debit
    return render_template_string(HTML_TEMPLATE, rows=rows, total_credit=total_credit, total_debit=total_debit, balance=balance, headers=headers)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
