#!/bin/bash -x
perl -MCPAN -e "install Term::Shell"
perl -MCPAN -e "install Getopt::Std"
chmod +x ./gitsh.pl
cp ./gitsh.pl /usr/bin/gitsh
