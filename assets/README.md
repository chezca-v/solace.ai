# Shared Flutter Assets

Assets placed here are bundled by Flutter and can be referenced by the app across Android, iOS, web, Windows, macOS, and Linux.

## Folders

* `fonts/` — bundled typefaces and their licenses.
* `brand/` — approved Solace logo and app-icon source artwork.
* `images/` — shared in-app images and illustrations.
* `animations/` — GIF or animation files used by the interface.

The folders are registered in `pubspec.yaml`. Add assets here rather than duplicating them in platform folders when they are used inside the Flutter UI.

Launcher icons are a separate platform concern. `pubspec.yaml` configures one square source image to generate Android, iOS, web, Windows, and macOS launcher icons. After replacing the current low-resolution logo with the approved high-resolution artwork, regenerate them with `dart run flutter_launcher_icons`. Linux may require a separate platform-specific icon update. Existing platform PNGs are generated outputs, not shared in-app assets.

## Typography

Plus Jakarta Sans is bundled locally so the same typeface is available offline on every Flutter target. Its SIL Open Font License is included beside the font in `fonts/OFL.txt`.
