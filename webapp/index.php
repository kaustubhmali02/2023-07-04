<html>

<head>
    <title>PHP Hello World!</title>
</head>

<body>
    <?php echo '<h1>Hello World</h1>'; ?>
    <!-- <?php phpinfo(); ?> -->
    <?php

    // Getting all env variables
    $db_host = $_SERVER['DB_HOST'];
    $db_user = $_SERVER['DB_USER'];
    $db_password = $_SERVER['DB_PASSWORD'];
    $db_name = $_SERVER['DB_NAME'];
    $connection = mysqli_connect("$db_host", "$db_user", "$db_password", "$db_name");
    $client_ip = $_SERVER['REMOTE_ADDR'];

    // Check connection
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        exit();
    } else {
        // INET_ATON() packs an IPv4 string representation into
        // four octets in a standard way.
        $query = "INSERT INTO events(client_ip)
          VALUES(INET_ATON('$client_ip'))";
        $connection->query($query);
        echo 'Your request has successfully created one database record.';
    }
    ?>
</body>

</html>