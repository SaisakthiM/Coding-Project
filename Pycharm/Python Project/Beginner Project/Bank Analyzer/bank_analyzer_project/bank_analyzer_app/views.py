from django.shortcuts import render
from django.core.files.storage import FileSystemStorage
import pandas as pd
from django.http import HttpResponse
import io
import zipfile
from django.conf import settings  # Import settings


def analyze_bank_data(request):
    if request.method == 'POST' and request.FILES['csv_file']:
        csv_file = request.FILES['csv_file']
        try:
            df = pd.read_csv(csv_file)
            # Perform your analysis here
            analysis_results = analyze_data(df)  # Call the function

            # Generate the HTML content
            html_content = generate_html(analysis_results)

            # Create a zip file in memory
            zip_buffer = io.BytesIO()
            with zipfile.ZipFile(zip_buffer, 'w') as zf:
                zf.writestr("bank_analyzer_app/index.html", html_content.encode('utf-8'))

            # Prepare the response
            response = HttpResponse(zip_buffer.getvalue(), content_type='application/zip')
            response['Content-Disposition'] = 'attachment; filename="bank_data_analysis.zip"'
            return response

        except Exception as e:
            return render(request, 'index.html', {'error_message': f"Error processing file: {e}"})

    return render(request, 'bank_analyzer_app/index.html')


def analyze_data(df):
    """
    Perform the data analysis here.  This is where you'll do the calculations
    on the DataFrame.
    """
    # Example Analysis (replace with your actual analysis)
    total_income = df[df['Type'] == 'Income']['Amount'].sum()
    total_expenses = df[df['Type'] == 'Expense']['Amount'].sum()
    average_income = df[df['Type'] == 'Income']['Amount'].mean()

    expense_breakdown = df[df['Type'] == 'Expense'].groupby('Category')['Amount'].sum().to_dict()

    # Monthly data aggregation
    df['Date'] = pd.to_datetime(df['Date'])  # Ensure Date is datetime
    df['Month'] = df['Date'].dt.strftime('%B')  # Extract month name
    monthly_data = df.groupby('Month').agg(
        Income=('Amount', lambda x: x[df['Type'] == 'Income'].sum()),
        Expenses=('Amount', lambda x: x[df['Type'] == 'Expense'].sum())
    ).reset_index()

    # Create a dictionary for the template
    analysis_results = {
        'total_income': total_income,
        'average_income': average_income,
        'total_expenses': total_expenses,
        'expense_breakdown': expense_breakdown,
        'transactions': df.to_dict('records'),
        'monthly_data': monthly_data.set_index('Month').to_dict('index') #important
    }
    return analysis_results

def generate_html(analysis_results):
    """
    Generates the HTML content from the analysis results.  This function
    replaces the template rendering.
    """
    # Start of the HTML
    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bank Data Analyzer</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Racing+Sans+One&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                font-family: 'Racing Sans One', cursive;
                background-image: url('https://images.unsplash.com/photo-1552519507-c1b5d9697a9b?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
                background-size: cover;
                background-position: center;
            }
            .bg-white-with-opacity {
                background-color: rgba(255, 255, 255, 0.5);
            }
        </style>
    </head>
    <body class="p-8">
        <div class="container mx-auto p-8 bg-white-with-opacity rounded-lg shadow-md backdrop-blur-md border border-gray-200">
            <h1 class="text-3xl font-bold text-center text-blue-900 mb-6 text-shadow-md">
                <i class="fas fa-chart-line mr-2"></i> Bank Data Analyzer
            </h1>
            <p class="text-center text-gray-700 mb-8">
                Upload your bank data in CSV format to analyze your finances.
            </p>
    """

    # Form for file upload
    html += """
            <form method="post" enctype="multipart/form-data" class="max-w-md mx-auto mb-8">
                {% csrf_token %}
                <div class="mb-4">
                    <label for="csv_file" class="block text-gray-700 text-sm font-bold mb-2">
                        <i class="fas fa-upload mr-2"></i> Upload CSV File:
                    </label>
                    <input type="file" name="csv_file" id="csv_file" accept=".csv" required
                           class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                </div>
                <button type="submit" class="bg-gradient-to-r from-green-400 to-blue-500 hover:from-green-500 hover:to-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    <i class="fas fa-search mr-2"></i> Analyze Data
                </button>
            </form>
    """

    # Error message
    html += """
            {% if error_message %}
                <div class="mt-6 text-center text-red-500 font-semibold">
                    {{ error_message }}
                </div>
            {% endif %}
    """

    # Analysis results
    if analysis_results:
        html += """
            <div class="mt-8">
                <h2 class="text-2xl font-semibold text-gray-900 mb-6 text-center">Analysis Results</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div class="bg-white/50 rounded-lg p-6 shadow-md backdrop-blur-md border border-gray-200">
                        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-chart-bar mr-2 text-blue-500"></i> Income Overview
                        </h3>
                        <div class="chart-container">
                            <canvas id="incomeChart"></canvas>
                        </div>
                        <div class="mt-4">
                            <p class="text-gray-700">Total Income: <span class="font-semibold text-green-600">${}</span></p>
                            <p class="text-gray-700">Average Income: <span class="font-semibold text-green-600">${}</span></p>
                        </div>
                    </div>
                    <div class="bg-white/50 rounded-lg p-6 shadow-md backdrop-blur-md border border-gray-200">
                        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-chart-pie mr-2 text-red-500"></i> Expense Breakdown
                        </h3>
                        <div class="chart-container">
                            <canvas id="expenseChart"></canvas>
                        </div>
                        <div class="mt-4">
                            <p class="text-gray-700">Total Expenses: <span class="font-semibold text-red-600">${}</span></p>
                            <ul class="list-none p-0">
                            """.format(analysis_results['total_income'],analysis_results['average_income'],analysis_results['total_expenses']) #inserted the python variables
        for category, amount in analysis_results['expense_breakdown'].items():
            html += f"""
                                <li class="py-1">
                                    <span class="text-gray-700">{category}:</span>
                                    <span class="font-semibold text-red-600">${amount}</span>
                                </li>
            """
        html += """
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="bg-white/50 rounded-lg p-6 shadow-md backdrop-blur-md border border-gray-200 mb-6">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-chart-line mr-2 text-green-500"></i> Monthly Trend
                    </h3>
                    <div class="chart-container">
                        <canvas id="monthlyTrendChart"></canvas>
                    </div>
                </div>

                <div class="bg-white/50 rounded-lg p-6 shadow-md backdrop-blur-md border border-gray-200">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                        <i class="fas fa-table mr-2 text-purple-500"></i> Transaction Summary
                    </h3>
                    <div class="overflow-x-auto">
                        <table class="min-w-full leading-normal shadow-md rounded-lg overflow-hidden">
                            <thead class="bg-gray-200 text-gray-700">
                                <tr>
                                    <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold uppercase tracking-wider">
                                        Date
                                    </th>
                                    <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold uppercase tracking-wider">
                                        Description
                                    </th>
                                    <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold uppercase tracking-wider">
                                        Amount
                                    </th>
                                    <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold uppercase tracking-wider">
                                        Type
                                    </th>
                                    <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold uppercase tracking-wider">
                                        Category
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white">
                            """.format()
        for transaction in analysis_results['transactions']:
            html += f"""
                                <tr>
                                    <td class="px-5 py-5 border-b border-gray-200 text-sm"><span class="font-italic text-gray-800">{transaction['Date']}</span></td>
                                    <td class="px-5 py-5 border-b border-gray-200 text-sm"><span class="text-blue-600">{transaction['Description']}</span></td>
                                    <td class="px-5 py-5 border-b border-gray-200 text-sm"><span class="font-semibold {
                'text-green-600' if transaction['Type'] == 'Income' else 'text-red-600'
            }">${transaction['Amount']}</span></td>
                                    <td class="px-5 py-5 border-b border-gray-200 text-sm"><span class="font-bold {
                'text-green-700' if transaction['Type'] == 'Income' else 'text-red-700'
            }">{transaction['Type']}</span></td>
                                    <td class="px-5 py-5 border-b border-gray-200 text-sm"><span class="font-oblique font-sans text-purple-500">{transaction['Category']}</span></td>
                                </tr>
            """
        html += """
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        """
    # End of the HTML
    html += """
        </div>

        <script src="https://kit.fontawesome.com/4f535d259a.js" crossorigin="anonymous"></script>
        <script>
    """
    if analysis_results:
        html += """
        const incomeCtx = document.getElementById('incomeChart').getContext('2d');
        const expenseCtx = document.getElementById('expenseChart').getContext('2d');
        const monthlyTrendCtx = document.getElementById('monthlyTrendChart').getContext('2d');

        const incomeChart = new Chart(incomeCtx, {
            type: 'bar',
            data: {
                labels: ["""
        html += ','.join(f"'{month}'" for month in analysis_results['monthly_data'].keys())
        html += "],"
        html += """
                datasets: [{
                    label: 'Income',
                    data: ["""
        html += ','.join(str(data['Income']) for data in analysis_results['monthly_data'].values())
        html += "],"
        html += """
                    backgroundColor: '#36a2eb',
                    borderColor: '#36a2eb',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Monthly Income',
                        font: {
                            size: 16
                        }
                    },
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        const expenseChart = new Chart(expenseCtx, {
            type: 'pie',
            data: {
                labels: ["""
        html += ','.join(f"'{category}'" for category in analysis_results['expense_breakdown'].keys())
        html += "],"
        html += """
                datasets: [{
                    label: 'Expenses',
                    data: ["""
        html += ','.join(str(amount) for amount in analysis_results['expense_breakdown'].values())
        html += "],"
        html += """
                backgroundColor: [
                    '#ff6384',
                    '#ff9f40',
                    '#ffcd56',
                    '#4bc0c0',
                    '#9966ff',
                    '#ffeb3b',
                    '#00bcd4',
                    '#e91e63'
                ],
                borderColor: '#ffffff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Expense Distribution',
                    font: {
                        size: 16
                    }
                },
                legend: {
                    position: 'top'
                }
            }
        });

        const monthlyTrendChart = new Chart(monthlyTrendCtx, {
            type: 'line',
            data: {
                labels: ["""
        html += ','.join(f"'{month}'" for month in analysis_results['monthly_data'].keys())
        html += "],"
        html += """
                datasets: [
                    {
                        label: 'Income',
                        data: ["""
        html += ','.join(str(data['Income']) for data in analysis_results['monthly_data'].values())
        html += "],"
        html += """
                        borderColor: '#4CAF50',
                        fill: false,
                        pointRadius: 5,
                        pointBackgroundColor: '#4CAF50',
                        pointHoverRadius: 7,
                        borderWidth: 2
                    },
                    {
                        label: 'Expenses',
                        data: ["""
        html += ','.join(str(data['Expenses']) for data in analysis_results['monthly_data'].values())
        html += "],"
        html += """
                        borderColor: '#F44336',
                        fill: false,
                        pointRadius: 5,
                        pointBackgroundColor: '#F44336',
                        pointHoverRadius: 7,
                        borderWidth: 2
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Monthly Income and Expense Trend',
                        font: {
                            size: 16
                        }
                    },
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    x: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Month'
                        }
                    },
                    y: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Amount ($)'
                        },
                        beginAtZero: true
                    }
                }
            }
        });
        """
    html += """
        </script>
    </body>
    </html>
    """
    return html