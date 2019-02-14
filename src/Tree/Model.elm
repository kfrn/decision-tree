module Tree.Model exposing (Node(..), Option, Tree(..), findClosestAncestor, setSelectionOn, updateChoices)

import List.Extra as ListX


type Tree a
    = Answer AnswerText
    | Question a


type Node
    = Node QuestionText (List Option)


type alias AnswerText =
    String


type alias QuestionText =
    String


type alias Option =
    { name : String
    , selected : Bool
    , childNode : Tree Node
    }


findClosestAncestor : Tree Node -> List (Tree Node) -> Maybe (Tree Node)
findClosestAncestor currentChoice previousChoices =
    ListX.find (\tree -> isChildOf currentChoice tree) (List.reverse previousChoices)


isChildOf : Tree Node -> Tree Node -> Bool
isChildOf currentChoice previousChoice =
    case previousChoice of
        Question (Node _ previousOptions) ->
            -- TODO: in isChildOf, matching on the question/answer string. Qs should not be repeated in the same path - but maybe use UUIDs?
            List.any
                (\opt -> nodeText opt.childNode == nodeText currentChoice)
                previousOptions

        Answer _ ->
            False


nodeText : Tree Node -> String
nodeText tree =
    case tree of
        Answer answerText ->
            answerText

        Question (Node questionText _) ->
            questionText


updateChoices : Tree Node -> Tree Node -> List (Tree Node) -> List (Tree Node)
updateChoices currentChoice parentChoice existingChoices =
    let
        listHead =
            ListX.takeWhile (\c -> c /= parentChoice) existingChoices
    in
    listHead ++ [ setSelectionOn parentChoice currentChoice, currentChoice ]


setSelectionOn : Tree Node -> Tree Node -> Tree Node
setSelectionOn parentChoice childChoice =
    case parentChoice of
        Question (Node questionText options) ->
            let
                newOptions =
                    List.map (\opt -> setOptionStatus opt childChoice) options
            in
            Question (Node questionText newOptions)

        _ ->
            parentChoice


setOptionStatus : Option -> Tree Node -> Option
setOptionStatus option childTree =
    if option.childNode == childTree then
        { option | selected = True }

    else
        { option | selected = False }
