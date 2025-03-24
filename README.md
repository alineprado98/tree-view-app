# tree-view-app

This is a Flutter app responsible for building a component tree for specific companies. It allows location searches, location components, and assets (such as machines) of a company. Users can filter items by name and status, such as assets in critical status or power sensors.

## Features

- **Location Search**: Users can search for specific locations within the company's structure.
- **Location Components**: The app allows you to view the components of a specific location.
- **Assets (Machines)**: It is possible to search for assets, such as a company's machines, and filter by name or status (e.g., assets with power sensors or critical status).
- **Advanced Filter**: Filters to help locate assets with critical status or power sensors.

## Libraries Used

- **GetIt**:  
  Dependency injection manager.

- **GoRouter**:  
  Used to define application routes, enabling smooth navigation between pages.

- **Flutter_BLoC**:  
  Efficiently manages the app's state using the BLoC (Business Logic Component) pattern. This library allows business logic to be isolated from the presentation layer (UI), making the code more modular, testable, and easier to maintain. By using BLoC, the app's states are managed reactively, improving code scalability and reusability.

- **Sqflite_sqlcipher**:  
  Used for secure local data storage, encrypting the database to ensure the protection of sensitive information.

- **Flutter Native Splash**:  
  Library to display a custom splash screen when starting the app. `flutter_native_splash` allows creating a launch screen that can be customized with the app's visual identity, displayed while the app's initial resources are loading or while the app connects to backend services.

- **Flutter_svg**:  
  Used to display icons and images in SVG format in the app. The SVG format is a vector graphic format, meaning images can be resized without losing quality. This library is useful for efficiently displaying scalable icons and graphics across different screen resolutions.

- **Dio**:  
  HTTP client for Flutter, enabling efficient communication with external APIs. Dio is a powerful tool for making HTTP requests, offering features like interceptors, error handling, timeout settings, and support for multipart data uploads, among other advanced functionalities that make API interaction easier and safer.

## Architecture

The app architecture follows the **Clean Architecture** pattern, with a clear separation of responsibilities to facilitate scalability and maintenance:

- **Repositories**:  
  The repository layer is responsible for data access logic. Here, you'll find interfaces for communication with backend services and the local database.

- **Services**:  
  The service layer in this context is an abstraction of the external libraries used in the project.

- **Pages**:  
  The pages layer contains the app's screens and widgets. Each page represents a user interface (UI) that interacts with the data provided by repositories and services.

This layered division follows the **separation of responsibilities** principle, where each layer is responsible for a distinct aspect of the application. This helps with code maintenance, scalability, and testing.

## Environment Variables

To configure environment variables (such as API URLs), the **flutter_dotenv** package was used. A `.env.template` file was created to store the necessary environment variables, and you can copy this file to `.env` and fill it with the appropriate values.

Example of variables in the `.env` file:

 `.env`:
BASE_URL=https://api.exemplo.com 
DATABASE_PASSWORD=your_api_key


## How to Run

1. **Clone the repository**:

   ```bash
   git clone https://github.com/usuario/tree-view-app.git
   cd tree-view-app
   flutter pub get
   ```

  Configure environment variables:
2. 
Copy the .env.template file to .env and fill it with the necessary information.



3. Run the app:

To run the app on your device or emulator, execute the command:
```bash
flutter run
```
## 📸 App screenshots


<p align="center">

<img src="https://github.com/alineprado98/tree-view-app/blob/develop/docs/images/home.png" alt="Tela Inicial do App" width="300" height="auto">
<img src="https://github.com/alineprado98/tree-view-app/blob/develop/docs/images/all_machines.png" alt="Tela Inicial do App" width="300" height="auto">
<img src="https://github.com/alineprado98/tree-view-app/blob/develop/docs/images/list_is_empty.png" alt="Tela Inicial do App" width="300" height="auto">
<img src="https://github.com/alineprado98/tree-view-app/blob/develop/docs/images/something_wrong.png" alt="Tela Inicial do App" width="300" height="auto">

<p/>

## 📸 App preview

[**APEX**] https://github.com/alineprado98/tree-view-app/blob/main/docs/apex.mp4


[**JAGUAR**] https://github.com/alineprado98/tree-view-app/blob/main/docs/jaguar.mp4


[**TOBIA**] https://github.com/alineprado98/tree-view-app/blob/main/docs/tobias.mp4




