module Update exposing (update)

import Messages exposing (Msg(..))
import Model exposing (Model)
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
                    ( updateChoices currentChoice ancestor model, Cmd.none )

                Nothing ->
                    ( [ fullDecisionTree ], Cmd.none )
