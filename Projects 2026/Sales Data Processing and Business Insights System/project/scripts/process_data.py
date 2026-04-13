import pandas as pd
import numpy as np
import os

data_frame = pd.read_csv("../data/Sales_data.csv")
#print(data_frame)

# Convert date
data_frame["date"] = pd.to_datetime(data_frame["date"])

# Revenue calculation
data_frame["revenue"] = data_frame["quantity"] * data_frame["price"]
data_frame["month"] = data_frame["date"].dt.strftime("%B")  # show it as names instead of the number much better that way January, February
pd.set_option("display.max_columns", None)
pd.set_option("display.width", None)# will show me all columns and all data without truncation cause the other column was not showing

print(data_frame[["transaction_id", "date", "product", "category", "quantity", "price", "region", "salesperson", "revenue", "month"]])
