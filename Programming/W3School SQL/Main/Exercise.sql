CREATE TABLE IF NOT EXISTS sai_sakthi(rollNo int(100), FirstName varchar(100), LastName varchar(100), Contact int(100));

INSERT INTO sai_sakthi VALUES(1001, "sai", "sakthi", 1021212232);

ALTER TABLE sai_sakthi
DROP Contact;

ALTER TABLE sai_sakthi
MODIFY rollNo float;

ALTER TABLE sai_sakthi
ADD PRIMARY KEY (rollNo);

TRUNCATE TABLE sai_sakthi;

SELECT * FROM sai_sakthi;

ALTER TABLE sai_sakthi
ADD INDEX (rollNo);

SELECT * FROM sai_sakthi;

INSERT INTO sai_sakthi VALUES (1002, "Karthik", "Vasan");

SELECT * FROM sai_sakthi;

CREATE INDEX idx_No ON sai_sakthi(rollNo);

SELECT *  FROM sai_sakthi;

RENAME TABLE sai_sakthi TO saisakthi_;

SELECT * FROM saisakthi_;