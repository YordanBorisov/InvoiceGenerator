use Spreadsheet::WriteExcel;
use strict;

require 'DBHelper.pl';

sub createXLS
{
	if (length(@_) != 1)
	{
		return;
	}
	my $userid = int($_[0]);
	my @det = getUserDetails($userid);
	# Create a new Excel workbook
	my $workbook = Spreadsheet::WriteExcel->new("Invoice$userid.xls");
	$workbook->compatibility_mode();
	my $worksheet = $workbook->add_worksheet("Sheet 1");

	my $format = $workbook->add_format(num_format => '@'); # Add a format
	my $col = my $row = 0;
	my $number = 1;
	foreach my $rowData (@det)
	{	

		$worksheet->write_number($row++,$col, @{$rowData}[5]);
		if ($row eq 65536)
		{
			$workbook->compatibility_mode();
			$worksheet = $workbook->add_worksheet("Sheet $number++");
			$row = 0;
		}

	}
	
	$worksheet->write('A4', '=SIN(PI()/4)');
	$workbook->close();
};
1