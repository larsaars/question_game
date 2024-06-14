# Project Structure

## Code

### The lib Folder

The main code folder is [lib](../lib) with following structure:

- [l10n](../lib/l10n): Contains localization files (country specific app strings are generated from the `*.arb` files in the folder).
- [database](../lib/database): Contains everything concerned with managing the loading of the questions from the text file based database as well as handling current and old game states.
- [utils](../lib/utils): Contains utilities for UI, navigation etc.
- [ui](../lib/ui): Contains everything concerned with ui.
  - [ui/widgets](../lib/ui/widgets): Contains custom widgets (reusable UI elements).
  - [ui/routes](../lib/ui/routes): Contains all the routes (pages/screens) of the app.

### pubspec.yaml

The file [pubspec.yaml](../pubspec.yaml) contains the dependencies (libraries used) of the project as well as some other general definitions.
  
## Assets

The assets are in the folders:
- [sounds](../sounds): Contains sounds used in the app.
- [imgs](../imgs): Contains images used in the app.
- [fonts](../fonts): Contains custom fonts used in the app.
- [question_database](../question_database): Contains the text file based database of questions.
- [licenses](../licenses): Contains licenses of the assets used in the project.