# purescript-simple-repl [![Build Status](https://travis-ci.org/Thimoteus/purescript-simple-repl.svg?branch=master)](https://travis-ci.org/Thimoteus/purescript-simple-repl)

*If it doesn't work, try throwing Aff at it*

# Usage

By example:

```purescript
import Node.ReadLine (READLINE)
import Node.SimpleRepl (setPrompt, close, readLine, runRepl, putStrLn)

main :: forall e. Eff (console :: CONSOLE, readline :: READLINE | e) Unit
main = runRepl do
  setPrompt "> "
  putStrLn "THE DRAMATIC REPL"
  putStrLn ":Q TO QUIT"
  loop
  where
    loop = do
      res <- readLine
      case res of
           ":q" -> close
           ":Q" -> close
           _ -> do
             putStrLn $ toUpper res <> "!!!"
             loop
```

The main draw of this library is the `readLine :: forall e. Repl e String`
function.

The point was to make it possible to do something akin to Haskell's
`getLine :: IO String`, since otherwise using just the barebones
`purescript-node-readline` library, user input is handled in a callback that
takes the input as its parameter.

# Installing

`bower i purescript-simple-repl`
