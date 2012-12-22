#!/usr/bin/env Rscript
library(ggplot2)
library(reshape2)
library(scales)

merry.raw <- na.omit(read.csv('merry.csv'))
merry.nonzero <- merry.raw[merry.raw$merry.raw,]

merry <- dcast(merry.raw, year ~ merry)
merry[is.na(merry[,'TRUE']),'TRUE'] <- 0
merry$total <- merry[,'TRUE'] + merry[,'FALSE']

merry$p <- merry[,'TRUE'] / merry$total

p.merry <- ggplot(merry) + aes(x = year, y = p, size = total) + geom_line() +
  geom_vline(xintercept = 1949, color = 'red') +
  scale_x_continuous('Year of birth') +
  scale_y_continuous('Proportion named "Merry"', labels = percent) +
  scale_size_continuous('Total people') +
  labs(title = 'When was the name "Merry" popular?\nBased on dead people from the Social Security Death Master File')

p.all <- ggplot(merry) + aes(x = year, y = total) + geom_line() +
  scale_x_continuous('Year of birth') +
  scale_y_continuous('Number of people born') +
  labs(title = 'Dead people by birth year')

pdf('merry.pdf', width = 11, height = 8.5)
print(p.all)
print(p.merry)
dev.off()
