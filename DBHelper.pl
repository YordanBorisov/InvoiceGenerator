#!/usr/bin/perl -w
 use DBI;
 use strict;
 
 sub getUserDetails
 {
	if (length(@_) != 1)
	{
		return;
	}
	my $dbh = DBI->connect('dbi:mysql:invoice','root','root')
	or die "Connection Error: $DBI::errstr\n";

	my $sql =   "select \n".
				"	u.name,\n".
				"	u.surname,\n".
				"	u.family,\n".
				"	u.address,\n".
				"	u.egn,\n".
				"	i.amount\n". 
				"from invoice i \n".
				"inner join users u on u.id = i.user_id\n".
				"where u.id = $_[0]\n".
				"union all\n".
				"select \n".
				"	u.name,\n".
				"	u.surname,\n".
				"	u.family,\n".
				"	u.address,\n".
				"	u.egn,\n".
				"	sum(i.amount) as amount\n".
				"from invoice i \n".
				"inner join users u on u.id = i.user_id\n".
				"where u.id = $_[0]\n".
				"group by i.user_id";

	my $sth = $dbh->prepare($sql);

	$sth->execute
	or die "SQL Error: $DBI::errstr\n";
	my @data;
	my $index = 0;
	while (my @row = $sth->fetchrow_array)
	{
		push(@data,\@row);
		
	} 
	
	$dbh->disconnect();
	return @data;
 };
1;
 
 