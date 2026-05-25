import pandas as pd
import logging
import os

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s,%(levelname)s,%(message)s",
    handlers=[
        logging.FileHandler("output/salespipeline.csv", mode='a'),#append instead of overwriting the log file each time
        logging.StreamHandler()#output while the program is running
    ]
)


def load_sales_data(filepath):
    """
    Open the sales CSV file and make sure the date column is treated as a real
    date, not just text. Without this, we cannot extract the month name later.
    """
    logging.info(f"Loading data from {filepath}")
    sales_data_frame = pd.read_csv(filepath, sep=None, engine="python")
    sales_data_frame["date"] = pd.to_datetime(sales_data_frame["date"])
    logging.debug(f"Columns found: {list(sales_data_frame.columns)}")
    logging.info(f"Loaded {len(sales_data_frame)} rows successfully")
    return sales_data_frame

def inspect_data(sales_data_frame):
    """
    Create a structured table showing data quality issues BEFORE cleaning.
    """
    logging.info("Creating data inspection table...")
    total_rows = len(sales_data_frame)
    logging.debug(f"Total rows before cleaning: {total_rows}")

    inspection_table = pd.DataFrame({
        "Column": sales_data_frame.columns,
        "Data Type": sales_data_frame.dtypes.values,
        "Missing Values": sales_data_frame.isnull().sum().values,
    
    })

    print("\n=== DATA INSPECTION TABLE (BEFORE CLEANING) ===")
    print(inspection_table)
    duplicate_rows = sales_data_frame[sales_data_frame.duplicated()]

    print("\n=== DUPLICATE ROWS (BEFORE CLEANING) ===")
    print(duplicate_rows)

    duplicate_count = len(duplicate_rows)
    logging.debug(f"Missing values per column:\n{sales_data_frame.isnull().sum()}")
    logging.info(f"Duplicate rows found: {duplicate_count}")
    print(" ")


def remove_duplicates(sales_data_frame):
    """
    Some transactions were recorded more than once by mistake. This finds those
    exact copies and removes them, keeping only one. The drop_duplicates() function
    looks for rows that are exactly the same across all columns and removes the
    extras, keeping only one instance of each unique transaction.
    """
    original_count = len(sales_data_frame)
    sales_data_frame = sales_data_frame.drop_duplicates()
    removed = original_count - len(sales_data_frame)
    logging.debug(f"Rows before deduplication: {original_count}")
    logging.info(f"Removed {removed} duplicate row(s). {len(sales_data_frame)} rows remaining")
    print(" ")

    return sales_data_frame


def fill_missing_values(sales_data_frame):
    """
    Two columns have missing values that need to be handled before the data can be used.

    Salesperson is filled with “Unknown” because it is not possible to determine who made the sale.
    However, the transaction itself is still valid and should be retained in the dataset.

    Quantity values are left blank instead of being estimated.
    """

    missing_salesperson = sales_data_frame["salesperson"].isnull().sum()
    missing_quantity = sales_data_frame["quantity"].isnull().sum()

    logging.debug(f"Missing salesperson values before fill: {missing_salesperson}")
    logging.debug(f"Missing quantity values before fill: {missing_quantity}")

    sales_data_frame["salesperson"] = sales_data_frame["salesperson"].fillna("Unknown")
    sales_data_frame = sales_data_frame.dropna(subset=["quantity"])

    logging.info(f"Filled {missing_salesperson} missing salesperson value(s) with Unknown")
    logging.info(f"Removed {missing_quantity} missing quantity value(s) rows. {len(sales_data_frame)} rows remaining")

    return sales_data_frame

def add_calculated_columns(sales_data_frame):
    """
    Adds two new columns to the dataset. Revenue is calculated by multiplying
    quantity by price for each transaction. Month is extracted from the date and
    stored as a name like January or February instead of a number.
    """
    sales_data_frame["revenue"] = sales_data_frame["quantity"] * sales_data_frame["price"]
    sales_data_frame["month"] = sales_data_frame["date"].dt.strftime("%B")
    logging.info("Added revenue and month columns")
    logging.debug(f"Revenue range: {sales_data_frame['revenue'].min()} - {sales_data_frame['revenue'].max()}")
    logging.debug(f"Months present: {sorted(sales_data_frame['month'].unique())}")

    return sales_data_frame


def display_sales_data(sales_data_frame) -> None:
    """
    Print the cleaned and updated table to the screen. The display settings are
    changed so that no columns are hidden and no text is cut short, which is the
    default behaviour in pandas when a table is too wide for the terminal.
    """
    print("\n=========== CLEANED SALES DATA =============")
    pd.set_option("display.max_columns", None)
    pd.set_option("display.width", None)
    print(sales_data_frame[["transaction_id", "date", "product", "category",
                             "quantity", "price", "region", "salesperson", "revenue", "month"]])


def save_cleaned_data(sales_data_frame):
    """
    Save the fully cleaned dataset as a CSV file in the output folder.
    This is the file that will be used as the base for all summary reports.
    """
    output_path = "output/clean_sales.csv"
    sales_data_frame["quantity"] = sales_data_frame["quantity"].astype("Int64")
    sales_data_frame["revenue"] = sales_data_frame["revenue"].astype("Int64")
    sales_data_frame.to_csv(output_path, index=False)
    logging.info(f"Cleaned data saved to {output_path}")

    print(" ")


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
    logging.info("Saved reports/sales_by_region.csv")
    print(" ")
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
    logging.info("Saved reports/sales_by_product.csv")
    print(" ")
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
    logging.info("Saved reports/monthly_revenue.csv")
    print(" ")
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
    logging.info("Saved reports/salesperson_performance.csv")
    print(" ")
    return salesperson_performance


def main():
    """
    Run all the steps in order: load, clean, fix, fill, calculate, save and
    then generate all summary reports.
    """
    logging.info("Pipeline started")

    sales_data_frame = load_sales_data("data/Messy_Sales_Data.csv")
    inspect_data(sales_data_frame)
    sales_data_frame = remove_duplicates(sales_data_frame)
    sales_data_frame = fill_missing_values(sales_data_frame)
    sales_data_frame = add_calculated_columns(sales_data_frame)
    display_sales_data(sales_data_frame)

    save_cleaned_data(sales_data_frame)
    generate_sales_by_region(sales_data_frame)
    generate_sales_by_product(sales_data_frame)
    generate_monthly_revenue(sales_data_frame)
    generate_salesperson_performance(sales_data_frame)

    logging.info("Pipeline completed successfully")


if __name__ == "__main__":
    main()