module Update exposing (update)

import Browser.Dom as Dom
import Messages exposing (Msg(..))
import Model exposing (Model)
import Task
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree(..), TreeNode(..), findClosestAncestor, updateChoices)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectOption currentChoice ->
            case findClosestAncestor currentChoice model of
                Just ancestor ->
                    ( updateChoices currentChoice ancestor model
                    , jumpToBottom "tree"
                    )

                Nothing ->
                    ( [ fullDecisionTree ], Cmd.none )

        Reset ->
            ( [ fullDecisionTree ], Cmd.none )


jumpToBottom : String -> Cmd Msg
jumpToBottom id =
    Dom.getViewportOf id
        |> Task.andThen (\info -> Dom.setViewport 0 info.scene.height)
        |> Task.attempt (\_ -> NoOp)
