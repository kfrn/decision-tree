module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullTree)
import Tree.Model exposing (Node, Tree)


type alias Model =
    List (Tree Node)


init : ( Model, Cmd Msg )
init =
    ( [ fullTree ]
    , Cmd.none
    )
