<?php 
session_name("onlyone");
session_start();
if(isset($_SESSION['usuario'])):
  header('Location: index.php?c=app&a=dashboard');
endif;
?>

<!DOCTYPE html>
<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Login - OnlyOne</title>

  <!-- Custom fonts for this template-->
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
  <link rel="Shortcut Icon" type="image/x-icon" href="assets/img/logo_onlyone.ico" />
  <!-- Custom styles for this template-->
  <link href="assets/css/sb-admin-2.min.css" rel="stylesheet">
  <link rel="stylesheet" href="assets/css/login.css">

</head>