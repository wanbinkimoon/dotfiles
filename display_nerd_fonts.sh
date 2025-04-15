#!/bin/bash

# Set sample text with the quick brown fox and properly encoded Nerd Font characters
SAMPLE="The quick brown fox jumps over the lazy dog $(echo -e "\uf11c \uf013 \uf0e0 \uf15c \uf1c0 \ue74c \uf1d1")"

# Set ligature examples that many coding fonts support
LIGATURES="
// Arrows: -> => <- <= <=> == === != !== 
// Comparisons: >= <= != == === !==
// Logic: && || ! !!
// Other: :: ... |> <| ++ 
// Math: != == >= <= =~ !~ <-< >->
// Code examples:
if (x !== null) { return x <= 10 && x >= 5; }
x => x.filter(y => y != null);
const isEmpty = (str) => str.length === 0;
"

echo "=== Nerd Font Display Script ==="
echo "This script will display a sample text in regular Nerd Fonts installed via Homebrew"
echo ""

# Find Homebrew font directory
BREW_PREFIX=$(brew --prefix)
FONT_DIR="$BREW_PREFIX/share/fonts"

# Check if font directory exists
if [ ! -d "$FONT_DIR" ]; then
    # Try alternative location for cask fonts
    FONT_DIR="/Library/Fonts"
    # Also check user fonts directory
    USER_FONT_DIR="$HOME/Library/Fonts"
fi

# Function to check if a font is "regular"
is_regular_font() {
    local font_path="$1"
    local font_name=$(basename "$font_path")
    
    # If it's explicitly labeled as Regular, it's regular
    if [[ "$font_name" == *"Regular"* ]]; then
        return 0  # true
    fi
    
    # If it has any weight/style markers, it's not regular
    if [[ "$font_name" == *"Bold"* || 
          "$font_name" == *"Thin"* || 
          "$font_name" == *"Light"* || 
          "$font_name" == *"Medium"* || 
          "$font_name" == *"ExtraLight"* || 
          "$font_name" == *"SemiBold"* || 
          "$font_name" == *"Black"* || 
          "$font_name" == *"ExtraBold"* || 
          "$font_name" == *"Italic"* || 
          "$font_name" == *"Oblique"* ]]; then
        return 1  # false
    fi
    
    # If no weight/style is specified, consider it regular
    return 0  # true
}

# Initialize an array to store found Nerd Fonts
declare -a NERD_FONTS

# Process font directories
process_font_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        while IFS= read -r font; do
            # Check if it's a Nerd Font
            if [[ "$font" == *"Nerd"* || "$font" == *"NF"* ]]; then
                # Check if it's a regular font
                if is_regular_font "$font"; then
                    NERD_FONTS+=("$font")
                fi
            fi
        done < <(find "$dir" -type f \( -name "*.ttf" -o -name "*.otf" \) 2>/dev/null)
    fi
}

# Check in Homebrew font directory and user font directory
process_font_dir "$FONT_DIR"
process_font_dir "$USER_FONT_DIR"

# If no Nerd Fonts found, check brew casks
if [ ${#NERD_FONTS[@]} -eq 0 ]; then
    echo "No regular Nerd Fonts found in font directories. Checking Homebrew casks..."
    while IFS= read -r font_cask; do
        if [[ "$font_cask" == *"nerd-font"* ]]; then
            echo "Found Nerd Font cask: $font_cask"
            NERD_FONTS+=("$font_cask (cask)")
        fi
    done < <(brew list --cask 2>/dev/null | grep -i nerd)
fi

# Create a temporary HTML file to display fonts
create_html_output() {
    local html_file="/tmp/nerd_fonts_display.html"
    
    # For HTML we need to use actual Unicode code points
    local html_sample="The quick brown fox jumps over the lazy dog &#xf11c; &#xf013; &#xf0e0; &#xf15c; &#xf1c0; &#xe74c; &#xf1d1;"
    
    echo "<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <title>Nerd Fonts Display</title>
    <style>" > "$html_file"
    
    # Add @font-face declarations for each font
    for font in "${NERD_FONTS[@]}"; do
        if [[ ! "$font" == *"(cask)"* ]]; then
            font_name=$(basename "$font" | sed 's/\.[ot]tf$//')
            font_path="$font"
            
            echo "
        @font-face {
            font-family: '$font_name';
            src: url('file://$font_path');
            font-feature-settings: 'liga' 1, 'calt' 1; /* Enable ligatures */
        }" >> "$html_file"
        fi
    done
    
    echo "
        body {
            font-family: system-ui;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .font-sample {
            margin-bottom: 40px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
        }
        .font-name {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 18px;
        }
        .font-path {
            font-size: 12px;
            color: #666;
            margin-bottom: 10px;
            word-break: break-all;
        }
        .sample-text {
            font-size: 18px;
            line-height: 1.5;
            margin-bottom: 15px;
        }
        .ligature-examples {
            font-size: 16px;
            line-height: 1.6;
            padding: 15px;
            background-color: #f0f0f0;
            border-radius: 5px;
            margin-top: 10px;
            white-space: pre;
            overflow-x: auto;
        }
        h2 {
            margin-top: 20px;
            margin-bottom: 10px;
            font-size: 16px;
            color: #555;
        }
    </style>
</head>
<body>
    <h1>Nerd Fonts Display</h1>
    <p>Showing ${#NERD_FONTS[@]} regular Nerd Fonts with icons and ligatures</p>" >> "$html_file"
    
    # Add a div for each font
    for font in "${NERD_FONTS[@]}"; do
        if [[ ! "$font" == *"(cask)"* ]]; then
            font_name=$(basename "$font" | sed 's/\.[ot]tf$//')
            
            echo "
    <div class='font-sample'>
        <div class='font-name'>$font_name</div>
        <div class='font-path'>$font</div>
        
        <h2>Nerd Font Icons</h2>
        <div class='sample-text' style='font-family: \"$font_name\";'>$html_sample</div>
        
        <h2>Programming Ligatures</h2>
        <div class='ligature-examples' style='font-family: \"$font_name\";'>$LIGATURES</div>
    </div>" >> "$html_file"
        else
            # For cask-only fonts that we couldn't find the actual files for
            font_name="${font% (cask)}"
            
            echo "
    <div class='font-sample'>
        <div class='font-name'>$font_name (installed as cask)</div>
        <div class='sample-text'>$html_sample (actual font not found)</div>
    </div>" >> "$html_file"
        fi
    done
    
    echo "</body>
</html>" >> "$html_file"
    
    echo "$html_file"
}

# Display sample text for each found Nerd Font
if [ ${#NERD_FONTS[@]} -eq 0 ]; then
    echo "No regular Nerd Fonts found installed via Homebrew."
    echo "You can install Nerd Fonts using: brew install --cask font-<name>-nerd-font"
    echo "Example: brew install --cask font-fira-code-nerd-font"
else
    echo "Found ${#NERD_FONTS[@]} regular Nerd Fonts."
    echo ""
    
    # Create HTML file for proper font display
    html_file=$(create_html_output)
    
    # Print the fonts in terminal (though they won't display in the correct font)
    for font in "${NERD_FONTS[@]}"; do
        if [[ ! "$font" == *"(cask)"* ]]; then
            font_name=$(basename "$font" | sed 's/\.[ot]tf$//')
            echo "========================================"
            echo "Font: $font_name"
            echo "Path: $font"
            echo "========================================"
            echo -e "$SAMPLE"
            echo ""
            echo "Ligatures (may not display correctly in terminal):"
            echo -e "$LIGATURES"
            echo ""
        else
            font_name="${font% (cask)}"
            echo "========================================"
            echo "Font: $font_name (cask)"
            echo "========================================"
            echo -e "$SAMPLE"
            echo ""
        fi
    done
    
    echo "For proper font display with ligatures, open the HTML file: $html_file"
    echo "You can open it with: open $html_file"
    
    # Try to open the HTML file automatically
    if command -v open >/dev/null 2>&1; then
        open "$html_file"
    fi
fi

echo "Script completed."
