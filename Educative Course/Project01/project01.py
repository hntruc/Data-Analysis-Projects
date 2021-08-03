#Stock market analysis
import pandas as pd 
import matplotlib.pyplot as plt

# read data of Ssystems Ltd
sys = pd.read_csv('Year_2018/SYS.csv')
netsol = pd.read_table('Year_2018/NETSOL.csv' , sep = ',')
ptc = pd.read_csv('Year_2018/PTC.csv')
avn = pd.read_csv('Year_2018/AVN.csv')

#section 1: Price Trends
#How much did the stock price of each company change over time?

# Moving average: smooth the short term random price changes by filtering unnecessary noise.
# Less sensitivity offers more smooth curves.
# days = 40 #Moving average window
# avg_col_name = "my_avg for " + str(days) + " days"
# sys[avg_col_name] = sys['Close'].rolling(days).mean()
# sys[['Close',avg_col_name]].plot(legend = True, figsize=(10,5))
# plt.show()

list_company = [sys,netsol,ptc,avn]
com_name = ['sys','netsol','ptc','avn']
for l in range (len(list_company)):
    #correct the format of date
    list_company[l]['Time'] = pd.to_datetime(list_company[l].Time) # correct the format of date
    list_company[l] = list_company[l].set_index('Time') #Set Time column as row index
    list_company[l]['Close'].plot( label = com_name[l], figsize=(10,5), legend = True)
plt.show() #show the plot

#Comment: It can be seen from the line chart that 2018 was a good year for NETSOL and Systems.

#section 2: What were the daily returns for all the companies?

#section 3: How are the stocks of the companies related to each other?

#section 4: How much money do we risk losing by investing in a certain company?

#section 5: Can we predict future stock behavior?