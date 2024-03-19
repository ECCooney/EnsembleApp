# Ensemble: A community based catalogue application for sharing items amongst friends and neighbour

## Final year student project for the SETU HDip in Computer Sciences


## 1. Overview

Ensemble is a cross platform application developed in Flutter using DART. In it's current iteration the app runs smoothly on Android devices, 
and is set up to run on web and IOS but is not fully tested or adjusted for those platforms.

The aim of Ensemble is to provide an application where users can create closed, invite only communities, where friends or neighbours can share often borrowed items.

A typical use case may be a neighbourhood group who want to share items like ladders, lawnmowers, wheelbarrows or other bulky and expensive items that only need occasional use.
A neighbour can set up a closed group in the app, provide the group name and code to their neighbours to access, and then each neighbour can upload items to the group, view
all available items, see each items available dates, and send a request to book an item for their preferred dates.


## 2. Getting Started

Step 1: Set up and install Flutter on your local machine, including setup of Android Studio as an IDE. For help getting started with Flutter development, view the online documentation, which offers tutorials, samples, guidance on mobile development, and a full API reference.

Step 2: Download/clone this repo onto your local machine using the following link:

https://github.com/ECCooney/EnsembleApp

Step 3: Configure the necessary plugins by using Android Studio to navigate to the pubspec.yaml file. Click "Pub get" to get the relevant dependencies, or possibly "Pub upgrade" to update any outdated dependencies.

Step 4: Create a Firebase project including Firestore database, storage, and authentication (see instructions here) and download google-services.json to the appropriate folder (android>app>src).

Step 5: Choose an appropriate emulator device, or connect a physical device for debugging and run the app via main.dart.


## 3. Features and Functionality

### 3.1. Backend Database, File Storage and Auth

All backend services required for the app are managed through Firebase. Firestore has been used for database storage and management. Authentication has been used for  sign up and login for both email/password and Google sign up and login.
Storage has been used for storing image files and any other files that may need to be stored.
App Check has been enabled to protect access and add an extra layer of security.

### 3.2. Splash Screen
A splash screen has been created used the plugin flutter_native_splash which allows the screen to be applied across platforms without having to develop each natively

![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710851237/Splash_bxuwg5.png)

### 3.2. Register and Login
Registration and login can be done either using an email/password combo, or using OAuth Google Sign Up and Login. Until a user logs in, the only routes available to them are these two screens.
Login          |  Register
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850956/Login_mnlcc2.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710851529/Signup_v9lp16.png)

### 3.3. Navigation
Navigation is the app is made easy using a nav drawer which can be opened through the appbar on any page, with swipe right also opening the navdrawer. This allows users to access any area of the app from any page without navigating back through.

![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850958/Navbar_ipy4pu.png)

### 3.4. User Profiles
Each user can view and edit their own profile, update their email address, image, and view a list of all items they have uploaded. Users registered through Google sign in will have their Google profile picture automatically added. Email sign ups will need to add their own.
User Profile        |  Edit Profile
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850964/user_Profile_icza44.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850726/EditProfile_ws41tc.png)

### 3.5. Home Screen
The home screen of the app when logged in displays an app bar with a link to the user's profile via their avatar, and a search function to search for groups by name, a list of the groups the user is a member of, and an option to create a new group. It displays a message if no groups are joined yet.
Home Screen with Groups       |  First Time User
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850950/HomeGroups_v6dwem.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710851859/Home_no_groups_ludket.png)

### 3.6 Group Creation and Editing
Initial group creation only requires the name, invite code and description. The user who created the group is automatically assigned as a member and an admin. Editing the group allows the user to upload a banner image, group image, and update the code and description.
Create a Group    |  Edit a Group
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850725/createagroup_ri679p.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850725/EditGroup_wbx4qr.png)


### 3.7 Group Details
Navigating to a group from the home page brings you to the group details screen. This screen is customised based on the users current status within that group. 
A user who is not yet a member will not be able to view the groups items, and will have access to two functions, a button to message the admins, where they can request the code to join, and a join button where they can input the code.
Members see the same message admins button but also a button to create an item, but in place of the join button, they have a button to leave the group. They can also view the full list of items in the group.
Admins can see everything members can, but in place of the join/leave button, they have an admin tools button which takes them to the admin dashboard.

Items in the group can be filtered by category using Filter Chips to show one or more types of item.

Item Cards will show whether an Item is available today based on whether it has been booked for the date.
Admin Group View      |  Non Member View
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850950/GroupDetailsAdmin_qgjzs6.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850954/join_screen_aeht5x.png)


### 3.8 Item Creation and Editing
Similar to groups, intial item creation only requires the name and description. Editing the item allows a picture to be added. The edit item screen can only be accessed by the owner of them item and also contains a full list of the booking history for that item.
Create an Item  |  Edit an Item
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710852234/Create_Item_fdskye.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850725/EditItem_s5vocr.png)


### 3.9 Item Details and Booking Functionality
Navigation to an item from the group page brings you to the item details screen. The screen can also be accessed from the user profile where their items are listed.

This screen will display an edit item button if the user is the owner of that item. Otherwise it will just display the item image, name and description and a booking calendar.

This booking calendar loads a list of the existing bookings for that item and blocks out those dates so they cannot be selected. A user can click on a date range and press 'Confirm' to send a request to book for those dates. Cancel will clear the current selection.

![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850951/Item_Details_aippwr.png)

### 3.10 Booking Process
Once the booking has been requested, it will appear in the item owners list of outstanding request, available through the Nav Drawer. There they can see the requested item, and the dates.
After clicking on the request, they can see further details including the requester, and add collection details including address, pickup time, dropoff time and click confirm, or they can cancel they booking if they do not want to go ahead with it.

Users can view all their bookings on the bookings screen also reachable through the Nav Drawer. They can filter by approved, pending and denied requests. When they click through to the booking they can see the details for collection.
Booking Request List  |  Request Details
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850722/Booking_Requests_ydi7ij.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850961/request_details_uw9kvd.png)
Booking List |  Booking Details
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850767/Filtered_Bookings_u9eiz5.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850722/Booking_Details_qxzslu.png)


### 3.11 Messaging
Messaging in the app is extremely basic and includes only a message to admins and it's response. It allows for users to contact the admins of a group, either to request a code or report an issue.
Messages to admins have either a outline icon if they are read, or a filled icon and bolding if they are unread.

Based on the type of message sent, admins have the ability to either confirm the code request, deny it, or acknowledge receipt of the report. 

Responses are available to users through a link in their navbar.
Message Admins |  Message Details | Responses
:-------------------------:|:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850956/Message_Admins_utm8u8.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850957/Message_Details_ccutih.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850957/messageresponse_pta6re.png)

### 3.12 Other Admin Functions
Admins can also add new admins from a list of the group members, and delete the group through the admin dashboard
Admin Dashboard |  Add Admins
:-------------------------:|:-------------------------:
![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850722/Admin_Tools_edydre.png)  |  ![](https://res.cloudinary.com/drnpyxlgc/image/upload/v1710850722/Add_new_admin_phe4np.png)


## 4. State Management
Riverpod has been used for the state management for this app. You can read more here: https://riverpod.dev/

## 5. Architecture
As Flutter comes with no standard folder structure, or recommended architecture there were a number of choices available. A key priority when building Ensemble was the separation of concerns, trying to keep all Firebase logic separate to the business logic so that if a new backend was chosen, there would be minimal changes needed in the code.
For this reason the Repository pattern recommended by some for Flutter was chosen. More can be read about that here: https://codewithandrea.com/articles/flutter-repository-pattern/

## 6. Dependencies
The following dependencies were used to reduce boilerplate code

### UI:
- cupertino_icons: ^1.0.2
- dotted_border: ^2.1.0
- flutter_screenutil: ^5.9.0

### Firebase and Storage:
- firebase_core: ^2.24.2
- cloud_firestore: ^4.14.0
- firebase_storage: ^11.6.0
- firebase_auth: ^4.17.6
- shared_preferences: ^2.2.2
- google_sign_in: ^6.2.1
- firebase_app_check: ^0.2.1+14

### Error Handling:
- fpdart: ^1.1.0 - allows error handling to be done more succinctly, removing the need for as many try catch blocks.

### Routing:
- routemaster: ^1.0.1 - keeps routing all in one file to be called in screens where needed, instead of generating new routes each time.

### Booking Calendar:
- syncfusion_flutter_calendar: ^24.2.5
- syncfusion_flutter_charts: ^24.2.6
- syncfusion_flutter_datepicker: ^24.2.6

### Misc
- envied: ^0.3.0 - for protecting keys
- flutter_riverpod: ^2.4.9 - for state management
- flutter_native_splash: 2.3.10 - to generate the splash screen
- file_picker: ^6.1.1 - to allow users to choose images and files from their device for upload
- uuid: ^4.3.2 - for generating unique IDs for the database










