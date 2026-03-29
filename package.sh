#!/bin/bash
# Package the ai-assessment-builder skill
# Usage: bash package.sh

SKILL_DIR="/workspace-inner/.openclaw/extensions/feishu/skills/ai-assessment-builder"
OUTPUT="/workspace/ai-assessment-builder.skill"

cd "$SKILL_DIR/.." || exit 1

# Create zip (if zip available) or tar
if command -v zip &>/dev/null; then
    cd ai-assessment-builder || exit 1
    zip -r "$OUTPUT" . -x "*.pyc" -x "__pycache__/*"
    echo "Packaged: $OUTPUT ($(du -sh "$OUTPUT" | cut -f1))"
else
    # Use python zipfile
    python3 -c "
import zipfile, os, pathlib
skill_dir = pathlib.Path('$SKILL_DIR')
out = pathlib.Path('$OUTPUT')
with zipfile.ZipFile(str(out), 'w', zipfile.ZIP_DEFLATED) as zf:
    for fp in sorted(skill_dir.rglob('*')):
        if fp.is_file():
            zf.write(fp, fp.relative_to(skill_dir.parent))
            print(' +', fp.relative_to(skill_dir.parent))
print('Done:', out, '('+str(os.path.getsize(out))+' bytes)')
"
fi
