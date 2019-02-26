module Tree.Model exposing (Answer, Breadcrumb, Option, Question, Tree(..), Zipper, focusChildOption, focusNonChildOption, rebuildParent)

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
    { answer : Answer
    , question : Question
    , leftOptions : List Option
    , rightOptions : List Option
    }


focusChildOption : Option -> Zipper -> Zipper
focusChildOption choice zipper =
    let
        ( leftOptions, rightOptions ) =
            case zipper.focus.tree of
                Branch _ options ->
                    ( takeUntil options choice.tree, takeAfter options choice.tree )

                _ ->
                    ( [], [] )

        crumb =
            { answer = zipper.focus.answer
            , question = treeText zipper.focus.tree
            , leftOptions = leftOptions
            , rightOptions = rightOptions
            }
    in
    { zipper | focus = choice, breadcrumbs = crumb :: zipper.breadcrumbs }


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
    ListX.takeWhileRight (\opt -> opt.tree /= tree) options


focusNonChildOption : Option -> Zipper -> Zipper
focusNonChildOption choice zipper =
    let
        ancestorBreadcrumbs =
            ListX.takeWhileRight (\crumb -> not <| optionInBreadcrumb choice crumb) zipper.breadcrumbs

        breadcrumbstoCollapse =
            ListX.filterNot (\crumb -> List.member crumb ancestorBreadcrumbs) zipper.breadcrumbs

        newBreadcrumbs =
            case collapseBreadcrumbs breadcrumbstoCollapse zipper.focus choice of
                Just crumb ->
                    crumb :: ancestorBreadcrumbs

                Nothing ->
                    []
    in
    { zipper | focus = choice, breadcrumbs = newBreadcrumbs }


optionInBreadcrumb : Option -> Breadcrumb -> Bool
optionInBreadcrumb option crumb =
    List.member option (crumb.leftOptions ++ crumb.rightOptions)


collapseBreadcrumbs : List Breadcrumb -> Option -> Option -> Maybe Breadcrumb
collapseBreadcrumbs breadcrumbs previousFocus choice =
    let
        ( butLast, last ) =
            ( ListX.init breadcrumbs, ListX.last breadcrumbs )
    in
    case ( butLast, last ) of
        ( Just [], Just crumb ) ->
            Just <| buildBreadcrumb previousFocus choice crumb

        ( Just crumbs, Just crumb ) ->
            let
                newFocus =
                    List.foldl rebuildParent previousFocus crumbs
            in
            Just <| buildBreadcrumb newFocus choice crumb

        _ ->
            Nothing


rebuildParent : Breadcrumb -> Option -> Option
rebuildParent crumb currentFocus =
    let
        options =
            crumb.leftOptions ++ currentFocus :: crumb.rightOptions

        tree =
            Branch crumb.question options
    in
    { answer = crumb.answer
    , tree = tree
    }


buildBreadcrumb : Option -> Option -> Breadcrumb -> Breadcrumb
buildBreadcrumb previousFocus choice crumb =
    let
        ( leftOptions, rightOptions ) =
            if List.member choice crumb.leftOptions then
                ( ListX.remove choice crumb.leftOptions, previousFocus :: crumb.rightOptions )

            else
                ( crumb.leftOptions ++ [ previousFocus ], ListX.remove choice crumb.rightOptions )
    in
    { crumb
        | leftOptions = leftOptions
        , rightOptions = rightOptions
        , question = crumb.question
    }
