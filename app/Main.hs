{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Maybe (fromMaybe)
import System.IO
import System.Environment (lookupEnv)

import Csv (updateList)


main :: IO ()
main = do
  tw' <- fromMaybe (error " not set") <$> lookupEnv "WEIGHT"
  updateList tw'
  return ()
