module CustomParserTests exposing (..)

import CustomParser exposing (CustomParser)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


type ExpectedOutput b a
    = Equal a
    | NotEqual a
    | Success
    | Fail
    | Error b


type ParserJudgement
    = Passed
    | Failed



-- helpers for testing


passResultToExpectation : a -> ExpectedOutput b a -> Expectation
passResultToExpectation actualVal expectedOutput =
    case expectedOutput of
        Equal expectedVal ->
            Expect.equal actualVal expectedVal

        NotEqual notExpectedVal ->
            Expect.notEqual actualVal notExpectedVal

        Success ->
            Expect.pass

        Fail ->
            Expect.fail "Expected test to fail, it passed instead"

        Error e ->
            Expect.fail ("Expected error: " ++ Debug.toString e ++ "\nTest passed instead")


errorResultToExpectation : b -> ExpectedOutput b a -> Expectation
errorResultToExpectation actualError expectedOutput =
    case expectedOutput of
        Equal expectedValue ->
            Expect.fail ("Expected result to be: " ++ Debug.toString expectedValue ++ "\nTest failed instead")

        NotEqual _ ->
            Expect.fail "Expected test to pass, it failed instead"

        Success ->
            Expect.fail "Expected test to pass, it failed instead"

        Fail ->
            Expect.pass

        Error e ->
            Expect.equal actualError e


createTestFromResult : String -> Expectation -> Test
createTestFromResult testName expectation =
    test testName <| \_ -> expectation


customParserTests :
    CustomParser a
    ->
        List
            { testName : String
            , input : String
            , expectedOutput : ExpectedOutput String a
            }
    -> List Test
customParserTests customParser testConfList =
    List.map
        (\{ input, testName, expectedOutput } ->
            case CustomParser.run customParser input of
                Ok val ->
                    createTestFromResult testName <| passResultToExpectation val expectedOutput

                Err error ->
                    createTestFromResult testName <| errorResultToExpectation error expectedOutput
        )
        testConfList



-- tests


testListInt : Test
testListInt =
    describe "testing list int: "
        (customParserTests CustomParser.listInt
            [ { testName = "valid list"
              , input = "4,232,67,2234,123"
              , expectedOutput = Equal [ 4, 232, 67, 2234, 123 ]
              }
            , { testName = "valid list: with random spaces"
              , input = "  4 ,232  , 67   ,   2234 ,    123"
              , expectedOutput = Equal [ 4, 232, 67, 2234, 123 ]
              }
            ]
        )


testListString : Test
testListString =
    describe "testing list string: "
        [ todo "todo: List String" ]
