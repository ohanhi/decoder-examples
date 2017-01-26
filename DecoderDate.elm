module Decoders exposing (..)

import Html exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Date exposing (Date)
import Http


type alias Model =
    { commits : List Commit
    }


type Msg
    = HandleResponse (Result Http.Error (List Commit))


init : ( Model, Cmd Msg )
init =
    ( { commits = [] }, getCommits )


update : Msg -> Model -> ( Model, Cmd msg )
update (HandleResponse response) model =
    case response of
        Ok commits ->
            ( { commits = commits }, Cmd.none )

        Err _ ->
            ( model, Cmd.none )


getCommits : Cmd Msg
getCommits =
    Http.get "/json/03-commits.json" listDecoder
        |> Http.send HandleResponse


type alias Commit =
    { authorName : String
    , date : Date
    }



-- aCommit =
--     Commit "Foo" (Date.fromString "")


commitDecoder : Decoder Commit
commitDecoder =
    decode makeIntoACommitRecord
        |> requiredAt [ "commit", "author", "name" ] string
        |> requiredAt [ "commit", "author", "date" ] dateDecoder


makeIntoACommitRecord : String -> Date -> Commit
makeIntoACommitRecord name date =
    { authorName = name, date = date }


dateDecoder : Decoder Date
dateDecoder =
    string
        |> Json.Decode.andThen
            (\dateString ->
                case (Date.fromString dateString) of
                    Ok date ->
                        Json.Decode.succeed date

                    Err errorString ->
                        Json.Decode.fail errorString
            )


listDecoder : Decoder (List Commit)
listDecoder =
    Json.Decode.list commitDecoder


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html msg
view model =
    text (toString model.commits)
