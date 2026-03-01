import os
import sys
import json
import subprocess
# For a real run, 'pip install google-generativeai' is required
try:
    import google.generativeai as genai
    HAS_GENAI = True
except ImportError:
    HAS_GENAI = False

def extract_word_of_the_day():
    print("[*] COMMENCING LINGUISTIC TELEMETRY EXTRACTION...")
    
    # 1. Capture local bash history (Telemetric Data)
    # Using a fallback for non-login shells or empty history
    history = os.popen('tail -n 50 ~/.bash_history 2>/dev/null').read()
    if not history:
        # Fallback to current session commands or a mock for the demo
        history = "npm run build\ngit commit -m 'feat: add telemetry'\nrclone sync /data/data/com.termux/files/home/epic/root remote:fleet\ntsc --noEmit\n"

    print("[+] History Data Captured.")

    word_data = {"word": "Unknown", "definition": "Imperial system standby."}

    # 2. High-Acuity Prompting (Sector 02: Gemini)
    api_key = os.getenv("GOOGLE_API_KEY")
    if HAS_GENAI and api_key:
        try:
            genai.configure(api_key=api_key)
            model = genai.GenerativeModel('gemini-1.5-flash')
            prompt = f"""
            Analyze this terminal history:
            {history}
            Identify one complex technical engineering term related to these actions.
            Provide: 1. The Word, 2. A concise 'Sovereign' definition for a Google Interview.
            Format STRICTLY as JSON: {{"word": "...", "definition": "..."}}
            """
            response = model.generate_content(prompt)
            # Basic JSON cleanup for Gemini output
            clean_text = response.text.replace('```json', '').replace('```', '').strip()
            word_data = json.loads(clean_text)
            print(f"[+] Gemini Generated High-Acuity Word: {word_data['word']}")
        except Exception as e:
            print(f"[-] GEMINI ERROR: {e}. Falling back to Imperial Defaults.")
    else:
        print("[!] GOOGLE_API_KEY not found or library missing. Mocking High-Acuity result.")
        # Logic to pick from a curated list of 'Imperial' terms based on history keywords
        if "rclone" in history:
            word_data = {"word": "Idempotency", "definition": "The property of certain operations in mathematics and computer science whereby they can be applied multiple times without changing the result beyond the initial application."}
        elif "git" in history:
            word_data = {"word": "Atomic Commits", "definition": "The practice of creating small, focused commits that change only one thing, ensuring a clean and reversible history."}
        else:
            word_data = {"word": "Asynchrony", "definition": "A form of input/output processing that permits other processing to continue before the transmission has finished."}

    # 3. UI Push (Sector 06: Firestore)
    print(f"[*] PUSHING '{word_data['word']}' TO SECTOR 06 (Firestore)...")
    try:
        # Call the existing update script in Sector 06
        subprocess.run([
            "python3", 
            "/data/data/com.termux/files/home/epic/root/sectors/06-firestore/update_word.py",
            "--word", word_data['word'],
            "--definition", word_data['definition']
        ], check=True)
        print("[✔] Linguistic Bridge Synchronized.")
    except Exception as e:
        print(f"[-] FIRESTORE PUSH ERROR: {e}")

if __name__ == "__main__":
    extract_word_of_the_day()
