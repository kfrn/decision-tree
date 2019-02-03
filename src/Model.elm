module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Model exposing (DecisionTree, TreeNode, tree)


type alias Model =
    { decisionTree : DecisionTree TreeNode
    , nodes : List (DecisionTree TreeNode)
    }


init : ( Model, Cmd Msg )
init =
    ( { decisionTree = tree, nodes = [ tree ] }
    , Cmd.none
    )
