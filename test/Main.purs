module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

import Data.String (toUpper)

import Node.ReadLine (READLINE)
import Node.SimpleRepl (setPrompt, readLine, runRepl, putStrLn)

main :: forall e. Eff (console :: CONSOLE, readline :: READLINE | e) Unit
main = runRepl do
  setPrompt "\x1b[32m>\x1b[0m "
  putStrLn "THE DRAMATIC REPL"
  putStrLn ":Q TO QUIT"
  loop
  where
    loop = do
      res <- readLine
      case res of
           ":q" -> pure unit
           ":Q" -> pure unit
           _ -> do
             putStrLn $ toUpper res <> "!!!"
             loop
