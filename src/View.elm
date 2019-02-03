module View exposing (view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (id)
import Messages exposing (Msg)
import Model exposing (Model)
import Tree.View exposing (tree)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Welcome to the fruitbowl" ]
        , div [ id "tree" ]
            (List.map tree model.nodes)
        ]
