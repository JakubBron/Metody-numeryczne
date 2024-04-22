import pandas as pd
import matplotlib.pyplot as p
import matplotlib.image as pimg


def EMA(N, values, dataLength):
    alpha = 2 / (N+1)
    EMA = []
    denominator = 0
    for i in range(0, N):
        denominator = denominator + pow((1-alpha), i)
        EMA.append(0)

    for i in range(N, dataLength):
        temp = 0
        for j in range(0, N):
            temp = temp + pow((1-alpha), j) * values[i-j]
        
        EMA.append(temp/denominator)

    return EMA

def MACD_line(EMA12, EMA26, dataLength):
    MACD = []
    for i in range(0, dataLength):
        if EMA12[i] ==  0 or EMA26[i] == 0:
            MACD.append(0)
        else: 
            MACD.append(EMA12[i] - EMA26[i])
    
    return MACD

def buysell(MACD, SIGNAL, dates, dataLength):
    intersection = []
    for i in range(1, dataLength):
        if MACD[i] > SIGNAL[i] and MACD[i-1] < SIGNAL[i-1]:
            intersection.append((dates[i], "BUY", MACD[i]))
        elif MACD[i] < SIGNAL[i] and MACD[i-1] > SIGNAL[i-1]:
            intersection.append((dates[i], "SELL", MACD[i]))
        else:
            intersection.append((dates[i], "HOLD", MACD[i]))
    return intersection

def profitloss(BUYSELL, price, securityName, period):
    buy = [0,0,0]   # price, date, quantity
    sell = [0,0]    # price, date
    cumulativeProfit = 0
    profit = 0
    
    with open(securityName+'_'+period+'_profitloss.txt', 'w') as f:

        print("=========================================================================================================================================================",file=f)
        print("Profit/loss report for "+securityName+" "+period + "; transaction every BUY/SELL signal (at least "+ period+" apart, if bought, need to be sold).", file=f)


        for i in range(0, len(BUYSELL)):
            if BUYSELL[i][1] == "BUY" and sell == [0,0]:
                buy =[price[i], BUYSELL[i][0], 1000/price[i]]
            
            if BUYSELL[i][1] == "SELL" and buy != [0,0,0]:
                sell = [price[i], BUYSELL[i][0]]
                profit = (float(sell[0]) - float(buy[0])) * buy[2]
                cumulativeProfit = cumulativeProfit + profit

                report = "Buy date: "+buy[1].strftime('%Y-%m-%d')+" | Buy price: "+f"{ '%.2f'%round(buy[0], 2):<10}"
                report = report + " | Sell date: "+sell[1].strftime('%Y-%m-%d')+" | Sell price: "+f"{'%.2f'%round(sell[0], 2):<10}"
                profitMoney = "%.2f"%round(profit, 2)
                profitPercentage = "%.3f"%round(profit / 1000 * 100, 3)

                profitStat = " | Profit: "+ f"{profitMoney:<7}" +" "+ f"{profitPercentage:<7}" + "%"
                report = report + f"{profitStat:<25}"
                report = report + " | Duration: "+ str(sell[1]-buy[1])
                print(report, file=f)

                buy = [0,0,0]
                sell = [0,0]

        print("=========================================================================================================================================================", file=f)
        print("Cumulative profit/loss: "+str(round(cumulativeProfit, 2)) + " " + str(round((cumulativeProfit-1000) / 1000 * 100, 2)) + "%", file=f)   
        print("\n", file=f)
    f.close()

def plot_prices(values, dates, securityName, period, showPlots):
    p.plot(dates, values, label='Price', color='blue')
    p.xlabel('Date')
    p.ylabel('Price')
    plotTitle = securityName +' '+period +' prices for last 1000 sessions'
    p.title(plotTitle)
    p.legend()

    fig = p.gcf()
    fig.set_size_inches(14.2, 8)
    
    fileName = securityName+'_'+period+'_prices.png'
    p.savefig(fileName, bbox_inches='tight')
    if showPlots:
        p.show()
    p.close()

def plot_MACDSIGNAL_intersection(MACD, SIGNAL, BUYSELL, dates, securityName, period, showPlots):
    intersection_buy_date = []
    intersection_buy_macd = []
    intersection_sell_date = []
    intersection_sell_macd = []
    for i in range(0, len(BUYSELL)):
        if BUYSELL[i][1] == "BUY":
            intersection_buy_date.append(BUYSELL[i][0])
            intersection_buy_macd.append(BUYSELL[i][2])
        elif BUYSELL[i][1] == "SELL":
            intersection_sell_date.append(BUYSELL[i][0])
            intersection_sell_macd.append(BUYSELL[i][2])

    p.plot(dates, MACD, label='MACD', color='blue')
    p.plot(dates, SIGNAL, label='SIGNAL', color='orange')
    p.plot(intersection_buy_date, intersection_buy_macd, '^', color = 'green', label='Buy')  
    p.plot(intersection_sell_date, intersection_sell_macd, 'v', color = 'red', label='Sell')  

    p.xlabel('Date')
    p.ylabel('MACD/SIGNAL')
    plotTitle = securityName+' '+period+ ' MACD/SIGNAL for last 1000 sessions & buy/sell signals'
    p.title(plotTitle)
    p.legend()
    
    fig = p.gcf()
    fig.set_size_inches(14.2, 8)
    
    fileName = securityName+'_'+period+'_MACDSIGNAL_BUYSELL.png'
    p.savefig(fileName, bbox_inches='tight')
    if showPlots:
        p.show()
    p.close()

def plot_prices_signals(values, dates, securityName, BUYSELL, period, showPlots):
    buy_date = []
    buy_price = []
    sell_date = []
    sell_price = []
    for i in range(0, len(BUYSELL)):
        if BUYSELL[i][1] == "BUY":
            buy_date.append(BUYSELL[i][0])
            buy_price.append(values[i])
        elif BUYSELL[i][1] == "SELL":
            sell_date.append(BUYSELL[i][0])
            sell_price.append(values[i])

    p.plot(dates, values, label='Price', color='blue')
    p.plot(buy_date, buy_price, '^', color = 'green', label='Buy')  
    p.plot(sell_date, sell_price, 'v', color = 'red', label='Sell')  

    p.xlabel('Date')
    p.ylabel('Price')
    plotTitle = securityName +' '+period+ ' prices for last 1000 sessions & buy/sell signals'
    p.title(plotTitle)
    p.legend()
    
    fig = p.gcf()
    fig.set_size_inches(14.2, 8)
    
    fileName = securityName+'_'+period+'_prices_signals.png'
    p.savefig(fileName, bbox_inches='tight')
    if showPlots:
        p.show()
    p.close()


def worker(data, securityName, period, showPlots):
    data['Data'] = pd.to_datetime(data['Data'])

    #calculate EMA12, EMA26, MACD and SIGNAL
    dataLength = len(data['Zamkniecie'])
    EMA12 = EMA(12, data['Zamkniecie'], dataLength)
    EMA26 = EMA(26, data['Zamkniecie'], dataLength)
    MACD = MACD_line(EMA12, EMA26, dataLength)
    SIGNAL = EMA(9, MACD, dataLength)
    BUYSELL = buysell(MACD, SIGNAL, data['Data'], dataLength)

    # generate plots
    plot_prices(data['Zamkniecie'], data['Data'], securityName, period, showPlots)
    plot_MACDSIGNAL_intersection(MACD, SIGNAL, BUYSELL, data['Data'], securityName, period, showPlots)
    plot_prices_signals(data['Zamkniecie'], data['Data'], securityName, BUYSELL, period, showPlots)

    # generate profit/loss report
    profitloss(BUYSELL, data['Zamkniecie'], securityName, period)

# -------------------------------------------------------------------------------------


WIG20 = pd.read_csv('wig20_last1000.csv', delimiter=';')
EURPLN = pd.read_csv('eurpln_last1000.csv', delimiter=';')
SP500 = pd.read_csv('sp500_last1000.csv', delimiter=';')
PKN = pd.read_csv('pkn_last1000.csv', delimiter=';')

WIG20_W1 = pd.read_csv('wig20_last1000_W1.csv', delimiter=';')
EURPLN_W1 = pd.read_csv('eurpln_last1000_W1.csv', delimiter=';')
SP500_W1 = pd.read_csv('sp500_last1000_W1.csv', delimiter=';')
PKN_W1 = pd.read_csv('pkn_last1000_W1.csv', delimiter=';')

worker(WIG20, 'WIG20', 'D1', False)
worker(EURPLN, 'EURPLN', 'D1', False)
worker(SP500, 'SP500', 'D1', False)
worker(PKN, 'PKN', 'D1', False)

worker(WIG20_W1, 'WIG20', 'W1', False)
worker(EURPLN_W1, 'EURPLN', 'W1', False)
worker(SP500_W1, 'SP500', 'W1', False)
worker(PKN_W1, 'PKN', 'W1', False)



