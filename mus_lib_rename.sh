#!/bin/bash

# mus_lib_rename: A script to organize your music library
#                 uniformly.  This script assumes that the
#                 library in question is organized as such:
#                 /Library/Artist/Album/*tracks*
#                 -or-
#                 <Library>/Artist/Album/Disc#/*tracks*
#
# Author: darth_crunchus & ChatGPT



# Path to your music library
music_library="/path/to/music/library"

# Log file path
log_file=$HOME/.music.log

# Clear the log_file if it's not empty
if [[ -s $log_file ]]; then
    echo "" > $log_file
fi
echo "$(basename "$0"): Processing files..."
# Function to log messages
log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Function to rename MP3 files
rename_files() {
    local directory="$1"
    files_renamed=0
    files_unaccounted=0

    # Iterate through subdirectories
    for artist_dir in "$directory"/*; do
        log "Checking $artist_dir"
        # Check if it's a directory
        if [[ -d "$artist_dir" ]]; then
            # Skip the "Game Soundtracks" directory during the initial renaming pass
            if [[ "$artist_dir" = "$directory/Game Soundtracks" ]]; then
                log "Artist directory is $artist_dir. Skipping."
                continue
            fi

            # Iterate through album directories in the artist directory
            for album_dir in "$artist_dir"/*; do
                log "Checking $album_dir"
                # Check if it's a directory
                if [[ -d "$album_dir" ]]; then
                    # Iterate through subdirectories within the album directory
                    for sub_dir in "$album_dir"/Disc*; do
                        log "Checking $sub_dir"
                        # Check if it's a directory
                        if [[ -d "$sub_dir" ]]; then
                            # Iterate through MP3 files in the subdirectory
                            for mp3_file in "$sub_dir"/*.mp3; do
                                log "Checking $mp3_file"
                                # Extract the filename without the directory path
                                local filename=$(basename "$mp3_file")

                                # Check if the filename matches any of the recognized formats
                                if [[ $filename =~ ^.+\ -\ .+\ -\ [0-9]+\ -\ .+\ \([0-9]+\)\.mp3$ ]]; then
                                    # Extract the track number and title from the filename
                                    local track_number=$(echo "$filename" | cut -d' ' -f4)
                                    local title=$(echo "$filename" | cut -d' ' -f6- | sed 's/ ([0-9]\+)//')
                                    local new_filename="${track_number} ${title}"

                                    # Rename the file if the new filename is different
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\ -\ .+\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d' ' -f1)
                                    local title=$(echo "$filename" | cut -d' ' -f3-)
                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\ -\ .+\ -\ .+\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d' ' -f1)
                                    local artist=$(echo "$filename" | cut -d' ' -f3)
                                    local title=$(echo "$filename" | cut -d' ' -f5-)
                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\.\ .+\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d'.' -f1)
                                    local title=$(echo "$filename" | cut -d' ' -f2-)
                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\ -\ [0-9]+\ -\ .+\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d' ' -f3)
                                    local title=$(echo "$filename" | cut -d' ' -f5-)
                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\ -\ .+\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d' ' -f1)
                                    local title=$(echo "$filename" | cut -d' ' -f2-)
                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                elif [[ $filename =~ ^[0-9]+\ Title\.mp3$ ]]; then
                                    local track_number=$(echo "$filename" | cut -d' ' -f1)
                                    local title=$(echo "$filename" | cut -d' ' -f2-)
                                    
                                    # Add leading zero if track number is a single character
                                    if [[ ${#track_number} -eq 1 ]]; then
                                        track_number="0$track_number"
                                    fi

                                    local new_filename="${track_number} ${title}"
                                    if [[ "$filename" != "$new_filename" ]]; then
                                        mv "$mp3_file" "$sub_dir/$new_filename"
                                        log "Renamed: $filename --> $new_filename"
                                        ((files_renamed++))
                                    else
                                        log "No changes needed for: $filename"
                                    fi
                                else
                                    ((files_unaccounted++))
                                fi
                            done
                        fi
                    done
                fi
            done
        fi
    done

    log "Total files renamed: $files_renamed"
    log "Total unaccounted files: $files_unaccounted"
}


if [[ -s $1 ]]; then
    # Check if the '--keep-log' or '-k' argument is provided
    if [[ $1 == "--keep-log" ]] || [[ $1 == "-k" ]]; then
        # Do not clear the log file
        touch "$log_file"
    else
        # Clear the log file
        echo "" > "$log_file"
    fi
    # Check if the '--help' or '-h' argument is provided
    if [[ $1 == "--help" ]] || [[  $1 == "-h" ]]; then
        echo "Usage: $(basename "$0") [--keep-log / -k] [--help / -h]
        
        Description: Renames all track files in your music library to conform to the filename format of
                     '<##> <Title>.mp3'.  The script assumes that your library is organized in the following fashion:
                     <LibraryPath>/Artist/Album/<tracks> for single disc albums
                     -or-
                     <LibraryPath>/Artist/Album/<Disc #>/<tracks> for multi-disc albums.
                     
        where:
        --keep-log|-k     If provided, the keep lof flag prevents the script from clearing the log when finished running.
            --help|-h     Show this help message and exit."
        exit
    fi
fi

# Rename files in the main music library excluding the "Game Soundtracks" directory
rename_files "$music_library"

# Rename files in the "Game Soundtracks" directory
rename_files "$music_library/Game Soundtracks"

echo "Total Files renamed: $files_renamed"
echo "Total unaccounted files: $files_unaccounted"
