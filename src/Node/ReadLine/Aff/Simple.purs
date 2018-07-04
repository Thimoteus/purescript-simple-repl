module Node.ReadLine.Aff.Simple where

import Prelude

import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Data.Either (Either(..))
import Data.Options ((:=))
import Node.Process (stdin, stdout)
import Node.ReadLine as RL

prompt :: RL.Interface -> Aff Unit
prompt = liftEffect <<< RL.prompt

setPrompt :: String -> Int -> RL.Interface -> Aff Unit
setPrompt s n = liftEffect <<< RL.setPrompt s n

close :: RL.Interface -> Aff Unit
close = liftEffect <<< RL.close

setLineHandler :: RL.Interface -> Aff String
setLineHandler i = makeAff \ cb -> nonCanceler <$ RL.setLineHandler i (cb <<< Right)

completionInterface :: RL.Completer -> Aff RL.Interface
completionInterface comp = liftEffect effInterface
  where
    effInterface = RL.createInterface stdin opts
    opts = RL.output := stdout <> RL.completer := comp

simpleInterface :: Aff RL.Interface
simpleInterface = completionInterface RL.noCompletion