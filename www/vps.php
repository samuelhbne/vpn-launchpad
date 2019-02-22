<?php
require 'vendor/autoload.php';
//ini_set("display_errors", true);

session_start();
$r=session_id();
if ( empty($_SESSION['aws_credentials']) ):
    header ('Location: '.'/login.php');
endif;

$ec2Client = new Aws\Ec2\Ec2Client([
    'region' => 'ap-northeast-1',
    'version' => '2016-11-15',
    'credentials' => $_SESSION['aws_credentials']
]);
$result = $ec2Client->describeInstances();
$vpscount = sizeof ($result['Reservations']);
$tags=array();
for ($i=0; $i<$vpscount; $i++) {
    $tags[$i] = $ec2Client->describeTags([
        'Filters' => [
            [
                'Name' => 'resource-id',
                'Values' => [$result['Reservations'][$i]['Instances'][0]['InstanceId']],
            ],
        ],
    ]);
}
?>

<html>
<head>
    <title><?php echo $_SESSION['aws_username']." ".$r; ?></title>
</head>
<body>
  <table border="1">
      <tr>
          <td>InstanceId</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td><?php echo $result['Reservations'][$i]['Instances'][0]['InstanceId']; ?></td>
          <?php }?>
      </tr>
      <tr>
          <td>State</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td><?php echo $result['Reservations'][$i]['Instances'][0]['State']['Name']; ?></td>
          <?php }?>
      </tr>
      <tr>
          <td>InstanceType</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td><?php echo $result['Reservations'][$i]['Instances'][0]['InstanceType']; ?></td>
          <?php }?>
      </tr>
      <tr>
          <td>PublicIpAddress</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td><?php echo $result['Reservations'][$i]['Instances'][0]['PublicIpAddress']; ?></td>
          <?php }?>
      </tr>
      <tr>
          <td>LaunchTime</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td><?php echo $result['Reservations'][$i]['Instances'][0]['LaunchTime']; ?></td>
          <?php }?>
      </tr>
      <tr>
          <td>Tags</td>
          <?php for ($i=0; $i<$vpscount; $i++) {?>
              <td style="vertical-align:top">
                  <table border="1">
                      <?php for ($j=0; $j<sizeof($tags[$i]['Tags']); $j++) {?>
                          <tr>
                              <td><?php echo $tags[$i]['Tags'][$j]['Key'];?></td>
                              <td><?php echo $tags[$i]['Tags'][$j]['Value'];?></td>
                          </tr>
                      <?php }?>
                  </table>
              </td>
          <?php }?>
      </tr>
  </table>
</body>
</html>
