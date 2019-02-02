module Tree.Model exposing (DecisionTree(..), Option(..), TreeNode(..), tree)


type DecisionTree a
    = Answer AnswerText
    | Question a


type TreeNode
    = TreeNode QuestionText Option Option


type alias QuestionText =
    String


type alias AnswerText =
    String


type Option
    = Option OptionText (DecisionTree TreeNode)


type alias OptionText =
    String


tree : DecisionTree TreeNode
tree =
    Question
        (TreeNode "Is it a melon?"
            (Option "yes"
                (Question
                    (TreeNode "What colour is it?"
                        (Option "pink" <| Answer "Watermelon")
                        (Option "orange" <| Answer "Rockmelon")
                    )
                )
            )
            (Option "no"
                (Question
                    (TreeNode "Is it a banana?"
                        (Option "yes" <| Answer "Banana")
                        (Option "no" <| Answer "Mango")
                    )
                )
            )
        )
