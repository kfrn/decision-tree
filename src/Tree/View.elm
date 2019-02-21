module Tree.View exposing (renderZipper)

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, classList, src)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Tree.Model exposing (Answer, Option, Question, Tree(..), Zipper)


renderZipper : Zipper -> Html Msg
renderZipper zipper =
    case zipper.focus.tree of
        Branch question options ->
            renderBranch question options

        Leaf answer ->
            renderLeaf answer


renderBranch : Question -> List Option -> Html Msg
renderBranch question options =
    div
        [ class "branch" ]
        [ div [ class "question" ] [ text question ]
        , div [ class "options" ]
            (List.map
                (renderOption <| List.length options)
                (List.indexedMap Tuple.pair options)
            )
        ]


renderOption : Int -> ( Int, Option ) -> Html Msg
renderOption optionsCount ( idx, option ) =
    let
        optionSelected =
            False

        arrow =
            if optionSelected then
                optionArrow idx optionsCount

            else
                div [] []
    in
    div [ class "option" ]
        [ button
            [ classList [ ( "button", True ), ( "is-link", optionSelected ) ]
            , onClick <| FocusChildOption option
            ]
            [ text option.answer ]
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


renderLeaf : Answer -> Html Msg
renderLeaf answer =
    div []
        [ div [ class "leaf" ]
            [ div [] [ text "The answer is:" ]
            , img [ src <| imageUrl answer "jpg" ] []
            , div [ class "has-text-weight-bold answer" ] [ text answer ]
            ]
        , button [ class "button is-link reset", onClick Reset ] [ text "Reset!" ]
        ]


imageUrl : String -> String -> String
imageUrl name extension =
    "%PUBLIC_URL%/images/" ++ name ++ "." ++ extension
