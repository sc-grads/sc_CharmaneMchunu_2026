import pandas as pd


def load_sales_data(filepath):
    """
    Open the sales CSV file and make sure the date column is treated as a real date, not just text. Without this , we cannot extract the month name later

    """
    sales_data_frame = pd.read_csv(filepath)
    sales_data_frame["date"] = pd.to_datetime(sales_data_frame["date"])
    return sales_data_frame

def remove_duplicates(sales_data_frame):
    """
    Some transactions were recorded more than once by mistake. This finds those exact copies and removes them , keeping only one
    that is what the drop_duplicates() function does, it looks for rows that are exactly the same across all columns and removes the duplicates, keeping only one instance of each unique transaction.
    """
    sales = sales_data_frame.drop_duplicates()
    return sales

def fix_regions(sales_data_frame):
    """
    The region column should only ever contain North, South, East or West.
    Anything else, like a name or a typo, is invalid. This replaces all invalid
    entries with Unknown so they do not get mixed into regional reports by mistake.
    """
    valid_regions = ["North", "South", "East", "West"]

    for i, region in enumerate(sales_data_frame["region"]):
        found = False
        for valid in valid_regions:
            if region == valid:
                found = True
                break
        if not found:
            sales_data_frame.at[i, "region"] = "Unknown"

    return sales_data_frame

def fill_missing_values(sales_data_frame):
    """
    Two columns have missing values that need to be filled before we can use the data.

    Salesperson is filled with Unknown because we cannot guess who made the sale,
    but we still want to keep the transaction in the dataset.

    Quantity is filled with 0 because leaving it blank would break the revenue
    calculation. A 0 also makes it obvious in reports that the quantity was never
    recorded, rather than hiding the gap with an estimated number.
    """
   
    missing_quantity = 0

    for i, row in sales_data_frame.iterrows():
        if pd.isnull(row["salesperson"]):
            sales_data_frame.at[i, "salesperson"] = "Unknown"

        if pd.isnull(row["quantity"]):
            sales_data_frame.at[i, "quantity"] = 0
            missing_quantity += 1

    return sales_data_frame

def add_calculated_columns(sales_data_frame):
    """
    Adds two new columns to the dataset: revenue and month. Revenue is calculated
    by multiplying quantity and price, while month is extracted from the date.
    """
    sales_data_frame["revenue"] = sales_data_frame["quantity"] * sales_data_frame["price"]
    sales_data_frame["month"] = sales_data_frame["date"].dt.strftime("%B")
    return sales_data_frame

def display_sales_data(sales_data_frame)-> None:
    """
    Print the cleaned and updated table to the screen. The display settings are
    changed so that no columns are hidden and no text is cut short, which is the
    default behaviour in pandas when a table is too wide for the terminal.
    """
    pd.set_option("display.max_columns", None)
    pd.set_option("display.width", None)
    print(sales_data_frame[["transaction_id", "date", "product", "category","quantity", "price", "region", "salesperson", "revenue", "month"]])

def save_cleaned_data(sales_data_frame):
    """
    Save the fully cleaned dataset as a CSV file in the output folder.
    This is the file that will be used as the base for all summary reports.
    """
    output_path = "output/clean_sales.csv"
    sales_data_frame.to_csv(output_path, index=False)
    print(f"Cleaned data saved to {output_path}")


def generate_sales_by_region(sales_data_frame):
    """
    Group all transactions by region and add up the total revenue and total
    quantity sold for each one. This shows which region is bringing in the
    most money for the business.
    """
    sales_by_region = sales_data_frame.groupby("region").agg(
        total_revenue=("revenue", "sum"),
        total_quantity=("quantity", "sum"),
        total_transactions=("transaction_id", "count")
    ).reset_index()

    sales_by_region.to_csv("reports/sales_by_region.csv", index=False)
    print("Saved reports/sales_by_region.csv")
    return sales_by_region


def generate_sales_by_product(sales_data_frame):
    """
    Group all transactions by product and calculate total revenue, total
    quantity sold and number of transactions. This shows which products
    are selling the most and generating the most revenue.
    """
    sales_by_product = sales_data_frame.groupby("product").agg(
        total_revenue=("revenue", "sum"),
        total_quantity=("quantity", "sum"),
        total_transactions=("transaction_id", "count")
    ).reset_index()

    sales_by_product.to_csv("reports/sales_by_product.csv", index=False)
    print("Saved reports/sales_by_product.csv")
    return sales_by_product


def generate_monthly_revenue(sales_data_frame):
    """
    Group all transactions by month and calculate total revenue for each one.
    This shows which months are the strongest and helps spot seasonal trends
    in the business.
    """
    monthly_revenue = sales_data_frame.groupby("month").agg(
        total_revenue=("revenue", "sum"),
        total_transactions=("transaction_id", "count")
    ).reset_index()

    monthly_revenue.to_csv("reports/monthly_revenue.csv", index=False)
    print("Saved reports/monthly_revenue.csv")
    return monthly_revenue


def generate_salesperson_performance(sales_data_frame):
    """
    Group all transactions by salesperson and calculate total revenue, total
    quantity sold and number of transactions. This shows who is performing
    well and who might need support.
    """
    salesperson_performance = sales_data_frame.groupby("salesperson").agg(
        total_revenue=("revenue", "sum"),
        total_quantity=("quantity", "sum"),
        total_transactions=("transaction_id", "count")
    ).reset_index()

    salesperson_performance.to_csv("reports/salesperson_performance.csv", index=False)
    print("Saved reports/salesperson_performance.csv")
    return salesperson_performance

def main():
    sales_data_frame = load_sales_data("data/Messy_Sales_Data.csv")
    sales_data_frame = remove_duplicates(sales_data_frame)
    sales_data_frame = fix_regions(sales_data_frame)
    sales_data_frame = fill_missing_values(sales_data_frame)
    sales_data_frame = add_calculated_columns(sales_data_frame)
    display_sales_data(sales_data_frame)   

    save_cleaned_data(sales_data_frame)
    generate_sales_by_region(sales_data_frame)
    generate_sales_by_product(sales_data_frame)
    generate_monthly_revenue(sales_data_frame)
    generate_salesperson_performance(sales_data_frame)

if __name__ == "__main__":
    main()     