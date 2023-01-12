# FlutterWideGamutPrototype

## Description

This is a prototype to show how to render Display P3 and the settings we would
need in the Flutter engine to make this work.

The crux is that I recommend that the engine stays in Linear RGB for all of its
work.  But when we load images that are in the Display P3 format we store them
in memory in the 64bit/pixel format and we use the 64bit/pixel pixel format
for all of the render buffers as well.

## Sources

Based on Apple's Sample Code, ["Creating and Sampling Textures"](https://developer.apple.com/documentation/metal/textures/creating_and_sampling_textures?language=objc).