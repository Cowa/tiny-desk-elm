module Header (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects)

view : Html
view =
  div
    [ class "header" ]
    [ span
        [ class "logo" ]
        [ i [ class "fa fa-anchor" ] [] ]
    , span
        [ class "logout" ]
        [ i [ class "fa fa-power-off" ] [] ]
    ]
