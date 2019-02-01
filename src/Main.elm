module Main exposing (main)

import Browser
import Messages exposing (Msg)
import Model exposing (Model, init)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
