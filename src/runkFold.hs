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
    let args =["training.txt"]
    if null args
       then do putStrLn "No arguments given, exiting"
               exitFailure
       else do

    inputContents <- readFile $ head args
    inputAnswers <- readFile "training-facit.txt"
    let images = map (rotImgCorrect 20) $ readImages inputContents
    --Writing all images to file
    --zipWithM_ (\image num -> writePGM ("rot" ++ (show num) ++ ".pgm");;;;;
    -- ;;;;; $ (rotImgCorrect image 20)) images [1..]
    --writePGM "orig.pgm" $ images !! 10
    --writePGM "rotated.pgm" $ rotImgRight (images !! 10) 20

    let
        answers = readAnswers inputAnswers
        (eyeAnswers, mouthAnswers) = unzip (map getEyesMouth answers)
        eyes = zip images eyeAnswers
        mouth = zip images mouthAnswers

    shuffled <- shuffle (zip eyes mouth)

    let (shuffledEyes,shuffledMouth) = unzip shuffled
        (testEyes,trainEyes) = splitAt 50 shuffledEyes
        (testMouth,trainMouth) = splitAt 50 shuffledMouth
--    permuEyes <- shuffle $ take 10000 $ cycle trainEyes
--    permuMouth <- shuffle $ take 10000 $ cycle trainMouth
{-
    writePGM "img1.pgm" (head images)
    eyeweights2 <- train trainEyes testEyes
    writePGM "eyew.pgm" eyeweights2
    writeFile "eye-weights" $ show eyeweights2
    putStrLn $ show eyeweights2
    mouthweights2 <- train trainMouth testMouth
    writePGM "mouthw.pgm" mouthweights2
    writeFile "mouth-weights" $ show mouthweights2
-}

    putStrLn "Eyes "

    test <- kFold 25 eyes
    putStrLn $ "Bertil " ++ (show test)
    putStrLn "Mouth "
    kFold 25 mouth >>= (putStrLn . show)

    exitSuccess






{-
let (|>) = flip ($)
    procseesd = input |> lines |> filter commentsEtc |> tail |> concatMap words |> map read
-}
