echo "Select your app to publish it on G-Console:"
echo "1. Gradding"
echo "2. Course-finder"

read -p "Select App: " choice

case "$choice" in
    1)
        new_app_name="Gradding"
        package_name="com.gradding"
        ;;
    2)
        new_app_name="Course Finder"
        package_name="com.gradding.finder"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Debug: Print the value of package_name after the case statement
echo "You selected: $new_app_name"
echo "package_name: '$package_name'"

# check the os and set the app dir path
 os_name=$(uname -s)

 if [[ "$os_name" == "Darwin" ]]; then
     echo "The operating system is macOS."

app_path="/Users/user/Documents/Cognus APPS/MRP FLUTTER APPS/mrp-app"
/home/user/Documents/projects/React/update_pubspec_path.sh app_path

read -p "Would you like to update Keystore file path? (y/n)" keyStoreUpdate

if [ "$keyStoreUpdate" == "y" ]; then
  echo "updating the keystore file path .... "

  # Define the new path for storeFile
  NEW_PATH="$app_path/android/cognuskey.keystore"

  sed -i "s|^storeFile=.*|storeFile=$NEW_PATH|" "$app_path/android/key.properties"

  echo "storeFile path updated to $NEW_PATH"

elif [ "$keyStoreUpdate" == "n" ]; then
  echo "not updating the keyStore file path "
else
  echo "Invalid input. Please enter 'y' for beta or 'n' for update the keystore file path."
  exit 1
fi


 elif [[ "$os_name" == "Linux" ]]; then
     echo "The operating system is Linux."
     app_path="/home/user/Apps/gradding/gradding_app"
 else
     echo "The operating system is neither macOS nor Linux."
 fi

# -------------------------------------- X - X --------------------------------------



# source folder declared
source_folder="$app_path/appAssets/${package_name}"

echo "App name changed to $new_app_name"


#------------------------------ for change the app assets -----------------------------------
# Destination folder path
android_path="/android/app/src/main/res"
ios_path="/android/app/src/main/res"
google_services="${app_path}/android/app"


# Android assets
rsync -av --delete --exclude='drawable' --exclude='values' --exclude='values-night' --exclude='xml' "${source_folder}/android/" "${app_path}${android_path}"

# google services json
cp -f "${source_folder}/google-services.json" "${google_services}"

echo "Files moved successfully from ${source_folder} to ${destination_folder}"
echo "Files moved successfully from ${source_folder} to ${android_path}"

## Run package_rename command
#dart run package_rename -p "${source_folder}/${package_name}_package_rename.yaml"
## -------------------------------------- X - X   --------------------------------------

#TODO : for package rename
cp -f "${source_folder}/package_rename_config.yaml" "${app_path}"

dart run package_rename -p "package_rename_config.yaml"



cd $app_path
#flutter run


echo "Now Change the AppConstants in the utility package to run the App Accordingly "
