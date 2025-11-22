import datetime as dt
import matplotlib.pyplot as plt
from matplotlib.dates import date2num

"""03-10-16,772.559998
04-10-16,776.429993
05-10-16,776.469971
06-10-16,776.859985
07-10-16,775.080017"""

data = [
    (dt.datetime.strptime("2016-10-03","%Y-%m-%d"),772.559998),
    (dt.datetime.strptime("2016-10-04","%Y-%m-%d"),776.429993),
    (dt.datetime.strptime("2016-10-05","%Y-%m-%d"),776.469971),
    (dt.datetime.strptime("2016-10-06","%Y-%m-%d"),776.859985),
    (dt.datetime.strptime("2016-10-07","%Y-%m-%d"),775.080017)

]

x = [date2num(date) for (date,value) in data]
y = [value for (date,value) in data]

figure = plt.figure()
graph = figure.add_subplot(111)
graph.plot(x,y,'r-o')
graph.set_xticks(x)
graph.set_xticklabels([date.strftime("%Y-%m-%d") for date in x])
plt.xlabel('Date')
plt.ylabel('Price')
plt.title("PClosing stocks of Alphabet inc.")
plt.show()






























