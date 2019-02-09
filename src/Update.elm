module Update exposing (update)

import List.Extra as ListX
import Messages exposing (Msg(..))
import Model exposing (Model)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree(..), TreeNode(..), addChild, findAncestor, isChildOf, updateChoices)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectOption currentChoice ->
            case ListX.last model of
                Just previousChoice ->
                    if isChildOf currentChoice previousChoice then
                        ( addChild currentChoice previousChoice model, Cmd.none )

                    else
                        -- If ancestor or sibling of the current choice
                        case findAncestor currentChoice model of
                            Just ancestor ->
                                ( updateChoices currentChoice ancestor model, Cmd.none )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( [ fullDecisionTree ], Cmd.none )
