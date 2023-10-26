# Text Recognition App

## Purpose

The purpose of the application is to enable the user to earn points by scanning their invoice with the camera after shopping. If the user buys the required products, he earns points. In addition, another purpose of the application is to provide users with free products with the points they earn.

## Use Case

1) User Registration:

- When the user opens the application, they encounter the login page.
- If they don't have an account, they navigate to the registration page by pressing the "Register" button.
- On the registration page, they provide the necessary information (name, email, password) and press "Register".
- After a successful registration, the application redirects the user to the login page.

2) User Login:

- The user enters their email and password on the login page and presses "Log In".
- If the login information is correct, the application directs the user to the main page.
- If the login information is incorrect, an error message is displayed to the user and they stay on the login page.

3) Main Page:

- After a successful login, the user is directed to the main page.
- The user's points are displayed, and they can use these points to purchase products.
- If the user doesn't have enough points, a "Insufficient Points" message is shown.

4) Earning Points:

- The user presses the "Earn Points" button on the main page to earn points.
- The application opens the camera, and the user scans their receipt.
- When the application recognizes keywords from the scanned receipt, the user is awarded 10 points.
- If no keywords are found, the user is awarded zero points.
- On the result page, the user confirms their points by pressing a button.

5)Result Page:

- After earning points, the user is redirected to the result page.
- The user clicks the "Collect Points" button to gather their points.
- If the application recognizes keywords from the scanned receipt, 10 points are added to the user's total.
- When the user presses "Okay", the application directs them back to the main page.

## How to Run ?

1)Run the Clone Command:
In the terminal, they can use the following command to clone the project:

  - git clone https://github.com/furkanayyildiz/Flutter_Text_Detection

2) Navigate to Project Directory:
Once the cloning is complete, they should use the cd command in the terminal to navigate to the cloned project's directory.

3) Install Dependencies:
Install the project's dependencies by running the following commands in the terminal:
 - flutter pub get
4) Open the Project:
 To run project write this command
 - flutter run
   
##Screenshots

![1](https://github.com/furkanayyildiz/Calculator/assets/59210754/0002edfc-f0e7-4c69-810a-ffd4f7a17d84)

![2](https://github.com/furkanayyildiz/Calculator/assets/59210754/6aff8c7f-8ce8-4e00-b734-35408c31a4e3)

![3](https://github.com/furkanayyildiz/Calculator/assets/59210754/2b14b9d1-ccf2-4e7e-908c-f921069b9195)

![4](https://github.com/furkanayyildiz/Calculator/assets/59210754/ff9f5f50-d2cd-45e5-8d18-51a9f1118f1b)

![5](https://github.com/furkanayyildiz/Calculator/assets/59210754/9b378d77-182d-490f-aa9c-065074bb3a5f)

![6](https://github.com/furkanayyildiz/Calculator/assets/59210754/b5629e3b-4883-4472-89cb-9d50c02c3b35)

![7](https://github.com/furkanayyildiz/Calculator/assets/59210754/b8bb6b59-e456-4b2d-a4ef-74ce1436d4f0)




