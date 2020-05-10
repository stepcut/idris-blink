module Main

%include C "idris_arduino.h"

digitalWrite : Int -> Int -> IO ()
digitalWrite pin val = foreign FFI_C "idrard_digitalWrite" (Int -> Int -> IO ()) pin val

pinMode : Int -> Int -> IO ()
pinMode pin mode = foreign FFI_C "idrard_pinMode" (Int -> Int -> IO ()) pin mode

delay : Int -> IO ()
delay ms = foreign FFI_C "idrard_delay" (Int -> IO ()) ms

blink : Int -> Int -> IO ()
blink pin t = do digitalWrite pin 1
                 delay t
                 digitalWrite pin 0
                 delay t
                 blink pin t

main : IO ()
main =
  do pinMode 13 1
     blink 13 30
