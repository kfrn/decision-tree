module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree, TreeNode)


type alias Model =
    { decisionTree : DecisionTree TreeNode
    , choices : List (DecisionTree TreeNode)

    -- TODO: choices to be Nonempty List?
    }


init : ( Model, Cmd Msg )
init =
    ( { decisionTree = fullDecisionTree, choices = [ fullDecisionTree ] }
    , Cmd.none
    )
