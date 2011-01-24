#!/bin/sh

curl -s -o "/usr/local/bin/gitsh" https://github.com/caglar/gitsh/raw/master/gitsh.pl

if [ $? -ne 0 ] ; then
	echo "Error occurred getting URL /usr/local/bin/gitsh:"
	if [ $? -eq 6 ]; then
		echo "Unable to resolve host\n"
	fi
	if [$? -eq 7 ]; then
		echo "Unable to connect to host\n"
	fi
	exit 1
fi

if [ -f "/usr/local/bin/gitsh" ] ; then
	chmod +x /usr/local/bin/gitsh
fi

perl -MTerm::Shell -e 1 &> /dev/null

if [ $? -ne 0 ] ; then
	echo "Perl Module Term::Shell is not installed!"
	perl -MCPAN -e "install Term::Shell"
fi
