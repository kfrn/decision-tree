module Tree.Model exposing (DecisionTree(..), Option, TreeNode(..), findClosestAncestor, setSelectionOn, updateChoices)

import List.Extra as ListX


type DecisionTree a
    = Answer AnswerText
    | Question a


type TreeNode
    = TreeNode QuestionText (List Option)


type alias AnswerText =
    String


type alias QuestionText =
    String


type alias Option =
    { name : String
    , selected : Bool
    , childNode : DecisionTree TreeNode
    }


findClosestAncestor : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> Maybe (DecisionTree TreeNode)
findClosestAncestor currentChoice previousChoices =
    ListX.find (\tree -> isChildOf currentChoice tree) (List.reverse previousChoices)


isChildOf : DecisionTree TreeNode -> DecisionTree TreeNode -> Bool
isChildOf currentChoice previousChoice =
    case previousChoice of
        Question (TreeNode _ previousOptions) ->
            -- TODO: in isChildOf, matching on the question/answer string. Qs should not be repeated in the same path - but maybe use UUIDs?
            List.any
                (\opt -> nodeText opt.childNode == nodeText currentChoice)
                previousOptions

        Answer _ ->
            False


nodeText : DecisionTree TreeNode -> String
nodeText tree =
    case tree of
        Answer answerText ->
            answerText

        Question (TreeNode questionText _) ->
            questionText


updateChoices : DecisionTree TreeNode -> DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
updateChoices currentChoice parentChoice existingChoices =
    let
        listHead =
            ListX.takeWhile (\c -> c /= parentChoice) existingChoices
    in
    listHead ++ [ setSelectionOn parentChoice currentChoice, currentChoice ]


setSelectionOn : DecisionTree TreeNode -> DecisionTree TreeNode -> DecisionTree TreeNode
setSelectionOn parentChoice childChoice =
    case parentChoice of
        Question (TreeNode questionText options) ->
            let
                newOptions =
                    List.map (\opt -> setOptionStatus opt childChoice) options
            in
            Question (TreeNode questionText newOptions)

        _ ->
            parentChoice


setOptionStatus : Option -> DecisionTree TreeNode -> Option
setOptionStatus option childTree =
    if option.childNode == childTree then
        { option | selected = True }

    else
        { option | selected = False }
