module Conversation where

--
--

type alias Model =
  { history : List Entry }

type alias Entry =
  ( String, String )

init : Model
init =
  { history = [ ( "Visitor", "Hello!" ), ( "Visitor", "I'm looking for boring stuff" ), ( "Operator", "Hello pretty visitor! How can I help you?" ) ] }

--
--

appendToHistory : Model -> Entry -> Model
appendToHistory ({history} as model) entry =
  { model | history = List.append history [ entry ] }
