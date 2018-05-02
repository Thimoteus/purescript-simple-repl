module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Array as A
import Data.String (toUpper)
import Data.String.CodePoints as S
import Node.ReadLine (READLINE)
import Node.SimpleRepl (completionRepl, putStrLn, readLine, setPrompt)

main :: forall e. Eff (console :: CONSOLE, readline :: READLINE | e) Unit
main = completionRepl comp do
  setPrompt "\x1b[32m>\x1b[0m "
  putStrLn "THE DRAMATIC REPL"
  putStrLn ":Q TO QUIT"
  loop
  where
    comp l = pure {completions, matched} where
      matched = l
      completions = A.filter isMatch allCompletions
      isMatch c = S.take (S.length l) c == l
      allCompletions = ["hello", "hi", "hola"]
    loop = do
      res <- readLine
      case res of
           ":q" -> pure unit
           ":Q" -> pure unit
           _ -> do
             putStrLn $ toUpper res <> "!!!"
             loop
