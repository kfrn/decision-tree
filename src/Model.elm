module Model exposing (Model, init)

import Messages exposing (Msg)


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )
