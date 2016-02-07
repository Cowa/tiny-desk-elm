module PickingList where

import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Cat

--
--

type alias Model =
  { cats : List Cat.Model
  , isVisible : Bool }


init : Model
init = { cats = [], isVisible = True }

--
--

type Action
  = Toggle
  | FetchCatsFromAPI (Maybe (List Cat.Model))

--
--

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Toggle ->
      ( { model | isVisible = not model.isVisible }, Effects.none )

    FetchCatsFromAPI maybeCats ->
      case maybeCats of
        Just cats ->
          ( { model | cats = cats }, Effects.none )

        Nothing -> ( model, Effects.none )

--
--

view : Signal.Address Action -> Model -> Html
view address model =
  let
    numberOfMessages = List.length model.cats |> toString
    viewCats = List.map viewSingleCat model.cats
    hiddenClass = if model.isVisible then "" else " hidden"
  in
    div [ class ("pickinglist" ++ hiddenClass) ]
      [ div [ class "pickinglist-header" ]
        [ text (numberOfMessages ++ " cats")
        , button [ onClick address Toggle ] [ text "x" ]
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
    |> Task.map FetchCatsFromAPI
    |> Effects.task
