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

type alias Model = { cats : List Cat.Model, isVisible : Bool, error : String }

init : Model
init = { cats = [], isVisible = True, error = "" }

--
--

type Action
  = Toggle
  | RetrievedCatsFromAPI (Result Http.Error (List Cat.Model))

--
--

update : Action -> Model -> Model
update action model =
  case action of
    Toggle ->
      { model | isVisible = not model.isVisible }

    RetrievedCatsFromAPI maybeCats ->
      case maybeCats of
        Ok cats -> { model | cats = cats }

        Result.Err err ->
          case err of
            Http.UnexpectedPayload msg -> { model | error = "The returned JSON is fucked up" }

            _ -> { model | error = "Something went wrong..." }
            -- We could handle more precisely other errors : http://package.elm-lang.org/packages/evancz/elm-http/1.0.0/Http#Error

--
--

view : Signal.Address Action -> Model -> Html
view address model =
  let
    nbMsg = List.length model.cats |> toString
    hiddenClass = if model.isVisible then "" else " hidden"
    viewCats = List.map viewSingleCat model.cats
    errorView = span [ class "pickinglist-error" ] [ text model.error ]
  in
    div [ class ("pickinglist" ++ hiddenClass) ]
      [ div [ class "pickinglist-header"]
        [ text (nbMsg ++ " cats")
        , button [ onClick address Toggle ] [ text "x"]
        ]
      , div [] (errorView :: viewCats)
      ]

viewSingleCat : Cat.Model -> Html
viewSingleCat cat =
  div [ class "pickinglist-entry" ] [ Cat.view cat ]

--
--

fetchCats : Effects Action
fetchCats =
  Http.get Cat.decode ("http://catfactory-api.herokuapp.com/cats")
    |> Task.toResult
    |> Task.map RetrievedCatsFromAPI
    |> Effects.task
