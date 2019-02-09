module Tests exposing (all)

import Expect
import Messages exposing (Msg(..))
import Test exposing (..)
import Tree.Model exposing (DecisionTree(..), TreeNode(..), findAncestor, isChildOf, setSelectionOn)
import Update exposing (update)


all : Test
all =
    describe "Decision Tree" <|
        let
            childTree =
                Answer "child answer"

            parentTree =
                Question (TreeNode "parent question text" [ { name = "parent option", selected = False, childNode = childTree } ])

            parentTreeSelected =
                Question (TreeNode "parent question text" [ { name = "parent option", selected = True, childNode = childTree } ])

            grandparentTree =
                Question
                    (TreeNode "question text"
                        [ { name = "option"
                          , selected = False
                          , childNode = parentTree
                          }
                        ]
                    )

            grandparentTreeSelected =
                Question
                    (TreeNode "question text"
                        [ { name = "option"
                          , selected = True
                          , childNode = parentTree
                          }
                        ]
                    )
        in
        [ describe "isChildOf" <|
            [ describe "when there is a parent-child relationship" <|
                [ test "it returns true" <|
                    \_ ->
                        Expect.equal True (isChildOf childTree parentTree)
                ]
            , describe "when the treenode is an indirect descendent" <|
                [ test "it returns false" <|
                    \_ ->
                        Expect.equal False (isChildOf grandparentTree childTree)
                ]
            , describe "when the tree nodes are unrelated" <|
                let
                    tree =
                        Question (TreeNode "question text" [ { name = "option", selected = False, childNode = Answer "some answer" } ])
                in
                [ test "it returns false" <|
                    \_ ->
                        Expect.equal False (isChildOf childTree tree)
                ]
            ]
        , describe "setSelectionOn" <|
            [ describe "when the first tree contains the second tree" <|
                [ test "the option in the first tree containing the second tree is set as selected" <|
                    \_ -> Expect.equal parentTreeSelected (setSelectionOn parentTree childTree)
                ]
            , describe "when the first tree does not contain the second tree" <|
                [ test "No option in the first tree is set as selected" <|
                    \_ -> Expect.equal parentTree (setSelectionOn parentTree (Answer "some answer"))
                ]
            ]
        , describe "findAncestor" <|
            [ describe "when searching for the ancestor of the child tree" <|
                [ test "it returns the parent" <|
                    \_ -> Expect.equal (Just parentTree) (findAncestor childTree [ parentTree ])
                ]
            , describe "when searching for the ancestor of the parent tree" <|
                [ test "it returns the grandparent tree" <|
                    \_ -> Expect.equal (Just grandparentTree) (findAncestor parentTree [ grandparentTree, parentTree ])
                ]
            , describe "when searching for the ancestor of the grandparent tree" <|
                [ test "it returns Nothing" <|
                    \_ -> Expect.equal Nothing (findAncestor grandparentTree [ grandparentTree, parentTree ])
                ]
            ]
        , describe "SelectOption" <|
            [ describe "when choosing a direct child of the most recent choice" <|
                [ test "the child tree is stored as a choice, and the parent tree is selected" <|
                    let
                        initialModel =
                            [ parentTree ]

                        expectedModel =
                            [ parentTreeSelected, childTree ]
                    in
                    \_ -> Expect.equal ( expectedModel, Cmd.none ) (update (SelectOption childTree) initialModel)
                ]
            , describe "when choosing an ancestor node of the most recent choice" <|
                [ test "the tree is 'reset' to the current choice, with the parent of that ancestor set to selected" <|
                    let
                        initialModel =
                            [ grandparentTree, parentTree, childTree ]

                        expectedModel =
                            [ grandparentTreeSelected, parentTree ]
                    in
                    \_ -> Expect.equal ( expectedModel, Cmd.none ) (update (SelectOption parentTree) initialModel)
                ]
            ]
        ]
