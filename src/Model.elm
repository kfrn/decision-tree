module Model exposing (Model, init)

import Messages exposing (Msg)
import Tree.Data exposing (fullTree)
import Tree.Model exposing (Zipper)


type alias Model =
    Zipper


init : ( Model, Cmd Msg )
init =
    ( { focus = { answer = "start", tree = fullTree }
      , breadcrumbs = []
      }
    , Cmd.none
    )
