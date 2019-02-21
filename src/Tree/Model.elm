module Tree.Model exposing (Answer, Breadcrumb, Option, Question, Tree(..), Zipper, focusChildOption)

import List.Extra as ListX


type Tree
    = Leaf FinalAnswer
    | Branch Question (List Option)


type alias Option =
    { answer : Answer
    , tree : Tree
    }


type alias FinalAnswer =
    String


type alias Question =
    String


type alias Answer =
    String


type alias Zipper =
    { focus : Option
    , breadcrumbs : List Breadcrumb
    }


type alias Breadcrumb =
    { previousChoice : ( Question, Answer )
    , leftSiblings : List Option
    , rightSiblings : List Option
    }


focusChildOption : Option -> Zipper -> Zipper
focusChildOption currentChoice zipper =
    let
        ( leftSiblings, rightSiblings ) =
            case zipper.focus.tree of
                Branch _ options ->
                    ( takeUntil options currentChoice.tree, takeAfter options currentChoice.tree )

                _ ->
                    ( [], [] )

        crumb =
            { previousChoice = ( treeText zipper.focus.tree, currentChoice.answer )
            , leftSiblings = leftSiblings
            , rightSiblings = rightSiblings
            }
    in
    { zipper
        | focus = currentChoice
        , breadcrumbs = crumb :: zipper.breadcrumbs
    }


treeText : Tree -> String
treeText tree =
    case tree of
        Branch question _ ->
            question

        Leaf answer ->
            answer


takeUntil : List Option -> Tree -> List Option
takeUntil options tree =
    ListX.takeWhile (\opt -> opt.tree /= tree) options


takeAfter : List Option -> Tree -> List Option
takeAfter options tree =
    takeUntil (List.reverse options) tree
        |> List.reverse
