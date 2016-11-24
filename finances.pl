#!/usr/bin/perl
use v5.24;
use strict;
use warnings;

use DBI;

my $dbfile = "finances.db";

my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

while(1){
    # system("clear");
    say "Spendings";
    say "---------";
    say "1. Display spendings.";
    say "2. Add spendings.";
    say "3. Delete spendings";
    say "";
    say "Earnings";
    say "--------";
    say "4. Display earnings.";
    say "5. Add earnings.";
    say "6. Delete earnings.";
    say "";
    say "Etc";
    say "---";
    say "7. Export to PDF.";
    say "";
    say "0. Exit.";
    print "> ";
    my $choice = <>;

    if($choice == 1) {
        printSpendings();
    } elsif($choice == 2) {
        addSpendings();
    } elsif($choice == 3) {
        deleteSpendings();
    } elsif($choice == 4) {
        printEarnings();
    } elsif($choice == 5) {
        addEarnings();
    } elsif($choice == 6) {
        deleteEarnings();
    } elsif($choice == 7) {
        exportToPDF();
    } elsif($choice == 0) {
        say "Thanks for using this program!";
        last;
    } else {
        say "Not a choice.";
    }
    say "";
}

# 1
sub printSpendings {
    my $sql = 'SELECT * FROM spendings ORDER BY spendDate';
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    printf("%30s %10s %10s %8s\n", "description", "amount", "date", "type");
    my $totalMoneySpent = 0;
    while (my @row = $sth->fetchrow_array) {
        # row 0 is id
        my $desc = sprintf("%30s", $row[1]);
        my $amount = sprintf("%10s", "\$$row[2]");
        my $date = sprintf("%10s", $row[3]);
        my $type = sprintf("%8s", $row[4]);
        say "$desc $amount $date $type";
        $totalMoneySpent += $row[2];
    }
    printf("%30s %10s\n", "Total money spent:", "\$$totalMoneySpent");
}

# 2
sub addSpendings{
    print "Enter a short description: ";
    my $desc= <>;
    chomp($desc);

    print "Enter the amount spent: ";
    my $amount = <>;
    chomp($amount);

    print "Enter the date in YYYY-MM-DD: ";
    my $date = <>;
    chomp($date);

    print "Enter the type: ";
    my $type = <>;
    chomp($type);

    $dbh->do('INSERT INTO spendings (desc, amount, spendDate, type) VALUES (?, ?, ?, ?)',
        undef,
        $desc, $amount, $date, $type);
}

#3
sub deleteSpendings{
    my $sql = 'SELECT * FROM spendings ORDER BY spendDate';
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    printf("%3s %30s %10s %10s %8s\n", "id", "desc", "amount", "date", "type");
    while (my @row = $sth->fetchrow_array) {
        my $id = sprintf("%3s", $row[0]);
        my $desc = sprintf("%30s", $row[1]);
        my $amount = sprintf("%10s", "\$$row[2]");
        my $date = sprintf("%10s", $row[3]);
        my $type = sprintf("%8s", $row[4]);
        say "$id $desc $amount $date $type";
    }

    say "Enter the id you wish to delete: ";
    my $id = <>;
    chomp($id);
    $dbh->do('DELETE FROM spendings WHERE id=?',
        undef,
        $id);
    say "Deleted.";
}

#4
sub printEarnings {
    #TODO
}

#5
sub addEarnings {
    #TODO
}

#6
sub deleteEarnings {

}

#7
sub exportToPDF {
    say "Work in progress";
}

$dbh->disconnect;
