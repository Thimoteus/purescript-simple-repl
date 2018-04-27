module Node.ReadLine.Aff.Simple where

import Prelude

import Control.Monad.Aff (Aff, makeAff, nonCanceler)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Either (Either(..))
import Data.Options ((:=))
import Node.Process (stdin, stdout)
import Node.ReadLine as RL

prompt :: forall e. RL.Interface -> Aff (readline :: RL.READLINE | e) Unit
prompt = liftEff <<< RL.prompt

setPrompt :: forall e. String -> Int -> RL.Interface -> Aff (readline :: RL.READLINE | e) Unit
setPrompt s n = liftEff <<< RL.setPrompt s n

close :: forall e. RL.Interface -> Aff (readline :: RL.READLINE |  e) Unit
close = liftEff <<< RL.close

setLineHandler :: forall e. RL.Interface -> Aff (readline :: RL.READLINE | e) String
setLineHandler i = makeAff \ cb -> nonCanceler <$ RL.setLineHandler i (cb <<< Right)

simpleInterface :: forall e. Aff (console :: CONSOLE, readline :: RL.READLINE | e) RL.Interface
simpleInterface = liftEff effInterface
  where
   effInterface = RL.createInterface stdin opts
   opts = RL.output := stdout <> RL.completer := RL.noCompletion
