CREATE DATABASE transports;
USE transports;

CREATE TABLE bus (
idx BIGINT NOT NULL AUTO_INCREMENT,
ddate_id BIGINT NOT NULL,
hours_id BIGINT NOT NULL,
passangers INT NOT NULL,
method_id BIGINT NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx),
KEY method_id (method_id),
KEY hours_id (hours_id),
KEY ddate_id (ddate_id),
CONSTRAINT bus_ibfk_1 FOREIGN KEY (method_id) REFERENCES method(idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT bus_ibfk_2 FOREIGN KEY (hours_id) REFERENCES hours(idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT bus_ibfk_3 FOREIGN KEY (ddate_id) REFERENCES calendar(idx) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE cablecar (
idx BIGINT NOT NULL AUTO_INCREMENT,
ddate_id BIGINT NOT NULL,
hours_id BIGINT NOT NULL,
passangers INT NOT NULL,
method_id BIGINT NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx),
KEY method_id (method_id),
KEY hours_id (hours_id),
KEY ddate_id (ddate_id),
CONSTRAINT cablecar_ibfk_1 FOREIGN KEY (method_id) REFERENCES method (idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT cablecar_ibfk_2 FOREIGN KEY (hours_id) REFERENCES hours (idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT cablecar_ibfk_3 FOREIGN KEY (ddate_id) REFERENCES calendar (idx) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE calendar (
idx BIGINT NOT NULL AUTO_INCREMENT,
ddates date NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx)
);
CREATE TABLE hours (
idx BIGINT NOT NULL AUTO_INCREMENT,
hours time NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx)
);
CREATE TABLE method (
idx BIGINT NOT NULL AUTO_INCREMENT,
method varchar(50) NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx)
);
CREATE TABLE metro (
idx BIGINT NOT NULL AUTO_INCREMENT,
ddate_id BIGINT NOT NULL,
hours_id BIGINT NOT NULL,
passangers INT NOT NULL,
method_id BIGINT NOT NULL,
PRIMARY KEY (idx),
UNIQUE KEY idx (idx),
KEY method_id (method_id),
KEY hours_id (hours_id),
KEY ddate_id (ddate_id),
CONSTRAINT metro_ibfk_1 FOREIGN KEY (method_id) REFERENCES method (idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT metro_ibfk_2 FOREIGN KEY (hours_id) REFERENCES hours (idx) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT metro_ibfk_3 FOREIGN KEY (ddate_id) REFERENCES calendar (idx) ON DELETE RESTRICT ON UPDATE CASCADE
);
