# Todox - To-Do List App

Todox is a To-Do List app built with Flutter, using Provider for state management and Firestore for cloud storage.  
It follows the MVC (Model-View-Controller) architecture for better structure and scalability.

## Features

- **Task List** – Fetch and display tasks from Firestore with title, description, due date, and completion status  
- **Add Task** – Add new tasks and save them to Firestore  
- **Edit Task** – Update existing tasks (title, description, due date)  
- **Delete Task** – Remove tasks from your list  
- **Task Completion** – Mark tasks as completed or pending  
- **Provider State Management** – App-wide state handling  
- **MVC Architecture** – Clear separation of concerns  

## Tech Stack

- **Flutter** (Frontend framework)  
- **Provider** (State management)  
- **Cloud Firestore** (Database)  
- **MVC Architecture**  

## Project Structure

```
lib/
├── models/            # Data models (TaskModel)
├── views/             # UI screens (TaskListPage, AddTaskPage, EditTaskPage)
├── controllers/       # Firestore CRUD operations
├── providers/         # Provider classes for state management
├── widgets/           # Reusable custom widgets
└── main.dart          # App entry point
```

## Getting Started

### Prerequisites  

- Install Flutter  
- Set up Firebase in your Flutter project  
- Enable Cloud Firestore in Firebase Console  

### Installation

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/AparnaRajVR/todox.git
   cd todox
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) inside `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) inside `ios/Runner/`

4. **Run the App**
   ```bash
   flutter run
   ```

## Future Enhancements

- [ ] Notifications for upcoming tasks
- [ ] Dark mode support
- [ ] Task categories or tags
- [ ] Offline support

## Contributing

Contributions are welcome! Please feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
