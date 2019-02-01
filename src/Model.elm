module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Model exposing (Tree, TreeNode, tree)


type alias Model =
    { decisionTree : Tree TreeNode }


init : ( Model, Cmd Msg )
init =
    ( { decisionTree = tree }
    , Cmd.none
    )
