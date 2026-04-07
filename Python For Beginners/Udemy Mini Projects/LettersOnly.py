import string
def is_letters_only(text:str)-> None:
    alphabet: str = string.ascii_letters +''

    for char in text:
        if char not in alphabet:
            raise ValueError('Text can only contain letters from the alphabet')
    print(f'{text} is a letters only, good job!')

def main() -> None:
    while True:
        try:
            user_input: str = input("Enter a letters only: ")
            is_letters_only(user_input)

        except ValueError:
            print('Please enter a English letters only')
        except Exception as e:
            print(f'Encountered and unknown exception:{type(e)}{e}')

main()

