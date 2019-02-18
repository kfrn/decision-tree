module Messages exposing (Msg(..))

import Tree.Model exposing (Tree)


type Msg
    = NoOp
    | Reset
    | SelectOption Tree
