<?php 
/**
 * 
 */
require_once "utility.php";
class crudModel 
{
   public $conn;

   function __construct()
   {
       $this->conn = new conn();
   }
    
   

    public function insertIntoTable($tableName, $params){
    $columns=array_keys($params);
    $values=array_values($params);
 $query ="INSERT INTO $tableName (".implode(',',$columns).") VALUES ('" . implode("', '", $values) . "' )";
 $result = $this->conn->connect->query($query);
 if($result){
    return  array("status"=>true,"msg"=>"successful"); 
 }else{
    return  array("status"=>false,"msg"=>$this->conn->connect->error); 
 }

}


public function selectFromTable($tableName,$fields = '*',$whereAgs=""){
    $query = null;

    if($whereAgs != ""){
        $query  = "SELECT $fields from $tableName ".$whereAgs;

    }else{
        $query  = "SELECT $fields from $tableName";

    }

    $result = $this->conn->connect->query($query);
    if($result){
        //return array("status"=>true,"msg"=>"ooo");
       $num = mysqli_num_rows($result);
       if($num > 0){
         $allRows = array();
        while ($row = $result->fetch_array()){
            if(isset($row['date'])){$row['date'] = utility::timeago($row['date']);}
            array_push($allRows,$row);
            //return array("status"=>true,"msg"=>$row);
            
        }
        return array("status"=>true,"msg"=>$allRows);
       }else{
        return  array("status"=>false,"msg"=>"0 row"); 
    }
    
    }else{
        return  array("status"=>false,"msg"=>$this->conn->connect->error); 
    }



}

public function deleteFromTable($tableName,$whereAgs){
    $query = "DELETE FROM $tableName ". $whereAgs;
    $result = $this->conn->connect->query($query);
    if($result){
        return  array("status"=>true,"msg"=>"successful");
    }else{
        return array("status"=>false,"msg"=>$this->conn->connect->error);
    }

}

public function updateTable($table,$params,$whereArgs) {
    $column_value = '';
    $x = 1;

    foreach($params as $column => $value) {
        $column_value .= "{$column} = \"{$value}\"";
        if($x < count($params)) {
            $column_value .= ',';
        }
        $x++;
    }

    $sql = "UPDATE {$table} SET {$column_value} ".$whereArgs;
    $result = $this->conn->connect->query($sql);

    if($result) {
       return array("status"=>true,"msg"=>"successful");
    }

    return array("status"=>false,"msg"=>$this->conn->connect->error); 
}

public function uploadImage($file){

    // Check if file was uploaded without errors
    if(isset($_FILES["photo"]) && $_FILES["photo"]["error"] == 0){
        $allowed = array("jpg" => "image/jpg", "jpeg" => "image/jpeg", "gif" => "image/gif", "png" => "image/png");
        $filename = $file["name"];
        $filetype = $file["type"];
        $filesize = $file["size"];
    
        // Verify file extension
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        if(!array_key_exists($ext, $allowed)){
            return array("status"=>false,"msg"=>"Error: Please select a valid file format.");
        } 
    
        // Verify file size - 5MB maximum
        $maxsize = 5 * 1024 * 1024;
        if($filesize > $maxsize){
            return array("status"=>false,"msg"=>"Error: File size is larger than the allowed limit.");
        
        }
    
        // Verify MYME type of the file
        if(in_array($filetype, $allowed)){
            // Check whether file exists before uploading it
            if(file_exists("upload/" . $filename)){
               return array("status"=>false,"msg"=>"File name already exist.");
            } else{
                move_uploaded_file($file["tmp_name"], "upload/" . $filename);
                return array("status"=>true,"msg"=>"Your file was uploaded successfully.","filename"=>$filename);
            } 
        } else{
            return array("status"=>false,"msg"=>"Error: There was a problem uploading your file. Please try again.");
             
        }
    } else{
        return array("status"=>false,"msg"=>"Error: ".$_FILES["photo"]["error"]);
             
        //echo "Error: " . $_FILES["photo"]["error"];
    }

}


}


?>