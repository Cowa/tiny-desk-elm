module PickingList where

import Http
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (Effects)

import Cat

--
--

type alias Model = { cats: List Cat.Model, isVisible : Bool }

init : Model
init = { cats = [], isVisible = True }

--
--

type Action
  = Toggle
  | RetrievedCatsFromAPI (Maybe (List Cat.Model))

--
--

update : Action -> Model -> Model
update action model =
  case action of
    Toggle ->
      { model | isVisible = not model.isVisible }

    RetrievedCatsFromAPI maybeCats ->
      case maybeCats of
        Just cats -> { model | cats = cats }
        Nothing -> model

--
--

view : Signal.Address Action -> Model -> Html
view address model =
  let
    nbMsg = List.length model.cats |> toString
    hiddenClass = if model.isVisible then "" else " hidden"
    viewCats = List.map viewSingleCat model.cats
  in
    div [ class ("pickinglist" ++ hiddenClass) ]
      [ div [ class "pickinglist-header"]
        [ text (nbMsg ++ " cats")
        , button [ onClick address Toggle ] [ text "x"]
        ]
      , div [] viewCats
      ]

viewSingleCat : Cat.Model -> Html
viewSingleCat cat =
  div [ class "pickinglist-entry" ] [ Cat.view cat ]

--
--

fetchCats : Effects Action
fetchCats =
  Http.get Cat.decode ("http://catfactory-api.herokuapp.com/cats")
    |> Task.toMaybe
    |> Task.map RetrievedCatsFromAPI
    |> Effects.task
