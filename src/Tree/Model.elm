module Tree.Model exposing (Answer, Breadcrumb, Option, Question, Tree(..), Zipper, focusChildOption, focusNonChildOption, reconstruct)

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
                    ( ListX.takeWhile (\opt -> opt.tree /= choice.tree) options
                    , ListX.takeWhileRight (\opt -> opt.tree /= choice.tree) options
                    )

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


focusNonChildOption : Option -> Zipper -> Zipper
focusNonChildOption choice zipper =
    let
        newCrumbs =
            case partitionBreadcrumbs choice zipper.breadcrumbs of
                ( crumbsToCollapse, Just crumbToRebuild, ancestorBreadcrumbs ) ->
                    let
                        newFocus =
                            List.foldl reconstruct zipper.focus crumbsToCollapse
                    in
                    buildBreadcrumb newFocus choice crumbToRebuild :: ancestorBreadcrumbs

                _ ->
                    []
    in
    { zipper | focus = choice, breadcrumbs = newCrumbs }


partitionBreadcrumbs : Option -> List Breadcrumb -> ( List Breadcrumb, Maybe Breadcrumb, List Breadcrumb )
partitionBreadcrumbs choice breadcrumbs =
    let
        inBreadcrumb crumb =
            List.member choice (crumb.leftOptions ++ crumb.rightOptions)
    in
    ( ListX.takeWhile (\crumb -> not <| inBreadcrumb crumb) breadcrumbs
    , ListX.find (\crumb -> inBreadcrumb crumb) breadcrumbs
    , ListX.takeWhileRight (\crumb -> not <| inBreadcrumb crumb) breadcrumbs
    )


reconstruct : Breadcrumb -> Option -> Option
reconstruct crumb currentFocus =
    { answer = crumb.answer
    , tree = Branch crumb.question (crumb.leftOptions ++ currentFocus :: crumb.rightOptions)
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
