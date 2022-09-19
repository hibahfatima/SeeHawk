# SeeHawk (Hack the North 2022 Finalist)
SeeHawk is a reading performance tracker which analyzes reading patterns and behaviours, presenting dynamic second-by-second updates delivered to your phone through our app.

# Inspiration
As avid readers, we wanted a tool to track our reading metrics. As a child, one of us struggled with concentrating and focusing while reading. Specifically, there was a strong tendency to zone out. Our app provides the ability for a user to track their reading metrics and also quantify their progress in improving their reading skills.

# What it does
By incorporating Ad Hawk’s eye-tracking hardware into our build, we’ve developed a reading performance tracker system that tracks and analyzes reading patterns and behaviours, presenting dynamic second-by-second updates delivered to your phone through our app. These metrics are calculated through our linear algebraic models, then provided to our users in an elegant UI interface on their phones. We provide an opportunity to identify any areas of potential improvement in a user’s reading capabilities.

# How we built it
We used the Ad Hawk hardware and backend to record the eye movements. We used their Python SDK to collect and use the data in our mathematical models. From there, we outputted the data into our Flutter frontend which displays the metrics and data for the user to see.

# Challenges we ran into
Piping in data from Python to Flutter during runtime was slightly frustrating because of the latency issues we faced. Eventually, we decided to use the computer's own local server to accurately display and transfer the data.

# Accomplishments that we're proud of
Proud of our models to calculate the speed of reading, detection of page turns and other events that were recorded simply through changes of eye movement.

# What we learned
We learned that Software Development in teams is best done by communicating effectively and working together with the same final vision in mind. Along with this, we learned that it's extremely critical to plan out small details as well as broader ones to ensure plan execution occurs seamlessly.

# What's next for SeeHawk
We hope to add more metrics to our app, specifically adding a zone-out tracker which would record the number of times a user "zones out".

# Built With
flutter, 
python, 
adhawk backend services, 
adhawk eye tracking glasses
