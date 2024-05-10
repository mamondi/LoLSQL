CREATE DATABASE IF NOT EXISTS db_LoLSQL;
USE db_LoLSQL;

CREATE TABLE IF NOT EXISTS Player (
  player_id INT PRIMARY KEY NOT NULL,
  player_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Nickname (
  nickname_id INT PRIMARY KEY NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  player_id INT,
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

CREATE TABLE IF NOT EXISTS Character (
  character_id INT PRIMARY KEY NOT NULL,
  character_name VARCHAR(50) NOT NULL,
  kill_count INT DEFAULT 0 CHECK (kill_count >= 0),
  death_count INT DEFAULT 0 CHECK (death_count >= 0),
  assist_count INT DEFAULT 0 CHECK (assist_count >= 0)
);

CREATE TABLE IF NOT EXISTS Runes (
  rune_id INT PRIMARY KEY NOT NULL,
  rune_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Items (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Gold (
  player_id INT PRIMARY KEY,
  total_gold INT NOT NULL CHECK (total_gold >= 0),
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

CREATE TABLE IF NOT EXISTS GoldGained (
  player_id INT,
  from_minions INT CHECK (from_minions >= 0),
  from_jungle INT CHECK (from_jungle >= 0),
  from_kills INT CHECK (from_kills >= 0),
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

CREATE TABLE IF NOT EXISTS PlayerTeam (
  player_id INT,
  team_color VARCHAR(10) CHECK (team_color IN ('Blue', 'Red')),
  FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

CREATE TABLE IF NOT EXISTS Teams (
  team_id INT PRIMARY KEY,
  team_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Matches (
  match_id INT PRIMARY KEY,
  match_date DATETIME NOT NULL,
  winning_team_id INT,
  losing_team_id INT,
  FOREIGN KEY (winning_team_id) REFERENCES Teams(team_id),
  FOREIGN KEY (losing_team_id) REFERENCES Teams(team_id)
);

CREATE TABLE IF NOT EXISTS PlayerStats (
  player_id INT,
  match_id INT,
  kills INT CHECK (kills >= 0),
  deaths INT CHECK (deaths >= 0),
  assists INT CHECK (assists >= 0),
  PRIMARY KEY (player_id, match_id),
  FOREIGN KEY (player_id) REFERENCES Player(player_id),
  FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

CREATE TABLE IF NOT EXISTS MatchParticipants (
  match_id INT,
  player_id INT,
  team_id INT,
  PRIMARY KEY (match_id, player_id),
  FOREIGN KEY (match_id) REFERENCES Matches(match_id),
  FOREIGN KEY (player_id) REFERENCES Player(player_id),
  FOREIGN KEY (team_id) REFERENCES Teams(team_id),
  FOREIGN KEY (match_id, team_id) REFERENCES Matches(match_id, winning_team_id)
);

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CreateNewPlayer(
    IN player_name VARCHAR(50)
)
BEGIN
    DECLARE new_player_id INT;

    INSERT INTO Player (player_name) VALUES (player_name);
    SET new_player_id = LAST_INSERT_ID();

    INSERT INTO Nickname (nickname, player_id) VALUES (CONCAT('Player_', new_player_id), new_player_id);

    INSERT INTO PlayerStats (player_id, match_id, kills, deaths, assists)
    VALUES (new_player_id, 0, 0, 0, 0);
END//

CREATE PROCEDURE IF NOT EXISTS RemoveInactivePlayers()
BEGIN
    DECLARE player_id INT;
    DECLARE last_activity DATE;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT player_id, MAX(match_date) FROM Matches GROUP BY player_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    fetch_loop: LOOP
        FETCH cur INTO player_id, last_activity;
        IF done THEN
            LEAVE fetch_loop;
        END IF;

        IF last_activity < DATE_SUB(NOW(), INTERVAL 6 MONTH) THEN
            DELETE FROM Player WHERE player_id = player_id;
            DELETE FROM PlayerStats WHERE player_id = player_id;
            DELETE FROM Gold WHERE player_id = player_id;
            DELETE FROM MatchParticipants WHERE player_id = player_id;
            DELETE FROM Nickname WHERE player_id = player_id;
        END IF;
    END LOOP;

    CLOSE cur;
END//

CREATE PROCEDURE IF NOT EXISTS AddNickname(IN player_id_param INT, IN nickname_param VARCHAR(50))
BEGIN
    INSERT INTO Nickname (nickname, player_id) VALUES (nickname_param, player_id_param);
END//

CREATE TRIGGER IF NOT EXISTS AddNicknameTrigger
AFTER INSERT ON Player
FOR EACH ROW
BEGIN
    DECLARE new_nickname VARCHAR(50);
    SET new_nickname = CONCAT('Player_', NEW.player_id);
    CALL AddNickname(NEW.player_id, new_nickname);
END//

DELIMITER ;
