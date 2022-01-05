# Database Engine USING BASH Script

Database engine that handles simple CRUD tasks on data stored in text files


## Features:
Database Operations:
* Create Database
* List Database
* Connect to Database
* Delete Database

Table Operations:
* Create New Table
* List Tables
* List Table Content
* Drop Table
* Insert Data Into Table
* Select Table Record
* update Table Record


### Supported Datatypes:
* String
* Integer

## How To Use:
```sh
$ ./maindb.sh
    then navigate through the menus
```
## Keep in mind:

* you cant use columns with string data type as your primary key
* you cant insert duplicated primary key or Null primary key
* you wont be able to select or update null values 
* you can enter null values if its string
* you cant insert null values for int columns (use 0 if u want to insert an int as null)
* you cant insert 0 for the PK 

## Contributors:
* [Hossam Abdulmageed](https://github.com/abdulmageed02)
* [Abdelrahman Nabil](https://github.com/AbdelrahmanNabill)


