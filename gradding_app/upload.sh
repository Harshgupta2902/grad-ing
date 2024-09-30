# Ask the user if they want to upload to the App shared folder
read -p "Do you want to upload the APK to the App shared folder on Google Drive? (y/n): " upload_choice

# Build the Flutter APK
flutter clean
flutter build apk --release

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Flutter build failed"
    exit 1
fi

FILE_PATH="mydrive:App/app-release.apk"
rclone lsf $FILE_PATH
if [ $? -eq 0 ]; then
    rclone delete $FILE_PATH
fi
    echo "Old APK Deleted from Google Drive"



if [[ "$upload_choice" == [yY] || "$upload_choice" == [yY][eE][sS] ]]; then
    # Upload the APK to the App shared folder on Google Drive
    rclone copy -P build/app/outputs/flutter-apk/app-release.apk mydrive:App

    # Check if the upload was successful
    if [ $? -ne 0 ]; then
        echo "Failed to upload APK to App shared folder on Google Drive"
        exit 1
    fi

    echo "APK uploaded successfully to Google Drive in App shared folder"
else
    echo "Upload to App shared folder skipped"
fi


share_link=$(rclone link $FILE_PATH)

# Check if the upload was successful
if [ $? -ne 0 ]; then
    echo "Failed to upload APK to Google Drive"
    exit 1
fi

# Print a success message
echo "APK uploaded successfully to Google Drive"


echo -n "$share_link" | pbcopy
echo "Shareable link created successfully: $share_link"