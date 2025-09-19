from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

model_name = "bigcode/starcoder2"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained("starcoder2").to("cuda")


input_text = "print('Hello World')"
inputs = tokenizer(input_text, return_tensors="pt")
outputs = model.generate(**inputs, max_new_tokens=50)
print(tokenizer.decode(outputs[0]))
