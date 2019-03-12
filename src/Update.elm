module Update exposing (update)

import Browser.Dom as Dom
import Messages exposing (Msg(..))
import Model exposing (Model, init)
import Task
import Tree.Model exposing (focusNonChildOption, focusChildOption)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FocusChildOption choice ->
            ( focusChildOption choice model, jumpToBottom "tree" )

        FocusNonChildOption choice ->
            ( focusNonChildOption choice model, jumpToBottom "tree" )

        NoOp ->
            ( model, Cmd.none )

        Reset ->
            init


jumpToBottom : String -> Cmd Msg
jumpToBottom id =
    Dom.getViewportOf id
        |> Task.andThen (\info -> Dom.setViewport 0 info.scene.height)
        |> Task.attempt (\_ -> NoOp)
