# Flutter Question Game
## Context

A question game for entertaining groups programmed with [flutter](https://flutter.dev).
This project was depeloped in the summer semester 2024 for the course "Ausgewählte Projekte der Informatik" (short DAPI)  at [OTH Regensburg](https://www.oth-regensburg.de/).
The app is as of now purely in German.

## Executing
### Website

The app is deployed via [Google Firebase Hosting](https://firebase.google.com/docs/hosting) and can be found [here](https://larsaars-question-game.web.app).

### Local

If you want to let it run on `localhost`:

1. [Install flutter](https://docs.flutter.dev/get-started/install) and a local web server like [python http.server](https://www.digitalocean.com/community/tutorials/python-simplehttpserver-http-server) or [npm serve](https://www.npmjs.com/package/serve)
1. Clone this repo with `git clone https://github.com/larsaars/flutter_question_game` and navigate into the folder.
1. Run `flutter build web --release`
1. Navigate into `cd build/web`
1. Start any http server (i.e. `python -m http.server`) with this as root directory and view the website on localhost (i.e. `http://0.0.0.0:8000/` in the case of python http.server) in your browser

