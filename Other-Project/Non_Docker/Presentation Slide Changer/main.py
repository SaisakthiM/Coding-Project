import threading
import pyautogui
import speech_recognition as sr
import pygetwindow as gw
import tkinter as tk
from tkinter import simpledialog, messagebox

# --- CONFIGURATION ---
PRESENTATION_TITLE = "chemistry.pptx"  # full filename with .pptx or browser tab title

# --- FOCUS PRESENTATION WINDOW ---
def focus_presentation():
    try:
        win = gw.getWindowsWithTitle(PRESENTATION_TITLE)[0]
        if not win.isActive:
            win.activate()
        return True
    except IndexError:
        print(f"Window with title '{PRESENTATION_TITLE}' not found.")
        return False

# --- LISTENING FUNCTION ---
def listen_commands():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        recognizer.adjust_for_ambient_noise(source, duration=0.5)
        while listening[0]:
            try:
                audio = recognizer.listen(source, phrase_time_limit=0.8)
                command = recognizer.recognize_google(audio).lower()
                
                # Print every recognized command
                print(f"Command received: {command}")
                
                if "next" in command:
                    if focus_presentation():
                        pyautogui.press("right", interval=0)
                elif "previous" in command:
                    if focus_presentation():
                        pyautogui.press("left", interval=0)
                elif "stop listening" in command:
                    listening[0] = False
                    messagebox.showinfo("Voice Control", "Stopped listening.")
            except sr.UnknownValueError:
                continue
            except sr.RequestError as e:
                print(f"Speech recognition error: {e}")
                break

# --- START LISTENING THREAD ---
def start_listening():
    listening[0] = True
    threading.Thread(target=listen_commands, daemon=True).start()
    status_label.config(text="Listening... Say 'next' or 'previous'")

# --- GUI ---
listening = [False]
root = tk.Tk()
root.title("Debug Voice Slide Controller")
root.geometry("350x150")

status_label = tk.Label(root, text="Click 'Start' to begin listening", wraplength=300)
status_label.pack(pady=10)

start_button = tk.Button(root, text="Start Listening", command=start_listening)
start_button.pack(pady=5)

stop_button = tk.Button(root, text="Stop Listening", command=lambda: listening.__setitem__(0, False))
stop_button.pack(pady=5)

def change_title():
    global PRESENTATION_TITLE
    new_title = simpledialog.askstring("Presentation Title", "Enter presentation window title:")
    if new_title:
        PRESENTATION_TITLE = new_title
        messagebox.showinfo("Updated", f"Presentation title set to:\n{PRESENTATION_TITLE}")

title_button = tk.Button(root, text="Set Presentation Window Title", command=change_title)
title_button.pack(pady=5)

root.mainloop()
