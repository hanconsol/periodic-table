#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table  -t --no-align -c"
MAIN () {
if [[ -z $1 ]]
then
  echo Please provide an element as an argument. 
else
# if input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
# assign variable to atomic number query using arg

ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number =$1")
# if doesn't exists 
if [[ -z $ELEMENT ]]
then 
  FAILED
 else
# pipe output variables

# print output
  SUCCESS
fi
# if it's not a number
else 
# else assign variable to symbol or name query using arg
ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
# if doesn't exists 
if [[ -z $ELEMENT ]]
then 
  FAILED
else
# pipe output variables
# print output
  SUCCESS

fi
fi
fi
}
FAILED() {
echo I could not find that element in the database.
exit
}
SUCCESS() {
 echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER  NAME  SYMBOL  TYPE  ATOMIC_MASS  MELTING_POINT  BOILING_POINT
 do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
 
 done 
}
MAIN $1