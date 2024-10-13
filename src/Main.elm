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
    , parsedList = Just []
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
        [ Html.textarea
            [ Events.onInput OnInputChange, Attributes.value model.input ]
            []
        , Html.p [] [ Html.text (printResult model.err model.parsedList) ]
        ]



-- update


update : Msg -> Model -> Model
update msg _ =
    case msg of
        OnInputChange input ->
            let
                result =
                    parseListOfInt input
            in
            case result of
                Ok listInt ->
                    Model Nothing (Just listInt) input

                Err error ->
                    Model (Just error) Nothing input


parseListOfInt : String -> Result String (List Int)
parseListOfInt input =
    CustomParser.run CustomParser.listInt input
