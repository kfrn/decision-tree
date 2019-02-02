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
        (TreeNode "What shape is it?"
            (Option "round(ish)"
                (Question
                    (TreeNode "Citric or stone fruit?"
                        (Option "stone fruit"
                            (Question
                                (TreeNode "Is it dark-coloured?"
                                    (Option "yes" <| Answer "plum")
                                    (Option "no"
                                        (Question
                                            (TreeNode "Is it big or small?"
                                                (Option "big" <| Answer "peach")
                                                (Option "small" <| Answer "apricot")
                                            )
                                        )
                                    )
                                )
                            )
                        )
                        (Option "citric" <| Answer "grapefruit")
                    )
                )
            )
            (Option "something else"
                (Question
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
                )
            )
        )
