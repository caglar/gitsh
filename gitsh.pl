#!/usr/bin/env perl
package gitsh;

use strict;
use warnings;

use base qw(Term::Shell);

use constant PRE_VCS => "git";
use constant PRE_MAN => "man";

my $SilentMode = 0;

#A simple sub for concatenating the params in an array
sub concat_params {
    my $params = shift;
    my $param_conc = "";
    #replaced ugly map with foreach:
     foreach my $param (@$params) {
       if ($param =~ m/\s/) {
            $param = "\"$param\"";
       }
       $param_conc .= $param." ";
    }
    return $param_conc;
}

#Overriding the Term::Shell functions
sub prompt_str {
    "gitsh> "
}

sub run_silent {
   $SilentMode = !$SilentMode;
}

sub help_silent {
<<END;
 to run commands in shell in silent mode, also use it for toggle
on/off the print mode
END
}

sub run_bye {
    print "goodbye!\n";
    exit 1;
}

sub help_bye {
<<END;
to quit the shell
END
}

sub catch_run {
    my ($o, $cmd, @args) = @_;
    my $params =  &concat_params(\@args);
    if ($cmd eq "commit" and scalar @args eq 0) {
        print "Please run commit with -m parameter. Commit is quitted!\n";
    } else {
       $cmd = PRE_VCS." ".$cmd." ".$params;
       if ($SilentMode) {
           `$cmd`;
       } else {
           print `$cmd`;
       }
    }
}

sub catch_help {
    my ($o, $cmd, @args) = @_;
    my $params = join(" ", @args);
    if (length $cmd eq 0) {
        print "Please enter a git command like:\n";
        print<<STR;
   bye        to quit the shell
   silent     to run commands in shell in silent mode, also use it for toggle
on/off the print mode
   add        Add file contents to the index
   bisect     Find by binary search the change that introduced a bug
   branch     List, create, or delete branches
   checkout   Checkout a branch or paths to the working tree
   clone      Clone a repository into a new directory
   commit     Record changes to the repository
   diff       Show changes between commits, commit and working tree, etc
   fetch      Download objects and refs from another repository
   grep       Print lines matching a pattern
   init       Create an empty git repository or reinitialize an existing one
   log        Show commit logs
   merge      Join two or more development histories together
   mv         Move or rename a file, a directory, or a symlink
   pull       Fetch from and merge with another repository or a local branch
   push       Update remote refs along with associated objects
   rebase     Forward-port local commits to the updated upstream head
   reset      Reset current HEAD to the specified state
   rm         Remove files from the working tree and from the index
   show       Show various types of objects
   status     Show the working tree status
   tag        Create, list, delete or verify a tag object signed with GPG
STR
    } elsif ($cmd eq "git") {
        $cmd = PRE_MAN." ".$cmd;
    } else {
       $cmd = PRE_MAN." ".PRE_VCS."-".$cmd." ".$params;
    }
    `$cmd`;

}

package main;

use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use Data::Dumper;

my $shell = gitsh->new;

sub usage {
    print STDERR << "EOF";
    usage: $0 [-he]
    -h: this (help) message
    -e: to execute gitsh commands chained with semicolon
    example: $0 -e add -A; commit -m "Lorem ipsulum"
EOF
}

sub parse {
    my $str = shift;
    my @cmds = split ";", $str;
    return @cmds;
}

sub exec {
    my $cmds = shift;
    for my $cmd (@$cmds) {
        $shell->cmd($cmd);
    }
}

sub init {
    my $rtn = 1;
    my $help;
    my $execute;

    GetOptions(
        "help|h!" => \$help,
        "exec|e=s" => \$execute
    ) or die "Incorrect usage";

    if ($help) {
        &usage();
        $rtn = 0;
    }
    if ($execute) {
        my @gitsh_cmds = &parse($execute);
        &exec(\@gitsh_cmds);
        $rtn = 0;
    }
    return $rtn;
}

if (&init()) {
    $shell->cmdloop;
}

__END__

=head1 NAME

sample - Using Getopt::Long and Pod::Usage

=head1 SYNOPSIS

gitsh [options] [command...]

Options:
-help brief help message
-man full documentation

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something
useful with the contents thereof.
