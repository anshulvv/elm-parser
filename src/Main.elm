module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import ParserHandler exposing (ParsedValueType(..), ParserType(..))



-- Model


type alias Model =
    { selectedParser : ParserType
    , parserResult : Result String ParsedValueType
    , input : String
    }



-- main


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- init


init : Model
init =
    { selectedParser = ListIntParser
    , parserResult = Ok (ListInt [])
    , input = ""
    }



-- Msg


type Msg
    = OnInputChange String
    | OnChangeParserType ParserType



-- view


view : Model -> Html Msg
view model =
    let
        printParserResult : Result String ParsedValueType -> String
        printParserResult result =
            case result of
                Ok parsedValue ->
                    ParserHandler.getStringValue parsedValue

                Err error ->
                    error

        viewItem parserType =
            Html.button [ Events.onClick (OnChangeParserType parserType) ] [ Html.text <| ParserHandler.parserTypeToString parserType ]
    in
    Html.div []
        [ Html.textarea
            [ Events.onInput OnInputChange, Attributes.value model.input ]
            []
        , Html.p [] [ Html.text (printParserResult model.parserResult) ]
        , Html.ul []
            (List.map viewItem ParserHandler.allParsers)
        ]



-- update


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInputChange input ->
            { model
                | parserResult = ParserHandler.parse input model.selectedParser
                , input = input
            }

        OnChangeParserType selectedParserType ->
            { model
                | selectedParser = selectedParserType
                , input = ""
                , parserResult = Err "Please enter something"
            }
