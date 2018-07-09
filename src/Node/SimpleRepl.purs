module Node.SimpleRepl where

import Prelude

import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Data.Either (either)
import Effect.Exception (message)
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Aff.Class (liftAff)
import Effect.Class.Console (error, log)
import Node.ReadLine (Interface, Completer)
import Node.ReadLine.Aff.Simple as RLA

type Repl a = ReaderT Interface Aff a

prompt :: Repl Unit
prompt = liftAff <<< RLA.prompt =<< ask

setPrompt :: String -> Repl Unit
setPrompt s = liftAff <<< RLA.setPrompt s 0 =<< ask

close :: Repl Unit
close = liftAff <<< RLA.close =<< ask

setLineHandler :: Repl String
setLineHandler = liftAff <<< RLA.setLineHandler =<< ask

readLine :: Repl String
readLine = prompt *> setLineHandler

simpleRepl :: Repl Unit -> Effect Unit
simpleRepl = runWithInterface RLA.simpleInterface

completionRepl :: Completer -> Repl Unit -> Effect Unit
completionRepl = runWithInterface <<< RLA.completionInterface

runWithInterface :: Aff Interface -> Repl Unit -> Effect Unit
runWithInterface int rep = runAff_ (either (error <<< message) pure) $ runReaderT (rep *> close) =<< int

putStrLn :: String -> Repl Unit
putStrLn = log
