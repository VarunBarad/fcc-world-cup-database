#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Read and add all teams
while IFS="," read -r rec_year rec_round rec_winner rec_opponent rec_winner_goals rec_opponent_goals
do
  echo "$($PSQL "insert into teams(name) values('$rec_winner') on conflict (name) do nothing")"
  echo "$($PSQL "insert into teams(name) values('$rec_opponent') on conflict (name) do nothing")"
done < <(tail -n +2 games.csv)

# Read and add all games
while IFS="," read -r rec_year rec_round rec_winner rec_opponent rec_winner_goals rec_opponent_goals
do
  WINNER_ID=$($PSQL "select team_id from teams where name='$rec_winner'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$rec_opponent'")
  echo "$($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($rec_year, '$rec_round', $rec_winner_goals, $rec_opponent_goals, $WINNER_ID, $OPPONENT_ID)")"
done < <(tail -n +2 games.csv)
