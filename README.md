# Classic Games App

A Flutter application featuring classic arcade games like Asteroids and Pong, built with the Flame engine. Includes an engaging main menu, keyboard controls, and on-screen touch controls for mobile play.

## Features

*   **Main Menu:** A beautiful and engaging main menu to select a game.
*   **Asteroids:** The classic space-shooter game.
    *   Fly your ship through a dangerous asteroid field.
    *   Shoot and destroy asteroids.
    *   Avoid collisions to survive.
*   **Pong:** The classic table tennis game.
*   **Tetris:** The iconic falling block puzzle game.
    *   Clear lines by completing rows of blocks.
    *   Strategize with next and held pieces.
    *   Increasing difficulty with levels.

## Screenshots

**Main Menu**

*A grid-based menu with icons and descriptions for each game.*

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

*   **Keyboard Controls:**
    *   **Arrow Left:** Turn left
    *   **Arrow Right:** Turn right
    *   **Arrow Up:** Thrust
    *   **Space Bar:** Shoot
*   **On-screen Controls (for touch devices):**
    *   **Left Button:** Turn left
    *   **Right Button:** Turn right
    *   **Thrust Button:** Thrust
    *   **Fire Button:** Shoot

## How to Play Pong

*   **Keyboard Controls:**
    *   **Player 1 (Left Paddle):** 'W' to move up and 'S' to move down.
    *   **Player 2 (Right Paddle):** Arrow Up and Arrow Down keys to move.
*   **On-screen Controls (for touch devices):**
    *   **Player 1 Up Button:** Move Player 1 paddle up
    *   **Player 1 Down Button:** Move Player 1 paddle down
    *   **Player 2 Up Button:** Move Player 2 paddle up
    *   **Player 2 Down Button:** Move Player 2 paddle down

## How to Play Tetris

*   **Keyboard Controls:**
    *   **Arrow Left:** Move piece left
    *   **Arrow Right:** Move piece right
    *   **Arrow Down:** Soft drop (move piece down faster)
    *   **Arrow Up:** Rotate piece
    *   **Space Bar:** Hard drop (instantly drop piece)
    *   **H:** Hold piece
    *   **Enter:** Restart game (after Game Over)
*   **On-screen Controls (for touch devices):**
    *   **<- Button:** Move piece left (press and hold for continuous movement)
    *   **-> Button:** Move piece right (press and hold for continuous movement)
    *   **Rot Button:** Rotate piece
    *   **Drop Button:** Hard drop

**Recent Improvements:**
*   On-screen left and right movement buttons now support "press and hold" for continuous movement.
*   Resolved issues with on-screen controls not appearing and the game starting directly on the "Game Over" screen.

## Built With

*   [Flutter](https://flutter.dev/) - The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
*   [Flame](https://flame-engine.org/) - A minimalist Flutter game engine.