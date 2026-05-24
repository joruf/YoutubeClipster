#!/bin/bash

show_link_detected_pulsate() {
    local msg="$1"
    (echo "0"; echo "# $msg"; echo "100"; sleep 0.5) | zenity --progress \
      --title="${MESSAGES[progress_title]}" --text="${MESSAGES[progress_text_prefix]} YouTube Link" \
      --auto-close --no-cancel --width=400 --pulsate 2>/dev/null
}

select_format() {
    local title="$1"
    zenity --list --title="${MESSAGES[zenity_format_title]}" \
      --text="${MESSAGES[zenity_format_text_prefix]}\n$title" --radiolist \
      --column="${MESSAGES[zenity_format_col_select]}" --column="${MESSAGES[zenity_format_col_format]}" \
      TRUE "${MESSAGES[zenity_format_mp3]}" FALSE "${MESSAGES[zenity_format_mp4]}" 2>/dev/null
}

select_audio_lang() {
    local title="$1"
    zenity --list --title="${MESSAGES[zenity_lang_title]}" \
      --text="${MESSAGES[zenity_lang_text]}\n$title" --radiolist \
      --column="${MESSAGES[zenity_format_col_select]}" --column="Sprache" \
      FALSE "${MESSAGES[lang_de]}" FALSE "${MESSAGES[lang_en]}" TRUE "${MESSAGES[lang_best]}" 2>/dev/null
}
