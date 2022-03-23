<img src="/assets/README/poster.png"/>



[![Python](https://img.shields.io/badge/Python-3.8.10-blue)](https://www.python.org/) [![Flutter](https://img.shields.io/badge/Flutter-2.10.1-blue)](https://flutter.dev/) [![MySQL](https://img.shields.io/badge/MySQL-8.0.27-blue)](https://www.mysql.com/)



# UN-SDGs In This Project

<img src="/assets/README/UN-SDGs_11.png" width="100%" />

There are many things that are unknowingly dangerous and uncomfortable in our modern society. Even though we are aware of these dangerous and inconvenient things, we will often have an experience of sitting on the sidelines because we have no damage to ourselves and are cumbersome to report. These problems will destroy the creation of sustainable cities and residences. To solve and improve this, our Peek-A-Boom has developed Comaplain, a communication application that reports and solves dangerous or inconvenient things around us.



# Google Technology In This Project
<img src="/assets/README/flutter_logo.png" width="50%" />
This project used Flutter for building "comaplain" app.   

<img src="/assets/README/firebase_logo.png" width="45%" />
This project used Firebase for using Google Sign in.     

<img src="/assets/README/google_cloud_logo.png" width="50%" />
This project used Google Cloud Platform to use a VM for this project's server.   



# Create a better world with the Comaplain App!

Comaplain App shares the threats to each other, which are due to malfunctioning facilities and unsafe areas. In this way, Comaplain App contributes to making the world safer and better. Participate in it and make the world safer. Please join us.

### [Report]

Check the areas...

- that have malfunctioning facilities.
- that are unsafe areas.

### [Solved Report]

Check the facilities and the areas becoming safer.

### [My Report]

Check the information you have shared.



# 👨‍💻 How To Run “Comaplain”

### If you are member of firebase project “complain”

- Check your Flutter SDK and android device
- `Download Zip` or `Clone` this repository
- Open a Terminal in the directory `comaplain(root)/comaplain/`
- Enter `flutter pub clean` and `flutter pub get`
- Connect an android device or launch an emulator
- Click `Run and Debug` or enter `flutter run`
- Wait **Comaplain**’s building



### If you are a new user

- Visit this link and install : https://play.google.com/store/apps/details?id=com.comaplain.comaplain


# 📁 Directory Tree

```bash
📁lib
├─📁bloc
│  ├─📁bottom_navi
│  ├─📁main_report
│  ├─📁report_detail_body
│  ├─📁report_detail_comment
│  ├─📁report_detail_image
│  ├─📁report_get
│  ├─📁report_list
│  ├─📁report_recommendation
│  ├─📁report_update
│  ├─📁report_write
│  ├─📁solve_write
│  ├─📁user
│  └─📁user_report_list
├─📁model
├─📁repository
└─📁screen
     ├─📁app_info
     ├─📁login
     ├─📁main
     ├─📁map
     ├─📁my_page
     │  └─📁settings
     ├─📁report_detail
     ├─📁report_list
     ├─📁report_update
     ├─📁report_writing
     ├─📁search
     └─📁solve_writing
```



# 📱 Details of the app screens

- Splash screen

<img src="/assets/README/Screenshot_1646724957.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646724970.png" width="200" height="400"/>

This application can be described with two keywords. These are **"complain"** and **"map"**. You can simply **complain** about some dangerous or uncomfortable things you find on your way by taking pictures and putting an explanation using this application. Then, our application **maps** the location of your report on the map screen so that it is easy to recognize where it happened. This splash screen shows these concepts.

- Main screen

<img src="/assets/README/Screenshot_1646725004.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725062.png" width="200" height="400"/>

The main screen shows a network map of reports within your 10km radius. Therefore, you can see how many kinds of reports have been received at a glance. If you click a specific circle icon on the visualization board, you can see the information bar that can reach the report detail screen. You can click this bar to get more information about the report or you can simply check the title and category of reports at the bottom of the visualization board.

- Map screen

<img src="/assets/README/Screenshot_1646725095.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725104.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725121.png" width="200" height="400"/>

On the map screen, you can get information about the location of reports. This screen displays report markers based on your signed-up location. But, you can also scroll, zoom in/out on the screen or just search the location to check markers based on other locations. If you click the floating button, your map screen is moved to your current location. You can see the title and explanation of the report by clicking the marker. If you tap the marker's information window, you can move to the report detail screen.

- Report writing screen

<img src="/assets/README/Screenshot_1646725133.png" width="200" height="400" align="left"/>  
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

The report writing screen appears when you click the rainbow-colored middle button on the bottom navigation bar. You can put up to five pictures. You have to choose one category and write a title and explanation of your report. 

- Report list screen

<img src="/assets/README/Screenshot_1646725155.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725161.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725166.png" width="200" height="400"/>

Reports within your 10km radius are displayed in two tabs on the report list screen. The "reports" tab displays reports that haven't been solved yet. The "solved" tab displays solved reports. You can select categories that you want to display. To create a report, click the pencil icon. Also, you can search for a specific report by clicking the search icon.

- Report detail screen

<img src="/assets/README/Screenshot_1646725304.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725317.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725309.png" width="200" height="400"/>

The report detail screen provides a comment function. When you click the top right button, you can see the report’s exact location on the map page.

- My page screen

<img src="/assets/README/Screenshot_1646725217.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725223.png" width="200" height="400"/> &nbsp;&nbsp;&nbsp; <img src="/assets/README/Screenshot_1646725837.png" width="200" height="400"/>

You can check personal information on my page screen. If you want to see the list of your reports, click the my report tab. If you want to change your information, click the settings tab.  You can change your nickname and update your location on this tab.



# **🛠 Tech Stack**

- Flutter version (22-02-13)
  - Flutter : `2.10.1`
  - Dart : `2.16.1`
  - DevTools : `2.9.2`
- Python : `3.8.10`
  - Django : `4.0.2`
  - djangorestframework : `3.13.1`
  - mysqlclient : `2.1.0`
  - haversine(위도, 경도) : `2.5.1`
  - pygments : `2.11.2`
  - sqlparse : `0.4.2`
- MySQL : `8.0.27`

# **⚙️ Architecture**

- BLoC Pattern

# 🧑‍🔧

- Won-young Lee : https://github.com/210-reverof
- Ha-jeong Lee : https://github.com/SS-hj/
- Jun-jang Jo : https://github.com/junjange
- Tae-gyu Han : https://github.com/TaegyuHan
