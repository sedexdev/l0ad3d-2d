# 📘 L0AD3D-2d

A 2D Lua based _Loaded_ (1995, PS1) demo running on the L&Ouml;VE2D engine.

This is a conceptual version of the classic 1995 PS1 game 'Loaded'. It features a small demo environment
to emulate the original in a 2D plane using Lua and the L&Ouml;VE2D game engine for development. All textures
were created by me using GIMP (unless otherwise credited below)

Current version: _1.1.3_

# 📦 Installation

## Prerequisites

L&Ouml;VE2D can be downloaded for your platform from their [official website](https://love2d.org/#download).

Getting the code:

```bash
git clone https://github.com/sedexdev/l0ad3d-2d/
```

Once L&Ouml;VE2D is installed **add the LOVE directory to the system path for your OS**. Then navigate to the root of the project and follow appropriate commands for your system.

_Note:_ **MacOS is not supported**

```bash
# Windows
cd l0ad3d-2d
lovec .
```

```bash
# Linux
cd l0ad3d-2d
love .
```

## Pre-packaged Executables

The game files have been pre-packaged as standalone files for _Windows_ and _Linux_.

They can be found under the [bin directory](https://github.com/sedexdev/l0ad3d-2d/tree/main/bin).

```bash
# Windows - extract the .zip archive to your chosen location
cd l0ad3d-2d
.\L0AD3D-2D.exe
```

```bash
# Linux - save the .AppImage file to your chosen location
cd l0ad3d-2d
chmod +x L0AD3D-2D.AppImage
./L0AD3D-2D.AppImage
```

# 🎮 Gameplay

The game is very simple. There is a single level that you need to navigate to find keys to get into the boss room and _kill the boss_. You get points for the number of enemies killed along the way. After killing the boss the level starts again, and all enemies get slightly stronger. After eventually dying your score goes in the high scores table where you and your friends will compete to have the most points!

## ✨ Features

-   Endless wave survival mode gameplay
-   2 characters to play as
-   Powerful sound track
-   Powerups
    -   One shot boss kill
    -   2x speed
    -   Invincibility shield
    -   Ammo / health pick ups
-   High score board
-   Level map

## 🕹️ Controls

-   **Movement**: WASD or up, down, left, right keys
-   **Shooting**: Space bar
-   **Display map**: M
-   **Pause**: Escape key
-   **Menu select**: Up, down keys and Enter to select
-   **Enter high score**: Up, down keys and Enter to select

# 📂 Project Structure

```
l0ad3d-2d/
│
├── audio/            # Audio files
├── bin/              # Pre-packaged binaries
├── fonts/            # Font files
├── graphics/         # Texture images and sprite sheets
├── lib/              # Lua dependencies
├── src/              # Source files
├── .gitignore        # Git ignore file
├── LICENSE           # M.I.T license
├── README.md         # This README.md file
└── main.lua          # Main game entry point
```

# 📄 Documentation

-   Itch game page: [https://sedexdev.itch.io/l0ad3d-2d](https://sedexdev.itch.io/l0ad3d-2d)

# 🐛 Reporting Issues

Found a bug or need a feature? Open an issue [here](https://github.com/sedexdev/l0ad3d-2d/issues).

# 🧑‍💻 Authors

-   **Andrew Macmillan** – [@sedexdev](https://github.com/sedexdev)

# 📜 License

This project is licensed under the MIT License - see the [M.I.T](LICENSE) file for details.

# 📝 Change Log

Version 1.1.3 includes the following updates:

-   The 'm' key now brings up a minimap of the whole level which tracks the players movement
-   Smoke effect when bullet hits wall is centered
-   Corridor wall correction glitch fixed
-   Player correction when passing through a doorway between adjacent areas improved
-   Added additional sound effects

# 📣 Acknowledgements

Non-original sources credit

-   Fonts:
    -   HoMicIDE EFfeCt.ttf - https://www.fontsaddict.com/font/homicide-effect.html
    -   Funkrocker.ttf - https://www.1001freefonts.com/funkrocker.font
-   Music:
    -   Heavy metal theme - https://freemusicarchive.org/music/lite-saturation/aggressive-metal/aggressive-metal/
    -   Source: Free Music Archive
    -   Title: Aggressive Metal
    -   Artist: Lite Saturation
    -   LICENSE: CC BY-ND
-   Sounds:
    -   Selection error - https://freesound.org/people/Isaac200000/
    -   Gun click select - https://freesound.org/people/magnuswaker/
    -   Gunshot - https://freesound.org/people/Xenonn/
    -   Explosion - https://freesound.org/people/derplayer/sounds/587183/>
    -   Canon fire - https://freesound.org/people/inferno/sounds/18391/>
    -   Grunt death - https://www.zapsplat.com/music/body-impact-splat/>
    -   Player death - https://freesound.org/people/Hoggington/sounds/536603/
    -   Boss hit - https://freesound.org/people/InspectorJ/sounds/414074/
    -   Boss death - https://freesound.org/people/ThePig01/sounds/588657/
    -   Turret hit - https://freesound.org/people/wilhellboy/sounds/351371/
    -   Wall hit - https://freesound.org/people/reapersrealmsrp/sounds/710175/
    -   Invincible - https://freesound.org/people/MATRIXXX_/sounds/523745/
    -   Ammo - https://freesound.org/people/EminYILDIRIM/sounds/543927/
    -   Health - https://freesound.org/people/Rickplayer/sounds/530488/
    -   Speed - https://freesound.org/people/Eponn/sounds/420998/
    -   One shot kill - https://freesound.org/people/SuperPhat/sounds/514228/
    -   Level complete - https://freesound.org/people/deleteCookies/sounds/376009/
    -   Game over - https://freesound.org/people/MATRIXXX_/sounds/524741/
    -   Key - https://freesound.org/people/MATRIXXX_/sounds/657939/
-   Graphics:
    -   Menu background - https://www.everwallpaper.co.uk/products/mottled-grey-wallpaper-mural
    -   Bullet holes - https://www.spriters-resource.com/submitter/MagicMaker/
    -   Gunshot flash - https://www.pngwing.com/en/free-png-mwnxf
    -   Gunshot flash 2 - https://www.pngitem.com/middle/TbhhRJ_muzzle-flash-vfx-transparent-background-gun-shot-png/
    -   Blood splatter - https://www.freeiconspng.com/images/blood-splatter-png
-   Character select:
    -   Cap'n Hands - https://www.giantbomb.com/cap-n-hands/3005-28408/
    -   Fwank - https://www.deviantart.com/tj-ryan/art/Fwank-from-Loaded-254964042</il>
