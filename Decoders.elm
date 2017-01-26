module Decoders exposing (..)

import Html exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


json =
    """
    [
      {
        "name": "Spotty",
        "weight": 12.9,
        "sex": "mail"
      },
      {
        "name": "Dashy",
        "weight": 9.2,
        "sex": "female"
      },
      {
        "name": "Sparky",
        "weight": 7.3,
        "sex": "male"
      }
    ]
    """


type Sex
    = Male
    | Female
    | Unknown


type alias Dog =
    { name : String
    , weight : Float
    , sex : Sex
    }


dogDecoder : Decoder Dog
dogDecoder =
    decode Dog
        |> required "name" string
        |> required "weight" float
        |> required "sex" sexDecoder


sexDecoder : Decoder Sex
sexDecoder =
    string
        |> Json.Decode.andThen
            (\sexString ->
                case sexString of
                    "male" ->
                        Json.Decode.succeed Male

                    "female" ->
                        Json.Decode.succeed Female

                    _ ->
                        Json.Decode.succeed Unknown
            )


listDecoder : Decoder (List Dog)
listDecoder =
    Json.Decode.list dogDecoder


decoded : Result String (List Dog)
decoded =
    Json.Decode.decodeString listDecoder json


main =
    text (toString decoded)
