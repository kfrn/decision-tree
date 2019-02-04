module Update exposing (update)

import List.Extra as ListX
import Messages exposing (Msg(..))
import Model exposing (Model)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree(..), TreeNode(..), addChild, findAncestor, isChildOf)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectOption currentChoice ->
            case ListX.last model.choices of
                Just previousChoice ->
                    -- Child of the current choice
                    if isChildOf currentChoice previousChoice then
                        ( { model | choices = addChild currentChoice model.choices }, Cmd.none )

                    else
                        -- Ancestor or sibling of the current choice
                        -- TODO: set correct option to selected, so you don't have to click twice.
                        case findAncestor currentChoice model.choices of
                            Just a ->
                                let
                                    listHead =
                                        ListX.takeWhile (\c -> c /= a) model.choices
                                in
                                ( { model | choices = listHead ++ [ a ] }, Cmd.none )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( { model | choices = [ fullDecisionTree ] }, Cmd.none )
