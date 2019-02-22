<?php

require 'vendor/autoload.php';

use Aws\Ec2\Ec2Client;

$credentials = new Aws\Credentials\Credentials('xxxxxxxxxxxxxxx', 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');


$ec2Client = new Ec2Client([
    'region' => 'ap-northeast-1',
    'version' => '2016-11-15',
    //'profile' => 'default'
    'credentials' => $credentials
]);

$result = $ec2Client->describeInstances();
$vpscount = sizeof ($result['Reservations']);
//var_dump($result['Reservations']);
for ($i=0; $i<$vpscount; $i++) {
    $tag[$i] = $ec2Client->describeTags([
        'Filters' => [
            [
                'Name' => 'resource-id',
                'Values' => [$result['Reservations'][$i]['Instances'][0]['InstanceId']],
            ],
        ],
    ]);
    var_dump ($tag[$i]);
    var_dump $tag[$i]['Tags'];
}


$client = new Aws\Iam\IamClient([
    //'profile' => 'default',
    'credentials' => $credentials,
    'region' => 'us-west-2',
    'version' => '2010-05-08'
]);

/*
try {
    $result = $client->getUser(
        array('UserName' => 'samuel.huang',));
    var_dump($result);
} catch (Aws\Exception\AwsException $e) {
    // output error message if fails
    error_log($e->getMessage());
}
*/
