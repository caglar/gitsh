#!/bin/bash -x
perl -MCPAN -e "install Term::Shell"
chmod +x ./gitsh.pl
cp ./gitsh.pl /usr/bin/gitsh
