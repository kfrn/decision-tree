module Tests exposing (all)

import Expect
import Test exposing (..)
import Tree.Model exposing (Option(..), Tree(..), updateZipper)


all : Test
all =
    describe "Decision Tree" <|
        let
            grandChildTree1 =
                Leaf "first grandchild final answer"

            grandChildTree2 =
                Leaf "second grandchild final answer"

            childTree1 =
                Branch "first child question"
                    [ Option "first child answer" grandChildTree1 ]

            childTree2 =
                Branch "second child question"
                    [ Option "second child answer" grandChildTree2 ]

            parentOption1 =
                Option "parent first answer" childTree1

            parentOption2 =
                Option "parent second answer" childTree2

            parentTree =
                Branch "parent question" [ parentOption1, parentOption2 ]
        in
        [ describe "updateZipper" <|
            [ describe "at the parent tree, choose the first child tree" <|
                let
                    zipper =
                        { focus = parentTree
                        , breadcrumbs = []
                        , leftSiblings = []
                        , rightSiblings = []
                        }

                    newZipper =
                        updateZipper childTree1 zipper
                in
                [ test "it focuses the first child tree" <|
                    \_ -> Expect.equal newZipper.focus childTree1
                , test "nothing is added to the leftSiblings field" <|
                    \_ -> Expect.equal newZipper.leftSiblings []
                , test "it adds the second Option to the rightSiblings field" <|
                    \_ -> Expect.equal newZipper.rightSiblings [ parentOption2 ]
                , test "it adds a breadcrumb with the parent tree information to the breadcrumbs field" <|
                    let
                        crumb =
                            { question = "parent question"
                            , leftSiblings = []
                            , rightSiblings = []
                            }
                    in
                    \_ -> Expect.equal newZipper.breadcrumbs [ crumb ]
                ]
            ]
        ]
