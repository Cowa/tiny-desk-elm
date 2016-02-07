module Background (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects)

view : Html
view =
  div
    [ class "background" ]
    [ i [ class "fa fa-life-ring" ] [] ]
