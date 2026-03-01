#!/usr/bin/env python3
"""
🛰️ Imperial Hook Creator: Sector 00 Automation
Automates the setup of Git hooks across the Imperial Fleet.
"""

import sys
import os
import stat

def create_hook(hook_type, script, stages):
    hook_path = f".git/hooks/{hook_type}"
    
    # Pre-determined logic for stages (M: Modified, A: Added, D: Deleted)
    # The stages argument can be used for more complex filtering in the script.
    
    content = f"""#!/bin/bash
# Imperial Git Hook: {hook_type}
# Stage: {stages}

{script}

# Get the list of staged files with their status (Added, Modified, Deleted)
# Filter based on stages if provided.
STAGED_FILES=$(git diff --cached --name-status)

if [ -z "$STAGED_FILES" ]; then
    echo "No relevant changes found in staged area."
else
    echo "Processing staged changes ({stages}):"
    echo "$STAGED_FILES"
fi

exit 0
"""

    with open(hook_path, "w") as f:
        f.write(content)
    
    # Make executable
    st = os.stat(hook_path)
    os.chmod(hook_path, st.st_mode | stat.S_IEXEC)
    
    print(f"✅ Created hook: {hook_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 hook_creator.py --type <type> --script <script> --stage <stage>")
        sys.exit(1)
    
    # Simple parsing of CLI args
    args = sys.argv[1:]
    hook_type = "pre-commit"
    script = "echo 'Running hook...'"
    stages = "modified,added,deleted"
    
    for i in range(len(args)):
        if args[i] == "--type" and i+1 < len(args):
            hook_type = args[i+1]
        elif args[i] == "--script" and i+1 < len(args):
            script = args[i+1]
        elif args[i] == "--stage" and i+1 < len(args):
            stages = args[i+1]
            
    create_hook(hook_type, script, stages)
