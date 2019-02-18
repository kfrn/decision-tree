module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullTree)
import Tree.Model exposing (Tree)


type alias Model =
    List Tree


init : ( Model, Cmd Msg )
init =
    ( [ fullTree ]
    , Cmd.none
    )
