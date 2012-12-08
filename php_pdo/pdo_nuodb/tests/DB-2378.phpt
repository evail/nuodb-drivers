--TEST--
DB-2378 schema not specified.
--FILE--
<?php 
try {  
  $db = new PDO("nuodb:database=test@localhost", "dba", "goalie") or die;
  $sql = "drop table db_2378 if exists";
  $db->query($sql);
  $sql = "create table db_2378 (Name String)";
  $db->query($sql);
  $sql = "insert into db_2378(Name) values ('foo')";
  $db->query($sql);
  $sql = "select * from USER.db_2378";
  foreach ($db->query($sql) as $row) {
     print_r ($row);
  }
  $db = NULL;
} catch(PDOException $e) {  
  echo $e->getMessage();  
}
$db = NULL;  
echo "done\n";
?>
--EXPECT--
Array
(
    [NAME] => foo
    [0] => foo
)
done