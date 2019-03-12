module Tree.View exposing (renderZipper)

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, id, src)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Tree.Model exposing (Answer, Breadcrumb, Option, Question, Tree(..), Zipper)


renderZipper : Zipper -> Html Msg
renderZipper zipper =
    div [ id "zipper" ]
        [ div [ class "breadcrumbs" ] (List.map renderBreadcrumb <| List.reverse zipper.breadcrumbs)
        , div [ class "focus" ] [ renderTree zipper.focus.tree ]
        ]


renderBreadcrumb : Breadcrumb -> Html Msg
renderBreadcrumb crumb =
    div [ class "crumb" ]
        [ renderQuestion crumb.question
        , renderOptions crumb crumb.answer
        ]


renderQuestion : Question -> Html Msg
renderQuestion question =
    div [ class "question" ] [ text question ]


renderOptions : Breadcrumb -> Answer -> Html Msg
renderOptions crumb answer =
    let
        chosenOption =
            div [ class "choice" ]
                [ button [ class "button is-primary option" ] [ text answer ]
                , arrow crumb
                ]
    in
    div [ class "options" ]
        (List.map (renderOption FocusNonChildOption) crumb.leftOptions
            ++ chosenOption
            :: List.map (renderOption FocusNonChildOption) crumb.rightOptions
        )


arrow : Breadcrumb -> Html Msg
arrow crumb =
    let
        leftOptionCount =
            List.length crumb.leftOptions

        rightOptionCount =
            List.length crumb.rightOptions

        arrowImage =
            if leftOptionCount == 0 then
                "arrow_left-down"

            else if rightOptionCount == 0 then
                "arrow_right-down"

            else
                "arrow_down"
    in
    div [ class "arrow" ]
        [ img [ src <| imageUrl arrowImage "svg" ] [] ]


renderOption : (Option -> Msg) -> Option -> Html Msg
renderOption msg option =
    button
        [ class "button option", onClick <| msg option ]
        [ text option.answer ]


renderTree : Tree -> Html Msg
renderTree tree =
    case tree of
        Branch question options ->
            renderBranch question options

        Leaf answer ->
            renderLeaf answer


renderBranch : Question -> List Option -> Html Msg
renderBranch question options =
    div [ class "branch" ]
        [ renderQuestion question
        , div [ class "options" ] (List.map (renderOption FocusChildOption) options)
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
