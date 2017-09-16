module Csv where

import Data.List
import Data.Char
import qualified Data.Text as T
import Data.Text.Internal

import System.Environment (lookupEnv)
import Data.Maybe (fromMaybe)
import System.IO
import Data.Time


-- リストを述語 p を満たす地点で分割
split :: (a -> Bool) -> [a] -> ([a], [a])
split _ [] = ([], [])
split p (x:xs)
      | p x       = ([], xs)
      | otherwise = (x : ys, zs)
      where (ys, zs) = split p xs

-- 最初の "," で分割
-- ["0801", "70.0", "-5.0"]
csv2list :: String -> [String]
csv2list [] = []
csv2list l = h : csv2list i
  where
    (h, i) = split (\x -> x == ',') l

list2Csv :: [String] -> String
list2Csv [x] = x
list2Csv (x:xs) = x ++ "," ++ list2Csv xs

-- csv をリスト化
-- [["0801", "70.0"], ["0802", "69.5"]]
csvReader :: String -> [[String]]
csvReader = map csv2list . lines

csvWriter :: [[String]] -> String
csvWriter = unlines . map list2Csv


-- 日本時間へ調整
-- utc = show time
utc2jst :: String -> String
utc2jst utc
  | time < 15 = month ++ date
  | otherwise = month ++ (show $ (read date :: Int) + 1)
  where
    time = read $ map (utc !!) [11, 12] :: Int
    month = map (utc !!) [5..7]
    date = map (utc !!) [8, 9]


-- 一覧の更新
updateList :: String -> IO ()
updateList todaysWeight = do
  time <- getCurrentTime
  appendFile "./weight.csv" $ (utc2jst $ show time) ++ "," ++ todaysWeight ++ "\n"
