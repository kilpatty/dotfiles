#!/usr/bin/env bash

# =============================================================================================
# Dock Configuration
# =============================================================================================

# Only Dock Appications we keep are: Mail, Calendar, Iterm
dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/iTerm.app"

killall Dock
