module Tree.View exposing (tree)

import Html exposing (Html, button, div, span, text)
import Html.Attributes exposing (class, classList, disabled)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Tree.Model exposing (DecisionTree(..), Option, Status(..), TreeNode(..))


tree : DecisionTree TreeNode -> Html Msg
tree decisionTree =
    case decisionTree of
        Answer answerText ->
            div [ class "answer" ]
                [ span [] [ text "Answer is: " ]
                , span [ class "has-text-weight-bold" ] [ text answerText ]
                ]

        Question treeNode ->
            renderTreeNode treeNode


renderTreeNode : TreeNode -> Html Msg
renderTreeNode (TreeNode questionText options) =
    div
        [ class "tree-node" ]
        [ div [ class "question" ] [ text questionText ]
        , div [ class "options" ]
            (List.map renderOption options)
        ]


renderOption : Option -> Html Msg
renderOption option =
    div
        [ class "option" ]
        [ button
            [ classList [ ( "button option-name", True ), ( "is-primary", option.status == Just Selected ) ]
            , disabled <| option.status == Just Disabled
            , onClick <| SelectOption option.childNode
            ]
            [ text option.name ]
        ]
