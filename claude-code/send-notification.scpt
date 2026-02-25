#!/usr/bin/osascript

on run argv
    set theTitle to item 1 of argv
    set theMessage to item 2 of argv

    tell application "System Events"
        display notification theMessage with title theTitle
    end tell
end run
