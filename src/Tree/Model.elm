module Tree.Model exposing (Answer, Option(..), Question, Tree(..), findClosestAncestor, updateChoices)

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


findClosestAncestor : Tree -> List Tree -> Maybe Tree
findClosestAncestor currentChoice previousChoices =
    ListX.find (\tree -> isChildOf currentChoice tree) (List.reverse previousChoices)


isChildOf : Tree -> Tree -> Bool
isChildOf currentChoice previousChoice =
    case previousChoice of
        Branch _ previousOptions ->
            List.any
                (\(Option _ tree) -> treeText tree == treeText currentChoice)
                previousOptions

        Leaf _ ->
            False


treeText : Tree -> String
treeText tree =
    case tree of
        Leaf answerText ->
            answerText

        Branch questionText _ ->
            questionText


updateChoices : Tree -> Tree -> List Tree -> List Tree
updateChoices currentChoice parentChoice existingChoices =
    let
        listHead =
            ListX.takeWhile (\c -> c /= parentChoice) existingChoices
    in
    listHead ++ [ parentChoice, currentChoice ]
