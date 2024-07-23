#!/usr/bin/env python3

import os


def rename_images(directory):
    # Expand the user home directory if the path contains '~'
    directory = os.path.expanduser(directory)
    
    # Check if the directory exists
    if not os.path.isdir(directory):
        print(f"Directory '{directory}' does not exist.")
        return
    
    # Supported image extensions
    image_extensions = ('.jpg', '.jpeg', '.png')
    # List to hold the paths of image files
    image_files = []

    # Traverse the directory
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(image_extensions):
                image_files.append(os.path.join(root, file))
    
    # Sort image files to ensure consistent renaming order
    image_files.sort()

    # Rename each file
    counter = 1
    for file_path in image_files:
        # Extract the file extension
        _, file_extension = os.path.splitext(file_path)
        # Determine new file name
        new_file_name = f"wall-{counter}{file_extension}"
        new_file_path = os.path.join(directory, new_file_name)

        # Check if the new file name already exists
        while os.path.exists(new_file_path):
            counter += 1
            new_file_name = f"wall-{counter}{file_extension}"
            new_file_path = os.path.join(directory, new_file_name)

        # Rename the file
        os.rename(file_path, new_file_path)
        print(f"Renamed {file_path} to {new_file_path}")
        counter += 1

# Specify the directory containing the images
image_directory = './'

# Call the function to rename images
rename_images(image_directory)
