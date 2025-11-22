from fpdf import FPDF

def create_backend_learning_pdf():
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)

    title = "Learning Path to Backend Development: Free Resources"
    pdf.cell(200, 10, text=title, ln=1, align="C")
    pdf.ln(5)

    content = """
To embark on your journey to becoming a Backend Developer, focusing on the following key areas with the provided free resources will be beneficial:

**1. Programming Languages:**

  * **Python:** A versatile and beginner-friendly language widely used in backend development.
      * **Free Resources:**
          * freeCodeCamp - Scientific Computing with Python: https://www.freecodecamp.org/learn/scientific-computing-with-python/
          * Google's Python Class: https://developers.google.com/edu/python/
          * Learn Python the Hard Way (Online HTML Version): https://web.archive.org/web/20160423062421/http://learnpythonthehardway.org/book/
  * **JavaScript (Node.js):** Essential for full-stack development, allowing you to use JavaScript on the backend.
      * **Free Resources:**
          * freeCodeCamp - JavaScript Algorithms and Data Structures: https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/
          * freeCodeCamp - Back End Development and APIs: https://www.freecodecamp.org/learn/back-end-development-and-apis/
          * MDN Web Docs - JavaScript: https://developer.mozilla.org/en-US/docs/Web/JavaScript
          * The Net Ninja (YouTube): https://www.youtube.com/c/TheNetNinja

**2. Databases:**

  * **SQL Databases (MySQL, PostgreSQL, SQLite):** Fundamental for structured data management.
      * **Free Resources:**
          * Khan Academy - SQL: https://www.khanacademy.org/computing/computer-programming/sql
          * W3Schools - SQL Tutorial: https://www.w3schools.com/sql/
          * SQLZoo: https://sqlzoo.net/
  * **NoSQL Databases (MongoDB):** Popular for flexible, unstructured data.
      * **Free Resources:**
          * MongoDB University: https://www.mongodb.com/learn
          * freeCodeCamp - MongoDB and Mongoose: https://www.freecodecamp.org/learn/back-end-development-and-apis/#mongodb-and-mongoose

**3. Backend Frameworks:**

  * **Python Frameworks (Django, Flask):** Provide structure for building web applications.
      * **Free Resources:**
          * Django Girls Tutorial: https://djangogirls.org/en/
          * The Flask Mega-Tutorial: https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world
  * **JavaScript (Node.js) Frameworks (Express.js, NestJS):** Used for building scalable server-side applications.
      * **Free Resources:**
          * freeCodeCamp - Express.js: https://www.freecodecamp.org/learn/back-end-development-and-apis/#basic-node-and-express
          * Node.js Documentation: https://nodejs.org/en/docs/
          * YouTube tutorials (search for Express.js and NestJS): https://www.google.com/search?q=

**4. APIs (Application Programming Interfaces):**

  * **Free Resources:**
    * freeCodeCamp - API Development and Microservices: https://www.freecodecamp.org/learn/back-end-development-and-apis/#apis-and-microservices
    * Postman Learning Center: https://learning.postman.com/
    * YouTube tutorials (search for "REST API tutorial for beginners"): https://www.google.com/search?q=

**5. Version Control (Git):**

  * **Free Resources:**
    * freeCodeCamp - Git and GitHub: https://www.freecodecamp.org/learn/quality-assurance/information-security-and-quality-assurance-curriculum-v7.1.0/information-security-with-helmetjs
    * Git Handbook: https://git-scm.com/book/en/v2
    * Atlassian Git Tutorials: https://www.atlassian.com/git/tutorials

**6. Web Servers (Nginx, Apache):**

  * **Free Resources:** (Often covered in introductory backend development courses and online tutorials)

**7. Basic Frontend Knowledge (HTML, CSS, JavaScript, React/Angular/Vue.js):**

  * **Free Resources:**
    * freeCodeCamp: https://www.freecodecamp.org/
    * MDN Web Docs: https://developer.mozilla.org/en-US/
    * The Odin Project: https://www.theodinproject.com/

**General Advice:**

  * Start with one language (Python or JavaScript recommended).
  * Focus on building projects to apply your learning.
  * Engage with online communities for support.
  * Be patient and persistent in your learning journey.
    """

    pdf.multi_cell(0, 10, text=content)
    pdf.output("backend_learning_resources.pdf", "F")

if __name__ == "__main__":
    create_backend_learning_pdf()
    print("PDF 'backend_learning_resources.pdf' generated successfully.")