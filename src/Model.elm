module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree, TreeNode)


type alias Model =
    { decisionTree : DecisionTree TreeNode
    , choices : List (DecisionTree TreeNode)
    }


init : ( Model, Cmd Msg )
init =
    ( { decisionTree = fullDecisionTree, choices = [ fullDecisionTree ] }
    , Cmd.none
    )
