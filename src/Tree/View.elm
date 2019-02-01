module Tree.View exposing (tree)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
import Messages exposing (Msg)
import Tree.Model exposing (Option, Tree(..), TreeNode(..), optionText, questionText)


tree : Tree TreeNode -> Html Msg
tree treeStructure =
    case treeStructure of
        Empty ->
            div [] []

        Node treeNode childTree1 childTree2 ->
            div [ class "node" ]
                [ renderTreeNode treeNode childTree1 childTree2 ]


renderTreeNode : TreeNode -> Tree TreeNode -> Tree TreeNode -> Html Msg
renderTreeNode (TreeNode question options) childTree1 childTree2 =
    let
        renderOption opt =
            div [ class "option" ]
                [ div [ class "button" ] [ text <| optionText opt ]
                , tree childTree1
                , tree childTree2
                ]
    in
    div
        [ class "treenode" ]
        [ h2
            [ class "question" ]
            [ text <| questionText question ]
        , div
            [ class "options" ]
            (List.map renderOption options)
        ]
