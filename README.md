# Bucium
A sound synthesis sandbox
***

### About
Bucium was designed as an experiment to aid in discovering different sound
synthesis algorithms and effects. It will feature a modular interface, in
which every generator, filter or effect is a Lua file.

### Building
Building requires PortAudio, Lua and libsndfile development headers. After
building, you can do
	`$ ./bucium generators/square.lua filters/wobbler.lua`
for a quick demo.
