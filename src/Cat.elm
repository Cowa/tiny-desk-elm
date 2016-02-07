module Cat where

import Json.Decode as Json exposing ((:=))
import Html exposing (..)
import Html.Attributes exposing (..)

type alias Model =
  { id : String
  , link : String
  }

--
--

view : Model -> Html
view model =
  img [ src model.link ] []

--
--

decode : Json.Decoder (List Model)
decode =
  ("data" := Json.list decodeSingle)

decodeSingle : Json.Decoder Model
decodeSingle =
  Json.object2 Model
    ("id" := Json.string)
    ("link" := Json.string)
