import os
import re

dir_path = r"e:\project\heathy_teacher\lib"

replacements = [
    (re.compile(r'khoá học online', re.IGNORECASE), 'ôn tập'),
    (re.compile(r'khóa học online', re.IGNORECASE), 'ôn tập'),
    (re.compile(r'học online', re.IGNORECASE), 'ôn tập'),
    (re.compile(r'khóa học', re.IGNORECASE), 'Tài liệu lớp học'),
    (re.compile(r'khoá học', re.IGNORECASE), 'Tài liệu lớp học'),
]

def get_replacement(match, replacement_text):
    original = match.group(0)
    if original.isupper():
        return replacement_text.upper()
    elif len(original) > 0 and original[0].isupper():
        return replacement_text
    else:
        return replacement_text.lower()

def process_file(filepath):
    if "apple_sanitizer.dart" in filepath:
        return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = content
    for pattern, rep_text in replacements:
        new_content = pattern.sub(lambda m: get_replacement(m, rep_text), new_content)
        
    if content != new_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk(dir_path):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

print("Done")
