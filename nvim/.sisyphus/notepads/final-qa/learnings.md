
## F3 QA — leader gd picker (real manual run)

- nvim launched with `-u init.lua` does NOT cd into opened file's dir → picker uses current shell CWD git repo. Tests must launch tmux with `-c "$F3_TMPDIR"` for picker to see fixture repo.
- Picker UI verified: shows file list (M/A status + filename), no hunk headers in list area (`@@...@@` only appears in preview pane, not list). 2/2 entries match fixture (a.txt modified, new.txt added).
- Enter in snacks picker confirms selection → opens file in main window. Buffer name resolves to `a.txt` after pressing Enter.
