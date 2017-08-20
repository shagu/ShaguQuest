# Fetch Databases

### ClassicDB: (Core Entries)
    git clone https://github.com/cmangos/classic-db.git classicdb

### Elysium: (Translations)
    git clone https://github.com/elysium-project/database.git elysiumdb

# Create Database Structure
    CREATE USER 'mangos'@'localhost' IDENTIFIED BY 'mangos';
    CREATE DATABASE `mangos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
    CREATE DATABASE `elysium` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES, EXECUTE, ALTER ROUTINE, CREATE ROUTINE ON `mangos`.* TO 'mangos'@'localhost';
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES, EXECUTE, ALTER ROUTINE, CREATE ROUTINE ON `elysium`.* TO 'mangos'@'localhost';

# Import Databases
    mysql -u mangos -p mangos -h 127.0.0.1 < classicdb/Full_DB/ClassicDB*.sql
    mysql -u mangos -p elysium -h 127.0.0.1 < elysiumdb/world_full_02032017.sql
    mysql -u mangos -p mangos -h 127.0.0.1 < aowow.sql

# Extract Data
### Extract Specific Localizations (3=german)

    ./itemDB.php 3
    ./questDB.php 3
    ./vendorDB.php 3
    ./spawnDB.php 3
    ./zoneDB.php 3

### Build Every Database

    ./itemDB.php
    ./questDB.php
    ./vendorDB.php
    ./spawnDB.php
    ./zoneDB.php

or

    make db
