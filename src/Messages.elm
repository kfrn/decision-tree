module Messages exposing (Msg(..))

import Tree.Model exposing (Option)


type Msg
    = NoOp
    | Reset
    | FocusChildOption Option
