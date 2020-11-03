Getting Started
===============

This demonstrates how to build a simple Idris 2 application for the
Arduino. This is largely just proof of concept. You will need a few
things to get started:


  1. A recent version of Idris 2 that includes *C with reference counting* backend.

  2. [Arduino Software](http://arduino.cc/en/Main/Software).
     The current version was tested against version 1.8.13.
     You need to untar or install the package for your platform.

  3. Some `Arduino` compatible hardware

Keep in mind that this repository contains git submodules for
the arduino building system called [Arduino-Makefile](https://github.com/sudar/Arduino-Makefile)
and for the slightly modified Idris 2 RTS with removed `pthread` imports and concurrency primitives
since `pthread` is not supported for Arduino.

After fetching this repository with submodules,
you may need to tune the `Makefile` in the root directory to select the board you use.
This repository contains presets for several boards that lie at `aux-makefiles/board-*.mk`.

Additionaly you may need to modify `Makefile` and files in the `aux-makefiles` directory.
There are variables that you may set according to you installation:

 * `ARDUINO_DIR`    = *where you unpacked the Arduino software*
 * `AVR_TOOLS_DIR`  = *dir containing `bin/avr-gcc` unless it is shipped with the Arduino software*
 * `AVRDUDE_CONF`   = *path to `avrdude.conf` unless avrdude is shipped with the Arduino software*
 * `BOARD_TAG` and `BOARD_SUB` = *your board name (e.g., uno, mega) and subname (if applicable, e.g. atmega2560 for mega)*
 * `IDRIS_RTS_PATH` = *path to the source for the RTS. Could point to the git source or to the copy of the files installed by cabal*
 * `ARDUINO_MAKEFILE_PATH` = *path to the `Arduino.mk` from step 2*

Now you can run `make` to build the project or `make upload` to build & upload the code.

How This Works
==============

This process simply uses the Idris `C` backend to produce a `.c` file
which is then built using `Arduino.mk`. The standard `Arduino.mk`
rules are augmented via the `Idris2.mk` file in the `aux-makefiles`
directory. Eventually the `Idris2.mk` should be installed in globally
as all the project specific information should be in the local
`Makefile`.

The standard FFI is used to import Arduino `C` functions into Idris 2.
In the example we are importing standard Arduino functions defined in `Arduino.h`
which are usually available with no additional effort in the `*.ino` sketches.

Limitations
===========

Arduino Uno only has 2K of RAM -- so even in C it is easy to exceed its limitations.

However, we are currently using recently added Idris 2's RTS with reference counting garbage collector.
By the [original claim](https://github.com/idris-lang/Idris2/pull/739)
*the main goal of this is portability - especially, being able to run Idris programs on unusual or constrained platforms*
which sounds promising.

Future
======

Porting Idris to the Arduino is fun for bragging rights -- but the
miniscle amount of RAM greatly limits its usefulness. However, there
are many other embedded systems which could also be targetted. Two
that I am interested in are:

 * [teensy](https://www.pjrc.com/teensy/teensy31.html) - $20 - 64K of RAM, 72MHz Cortex-M4. Can use many Arduino libraries.

 * [Raspberry Pi](http://en.wikipedia.org/wiki/Raspberry_Pi) - $25-35, 512MB of RAM, 700MHz ARM1176JZF-S.

For the Raspberry Pi, it is already rather trivial to generate .c code
on another machine, and then compile it on the RaspberryPi -- assuming
you are running a Linux based OS on the Raspberry Pi.

However -- I hate waiting for Linux to boot and having to worry about
it shutting down properly. So, my goal would be to target the
RaspberryPi hardware directly. There are challenges here such as
integrating with the built-in bootloader, writing drivers for the
hardware with may require binary blobs, etc.


Why?
====

You might wonder why use Idris for embedded development? But, for me,
it seems like the perfect match. Debugging code on embedded systems is
extremely annoying. Often times your only output is a single LED,
making it slow to narrow down a problem. In many cases the system
might be controlling dangerous or expensive equipment which could be
damaged or even lead to loss of life.

I first became interested in functional programming over a decade ago
when working as a firmware engineer. Frusted with having to debug
stupid C code bugs I searched out and found
[splint](http://en.wikipedia.org/wiki/Splint_(programming_tool))
(called lc-lint at the time). It's a tool that statically checks C
code eliminating many of my coding errors. To perform the extra checks
you have to add additional annotations to your code via specially
formatted C comments.

splint saved me so much time I wondered why languages didn't have that
functionality built-in. This led me to the
[Clean](http://wiki.clean.cs.ru.nl/Clean) programming language, and
then on to [Haskell](http://www.haskell.org).

But, it is Idris that seems to really have enough power to make it
exciting for embedded development because it can capture the
constraints of the system without becoming
awkward. For example, I would like to control a string of 50
individually addressable RGB LEDs. I know that my system has exactly
50 LEDS -- and so I can specify that the code must supply a `Vect 50 RGB`.

I also wish to use Idris to control a propane flame effect with a
verified pilot. The system should never open the solenoid and release
the propane fuel unless the pilot light can be verified. Using Idris,
I can enforce this constraint at compile time and be certain it holds.

Often times I wish to communicate between the embedded system and a
host machine. The Idris
[Protocols](https://github.com/edwinb/Protocols) library seems like a
very attractive solution to handling the over-the-wire-format and
ensuring both sides are functioning correctly.
