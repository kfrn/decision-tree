module Tree.Data exposing (fullTree)

import Tree.Model exposing (Option(..), Tree(..))


fullTree : Tree
fullTree =
    Branch "Is it an exotic fruit?"
        [ Option "no"
            (Branch "Is it citric or stone fruit?"
                [ Option "citric" citricBranch
                , Option "stone fruit" stoneFruitBranch
                ]
            )
        , Option "yes"
            (Branch "Is it a melon?"
                [ Option "yes" melonBranch
                , Option "no" bananaBranch
                ]
            )
        ]


citricBranch : Tree
citricBranch =
    Branch "Green or orange?"
        [ Option "green"
            (Branch "Big or small?"
                [ Option "big" (Leaf "grapefruit")
                , Option "small" (Leaf "lime")
                ]
            )
        , Option "orange"
            (Branch "Big or small?"
                [ Option "big" (Leaf "orange")
                , Option "small" (Leaf "mandarin")
                ]
            )
        ]


stoneFruitBranch : Tree
stoneFruitBranch =
    Branch "Is it dark-coloured?"
        [ Option "yes" (Leaf "plum")
        , Option "no"
            (Branch "Is it big or small?"
                [ Option "big" (Leaf "peach")
                , Option "small" (Leaf "plum")
                ]
            )
        ]


melonBranch : Tree
melonBranch =
    Branch "What colour is it?"
        [ Option "pink" (Leaf "watermelon")
        , Option "orange" (Leaf "rockmelon")
        , Option "green" (Leaf "honeydew")
        ]


bananaBranch : Tree
bananaBranch =
    Branch "Is it a banana?"
        [ Option "yes" (Leaf "banana")
        , Option "no" (Leaf "mango")
        ]
