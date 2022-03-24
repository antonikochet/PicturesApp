# PicturesApp
test task for Rentateam

### App description

The app works with [API Pexels](https://www.pexels.com/ru-ru/api/).

1. Pictures view
 - tape of photos received from the server shows the photo author's name and description 

2. Detail view picture
 - the screen shows the photo in full screen size, the author photo, description and the date the photo was downloaded

offline mode was made using CoreData, in the absence of the Internet or a weak signal, photos from the storage on the phone of already downloaded photos will be loaded. If the photos are not uploaded, a notification will appear.

A repeated request can be made by updating the collection of photos.

Architecture - MVVM 

App screens:

 - Photos screen
![photos](screenshots/photosScreen.gif)
 - Detail photo screen
![detail photo](screenshots/detailPhotoScreen.gif)
 - offline mode
![offline mode](screenshots/offlineMode.gif)
