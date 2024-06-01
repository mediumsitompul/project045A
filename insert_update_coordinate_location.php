<?php
//insert_data_live_location1.php

$timezone = "Asia/Jakarta";
if(function_exists('date_default_timezone_set')) date_default_timezone_set($timezone);

?>

<?php
include "connection.php";

$lat = $_POST['lat'];
$lng = $_POST['lng'];
$username = $_POST['username1'];
$name = $_POST['name1'];

$date = date('Y-m-d');
$time = date('H:i:s');


    if($lat != NULL) {
        
        $result2 = mysqli_query($conn, "
        
        insert into t_latlng_history_insert
        (date, time, datetime, lat, lng, username, name) 
        values ('$date', '$time', NOW(), '$lat', '$lng', '$username', '$name') 
        
        ");
        
        
        
        $result3 = mysqli_query($conn, "
        
        UPDATE t_latlng_update1 
        set lat='$lat', lng ='$lng', date='$date', time='$time', 
        datetime=NOW(), username=trim('$username'), name='$name'
        where username = '$username'
        
        ");

        echo json_encode('success');
        }else {
        echo json_encode('failed');
        }
?>

