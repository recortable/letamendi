    echo Script to convert MySQL latin1 charsets to utf8.
    echo Usage: $0 dbname
    echo 060329 yky Created.

    echo Dumping out $1 database
    mysqldump --add-drop-table $1 > db.sql

    mydate=`date +%y%m%d`
    echo Making a backup
    mkdir bak &> /dev/null
    cp db.sql bak/$1.$mydate.sql

    echo String replacing latin1 with utf8
    cat db.sql | replace CHARSET=latin1 CHARSET=utf8 > db2.sql

    echo Pumping back $1 into database
    mysql $1 < db2.sql

    echo Changing db charset to utf8
    mysql $1 -e "alter database $1 charset=utf8;"

    echo $1 Done!

