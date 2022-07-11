#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Clear the database
echo Clear the database "$($PSQL "truncate table games,teams")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do


if [[ $WINNER != 'winner' ]]
then
  echo $WINNER $OPPONENT

#get team_id for winner and opponent and insert into database worldcup, table teams

  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
# if winner not found
if [[ -z $WINNER_ID ]]
then
  INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
  if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
  then
    echo "-->"Inserted into teams, $WINNER
  fi
#get new team id from winner
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
else echo ***Team $WINNER already in database
fi

#check opponent
if [[ -z $OPPONENT_ID ]]
then
  INSERT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
  if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
  then
    echo "-->"Inserted into teams, $OPPONENT
  fi
  #get new team id for opponent
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
else echo ***Team $OPPONENT already in database
fi

#insert data into games table;
INSERT_GAME=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
if [[ $INSERT_GAME == "INSERT 0 1" ]]
then
  echo '+++'Game added in database
fi



fi












done
