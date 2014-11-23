Factors Effecting Fuel Economy
========================================================

# Executive Summary

This report investigates the relationship between the fuel economy of an automobile and its characteristics such as weight, horsepower, transmission, # of cylinders, etc. The data used for this report was extracted from the 1974 Motor Trend US magazine and comprises data about fuel consumption (measured by miles per gallon(mpg)) plus 10 additional measures of the automobile’s design and performance for 32 cars (1973–74 models). The dataset can be accessed in the r programming interface as shown below (it comes as part of the base r installation) or you can download the data at this [link](http://www.lsta.upmc.fr/guilloux/Bootstrap/mtcars.R).  

Although this report initially set out to answer a simple question of what type of transmission is better for fuel economy, it turned out that the answer was a bit more complex than "manual" or "automatic". The findings of this report are detailed below and can be summarized as follows; fuel economy of a vehicle is most heavily influenced by the weight and ¼-mile time of the vehicle (of course ¼-mile time is determined by # of cylinders & horsepower). As weight increases, fuel economy falls. As ¼-mile time increases (indicating a slower car), fuel economy rises. In the end, the report concludes that a manual transmission vehicle with the same weight and same 1/4-mile time as an automatic transmission vehicle will get more miles on a single gallon of fuel.
 
# Exploratory Analysis

First things first, what does the data 'look' like? What is the structure of the dataset and are there any missing value? Are outliers present and is the mpg data roughly normally distributed?

What we find is that this is a dataset with no missing values (how rare!!!). All variables are numeric. After converting transmission type ('am') to a factor aka categorical variable, a simple box plot and density chart shows us that no outliers appear and the data is roughly normally distributed. See the appendix for charts. This is important if we are going to search for a linear regression model to quantify these relationships. More on linear model assumptions [here](http://users.ecs.soton.ac.uk/jn2/teaching/interactions.pdf)




Taking a second look at the boxplot shows us that, not only is the data normally distributed, but autmatic transmission automobiles seem to have a lower average fuel economy than manual transmission automobiles. Here are the averages.


```
## Automatic    Manual 
##     17.15     24.39
```


This sounds in line with conventional wisdom, but perhaps this is only a statistical anomoly of our dataset. Let's use an independent t-test to find out.




In this test the p-value is .001374. Translation for data people: assuming the null hypothesis is true (which is that there is no difference in the means of auto and manual transmission), the probability of aquiring a dataset like the one we have where the means are 7 points different is only .1374%... very very small. Hence we reject the null. Translation for everyone else: manual transmission vehicles get better fuel economy than automatic transmission vehicles. But ... should we stop there? 

Unfortunately, the interaction between variables makes our t-test results less compelling. In order to further quantify the magnitude of the difference in mpg between auto trans and manual trans we need to conduct a multiple linear regression linking a car's fuel economy with it's characteristics. A reasonable guess for this relationship is that all of the variables in the dataset will have an impact on mpg. That model looks like this:

mpg = intercept + weight + horsepower + 1/4-mile time + # of cylinders + displacement + rear axle ration + cyclinder configuration + transmission type + # of forward gears + # of carburetors + some margin of error




Inevitably, this would lead to overfitting and a model that is too complex to explain. Okums razor... Not only that, but there is strong correlation between some of our variables. In the correlation matrix below, notice the strong association between 1/4-mile time and horsepower. If we include both of those in the model, in a sense we'd be double counting the effect.








```r
cor(mtcars[, 4], mtcars[, 7])
```

```
## [1] -0.7082
```





So, let's use [stepwise selection](http://www.stat.columbia.edu/~martin/W2024/R10.pdf) in order to gain insight into the best fit model (which variable to use) for our analysis. Please find the summary in the appendix


```r
step.model <- step(lm(data = mtcars, mpg ~ .), trace = 0, steps = 10000)
```


The results tell us we have 3 variables in our model; 'wt' (weight), 'qsec' (1/4 mile time), and 'am' (transmission type). With an adjusted r^2 of .83, this model explains 83% of the variation in mpgs between cars. The p-value is tiny --- way below our benchmark of .005 --- which tells us that these results are stitistically significant. The coefficients can be interpreted as so

1. A car with wt = 0, qsec = 0, and am = null will get 9.68 mpgs. Of course, this is irrelevent but running our regression through the mean will lead to some sacrifice of the accuracy of the coefficients... so it remains
2. For every 1,000 additional lbs in car weitht, mpg fuel efficiency will fall by 3.92 mpg
3. For every 1 additional second in 1/4 mile time, mpg fuel efficicency will increase by 1.23 mpg
4. 'am' is a factor variable so this coefficient is meaningless in our model

In order to stregthen this model we can control for the am varaible to see the effect of wt and qsec on mpg between automatic transmission vehicles and manual transmission vehicles. This will mediate any interaction effect aka moderation effect taking place (I've added and subtracted variables from the model to witness that indeed, am is a confounding variable --- which means it fucks up our model)


```r
step.model <- lm(mpg ~ factor(am):wt + factor(am):qsec, data = mtcars)
summary(step.model)
```

```
## 
## Call:
## lm(formula = mpg ~ factor(am):wt + factor(am):qsec, data = mtcars)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -3.936 -1.402 -0.155  1.269  3.886 
## 
## Coefficients:
##                          Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                13.969      5.776    2.42   0.0226 *  
## factor(am)Automatic:wt     -3.176      0.636   -4.99  3.1e-05 ***
## factor(am)Manual:wt        -6.099      0.969   -6.30  9.7e-07 ***
## factor(am)Automatic:qsec    0.834      0.260    3.20   0.0035 ** 
## factor(am)Manual:qsec       1.446      0.269    5.37  1.1e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.1 on 27 degrees of freedom
## Multiple R-squared:  0.895,	Adjusted R-squared:  0.879 
## F-statistic: 57.3 on 4 and 27 DF,  p-value: 8.42e-13
```


Interpretation: Automatic transmission car with wt is 2.32 and qsec is 18.61 MPG = 13.97 - 3.18 * 2.32 + 0.83 * 18.61 = 22.04. Manual transmission car with wt is 2.32 and qsec is 18.61 MPG = 13.97 - 6.1 * 2.32 + 1.4 * 18.61 = 25.87. This model appears to agree with our prior notion (and the conventional wisdom) that manual cars get better gas mileage than automatic transmission cars.

# Goodness of Fit




There is no apparent trend in the residuals, the Q-Q plot appears linear and lies very close to the line y=x, and there is no apparent pattern in the scale-location graph. See graphs in appendix. [All indicate a good fit.](http://www.stat.berkeley.edu/classes/s133/Lr0.html) Further, plotting the predicted value of each with confidence margin of 95% of versus the actual value shows that the model comes pretty close to identifying the correct mpg for each autombile


```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```


![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 


Not perfect, but no model is. Actually, quite far from perfect. In ten out of 32 cases, our model failed to capture the actual mpg of the auto we were predicting for as indicated by the blue dots falling outside of our predicted value error bars. This is definitely an area for further investigation. 
 
# Appendix

MPG Boxplot & Density Chart


```
## Package 'sm', version 2.2-5.4: type help(sm) for summary information
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 


Goodness of fit


```r
par(mfrow = c(2, 2))
plot(step.model)
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15.png) 

