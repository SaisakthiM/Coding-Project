import tkinter as tk
from tkinter import simpledialog, messagebox
import threading
import speech_recognition as sr
import pyautogui
import pygetwindow as gw
import time

# --- CONFIG ---
ENERGY_THRESHOLD = 45   # sensitivity
PRESENTATION_TITLE = "Your Presentation Title"

# --- GLOBAL STATE ---
listening = [False]

# --- FOCUS PRESENTATION ---
def focus_presentation():
    try:
        win = gw.getWindowsWithTitle(PRESENTATION_TITLE)[0]
        if not win.isActive:
            win.activate()
        return True
    except IndexError:
        print(f"Window with title '{PRESENTATION_TITLE}' not found.")
        return False

# --- SPEECH LISTENER ---
def listen_commands():
    recognizer = sr.Recognizer()
    recognizer.energy_threshold = ENERGY_THRESHOLD
    mic = sr.Microphone()

    with mic as source:
        recognizer.adjust_for_ambient_noise(source, duration=1)

    while listening[0]:
        with mic as source:
            try:
                audio = recognizer.listen(source, timeout=1, phrase_time_limit=2)
                command = recognizer.recognize_google(audio).lower()
                print(f"Recognized command: {command}")
                last_command_var.set(f"Last Command: {command}")

                if "next" in command:
                    if focus_presentation():
                        pyautogui.press("right")
                    print("Next slide triggered!")
                elif "previous" in command:
                    if focus_presentation():
                        pyautogui.press("left")
                    print("Previous slide triggered!")

            except sr.WaitTimeoutError:
                continue
            except sr.UnknownValueError:
                continue
            except sr.RequestError as e:
                print(f"Speech Recognition error: {e}")

# --- GUI FUNCTIONS ---
def start_listening():
    listening[0] = True
    threading.Thread(target=listen_commands, daemon=True).start()
    status_label.config(text="Listening for commands...")

def stop_listening():
    listening[0] = False
    status_label.config(text="Stopped.")

def change_title():
    global PRESENTATION_TITLE
    new_title = simpledialog.askstring("Presentation Title", "Enter presentation window title:")
    if new_title:
        PRESENTATION_TITLE = new_title
        messagebox.showinfo("Updated", f"Presentation title set to:\n{PRESENTATION_TITLE}")

# --- GUI ---
root = tk.Tk()
root.title("Voice-Controlled Slide Controller")
root.geometry("450x200")

status_label = tk.Label(root, text="Click 'Start' to begin listening", wraplength=400)
status_label.pack(pady=10)

start_button = tk.Button(root, text="Start Listening", command=start_listening)
start_button.pack(pady=5)

stop_button = tk.Button(root, text="Stop Listening", command=stop_listening)
stop_button.pack(pady=5)

title_button = tk.Button(root, text="Set Presentation Window Title", command=change_title)
title_button.pack(pady=5)

last_command_var = tk.StringVar()
last_command_var.set("Last Command: None")
last_command_label = tk.Label(root, textvariable=last_command_var)
last_command_label.pack(pady=5)

root.mainloop()
