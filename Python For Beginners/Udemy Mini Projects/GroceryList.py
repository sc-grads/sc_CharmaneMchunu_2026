import sys
def welcome_message() -> None:
    print('Welcome to Grocery List!')
    print("Enter:")
    print('-----------------------------')
    print("1 - To add an item")
    print('2 - To remove an item')
    print('3 - To show all items')
    print('0 - To exit the program')
    print('--------------------------------')

def add_item(item:str , groceries: list[str]) -> None:
    groceries.append(item)
    print(f'{item} is added to the grocery list')

def remove_item(item:str , groceries: list[str]) -> None:
    try:
        groceries.remove(item)
        print(f'{item} is removed from the grocery list')
    except ValueError:
        print(f'{item} is not in the grocery list')

def display(groceries: list[str]) -> None:
    print('________LIST_________')
    for i,item in enumerate(groceries,1):
        print(f'{i}. {item.capitalize()}')

    print('_'*10)

def is_an_option(text: str) -> bool:
    return text in ['1', '2', '3','0']

def main() -> None:
    groceries : list[str] = []
    welcome_message()
    while True:
        user_input: str = input('Choose: ').lower()

        if not(is_an_option(user_input)):
            print('Please enter a valid option')
            continue

        if user_input == '1':
            new_item: str = input('What item would you like to add: ').lower()
            add_item(user_input, groceries)

        elif user_input == '2':
            new_item: str = input('What item would you like to remove: ').lower()
            remove_item(new_item, groceries)

        elif user_input == '3':
            display(groceries)

        elif user_input == '0':
            print('Exiting the program.....')
            sys.exit()

if __name__ == '__main__':
    main()




