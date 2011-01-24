#!/bin/sh

perl -MCPAN -e "install Term::Shell"

chmod +x /usr/local/bin/gitsh
cp ./gitsh.pl /usr/bin/gitsh
