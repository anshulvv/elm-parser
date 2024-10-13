module CustomParser exposing (CustomParser, listInt, run)

import Parser exposing ((|.), (|=), Parser, Step(..))


type alias CustomParser a =
    { name : String
    , parser : Parser.Parser a
    }



-- Runner


run : CustomParser a -> String -> Result String a
run customParser input =
    Parser.run customParser.parser input
        |> Result.mapError Parser.deadEndsToString



-- Definitions of parsers


eatSpaces : Parser String
eatSpaces =
    let
        isSpace : Char -> Bool
        isSpace char =
            char == ' ' || char == '\t'
    in
    Parser.getChompedString <|
        Parser.succeed ()
            |. Parser.chompWhile isSpace



-- list of int parser


listInt : CustomParser (List Int)
listInt =
    { name = "List of Integers"
    , parser = parserListInt
    }


parserListInt : Parser (List Int)
parserListInt =
    Parser.succeed identity
        |. eatSpaces
        |= Parser.oneOf
            [ Parser.succeed []
                |. Parser.spaces
                |. Parser.end
            , Parser.loop [] parserListIntHelper
            ]


parserListIntHelper : List Int -> Parser (Step (List Int) (List Int))
parserListIntHelper li =
    let
        callback i next =
            next (i :: li)
    in
    Parser.succeed callback
        |. eatSpaces
        |= Parser.int
        |. eatSpaces
        |= Parser.oneOf
            [ Parser.succeed (Done << List.reverse)
                |. Parser.end
            , Parser.succeed Loop
                |. Parser.symbol ","
            ]
