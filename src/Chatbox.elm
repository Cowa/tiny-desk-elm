module Chatbox (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (Effects)
import Html.Animation as UI
import Conversation

--
--


type alias Model =
  { conversation : Conversation.Model, hidden : Bool, messageToSend : String }


init : Model
init =
  { hidden = True, conversation = Conversation.init, messageToSend = "" }



--
--


type Action
  = ToggleHide
  | ComposingMessage String
  | SendMessage String
  | NoOp



--
--


update : Action -> Model -> ( Model, Effects Action )
update action ({ hidden, conversation, messageToSend } as model) =
  case action of
    ToggleHide ->
      ( { model | hidden = not hidden }, Effects.none )

    SendMessage message ->
      let
        updatedConversation = Conversation.appendToHistory conversation ("Operator", message)
      in
        ( { model | conversation = updatedConversation
                  , messageToSend = "" }
        , Effects.none )

    ComposingMessage message ->
      ( { model | messageToSend = message }, Effects.none )

    NoOp ->
      ( model, Effects.none )


--
--


view : Signal.Address Action -> Model -> Html
view address model =
  let
    hiddenClass =
      if model.hidden then
        "hidden"
      else
        ""

    reduceClass =
      if model.hidden then
        "fa-chevron-up"
      else
        "fa-chevron-down"
  in
    div
      [ class ("chatbox " ++ hiddenClass) ]
      [ div
        [ class "chatbox-header" ]
        [ span
          [ class "close" ]
          [ i [ class "fa fa-close" ] [] ]
        , span
          [ class "reduce", onClick address ToggleHide ]
          [ i [ class ("fa " ++ reduceClass) ] [] ]
        ]
      , div [ class "chatbox-history" ] (List.map viewMessageEntry model.conversation.history)
      , textarea
          [ class "chatbox-comboseBox"
          , on "input" targetValue (Signal.message address << ComposingMessage)
          , value model.messageToSend
          ]
          []
      , button
        [ class "chatbox-sendmessage"
        , onClick address (SendMessage model.messageToSend)
        ]
        [ text ("Send") ]
      ]


viewMessageEntry : Conversation.Entry -> Html
viewMessageEntry ( who, say ) =
  div [ class "chatbox-messageEntry" ] [ text (who ++ ": " ++ say) ]
