module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullDecisionTree)
import Tree.Model exposing (DecisionTree, TreeNode)


type alias Model =
    List (DecisionTree TreeNode)


init : ( Model, Cmd Msg )
init =
    ( [ fullDecisionTree ]
    , Cmd.none
    )
