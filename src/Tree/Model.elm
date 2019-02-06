module Tree.Model exposing (DecisionTree(..), Option, TreeNode(..), addChild, findAncestor, isChildOf, setSelection)

import List.Extra as ListX
import Maybe.Extra as MaybeX


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


isChildOf : DecisionTree TreeNode -> DecisionTree TreeNode -> Bool
isChildOf currentChoice previousChoice =
    case previousChoice of
        Question (TreeNode _ previousOptions) ->
            -- TODO: in isChildOf, matching on the question/answer string. Qs should not be repeated in the same path - but use UUIDs?
            MaybeX.isJust <| ListX.find (\opt -> nodeText opt.childNode == nodeText currentChoice) previousOptions

        Answer _ ->
            -- Previous node can't be an answer.
            False


nodeText : DecisionTree TreeNode -> String
nodeText tree =
    case tree of
        Answer answerText ->
            answerText

        Question (TreeNode questionText _) ->
            questionText


addChild : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
addChild currentChoice existingChoices =
    listWithoutTail existingChoices ++ updateParent currentChoice existingChoices ++ [ currentChoice ]


listWithoutTail : List a -> List a
listWithoutTail list =
    -- TODO: utils module?
    case ListX.init list of
        Just head ->
            head

        Nothing ->
            []


updateParent : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
updateParent currentChoice existingChoices =
    -- Marks the chosen option as selected on the parent node of the current tree
    case ListX.last existingChoices of
        Just parentChoice ->
            -- TODO: Maybe.map?
            [ setSelection parentChoice currentChoice ]

        _ ->
            []


findAncestor : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> Maybe (DecisionTree TreeNode)
findAncestor currentChoice previousChoices =
    -- Find the first choice which includes the current choice in its list of options
    ListX.find (\tree -> isChildOf currentChoice tree) previousChoices


setSelection : DecisionTree TreeNode -> DecisionTree TreeNode -> DecisionTree TreeNode
setSelection parentChoice childChoice =
    case parentChoice of
        Question (TreeNode questionText options) ->
            let
                newOptions =
                    List.map (\opt -> optionStatus opt childChoice) options
            in
            Question (TreeNode questionText newOptions)

        _ ->
            -- Not possible for an Answer node to have children!
            parentChoice


optionStatus : Option -> DecisionTree TreeNode -> Option
optionStatus option childTree =
    if option.childNode == childTree then
        { option | selected = True }

    else
        { option | selected = False }
