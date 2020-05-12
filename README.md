Getting Started
===============

This demonstrates how to build a simple Idris application for the
Arduino. This is largely just proof of concept. You will need a few
things to get started:


  1. A recent version of Idris that includes
  `rts/arudino/idris_main.c`. You will want to build and install
  this. At the time of this writing you will need to pull the patches
  from this branch
  [https://github.com/stepcut/Idris-dev/tree/fix/master/arduino](https://github.com/stepcut/Idris-dev/tree/fix/master/arduino)

  2. [Arduino-Makefile](https://github.com/sudar/Arduino-Makefile). You
  just need to check out the source somewhere.

  3. [Arduino Software](http://arduino.cc/en/Main/Software). Currently
  only the 1.0.x series is supported. You will need to untar the
  package for your platform.

  4. Some `Arduino` compatible hardware

Next you will need to update the `Makefile` in this directory.

You will need to set the following variables:

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
rules are augmented via the `Idris.mk` file in the local
directory. Eventually the `Idris.mk` should be installed in globally
as all the project specific information should be in the local
`Makefile`.

The standard FFI is used to import Arduino `C` functions into
Idris. The functions to be imported are defined in the local
`idris_arduino.c` file. Some of the functions are just wrappers around
the standard Arduino functions. I honestly have no idea why I used
wrappers -- there may be no reason at all.

Limitations
===========

You can't write very much code before you run out of RAM on the arduino. I think that even just something like:

    main : IO ()
    main =
      do pinMode 13 1
         digitalWrite 13 1
         delay 100
         digitalWrite 13 0
         delay 100
         digitalWrite 13 1
         delay 100
         digitalWrite 13 0
         delay 100
         digitalWrite 13 1
         delay 100

might be enough to cause trouble. The arduino only has 2K of RAM -- so
even in C it is easy to exceed its limitations. We are currently using
the standard RTS garbage collector on the arduino -- which is
definitely far from ideal. The standard GC is a Cheney style garbage
collector where the heap is divided in two and only half is used at
any time. Zoinks! Additionally, it uses `malloc` and `free` which is
frowned upon on the Arduino.

So, the next order of business is to implement a more sensible GC for
embedded systems. Given that we know how much RAM is available at
compile time and that there are no other applications running on the
system, there is no need for `malloc`/`free`. Additionally, we want a GC
system that does not waste half the very limited space. Would also be
nice to have a GC that was friendly towards real-time system. That is,
of course, still an open research problem.

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
