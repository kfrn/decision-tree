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
    -- TODO: here and elsewhere, matching on questionText. What if the same Q is repeated in different places in the tree? -> Use UUIDs?
    case ( currentChoice, previousChoice ) of
        ( Question (TreeNode currentQuestion _), Question previousTreeNode ) ->
            let
                (TreeNode _ previousOptions) =
                    previousTreeNode
            in
            MaybeX.isJust <| ListX.find (\opt -> questionText opt.childNode == Just currentQuestion) previousOptions

        ( Answer answerText, Question treeNode ) ->
            -- TODO - Is this actually a possible case? Check.
            let
                (TreeNode _ options) =
                    treeNode
            in
            MaybeX.isJust <| ListX.find (\opt -> opt.childNode == Answer answerText) options

        _ ->
            -- Previous node can't be an answer.
            False


questionText : DecisionTree TreeNode -> Maybe QuestionText
questionText decisionTree =
    case decisionTree of
        Question (TreeNode text _) ->
            Just text

        _ ->
            Nothing


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
findAncestor currentChoice existingChoices =
    case currentChoice of
        Question (TreeNode currentQuestion _) ->
            ListX.find (isChildQuestion currentQuestion) existingChoices

        Answer answerText ->
            ListX.find (isChildOptionText answerText) existingChoices


isChildOptionText : String -> DecisionTree TreeNode -> Bool
isChildOptionText text tree =
    case tree of
        Question (TreeNode _ options) ->
            List.any (\childTree -> treeText childTree == text) (List.map .childNode options)

        _ ->
            False


treeText : DecisionTree TreeNode -> String
treeText tree =
    case tree of
        Answer answerText ->
            answerText

        Question (TreeNode qText _) ->
            qText


isChildQuestion : QuestionText -> DecisionTree TreeNode -> Bool
isChildQuestion qText tree =
    case tree of
        Question (TreeNode _ options) ->
            List.any (\childTree -> questionText childTree == Just qText) (List.map .childNode options)

        _ ->
            False
