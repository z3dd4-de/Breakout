# Breakout
 A classic game - Godot Game Engine 4.2

### A speed programming attempt
I saw a video of a programmer who did Breakout in three different programming languages (Assembler, C, C++) and compared his experiences (https://www.youtube.com/watch?v=2eeXj-ck9VA).
This gave me the idea to try it out in Godot which should be much easier. 

My first goal was to use no graphics assets and to do everything (ball, bricks, player's slider) only with the _draw() method of Godot. Furthermore the bricks should get random colors and all levels should also be "calculated", so that the design view would only be used to layout the UI.

Actually, it was as simple as I thought and after around two hours I got a working game with the first level. But this game had no end yet and the level completed screen was still missing. You could loose the game and restart it, though.

This is now a final first version with three levels, level switching, level completed screen and end game / restart screen.
I will eventually put a tutorial on my "Ants Godot"-Youtube channel.

### Version history
V0.1 - 18-Jan-2024: Speed programming of level 1 with brick, ball, player and game (Proof of concept)

V1.0 - 19-Jan-2024: Added level 2 and 3. New screens for level completed, game ended, restart game. Level switching. New levels can be easily integrated into the game.gd file without changing the other files. Fixed some small bugs. Mouse cursor is now hidden when the game is running.

V1.1 - 19-Jan-2024: Music and audio menu added. Levels 4-6 added. Levels have a name now that is shown at the beginning of each level for a few seconds. Created an Ants Godot video showing the current gameplay (https://www.youtube.com/watch?v=9MSujApKUog). 
