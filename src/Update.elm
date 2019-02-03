module Update exposing (update)

import List.Extra as ListX
import Messages exposing (Msg(..))
import Model exposing (Model)
import Tree.Model exposing (DecisionTree(..), Status(..), TreeNode(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectOption tree ->
            let
                listHead =
                    case ListX.init model.nodes of
                        Just head ->
                            head

                        Nothing ->
                            []

                newNodes =
                    listHead ++ newParentNode tree model.nodes ++ [ tree ]
            in
            ( { model | nodes = newNodes }, Cmd.none )


newParentNode : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
newParentNode currentTree existingNodes =
    case ListX.last existingNodes of
        Just (Question (TreeNode questionText options)) ->
            let
                selectedOption option =
                    if option.childNode == currentTree then
                        { option | status = Just Selected }

                    else
                        { option | status = Just Disabled }

                newOptions =
                    List.map selectedOption options
            in
            [ Question (TreeNode questionText newOptions) ]

        _ ->
            []
