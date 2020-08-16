NJIT Database proof of concept
Zach Barnhart

Setup Guide

Open command prompt and navigate to the folder where mysql.exe is installed
(C:\Program Files\MySQL\MySQL Server 8.0\bin on my machine), then execute
mysql -h localhost -u root -p

to open a MySQL session with the root account. Then type USE mysql, to select
the built-in database named mysql, which stores server information, such as
user accounts and their privileges for interacting with the server.
Now, create a user account with name ‘deitel’ to access and modify the database
we will create with njit.sql. To do this, we use the command

create user 'deitel'@'localhost' identified by 'deitel'; grant alter, select, insert, update, delete, create, drop, references, execute on *.* to 'deitel'@'localhost';

then exit the session with the root account by typing exit;

Then start a session with the user account we just created

mysql -h localhost -u deitel -p

and inputting the password when prompted. Copy njit.sql (attached) to the MySQL bin file path
(C:\Program Files\MySQL\MySQL Server 8.0\bin on my machine) and in the command prompt where
the deitel account mysql session has been opened, type

source njit.sql

and hit enter. It should create the njit database.Type exit; to close session.

Now, you can open MySQL Workbench and add some students to classes by adding rows to the register table, or you can leave it empty for now.
If you leave it empty, you will get a message about no results when you open the app for the first time. In any case, to run the app, compile and run the attached Java file.
Input a student ID number (e.g. 101, 102, 131, etc) and, unless you added students to classes earlier, you will get a message that says no results and the table will be empty.
If you already added students to classes and typed the student id of a student already enrolled, then that student's classes will appear. 
To enroll a student in another class, input the information for the class you want them to enroll in (you can find this information in MySQL Workbench or in njit.sql in the INSERT INTO sections),
and click "Add Class", and the class will show up on their schedule. 

Course Rosters work in a similar manner, but a valid staff id must be entered to look at course rosters.