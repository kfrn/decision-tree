module Tree.Model exposing (DecisionTree(..), Option, TreeNode(..), addChild, findAncestor, isChildOf)

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
            -- TODO: in isChildOf, matching on the question/answer string - what if the same question is repeated in different parts of the tree?
            MaybeX.isJust <| ListX.find (\opt -> nodeText opt.childNode == nodeText currentChoice) previousOptions

        Answer _ ->
            -- Previous node can't be an answer.
            False


nodeText : DecisionTree TreeNode -> String
nodeText tree =
    case tree of
        Answer answerText ->
            answerText

        Question (TreeNode qText _) ->
            qText


addChild : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
addChild currentChoice existingChoices =
    listWithoutTail existingChoices ++ updateParent currentChoice existingChoices ++ [ currentChoice ]


listWithoutTail : List a -> List a
listWithoutTail list =
    case ListX.init list of
        Just head ->
            head

        Nothing ->
            []


updateParent : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> List (DecisionTree TreeNode)
updateParent currentChoice existingChoices =
    -- Marks the chosen option as selected on the parent node of the current tree
    case ListX.last existingChoices of
        Just (Question (TreeNode qText options)) ->
            let
                markSelection option =
                    if option.childNode == currentChoice then
                        { option | selected = True }

                    else
                        { option | selected = False }

                newOptions =
                    List.map markSelection options
            in
            [ Question (TreeNode qText newOptions) ]

        _ ->
            []


findAncestor : DecisionTree TreeNode -> List (DecisionTree TreeNode) -> Maybe (DecisionTree TreeNode)
findAncestor currentChoice previousChoices =
    -- Find the first choice which includes the current choice in its list of options
    ListX.find (\tree -> isChildOf currentChoice tree) previousChoices
