#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate teams, games;" )
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then
# get winner id
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
if [[ -z $WINNER_ID ]]
then
# insert winner id if not found in teams
echo $($PSQL "insert into teams(name) values ('$WINNER')";)
# get new winner id
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
fi
# get opponent id
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
# insert opponent id if not found in teams
if [[ -z $OPPONENT_ID ]]
then
echo $($PSQL "insert into teams(name) values ('$OPPONENT');")
# get new opponent id
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
fi
# insert all data to games
echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)
;")
fi
done