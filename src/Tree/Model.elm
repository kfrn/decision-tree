module Tree.Model exposing (Answer, Option(..), Question, Tree(..), Zipper, updateZipper)

import List.Extra as ListX


type Tree
    = Leaf FinalAnswer
    | Branch Question (List Option)


type Option
    = Option Answer Tree


type alias FinalAnswer =
    String


type alias Question =
    String


type alias Answer =
    String


type alias Zipper =
    { focus : Tree
    , breadcrumbs : List Breadcrumb
    , leftSiblings : List Option
    , rightSiblings : List Option
    }


type alias Breadcrumb =
    { question : Question
    , leftSiblings : List Option
    , rightSiblings : List Option
    }


updateZipper : Tree -> Zipper -> Zipper
updateZipper currentChoice zipper =
    let
        ( leftSiblings, question, rightSiblings ) =
            case zipper.focus of
                Branch questionText options ->
                    ( takeUntil options currentChoice, questionText, takeAfter options currentChoice )

                _ ->
                    ( [], "", [] )

        crumb =
            { question = question
            , leftSiblings = zipper.leftSiblings
            , rightSiblings = zipper.rightSiblings
            }
    in
    { zipper
        | focus = currentChoice
        , leftSiblings = leftSiblings
        , rightSiblings = rightSiblings
        , breadcrumbs = crumb :: zipper.breadcrumbs
    }


takeUntil : List Option -> Tree -> List Option
takeUntil options tree =
    ListX.takeWhile (\(Option _ t) -> t /= tree) options


takeAfter : List Option -> Tree -> List Option
takeAfter options tree =
    takeUntil (List.reverse options) tree
        |> List.reverse
