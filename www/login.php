<?php
require 'vendor/autoload.php';

ini_set("display_errors", true);

session_start();
$r=session_id();
if (!empty($_POST)):
    $_SESSION['aws_id'] = $_POST['aws_id'];
    $_SESSION['aws_key'] = $_POST['aws_key'];
    $_SESSION['aws_credentials'] = new Aws\Credentials\Credentials ($_SESSION['aws_id'], $_SESSION['aws_key']);
    $client = new Aws\Iam\IamClient([
    'credentials' => $_SESSION['aws_credentials'],
    'region' => 'us-west-2',
    'version' => '2010-05-08'
    ]);
    $result = $client->getUser();
    $_SESSION['aws_username'] = $result['User']['UserName'];
endif; 
?>

<html>
    <head>
        <title><?php echo $_SESSION['aws_username']." ".$r; ?></title>
    </head>
    <body>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <table>
                <tr><td>aws_id:</td><td><input type="text" name="aws_id" value="<?php echo $_SESSION['aws_id']; ?>"></td></tr>
                <tr><td>aws_key:</td><td><input type="text" name="aws_key" value="<?php echo $_SESSION['aws_key']; ?>"></td></tr>
            </table>
            <input type="submit" value="Login">
            <button name="init" value="login" type="submit">AWS account login</button>
        </form>
    </body>
</html>
