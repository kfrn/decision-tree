module Update exposing (update)

import List.Extra as ListX
import Messages exposing (Msg(..))
import Model exposing (Model)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree(..), TreeNode(..), addChild, findAncestor, isChildOf, setSelection)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectOption currentChoice ->
            case ListX.last model.choices of
                Just previousChoice ->
                    if isChildOf currentChoice previousChoice then
                        -- Child of the current choice
                        ( { model | choices = addChild currentChoice model.choices }, Cmd.none )

                    else
                        -- Ancestor or sibling of the current choice
                        case findAncestor currentChoice model.choices of
                            Just ancestor ->
                                let
                                    listHead =
                                        ListX.takeWhile (\c -> c /= ancestor) model.choices
                                in
                                ( { model | choices = listHead ++ [ setSelection ancestor currentChoice, currentChoice ] }, Cmd.none )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( { model | choices = [ fullDecisionTree ] }, Cmd.none )
