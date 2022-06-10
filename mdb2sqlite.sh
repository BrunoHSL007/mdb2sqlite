#!/bin/bash

# Warning: this script remove your .csv files in the current folder, so keep your backup in another folder
# To run it you need to install:
# sudo apt install sqlite3
# sudo apt install mdbtools

# Usage: ./mdb2sqlite.sh <input.c01> <output(AutoComplete with Database.sqlite)>
caminho_arquivo=$1;
nome_fabricante=$2'Database.sqlite';
shift

# Remove files to avoid conflicts
rm -f *.csv
rm -f $nome_fabricante
rm -f *.sqlitesh

# Convert from .mdb to .csv
mdb-tables -1 $caminho_arquivo | xargs -I{} bash -c 'mdb-export '$caminho_arquivo' '{}' > '{}'.csv' -- {}

# Convert from .csv to .sqlite
echo '.mode csv' > sqliteexec.sqlitesh
mdb-tables -1 $caminho_arquivo | xargs -I{} echo '.import '{}'.csv '{} >> sqliteexec.sqlitesh
sqlite3 $nome_fabricante '.read sqliteexec.sqlitesh'

# Remove files used in the process
rm -f *.csv 
rm -f *.sqlitesh
