# EBookNote

This app is for readers to read, take notes, summary content and collect information from books

## Features

- [x] User Authentication
- [x] REST API Integration
- [x] Core Data Persistence
- [x] UIKit Interface

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Using Git

1. Clone the repository:

    ```sh
    git clone https://github.com/HungNguyen14121998/ebooknote_ios.git
    ```

2. Navigate to the project directory:

    ```sh
    cd EBookNote
    ```

3. Open the project in Xcode:

    ```sh
    open EBookNote.xcodeproj
    ```

4. Build and run the project using the Xcode toolbar or the shortcut `Cmd + R`.

## Features

1. Launch the app on your iOS device or simulator.
2. Sign up for a new account or log in using existing credentials.
3. Create new book.
4. Create history you read of the chapter from the book.
5. View process you readed throw book card, graph
6. Set goals you want reach in a week

## Screens and Usage

1. Login Screen: Sign in account the app.![Login](https://github.com/user-attachments/assets/e974f393-46eb-473e-a7a9-5d99869e28ce)
2. Register Screen: Register new account for use app.![Register](https://github.com/user-attachments/assets/dbe998f0-9a36-4ad8-a346-d692cb26355e)
3. Home Screen: Display reading progress of a week.![Home](https://github.com/user-attachments/assets/242b676c-5f6c-4d87-92ad-a9250ef8eed6)
- press date cell to show number of pages read.
- press book card to show collection of book contents.
4. Book Screen: Display list book.![Books](https://github.com/user-attachments/assets/97649406-2e5b-4fcd-bf17-6f6785c0baf6)
- press plus button on the upper right corner to add a new book.
- press update button to navigate to create history screen from the most recent book you have updated.
- press book card to show collection of book contents.
5. Create Book Screen: ![CreateBook](https://github.com/user-attachments/assets/11402871-ff13-4778-ae4d-243eb311581b)
- press library button to open photo library to pick a cover picture.
- press camera button to open camera to take a cover picture.
- you can fill in book textfield, author textfield, number of pages textfield.
- press button save to create a new book.
6. List Histories Screen: Display list histories of content you noted from the book.![ListHistories](https://github.com/user-attachments/assets/60bc32ec-f59a-4176-8155-22cbd1ed9059)
- press library button to open photo library to pick a cover picture.
- press camera button to open camera to take a cover picture.
- you can fill in book textfield, author textfield, number of pages textfield.
- press button save to create a new book.
7. Create History Screen: Create a new history.![CreateHistory](https://github.com/user-attachments/assets/c3ccaff6-1dbd-44cf-a9f4-08c46dcf2e87)
- press chapter button will show pop up Add tag name.
- enter the chapter.
- press pages button will show pop up Add number of pages.
- enter the from page to page.
- fill in the content you read.
- press save button.
8. Graph Screen: Display reading progress graph in two weeks recently.![Graph](https://github.com/user-attachments/assets/e4605fe9-8436-49d5-98de-3ea969c4158a)
- press one point on the graph view change the total number of pages.
9. Menu screen: Display set goals button and logout button.![Menu](https://github.com/user-attachments/assets/ef8245b3-523e-460a-85c4-21adb8019d8d)
- press set goals to navigate set goals screen.
- press logout to show pop up logout.
10. Set Goals Screen: Set a goal of how many pages to read in a week.![SetGoals](https://github.com/user-attachments/assets/fcab3561-7843-483f-9501-87f1214c1cf7)
- fill in number of pages textfield (illustrated by orange line on the graph view, calculated by dividing into 7 (7 days))
- press save button

## Disadvantages
- Because my back-end server deploy is free, so it turns off after every 15 minutes.
- Missing some features such as  update book, delete book, …

## Account you can use
- username1: vinsmokesanji/abcd1234
- username2: nicorobin/abcd1234


---
