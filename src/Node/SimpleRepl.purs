module Node.SimpleRepl
  ( Repl
  , runRepl
  , setPrompt
  , readLine
  , putStrLn
  ) where

import Prelude

import Control.Monad.Aff (Aff, runAff)
import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, error)
import Control.Monad.Eff.Exception (message)
import Control.Monad.Reader.Class (ask)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Data.Either (either)
import Node.ReadLine (Interface, READLINE)
import Node.ReadLine.Aff.Simple as RLA

type Repl e a = ReaderT Interface (Aff (console :: CONSOLE, readline :: READLINE | e)) a

prompt :: forall e. Repl e Unit
prompt = liftAff <<< RLA.prompt =<< ask

setPrompt :: forall e. String -> Repl e Unit
setPrompt s = liftAff <<< RLA.setPrompt s 0 =<< ask

close :: forall e. Repl e Unit
close = liftAff <<< RLA.close =<< ask

setLineHandler :: forall e. Repl e String
setLineHandler = liftAff <<< RLA.setLineHandler =<< ask

readLine :: forall e. Repl e String
readLine = prompt *> setLineHandler

runRepl :: forall e. Repl e Unit -> Eff (console :: CONSOLE, readline :: READLINE | e) Unit
runRepl rep = void $ runAff (either (error <<< message) pure) $ runReaderT (rep *> close) =<< RLA.simpleInterface

putStrLn :: forall e. String -> Repl e Unit
putStrLn = liftAff <<< log
