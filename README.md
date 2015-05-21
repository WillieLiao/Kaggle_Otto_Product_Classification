# Kaggle Otto Group Product Classification

## Introduction
This solution ranked 187/3514 in Kaggle's [Product Classification](https://www.kaggle.com/c/otto-group-product-classification-challenge) competition.  The competition goal was to classify items into 9 product categories based on 93 anonymous count vectors.  This was one of the biggest competitions hosted by Kaggle and several high performing benchmarks were posted in the forums.  My personal goal was to learn the xgboost package and become familiar with deep learning.  It just so happens that [DataGeek](https://www.kaggle.com/c/otto-group-product-classification-challenge/forums/t/14134/deep-learning-h2o-0-44) and [Chris](https://www.kaggle.com/c/otto-group-product-classification-challenge/forums/t/12989/code-for-leaderboard-score-of-0-45612-in-3-minutes) contributed benchmarks using those.

## Algorithms
* xgboost
* deep learning

## Features
I did not try to do too much since I was more interested in tuning xgboost and neural networks.
* average counts
* zero counts

## Dependencies
* R version 3.1+
* R packages
  * data.table
  * xgboost
  * h2o

## Run
Requires unzipped train.csv and test.csv in the Data subdirectory.  Run main.
