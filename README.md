# TomThumb
Tom Thumb is an application that uses TomThumb's crumb metaphor, is a user-friendly assistive technology for AR navigation. The aim is to help young people with cognitive disabilities to memorize and walk paths independently. The app is divided into two parts:
- Caregiver side:
Route creation and real-time monitoring of Tom's AR navigation.
- Tom side:
Run routes sent by the caregiver using GPS navigation combined with augmented reality, and they will also be able to run the routes independently already traveled previously.

# Features
1.Creating the route:
The caregiver, with the support of the map, creates the path by adding the crumbs in the desired positions, associating an audio for each.

2. AR execution and monitoring:
Tom walks the route in augmented reality and collects all the crumbs. He will be guided during the entire execution by visual and auditory support.
The caregiver monitors Tom's progress in real time.

3.Security:
Departure from the route: The app comes to Tom's aid if he walks away from the route through auditory and visual aids by suggesting that he call the caregiver
Unexpected: In case of unexpected events Tom can play a personalized audio or call the caregiver
Call caregiver: shortcut to call the caregiver in case of need.

# Technologies
- SwiftUI for the implementation of the Views
- Swift for Model and ViewModel
- ARKit library for the AR part 
- ARCL library for combine AR and CoreLocation (gps technolgy)
- MapKit and CoreLocation for manage gps and map
- AVFundation for manage audio 
- Firebase as a noSQL database for data persistence

# Link
Below the link for a pdf presentation of TomThumb project:
https://github.com/marcoortu96/TomThumb/blob/master/presentationTomThumb.pdf

Below the youtube link to explaine the functionalities of TomThumb app:
https://www.youtube.com/watch?v=UX0lXw7VAzA
