Nicholas Fentekes
Myoband-Supercollider Interfaces

Created a system using a Myo Armband, Wekinator, and Processing to control Supercollider with gestures.
These gestures are identified via machine learning classification of EMG data from the Myo Band.
The classification then sends its correspeonding OSC message to the scsynth server in order to load and launch a synth.

Dependencies:
-Wekinator
-Processing
  -oscP5, controlP5, and Myo packages installed
-MyoBand with MyoConnect software
-SuperCollider

To run:
-Open SuperCollider file and boot-up the scsynth server
-Open Wekinator and load first project file
	-Start listening for OSC on Wekinator
-Open another instance of Wekinator and load second project file
	-Start Listening for OSC on Wekinator
-Open myo_processing.pde in Processing and run the program
-In Wekinator, select which number gesture you would like to record from the drop down menu.
	-Make the gesture you wish to record with the MyoBand, then click start recording, then stop recording
	2 seconds after.
	-Record all desired gestures, make sure that you record an "at rest" position and make sure each position is
	accurately classified.
	-After recording each position, simply click train then run.

The supercollider file is loaded with a few basic sounds that alternate with different gestures as a basic demonstration of concept. Please read the supercollider file to understand how to implement this with your patches.
