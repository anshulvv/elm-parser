module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


tester : Test
tester =
    describe "testing describe"
        [ test "a tester test for testing if tests work" <|
            (\_ -> Expect.pass)
        ]
