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
            case ListX.last model.choices of
                Just previousChoice ->
                    if isChildOf currentChoice previousChoice then
                        ( { model | choices = addChild currentChoice previousChoice model.choices }
                        , Cmd.none
                        )

                    else
                        -- If ancestor or sibling of the current choice
                        case findAncestor currentChoice model.choices of
                            Just ancestor ->
                                ( { model | choices = updateChoices currentChoice ancestor model.choices }
                                , Cmd.none
                                )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( { model | choices = [ fullDecisionTree ] }, Cmd.none )
