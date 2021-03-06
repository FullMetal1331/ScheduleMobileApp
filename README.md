# **Schedule App**
A Flutter app to keep track of your daily schedule and pending tasks. This app is mainly aimed at school/college students to help them maximize their time utilization.

## Login/Register
Users are allowed to register if they are new or login if they are already registered.

<p align="center">
<img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/login_register.gif' height=600 />
</p>

## Main Screen
After a successful login/registration the user is redirected to the main screen that contains a user avatar, user name and buttons to access the TimeTable and ToDo list.

<p align="center">
<img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/profile.gif' height=600 />
</p>

## TimeTable
The TimeTable page contains all seven days of the week with entries for each day divided on an hourly basis from 9AM - 6PM.
(P.S. The pixel overflow is now fixed  :sweat_smile: )

<p align="center">
<img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/timetable.gif' height=600 />
</p>

## ToDo List
The ToDo list allows users to add a tasks, mark tasks as complete/incomplete on tap and delete tasks on long press. A ML model is used to calculate a **time threshold** for the user, that represents the amount of time after which it is highly likely that the task will be deleted without being completed. The tasks whose total time in the list is greater than the time threshold will be displayed in a bigger font size and red font color( **time threshold** is calculated by using attributes of deleted tasks ).

<p align="center">
<img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/todo.gif' height=600 />
</p>

## User Settings
> - Subjects List: This list contains all the unique entries in the timetable which helps to provide an overvieww of the same.
> <p align="center"><img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/user_subjects.gif' height=600 /></p>
> - Profile/UserName: Users are allowed to change their display name and using the RoboHash API a robot avatar is generated using the new display name as a query string.
> <p align="center"><img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/user_pic.gif' height=600 /></p>

## Schedule Notifications
Like the greeting notification shown below the user also gets notifications based on their timetable entries when a scheduled event is within the next 15 mins. A headless event runs in the background every 15 mins( even if the app is closed ) which checks and informs the user about any scheduled events.

<p align="center">
<img src='https://raw.githubusercontent.com/FullMetal1331/ScheduleMobileApp/master/images/notification.gif' height=600 />
</p>
