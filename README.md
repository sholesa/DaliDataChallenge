# Avery Sholes DALI Application 22X Data Challenge

Thank you for reading my application! I will outline in this README my entire process for the three visualizations and the Part 2 of the data challenge, rather than documenting them all in different files.

## Table of Contents
1. Visualization #1
2. Visualization #2
3. Visualization #3
4. Part Two

## Visualization #1

__Note__: I did not include the dynamic visualization because I could not load it to a proper file. So I uploaded the static viz in `/Scripts/fig_01_not_interactive.png`. To view the dynamic one, please just run the R script!

__Disclaimer__: For what it's worth, I feel more comfortable in Python/Pandas for data wrangling and manipulation, but more so in R for ggplot. So, in addition to just showing my knowledge in different software/languages, the unorthodox method of using .ipnyb and .R files for one visualization is also just because of my own comfort zone.


### Motivation
This first visualization may not give as much a clear overarching view of the entire dataset, but as with any superstore in the 21st Century, it is important to know where the backbone of the current company, ***technology***, is being sold, and in where it is most densely sold. So, I decided to divide the dataset by the `Category` column, and see which states are purchasing larger sums, relatively, of technology-categorized products.

### Methods
#### Jupyter Notebook Script
After loading the Superstore data, I added a column labeled `%` to outline the percentage of Sales that were contributed by each category (one of Technology, Furniture, Office Supplies) per each state. Then, in order to make a column solely for technology percentages, I created a temporary dataframe, subsetting where `viz1df["Category"] == "Technology"`, and then merged the two on the `State` column.
Then, to pass it on to R, where I made the visualization itself, I exported the dataframe to a csv.

#### R Script
Using the `usmap` R package, I merged the dataframe I exported from the notebook to my R script with one of US States and their geometric values, for the viz.
Then, to make the dynamic visualization (showing the exact tech. percentage for that state when hovering over it), I used `geom_ploygon()` in ggplot and used the `ggplotly` package for dynamism.

### Findings
Apart from the states with few purchases in the dataset (MT, WY, ND, WV), Florida, Maine and Indiana had a disporportionately large percentage of their orders be in the technology category. They gotta get off their phones! Meanwhile, South Carolinans and Tennesseeans were more focused on getting office supplies and furniture from the superstore. 

## Visualization #2
### Motivation
Sticking on the `Category` column: How, over time of the superstore's existence, have consumer interests changed? I believe a time-series visualization is important in using "these graphs to describe most of the data." This will give insight into where the superstore has succeeded, and maybe some surprising shifts. It's always important to know where the money is coming from!

### Methods
Deciding to represent the time-series data on a monthly level, I extracted the month and year from the `Order Date` column using the `str.extract()` function with some regex, and converting the new `Order_yearmonth` column to datetime format. Then, grouping by both month and category, I used `apply()` to calculate the mean profit per sale in each category, per month.
Then, to be able to get the proper x-axis data, I pivoted the dataframe.
This time, I made the resulting visualization with `matplotlib` and is saved in `/Scripts/fig_02.png`.

### Findings
For office supplies, they were barely making a profit on average per sale, but they were consistently above $0 on their average sale of office supplies. When it came to furniture, the superstore would normally hover right above or below making a profit, but in January 2015 they averaged a **big** loss around $-200. Technology, on the other hand, is the money maker. With the exception of a few months (spread out) the superstore was making significantly more profit, per sale, than in the other categories.

## Visualization #3
### Motivation
After looking at `Category` in my first two vizualizations, I decided to dive further into it. 

Enter: `Sub-Category`!

How much money in sales was the superstore producing by selling products in each sub-category, and what kind of customers were buying them? This can tell a lot about a store's customer base and can give many insights in what is working, and towards whom they should be marketing -- and which products -- more.

### Methods
For this viz, I used only an R script. I simply grouped by `Segment` and `Sub-Category`, and aggregated the sum of sales per grouping. Then, using the `geom_col` property in ggplot, I created the figure shown in /Scripts/fig_03.png`.

### Findings
Throughout its existence, the superstore has, far and away, done the most sales in chairs and phones. Interestingly enough, those products' sales are almost identically allocated to Consumer, Corporate, and Home Office purchases, respectively! Elsewhere, you can see that Art, Envelopes, Fasteners, and Labels all have relatively low sales, and yet even that small number is dominated by the Consumer segment.

Additionally, there could be a lot more findings here just by looking at the figure -- i.e., which sub-categories have disproportionately high rates of purchases for home-office (or any segment), and why might that be?

## Part 2 -- scikit-learn model
### Motivation
Piggybacking off the motivation for my 3rd viz, I wished to see if I could train a model to predict the `Segment` for which a superstore's purchase was designated. Of course the data is given to us, but I imagine a scenario where you don't know the exact segment, and where if you did, you would better be able to see trends in purchases and could also deploy a better marketing strategy, had you known this information. It was for this reason, and the potential uncoverable insights about the superstore's customer segments that led me to investigate this problem and build this model.

### Methods

Firstly, I knew I would want to include the buyer's location on the "X" side of my model. However, `Region` and `State` both seemed too broad. So, I extracted the first three digits of the buyer's Postal Address to make `zip_sub`[^1].

[^1]: The first digit in a ZIP code represents a defined group of U.S. states. The second and third digits represent a region in that group, such as a large city.

To prepare my data for modeling, I had to convert my categorical variables to numerical ones using the `.map()` function. I also subsetted for all purchases without discounts, as I felt that would obstruct, at least in some instances, the affect quantity and sales numbers had on the final segment prediction.

I settled on using `zip_sub, Quantity, Sales, Sub-Category, Ship Mode` as my "X" variables with which I would use to predict `Segment`. I felt as though these are, all together, sufficient pieces of information that you definitely know at the time of purchase, and can be used to help determine segment. Ship Mode -- does the "Corporate" segment want things quicker? Zip_sub -- are there certain locations where home offices are more popular? This list of reasons for these variables can go on and on.

I then used sklearn's `test_train_split` function with a test size of .25 of all observations to build training and testing dataframes.
I then built a decision tree classifier using sklearn's DTC functionality with a max depth of 10 from the training set previously compiled.

I then used `dt.predict()` to predict the regression value of the variables in X and also found the feature importances of the five columns using built in functions (thanks, scikit!).

### Findings
In the testing phase, the model accurately predicted 618/1200 Segments, good for just over 50%. Its most overestimates came from incorrectly predicting Consumer when it was either Corporate or Home Office, and that informs us of a more specific flaw in the model as well - albeit unsurprisingly in that there are many more Consumer purchases than for the other two segments. 


Interestingly, `zip_sub` was the most important feature in determing the Segment outcome at about 33%. I guess certain locations are more deterministic in whether you are a regular consumer, or a corporate one (or buying for your home office).

Second in importance was Sales, which makes sense given the amount purchased is likely to factor into the segment of the buyer.

Overall, I am happy with the findings of this model, and in a world where the superstore did not have immediate access to the segments of the individual buyers, this model has the potential to help implement and streamline certain practices of both manufacturing and advertising certain products and certain modes of shipping, in certain zip codes, to certain segments.

