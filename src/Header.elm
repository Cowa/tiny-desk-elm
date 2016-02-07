module Header (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (Effects)
import PickingList

view : Signal.Address PickingList.Action -> Html
view address =
  div
    [ class "header" ]
    [ span
        [ class "logo", onClick address PickingList.Toggle ]
        [ i [ class "fa fa-anchor" ] [] ]
    , span
        [ class "logout" ]
        [ i [ class "fa fa-power-off" ] [] ]
    ]
