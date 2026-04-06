from datetime import datetime, time
import time


# print("Hello Bob") #Greets the user
# print('Hello Bob!')
# #Print wont work cause Python is case sensitive
# print('Ciao bello!') #prints a frindly message to user
#
# #Variables
# greeting = 'Hello'
# print(greeting + ' Bob')
# print(greeting + ' Cat')
# print(greeting + ' Dave')
#
# #Constants - cant change value
# PI = 3.14
# VERSION = 2
#
# print(VERSION)
# print(PI * 2)
#
# #DATA TYPES
# print(10+5.5) # decimal and integer are compatible
# #Numeric types
# number = -100
# percent = 1.50
# imaginary = 9j
#
# #Boolean types
# is_connected = True
# has_money = False
#
# #String types
# text = 'Hello Bob'
#
# #Sequence type
# numbers = [1,2,3,4]
# coordinates = (2.5 ,1.0)
#
# #Mapping types
# users = {'Mario' :1 , 'Luigi' : 2}
#
# #Set types
# raffles = {1,10,20,25,50}
# frozen = frozenset({1,2,3,4})
#
# #Type hints
# number_type  = 10
# print(number_type)
# print(type(number_type))
#
# number_type = 'Hello'
# print(number_type)
# print(type(number_type))
#
# #be more explicit
#
# #Integers -> whole number
# age: int = 10
# print(age)
# money : int = 100
# self_esteem : int = -100
# a: int = 5
# b: int = 10
#
# print(a+b)
# print(a-b)
# print(a*b)
# print(a/b)
#
# #Floats
# PI : float = 3.14
# percentage : float = 0.5
# height_in_metres: float = 1.72
# a: float = .5
# b: float = 1.5
#
# #Operators(Part 1)
# c : int = 3
# d : int = 6
# print(a//b) # floor division make sure that you get a whole number back when you divide
# print(6//4) # cuts the decimal part out
# print(c ** d)
# print(10%7) #modulas operator gives us the remainder
# #order of precedence
#
# x : int = 2
#
# x+=2 #x= x+2
# x-=2 #x= x-2
# x*=2 #x= x*2
#
# #Operators(Part 2)
# e: int = 2
# f: int = 3
# g: int = 4
# h: int = 4
#
# print(h==e) #false
# print(g==h) #true
# print (f!=g) #true
# print(f>e) #false
# print(f<h) #True
# print(f>=h) #False
# print(g>f>e) #chaining
#
# #Operators(Part 3)
# print(f>e and g==h)
# print(f<h and g==e) #both have to be true
# print(f==h or  g==e) #at least one is true
# print(not(c!=d))
#
# #Strings
# name: str = 'Charmane\'s'
# fruit: str = "apple"
# quote: str =" Quote - \"I love me \""
# print(name +" Beauty "+ fruit + quote)
# poem: str = """
# Roses are red,
# Violets are'nt orange
# I can't find my keys
# """
#
# print(poem)
#
# #Type Conversion
# txt_value: str = '100'
# int_value: int = 50
# print(int(txt_value)+ int_value)
# print(txt_value + str(int_value))
#
# print(type(5.5+1))
# print(int(5))
#
# #FUNCTIONS
# def greet():
#     print("Hello Bob")
# greet()
# greet()
# greet()

def show_time():
    now: datetime = datetime.now()
    print(f'Time : {now:%H:%M:%S}')

show_time()
time.sleep(5)
show_time()



