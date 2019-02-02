module Tree.View exposing (tree)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Messages exposing (Msg)
import Tree.Model exposing (DecisionTree(..), Option(..), TreeNode(..))


tree : DecisionTree TreeNode -> Html Msg
tree decisionTree =
    case decisionTree of
        Answer answerText ->
            div [ class "has-text-weight-bold answer" ] [ text answerText ]

        Question treeNode ->
            renderTreeNode treeNode


renderTreeNode : TreeNode -> Html Msg
renderTreeNode (TreeNode questionText option1 option2) =
    div
        [ class "tree-node" ]
        [ div
            [ class "question" ]
            [ text questionText ]
        , div [ class "options" ]
            [ renderOption option1
            , renderOption option2
            ]
        ]


renderOption : Option -> Html Msg
renderOption (Option optionText decisionTree) =
    div
        [ class "option" ]
        [ button [ class "button option-name" ] [ text optionText ]
        , tree decisionTree
        ]
