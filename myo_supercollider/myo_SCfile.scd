s.makeWindow.boot;

/*
Nicholas Fentekes
Final Project

Created a system using a Myo Armband, Wekinator, and Processing to control Supercollider with gestures.
These gestures are identified via machine learning classification of EMG data from the Myo Band.


*/

(
//Here's the band

// drum1 are the cymbals and bass drum

SynthDef("drum1",
{
arg dur = 1, freq = 2820;
a = PinkNoise.ar;
	b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 0.26, 1, -4),doneAction:2);
	e = FreeVerb.ar(b, 0.5, 0.7, 0, 4);
Out.ar([0, 1], e)
}).load(s);


//drum2 is the high hat

SynthDef("drum2",
{
arg dur = 1, freq = 2820;
	a = PinkNoise.ar;
	b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 0.11, 1, -4),doneAction:2);
Out.ar([0, 1], b)
}).load(s);




SynthDef("clap", {
		arg outBus=0, amp = 0.5;
		var env1, env2, out, noise1, noise2;

		env1 = EnvGen.ar(Env.new([0, 1, 0, 1, 0, 1, 0, 1, 0], [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03], [0, -3, 0, -3, 0, -3, 0, -4]));
		env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2);

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, 600);
		noise1 = BPF.ar(noise1, 2000, 3);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, 1000);
		noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

		out = noise1 + noise2;
		out = out * 2;
		out = out.softclip * amp;

		Out.ar(outBus, out.dup);
	}).send(s);
// this is one of those MIDI keyboards that hangs off your shoulder like a guitar

SynthDef("bass",
{arg midinote = 60, amp = 1, dur = 4, pan = 0, legato = 0.8;

	 v = Pan2.ar(
			Pulse.ar(midinote.midicps, SinOsc.ar(4, 0, amp, 0.5), 0.1)
			*
			EnvGen.kr(Env.perc(0.05, dur*legato), doneAction: 2),
			pan);
			v = FreeVerb.ar(v, 0.5, 0.7, 0.5, 1);
	Out.ar([0, 1], v);
	}).load(s);


//Radio Shack Fender Rhodes...

SynthDef("fender2",
{
arg midinote = 60, dur = 1, legato = 0.2;
	x = PMOsc.ar(midinote.midicps, midinote.midicps + 10, 1, 0, 0.7)
	*
	EnvGen.kr(Env.perc(0.0, 3, 1), doneAction: 2);
	x = Pan2.ar(x, 0, 0.7);
	x = FreeVerb.ar(x, 0.7, 0.9, 0.7, 0.5);
Out.ar([0, 1], x)
	}).load(s);

SynthDef("fender23",
{
arg midinote = 63, dur = 1, legato = 0.2;
	x = PMOsc.ar(midinote.midicps, midinote.midicps + 10, 1, 0, 0.7)
	*
	EnvGen.kr(Env.perc(0.0, 3, 1), doneAction: 2);
	x = Pan2.ar(x, 0, 0.7);
	x = FreeVerb.ar(x, 0.7, 0.9, 0.7, 0.5);
Out.ar([0, 1], x)
	}).load(s);

SynthDef("fender24",
{
arg midinote = 67, dur = 1, legato = 0.2;
	x = PMOsc.ar(midinote.midicps, midinote.midicps + 10, 1, 0, 0.7)
	*
	EnvGen.kr(Env.perc(0.0, 3, 1), doneAction: 2);
	x = Pan2.ar(x, 0, 0.8);
	x = FreeVerb.ar(x, 0.7, 0.9, 0.7, 0.5);
Out.ar([0, 1], x)
	}).load(s);


SynthDef("kick", {
		arg outBus=0;
		var env0, env1, env1m, out;

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
		env1m = env1.midicps;

		out = LFPulse.ar(env1m, 0, 0.5, 0.5, -0.5);
		out = out + WhiteNoise.ar(1);
		out = LPF.ar(out, env1m*1.5, env0*0.6);
		out = out + SinOsc.ar(env1m, 0.5, env0*0.6);

		out = out * 1.2;
		out = out.clip2(1);

		Out.ar(outBus, out.dup);
	}).send(s);


//hat
SynthDef("hhat", {
		arg outBus=0, amp=0.3;
		var env1, env2, out, oscs1, noise, n, n2;

		n = 5;
		thisThread.randSeed = 4;

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, 0.2], [0, -12]));
		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.05, 0.03], [0, -4, -4]), doneAction:2);

		oscs1 = Mix.fill(n, {|i|
			SinOsc.ar(
				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,
				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),
				1/n
			)
		});

		oscs1 = BHiPass.ar(oscs1, 1000, 2, env1);
		n2 = 8;
		noise = WhiteNoise.ar;
		noise = Mix.fill(n2, {|i|
			var freq;
			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;
			CombN.ar(noise, 0.04, freq, 0.1)
		}) * (1/n) + noise;
		noise = BPF.ar(noise, 6000, 0.9, 0.5, noise);
		noise = BLowShelf.ar(noise, 3000, 0.5, -6);
		noise = BHiPass.ar(noise, 1000, 1.5, env2);

		out = noise + oscs1;
		out = out.softclip;
		out = out * amp;

		Out.ar(outBus, out.dup);
	}).send(s);


//acid
SynthDef("acid", {
		arg freq = 30,dur=1,outBus=0, gate=1, pitch=25, amp=0.1;
		var env1, env2, out;
		freq = Lag.kr(freq, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
		out = LFPulse.ar(freq.midicps, 0.0, 0.51, 2, -1);

		out = RLPF.ar(out, (pitch + env2).midicps, 0.3);
		out = out * env1;

		Out.ar(outBus, out.dup);
	}).send(s);


)

//Here's the chart





(
var track1, track2, track3, bass, guit1, guit2, guit3, guit4,claptrack,kicktrack,hattrack,acidtrack;
//acidtrack
acidtrack = Pbind(\instrument, "acid",
	[\freq,\dur],
	Pseq([Pseq([
		[\rest,1],[30,1],[33,3/2],[30,1/2],[\rest,1],[30,2],[30,1]],3),[\rest,1],[30,1],[33,3/2],[30,1/2],[\rest,1],[33,2],[37,1]],inf)
		);

//claptrack
claptrack = Pbind(\instrument, "clap",
	[\freq,\dur],
	Pseq([
		[\rest,2],[3000,2]],inf)
		);
kicktrack = Pbind(\instrument, "kick",
	[\freq,\dur],
	Pseq([
		[30,2],[30,2]],inf)
		);

//ride cymbal

track1 = Pbind(\instrument, "drum1",
	[\freq, \dur],
	Pseq([
		[13810, 1], [14000, 1], [12810, 2/3], [14800, 1/3],
		[14810, 1], [14500, 1], [12000, 1], [13800, 1],
		[14810, 1], [14500, 1], [12000, 2/3], [13800, 1/3],
		[14810, 1], [14500, 1], [12000, 1], [13800, 1],
		[14810, 1], [14500, 1], [12000, 2/3], [13800, 1/3],
		],inf)
		);

//bass drum

track2 = Pbind(\instrument, "drum1",
	[\freq, \dur],
	Pseq([
		[25, 2], [35, 2]],inf)
		);

//hattrack
hattrack = Pbind(\instrument, "hhat",
	[\freq, \dur],
	Pseq([
		[\rest, 1], [4000, 1]],inf)
		);
//hat cymbal

track3 = Pbind(\instrument, "drum2",
	[\freq, \dur],
	Pseq([
		[\rest, 1], [4000, 1]],inf)
		);

//bass line
//chord root

guit1 = Pbind( \instrument, "fender2",
			[\midinote, \dur],
			Pseq([
		[66, 3], [73, 3], [70, 4],[66,2], [\rest, 4]
					], inf),
				);

//chord extentions



Ptpar([0.0, Ppar([track1,hattrack, track2, track3,claptrack,kicktrack]), 32.0,
		Ppar([acidtrack])]).play(TempoClock(4));
)
