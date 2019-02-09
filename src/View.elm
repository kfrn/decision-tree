module View exposing (view)

import Html exposing (Html, a, code, div, footer, h1, text)
import Html.Attributes exposing (href, id)
import Messages exposing (Msg)
import Model exposing (Model)
import Tree.View exposing (tree)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "what fruit does the decision tree hold?" ]
        , a [ href "https://github.com/kfrn/decision-tree" ] [ code [] [ text "(source code!)" ] ]
        , div [ id "tree" ]
            (List.map tree model)
        ]
