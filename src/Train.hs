-----------------------------------------------------------------------------
--
-- Module      :  Main
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Main (

    main

) where

import System.Environment (getArgs, getProgName)
import System.IO (hClose, openFile, hGetContents)
import Data.List ()
import System.Exit (exitSuccess, exitFailure)
import GHC.IO.IOMode (IOMode(..))
import Func
       (Image, Face, shuffle, train, getEyesMouth, chunks,
        test, writePGM, rotImgCorrect, readImages, readAnswers, kFold)
import Control.Monad (zipWithM_)

main = do
    inputContents <- readFile "training.txt"
    inputAnswers <- readFile "training-facit.txt"
    let images = map (rotImgCorrect 20) $ readImages inputContents
        answers = readAnswers inputAnswers
        (eyeAnswers, mouthAnswers) = unzip (map getEyesMouth answers)
        eyes = zip images eyeAnswers
        mouth = zip images mouthAnswers

    shuffled <- shuffle (zip eyes mouth)

    let (shuffledEyes,shuffledMouth) = unzip shuffled
        (testEyes,trainEyes) = splitAt 50 shuffledEyes
        (testMouth,trainMouth) = splitAt 50 shuffledMouth


    eyeweights2 <- train trainEyes testEyes
    writePGM "eyew.pgm" eyeweights2
    writeFile "eye-weights" $ show eyeweights2
    mouthweights2 <- train trainMouth testMouth
    writePGM "mouthw.pgm" mouthweights2
    writeFile "mouth-weights" $ show mouthweights2


    exitSuccess






{-
let (|>) = flip ($)
    procseesd = input |> lines |> filter commentsEtc |> tail |> concatMap words |> map read
-}
