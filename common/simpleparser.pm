# $Id$

package SimpleParser;

use strict;
use FileHandle;

###############################################################################
# Constructor

sub new  
{
    my $proto = shift;
    my $class = ref ($proto) || $proto;
    my $self = {};
    
    bless ($self, $class);
    return $self;
}

###############################################################################
# Methods

sub Parse ($\%)
{
    my $self = shift;
    my $file = shift;
    my $data = shift;
    
    my $file_handle = new FileHandle ($file, 'r');
    
    if (!defined $file_handle) {
        print STDERR "Error: Could not open file <$file>: $!\n";
        return 0;
    }
    
    my $state = 'none';
        
    while (<$file_handle>) {
        chomp;
        
        # Ignore comments and blank lines
        s/<!--(.*?)-->//g;
        next if (m/^\s*$/);
        
        if ($state eq 'none') {
            if (m/^\s*<verifybuild>\s*$/i) {
                $state = 'verifybuild';
            }
            elsif (m/^\s*<\?.*\?>\s*/i) {
                # ignore
            }
            else {
                print STDERR "Error: Unexpected in state <$state>: $_\n";
                return 0;
            }
        }
        elsif ($state eq 'verifybuild') {
            if (m/^\s*<\/verifybuild>\s*$/i) {
                $state = 'none';
            }
            elsif (m/^\s*<configuration>\s*$/i) {
                $state = 'configuration';
            }
            elsif (m/^\s*<command\s*name\s*=\s*"(.*?)"\s*options\s*=\s*"(.*?)"\s*\/\s*>\s*$/i) {
                my %value;
                
                %value->{NAME} = $1;
                %value->{OPTIONS} = $2;
                
                push @{$data->{COMMANDS}}, \%value;
            }
            elsif (m/^\s*<command\s*name\s*=\s*"(.*?)"\s*\/\s*>\s*$/i) {
                my %value;
                
                %value->{NAME} = $1;
                %value->{OPTIONS} = '';
                
                push @{$data->{COMMANDS}}, \%value;
            }
            else {
                print STDERR "Error: Unexpected in state <$state>: $_\n";
                return 0;
            }
        }
        elsif ($state eq 'configuration') {
            if (m/^\s*<\/configuration>\s*$/i) {
                $state = 'verifybuild';
            }
            elsif (m/^\s*<variable\s*name\s*=\s*"(.*?)"\s*value\s*=\s*"(.*?)"\s*\/\s*>\s*$/i) {
                $data->{VARS}->{$1} = $2;
            }
            elsif (m/^\s*<environment\s*name\s*=\s*"(.*?)"\s*value\s*=\s*"(.*?)"\s*\/\s*>\s*$/i) {
                my %value;
                
                %value->{NAME} = $1;
                %value->{VALUE} = $2;
                
                push @{$data->{ENVIRONMENT}}, \%value;
            }
            else {
                print STDERR "Error: Unexpected in state <$state>: $_\n";
                return 0;
            }
        }
        else {
            print STDERR "Error: Parser reached unknown state <$state>\n";
            return 0;
        }
    }
    
    return 1;
}

1;