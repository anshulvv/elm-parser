module Main exposing (main)

import Browser
import CustomParser
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events



-- Model


type alias Model =
    { err : Maybe String
    , parsedList : Maybe (List Int)
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
    { err = Nothing
    , parsedList = Nothing
    , input = ""
    }



-- Msg


type Msg
    = OnInputChange String



-- view


view : Model -> Html Msg
view model =
    let
        printResult : Maybe String -> Maybe a -> String
        printResult err result =
            err
                |> Maybe.withDefault (Debug.toString result)
    in
    Html.div []
        [ Html.input
            [ Events.onInput OnInputChange, Attributes.value model.input ]
            [ Html.text <| "I wrote something" ]
        , Html.p [] [ Html.text (printResult model.err model.parsedList) ]
        ]



-- update


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInputChange input ->
            parseListOfInt input


parseListOfInt : String -> Model
parseListOfInt input =
    let
        result =
            CustomParser.run CustomParser.listInt input
    in
    case result of
        Ok list ->
            Model Nothing (Just list) input

        Err str ->
            Model (Just str) Nothing input



