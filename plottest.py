import pandas as pd
import matplotlib as plt
plt.use('Agg')

df = pd.read_csv('weight.csv')
# df.index = pd.to_datetime(df.index)
df.plot(x='date')

# plt.pyplot.show()
plt.pyplot.savefig("weight.png")
