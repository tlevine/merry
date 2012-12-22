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
merry$se <- sqrt(merry$p * (1-merry$p) / merry$total)

p.merry <- ggplot(merry) + aes(x = year, y = p) + geom_line() +
  geom_vline(xintercept = 1949, color = 'red') +
  scale_x_continuous('Year of birth') +
  scale_y_continuous('Proportion named "Merry"', labels = percent) +
  labs(title = 'When was the name "Merry" popular?\nBased on dead people from the Social Security Death Master File')

p.merry.error <- p.merry +
  geom_errorbar(
    aes(ymin = p + qnorm(0.25) * se, ymax = p + qnorm(0.975) * se),
    color = 'grey',
    width = 0
  ) + geom_line()

merry$low.estimate <- sapply(merry$p + qnorm(0.05) * merry$se, function(v) {max(0, v)})
p.merry.low <- ggplot(merry) + aes(x = year, y = low.estimate) + geom_line() +
  geom_vline(xintercept = 1949, color = 'red') +
  scale_x_continuous('Year of birth') +
  scale_y_continuous('Low estimate of proportion of people named "Merry"\n(Stupidly estimated single-tailed normal 95% confidence interval imagining a superpopulation)', labels = percent) +
  labs(title = 'When was the name "Merry" popular?\nBased on dead people from the Social Security Death Master File')

p.all <- ggplot(merry) + aes(x = year, y = total) + geom_line() +
  scale_x_continuous('Year of birth') +
  scale_y_continuous('Number of people born') +
  labs(title = 'Dead people by birth year')

pdf('merry.pdf', width = 11, height = 8.5)
print(p.all)
print(p.merry)
# print(p.merry.error)
print(p.merry.low)
dev.off()
