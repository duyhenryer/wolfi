#!/usr/bin/env php
<?php

if (php_sapi_name() !== 'cli') {
    exit;
}

require '/usr/share/php/minicli/minicli';

$app = new Minicli\App();
$app->setSignature('minicli <command>');

$app->registerCommand('welcome', function (Minicli\Command\CommandCall $input) {
    echo "Welcome to Minicli on Wolfi!\n";
});

$app->runCommand($input->getArgv());