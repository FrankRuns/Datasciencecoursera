---
title       : Tracking Warehouse Productivity
subtitle    : Understanding Account Level Efficiency
author      : Frank Corrigan
job         : Data Products Develpment Manager
framework   : io2012       # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Purpose

1. 60% of warehouse costs are attributable to labor.
2. Tracking labor productivity is crucial to the growth of a wareouhouse business.
3. A user friendly application to track and understand account level labor efficieny in a warehouse will improve bottom line for any distribution center.
4. This application delivers daily productivity measures for a hypothetical 3rd party logistics (3PL) company specializing in fashion apparel.

--- .closed

## Data

The back data for this application is stored in a google spreadsheet and is updated daily by account supervisors. For each task they are required to record both the number of items processed for that task and the manhours attributed to that task. A few examples of a task are:

* Receive Cartons
* Putaway Pallets
* Pick Unit
* Ship Cartons

The blended labor productivity rate (uph) is calculated (manhours) / (quantity processed).

--- .closed

## The Application

<iframe style="height:500px" src="https://frankruns.shinyapps.io/whprod/"></iframe> 

This application lives [here]("https://frankruns.shinyapps.io/whprod/").

--- .closed

## Benefits

Most 3PLs track labor productivty with an end of the month excel or pdf report. This is stale data and if a potential problem has been brewing in the warehouse, it might be too late to resolve without major consequences.

Putting daily productivity data in the hands of the company executives (and warehouse managers) gives them timely insight into warehouse operations and ultimitely insight into the health of the bottom line.

Additionally, analyzing account level productivity will allow managers to identfy accounts that are permorming successfully and accounts that are performing poorly. To that end, it is a opportunity for company wide improvement in performance.

--- .closed


