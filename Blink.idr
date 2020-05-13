module Main

%include C "Arduino.h"

digitalWrite : Int -> Int -> IO ()
digitalWrite pin val = foreign FFI_C "digitalWrite" (Int -> Int -> IO ()) pin val

pinMode : Int -> Int -> IO ()
pinMode pin mode = foreign FFI_C "pinMode" (Int -> Int -> IO ()) pin mode

delay : Int -> IO ()
delay ms = foreign FFI_C "delay" (Int -> IO ()) ms

forever : Monad f => f a -> f b
forever x = do x
               forever x

blink : Int -> Int -> IO ()
blink pin t = do digitalWrite pin 1
                 delay t
                 digitalWrite pin 0
                 delay t

main : IO ()
main =
  do pinMode 13 1
     forever $ blink 13 300
