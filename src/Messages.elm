module Messages exposing (Msg(..))

import Tree.Model exposing (Option)


type Msg
    = FocusChildOption Option
    | FocusNonChildOption Option
    | NoOp
    | Reset
