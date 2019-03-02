# decision-tree

This is a proof-of-concept for a decision tree that the user can click through, making choices until they reach a final answer.  
Below, you can find my pen-and-paper representation, or see it live [here](https://kfrn.github.io/decision-tree)!

## Data structures

I made this project in large part because I wanted to learn more about working with tree structures.

### A tree by any other name would smell as sweet ... 🌹🌹🌹

My tree is a rose tree, AKA multi-way tree: a tree that has a variable amount of choices per branch.

```
        B
     ↙     ↘
   B         B
 ↙ ↓ ↘      ↙ ↘
L  L  L    B   L
         ↙ ↓ ↘
        L  L  L
```

### Zippers 🤐

In pure functional programming languages, a zipper is a technique for conveniently traversing a recursive data structure. They're a general concept, but mostly applied to trees.  
Essentially, when moving through a tree you store the current tree node (branch or leaf) that you're at, plus a series of steps (‘breadcrumbs’) of how you got there. Each breadcrumb represents a level of the tree you passed through. It holds the other possible choices at that level - i.e., the roads not taken - and your actual choice is like a ‘hole’ in that list of possible choices.  
For me it was easiest to understand this by diagramming it on paper.

Here are some resources about trees and zippers that I found useful:

* [Zippers](https://learnyouanelm.github.io/pages/14-zippers.html) (Learn You an Elm)
* [Haskell/Zippers](https://en.wikibooks.org/wiki/Haskell/Zippers), using the story of Theseus and Minotaur (WikiBooks)
* [`elm-rosetree`](https://github.com/zwilias/elm-rosetree) (zwilias), and [demo on Ellie](https://ellie-app.com/4LrNKhjdvkJa1)

## Local setup

### Dependencies

* [Elm `0.19`](https://guide.elm-lang.org/install.html)
* Node.js and `npm`
* [`create-elm-app`](https://github.com/halfzebra/create-elm-app)

### To run locally

```bash
git clone git@github.com:kfrn/decision-tree.git
cd decision-tree/
npm install
npm run build-css
elm-app start
```

## Tests

```bash
elm-app test
```

<!-- To deploy to github pages:
```
elm-app build
gh-pages -d build
```
-->

## Paper programming

![decision tree](./decision-tree.jpg)

## Credit

[Curved arrow](https://thenounproject.com/StarAndAnchor/collection/rounded-arrows/?i=546316) by Star and Anchor Design from the Noun Project.
