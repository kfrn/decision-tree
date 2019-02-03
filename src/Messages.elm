module Messages exposing (Msg(..))

import Tree.Model exposing (DecisionTree, TreeNode)


type Msg
    = NoOp
    | SelectOption (DecisionTree TreeNode)
