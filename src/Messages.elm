module Messages exposing (Msg(..))

import Tree.Model exposing (Tree, Node)


type Msg
    = NoOp
    | SelectOption (Tree Node)
    | Reset
