module ParserHandler exposing (ParsedValueType(..), ParserType(..), allParsers, getStringValue, parse, parserTypeToString)

import CustomParser exposing (CustomParser)


type ParserType
    = ListIntParser
    | ListStringParser


type ParsedValueType
    = ListInt (List Int)
    | ListString (List String)



-- main runner


parse : String -> ParserType -> Result String ParsedValueType
parse input parserType =
    case parserType of
        ListIntParser ->
            Result.map ListInt <| CustomParser.run CustomParser.listInt input

        ListStringParser ->
            Result.map ListString <| CustomParser.run CustomParser.listString input


allParsers : List ParserType
allParsers =
    [ ListIntParser, ListStringParser ]


parserTypeToString : ParserType -> String
parserTypeToString parserType =
    case parserType of
        ListIntParser ->
            "List Int"

        ListStringParser ->
            "List String"


getStringValue : ParsedValueType -> String
getStringValue parsedValue =
    case parsedValue of
        ListInt list ->
            Debug.toString list

        ListString list ->
            Debug.toString list
