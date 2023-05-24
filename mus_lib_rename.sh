#!/bin/bash

# Path to your music library
music_library=/path/to/music/library

# Log file path
log_file=$HOME/.music.log

# Clear the log_file if iit's not empty
if [[ -s $log_file ]]; then
    echo "" > $log_file
fi

# Function to log messages
log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Function to rename MP3 files
rename_files() {
    local directory="$1"
    local files_renamed=0

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
                    # Iterate through MP3 files in the album directory
                    for mp3_file in "$album_dir"/*.mp3; do
                        log "Checking $mp3_file"
                        # Extract the filename without the directory path
                        local filename=$(basename "$mp3_file")

                        # Check if the filename matches the format '<##> <Artist> -  <Title>.mp3'
                        if [[ $filename =~ ^[0-9]+\ .+\ -\ \ .+\.mp3$ ]]; then
                            # Extract the track number and title from the filename
                            local track_number=$(echo "$filename" | cut -d' ' -f1)
                            local artist_title=$(echo "$filename" | cut -d'-' -f2- | sed -e 's/^[[:space:]]*//')
                            local title=${artist_title%-*}
                            local artist=${artist_title#*-}
                            local new_filename="${track_number} ${artist//-/} - ${title}"

                            # Replace " - " with " " in the filename
                            new_filename=${new_filename//\ -\ /" "}

                            # Add leading zero if track number is a single digit
                            if [[ ${#track_number} -eq 1 ]]; then
                                track_number="0$track_number"
                            fi

                            # Construct the new filename
                            local new_filename="${track_number} ${title}"

                            # Rename the file if the new filename is different
                            if [[ "$filename" != "$new_filename" ]]; then
                                mv "$mp3_file" "$album_dir/$new_filename"
                                log "Renamed: $filename --> $new_filename"
                                ((files_renamed++))
                            else
                                log "No changes needed for: $filename"
                            fi
                        fi
                    done
                fi
            done
        fi
    done

    log "Total files renamed: $files_renamed"
}

# Clear the log file
> "$log_file"

# Rename files in the main music library excluding the "Game Soundtracks" directory
rename_files "$music_library"

# Rename files in the "Game Soundtracks" directory
rename_files "$music_library/Game Soundtracks"
