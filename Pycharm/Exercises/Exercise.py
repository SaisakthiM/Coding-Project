from collections import Counter

a = """In the world of computer science, problems often look complex at first, 
but they can be solved step by step with patience and logic. 
Programming is not just about writing code; it is about solving problems, 
analyzing patterns, and building solutions that work reliably. 
A student who learns programming early develops a way of thinking that is structured and creative at the same time. 
Such a mindset can help in many fields, not only in computer science but also in mathematics,
engineering, economics, and even in everyday decision-making.
When you count words in a text, for example, you are breaking down a larger problem into smaller steps: 
splitting the text, analyzing the pieces, and then counting frequencies. 
This is a basic form of text analysis, 
and it demonstrates how programming can turn raw data into meaningful insights. 
Over time, such simple exercises lead to stronger problem-solving skills and 
prepare learners for more advanced challenges."""

words = a.split()
word_count = Counter(words)

print(word_count)
