INSERT INTO Player (player_id, player_name) VALUES (1, 'GigaGamer#UA');
INSERT INTO Player (player_id, player_name) VALUES (2, 'Nagibator22822#WOW');

INSERT INTO Nickname (nickname_id, nickname, player_id) VALUES (1, 'GigaGamer', 1);
INSERT INTO Nickname (nickname_id, nickname, player_id) VALUES (2, 'Nagibator22822', 2);

INSERT INTO Character (character_id, character_name, kill_count, death_count, assist_count) VALUES (1, 'Kindred', 10, 5, 3);
INSERT INTO Character (character_id, character_name, kill_count, death_count, assist_count) VALUES (2, 'Jhin', 8, 3, 6);

INSERT INTO Runes (rune_id, rune_name) VALUES (1, 'Press the attack');
INSERT INTO Runes (rune_id, rune_name) VALUES (2, 'Dark Harvest');

INSERT INTO Items (item_id, item_name) VALUES (1, '3300');
INSERT INTO Items (item_id, item_name) VALUES (2, '3400');

INSERT INTO Gold (player_id, total_gold) VALUES (1, 3300);
INSERT INTO Gold (player_id, total_gold) VALUES (2, 3400);

INSERT INTO GoldGained (player_id, from_minions, from_jungle, from_kills) VALUES (1, 200, 2500, 800);
INSERT INTO GoldGained (player_id, from_minions, from_jungle, from_kills) VALUES (2, 2200, 100, 1200);

INSERT INTO PlayerTeam (player_id, team_color) VALUES (1, 'Blue');
INSERT INTO PlayerTeam (player_id, team_color) VALUES (2, 'Red');

INSERT INTO Teams (team_id, team_name) VALUES (1, 'Team_Blue');
INSERT INTO Teams (team_id, team_name) VALUES (2, 'Team_Red');

INSERT INTO Matches (match_id, match_date, winning_team_id, losing_team_id) VALUES (1, '2024-05-10 20:00:00', 1, 2);
INSERT INTO Matches (match_id, match_date, winning_team_id, losing_team_id) VALUES (2, '2024-05-10 20:00:00', 2, 1);

INSERT INTO PlayerStats (player_id, match_id, kills, deaths, assists) VALUES (1, 1, 6, 2, 5);
INSERT INTO PlayerStats (player_id, match_id, kills, deaths, assists) VALUES (2, 2, 12, 3, 6);

INSERT INTO MatchParticipants (match_id, player_id, team_id) VALUES (1, 1, 1);
INSERT INTO MatchParticipants (match_id, player_id, team_id) VALUES (1, 2, 2);