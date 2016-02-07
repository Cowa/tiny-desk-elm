module TinyDesk where

import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects)
import Header
import Background
import Conversation
import Chatbox
import PickingList


--
--


type alias Model =
  { activeChatbox : Maybe Chatbox.Model
  , pickingList : PickingList.Model }


init : ( Model, Effects Action )
init =
  ( { activeChatbox = Just Chatbox.init, pickingList = PickingList.init }
  , Effects.map PickingList PickingList.fetchCats
  )



--
--


type Action
  = ActiveChatbox Chatbox.Action
  | PickingList PickingList.Action
  | NoOp



--
--


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    ActiveChatbox action' ->
      let
        ( activeConv, fx ) =
          case model.activeChatbox of
            Just conv ->
              let
                ( conv', fx ) =
                  Chatbox.update action' conv
              in
                ( Just conv', fx )

            Nothing ->
              ( model.activeChatbox, Effects.none )
      in
        ( { model | activeChatbox = activeConv }, Effects.map ActiveChatbox fx )

    PickingList action' ->
      let
        (newPickingList, fx) = PickingList.update action' model.pickingList
      in
        ( { model | pickingList = newPickingList }, Effects.map PickingList fx )


--
--


view : Signal.Address Action -> Model -> Html
view address model =
  let
    chatboxView =
      case model.activeChatbox of
        Just chatbox ->
          Chatbox.view (Signal.forwardTo address ActiveChatbox) chatbox

        Nothing ->
          div [] []
    pickingListAddress = Signal.forwardTo address PickingList
  in
    div
      []
      [ Header.view pickingListAddress
      , chatboxView
      , Background.view
      , PickingList.view pickingListAddress model.pickingList
      ]
