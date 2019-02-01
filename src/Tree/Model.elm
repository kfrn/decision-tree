module Tree.Model exposing (Option, Tree(..), TreeNode(..), optionText, questionText, tree)


type Tree a
    = Empty
    | Node a (Tree a) (Tree a)


type TreeNode
    = TreeNode Question (List Option)


type Question
    = Colour
    | IsBanana
    | IsMelon


type Option
    = No
    | Orange
    | Pink
    | Yes


tree : Tree TreeNode
tree =
    Node
        (TreeNode IsMelon [ Yes, No ])
        (Node
            (TreeNode IsBanana [ Yes, No ])
            Empty
            Empty
        )
        (Node
            (TreeNode Colour [ Pink, Orange ])
            Empty
            Empty
        )


questionText : Question -> String
questionText q =
    case q of
        Colour ->
            "What colour is it?"

        IsBanana ->
            "Is it a banana?"

        IsMelon ->
            "Is it a melon?"


optionText : Option -> String
optionText opt =
    case opt of
        No ->
            "No"

        Orange ->
            "Orange"

        Pink ->
            "Pink"

        Yes ->
            "Yes"
