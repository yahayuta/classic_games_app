# Classic Games App

A Flutter application that brings classic arcade games to your fingertips. This project is a collection of simple, fun games built with the Flame engine.

## Features

*   **Main Menu:** A simple menu to select a game.
*   **Asteroids:** The classic space-shooter game.
    *   Fly your ship through a dangerous asteroid field.
    *   Shoot and destroy asteroids.
    *   Avoid collisions to survive.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   [Flutter](https://flutter.dev/docs/get-started/install)

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username_/classic_games_app.git
    ```
2.  Install packages
    ```sh
    flutter pub get
    ```

### Running the App

You can run the app on a connected device, simulator, or the web.

*   **Run on a connected device or simulator:**
    ```sh
    flutter run
    ```
*   **Run on the web:**
    ```sh
    flutter run -d chrome
    ```
    or
    ```sh
    flutter run -d edge
    ```
    If you have trouble launching a browser, you can use the web server option:
    ```sh
    flutter run -d web-server
    ```
    This will start a local server. You can then open the provided URL in your browser.

## How to Play Asteroids

*   **Arrow Keys:** Use the left and right arrow keys to turn the ship, and the up arrow key to move it forward.
*   **Space Bar:** Press the space bar to shoot.

## Built With

*   [Flutter](https://flutter.dev/) - The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
*   [Flame](https://flame-engine.org/) - A minimalist Flutter game engine.