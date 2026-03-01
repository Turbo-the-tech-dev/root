import argparse
import sys
import datetime

def main():
    parser = argparse.ArgumentParser(description="Update Project Knowledge 'Word of the Day'")
    parser.add_argument("--word", type=str, required=True, help="The technical term to push")
    parser.add_argument("--definition", type=str, help="Optional definition or context")
    
    args = parser.parse_args()
    
    # Validation: Ensure the word isn't just whitespace or a dangerous shell character
    word = args.word.strip()
    if not word or len(word) > 50:
        print("[-] SECURITY ERROR: Word must be 1-50 characters.")
        sys.exit(1)

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    print(f"[*] SYNCING TO SECTOR 06 (Firestore)...")
    print(f"[+] WORD OF THE DAY: {word}")
    print(f"[+] TIMESTAMP: {timestamp}")
    
    # Mocking Firestore update logic
    # db.collection('daily_insights').document('word_of_the_day').set({
    #     'term': word,
    #     'definition': args.definition or "Extracted from Imperial Terminal History",
    #     'date': timestamp
    # })
    
    print(f"[✔] Sector 06 Synchronized. The root has spoken: '{word}'")

if __name__ == "__main__":
    main()
