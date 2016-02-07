module Main (..) where

import StartApp
import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Never)
import TinyDesk exposing (Model, init, view, update)


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = []
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks
