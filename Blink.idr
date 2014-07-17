module Main

digitalWrite : Int -> Int -> IO ()
digitalWrite pin val = mkForeign (FFun "idrard_digitalWrite" [FInt, FInt] FUnit) pin val

pinMode : Int -> Int -> IO ()
pinMode pin mode = mkForeign (FFun "idrard_pinMode" [FInt, FInt] FUnit) pin mode

delay : Int -> IO ()
delay ms = mkForeign (FFun "idrard_delay" [FInt] FUnit) ms

blink : Int -> Int -> IO ()
blink pin ms = mkForeign (FFun "idrard_blink" [FInt, FInt] FUnit) pin  ms

main : IO ()
main =
  do pinMode 13 1
     blink 13 30
