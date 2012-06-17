<?php 
// Test insert perpared statements.
try {  
  $db = new PDO("nuodb:database=test@localhost;schema=Hockey", "dba", "goalie") or die;
  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $position = NULL;
  $sql = "insert into hockey(NUMBER, NAME, POSITION, TEAM) values (101, 'Tom Gates', NULL, NULL)";
  $stmt = $db->prepare($sql);
  $stmt->execute();
  $db->commit();
  $sql = "select count(*) from hockey where POSITION = :position";
  $stmt = $db->prepare($sql);
  $stmt->bindParam(':position', $position, PDO::PARAM_STR);
  $stmt->execute();
  $result = $stmt->fetchAll();
  foreach ($result as $row) {
     print_r ($row);
  }
  $db = NULL;
} catch(PDOException $e) {  
  echo $e->getMessage();  
}
$db = NULL;  
echo "done\n";
?>
