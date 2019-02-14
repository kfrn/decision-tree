module Tree.View exposing (tree)

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, classList, src)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Tree.Model exposing (Tree(..), Option, Node(..))


tree : Tree Node -> Html Msg
tree decisionTree =
    case decisionTree of
        Answer answerText ->
            div []
                [ div [ class "answer" ]
                    [ div [] [ text "The answer is:" ]
                    , img [ src <| imageUrl answerText "jpg" ] []
                    , div [ class "has-text-weight-bold answer-name" ] [ text answerText ]
                    ]
                , button [ class "button is-link reset", onClick Reset ] [ text "Reset!" ]
                ]

        Question node ->
            renderNode node


imageUrl : String -> String -> String
imageUrl name extension =
    "%PUBLIC_URL%/images/" ++ name ++ "." ++ extension


renderNode : Node -> Html Msg
renderNode (Node questionText options) =
    div
        [ class "tree-node" ]
        [ div [ class "question" ] [ text questionText ]
        , div [ class "options" ]
            (List.map (renderOption (List.length options)) (List.indexedMap Tuple.pair options))
        ]


renderOption : Int -> ( Int, Option ) -> Html Msg
renderOption optionsCount ( idx, option ) =
    let
        arrow =
            if option.selected == True then
                optionArrow idx optionsCount

            else
                div [] []
    in
    div [ class "option" ]
        [ button
            [ classList [ ( "button", True ), ( "is-link", option.selected == True ) ]
            , onClick <| SelectOption option.childNode
            ]
            [ text option.name ]
        , arrow
        ]


optionArrow : Int -> Int -> Html Msg
optionArrow optionIdx optionsCount =
    let
        imageName =
            if optionIdx == 0 then
                "arrow_left-down"

            else if optionsCount == (optionIdx + 1) then
                "arrow_right-down"

            else
                "arrow_down"
    in
    div [ class "arrow" ]
        [ img [ src <| imageUrl imageName "svg" ] []
        ]
