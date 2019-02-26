module Tests exposing (all)

import Expect
import List.Extra as ListX
import Test exposing (..)
import Tree.Model exposing (Option, Tree(..), focusChildOption, focusNonChildOption, rebuildParent)


all : Test
all =
    describe "Decision Tree" <|
        let
            startOption =
                { answer = "start"
                , tree = tree
                }

            tree =
                Branch "is it native or foreign?" [ nativeOption, foreignOption ]

            nativeOption =
                { answer = "native"
                , tree =
                    Branch "do tuis like it?" [ kowhaiOption, rimuOption, flaxOption ]
                }

            foreignOption =
                { answer = "foreign"
                , tree =
                    Branch "Does it have fruit?"
                        [ { answer = "yes", tree = Leaf "apple tree" }
                        , { answer = "no", tree = Leaf "oak tree" }
                        ]
                }

            kowhaiOption =
                { answer = "yes", tree = Leaf "kowhai" }

            rimuOption =
                { answer = "no", tree = Leaf "rimu" }

            flaxOption =
                { answer = "maybe", tree = Leaf "flax" }

            initialZipper =
                { focus = startOption
                , breadcrumbs = []
                }
        in
        [ describe "focusChildOption" <|
            [ describe "Top-level choice" <|
                [ describe "Ts it native or foreign? -> native" <|
                    let
                        newZipper =
                            focusChildOption nativeOption initialZipper
                    in
                    [ test "it focuses the native tree option" <|
                        \_ -> Expect.equal newZipper.focus nativeOption
                    , test "it adds a breadcrumb with the question, and the foreignOption added to the rightOptions field" <|
                        let
                            crumb =
                                { answer = "start"
                                , question = "is it native or foreign?"
                                , leftOptions = []
                                , rightOptions = [ foreignOption ]
                                }
                        in
                        \_ -> Expect.equal newZipper.breadcrumbs [ crumb ]
                    ]
                ]
            , describe "Second-level choice" <|
                [ describe "Native tree. Do tuis like it? -> no" <|
                    let
                        newZipper =
                            focusChildOption nativeOption initialZipper
                                |> focusChildOption rimuOption
                    in
                    [ test "it focuses the first grandchild tree" <|
                        \_ -> Expect.equal newZipper.focus rimuOption
                    , test "it adds a breadcrumb to the breadcrumbs field" <|
                        \_ -> Expect.equal (List.length newZipper.breadcrumbs) 2
                    , test "the new breadcrumb includes the question, and the sibling options of the choice" <|
                        let
                            crumb =
                                { answer = "native"
                                , question = "do tuis like it?"
                                , leftOptions = [ kowhaiOption ]
                                , rightOptions = [ flaxOption ]
                                }
                        in
                        \_ -> Expect.equal (List.head newZipper.breadcrumbs) (Just crumb)
                    ]
                ]
            ]
        , describe "focusNonChildOption" <|
            let
                currentZipper =
                    focusChildOption nativeOption initialZipper
                        |> focusChildOption rimuOption
            in
            [ describe "focusing a sibling of the current focus" <|
                let
                    newZipper =
                        focusNonChildOption flaxOption currentZipper
                in
                [ test "it focuses that option" <|
                    \_ -> Expect.equal newZipper.focus flaxOption
                , test "the number of breadcrumbs is the same" <|
                    \_ -> Expect.equal (List.length newZipper.breadcrumbs) (List.length currentZipper.breadcrumbs)
                , test "the breadcrumbs are updated to reflect the new focus" <|
                    let
                        newBreadcrumbs =
                            [ { answer = "native"
                              , question = "do tuis like it?"
                              , leftOptions = [ kowhaiOption, rimuOption ]
                              , rightOptions = []
                              }
                            , { answer = "start"
                              , question = "is it native or foreign?"
                              , leftOptions = []
                              , rightOptions = [ foreignOption ]
                              }
                            ]
                    in
                    \_ -> Expect.equal newZipper.breadcrumbs newBreadcrumbs
                ]
            , describe "focusing an 'aunt' option of the current focus" <|
                let
                    newZipper =
                        focusNonChildOption foreignOption currentZipper
                in
                [ test "it focuses that option" <|
                    \_ -> Expect.equal newZipper.focus foreignOption
                , test "the number of breadcrumbs is decreased by one" <|
                    \_ -> Expect.equal (List.length newZipper.breadcrumbs) (List.length currentZipper.breadcrumbs - 1)
                , test "the breadcrumbs are updated to reflect the new focus" <|
                    let
                        newBreadcrumbs =
                            [ { answer = "start"
                              , question = "is it native or foreign?"
                              , leftOptions = [ nativeOption ]
                              , rightOptions = []
                              }
                            ]
                    in
                    \_ -> Expect.equal newZipper.breadcrumbs newBreadcrumbs
                ]
            ]
        , describe "rebuildParent" <|
            [ describe "given a current focus and the breadcrumb of its parent context" <|
                let
                    breadcrumb =
                        { answer = "native"
                        , question = "do tuis like it?"
                        , leftOptions = [ kowhaiOption, rimuOption ]
                        , rightOptions = []
                        }
                in
                [ test "it rebuilds that parent option" <|
                    \_ -> Expect.equal (rebuildParent breadcrumb flaxOption) nativeOption
                ]
            ]
        ]
