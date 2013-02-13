use PDF::Create;
use strict;
use open IO  => ":encoding(windows-1251)";
require 'DBHelper.pl';

sub createPDF
{
	if (length(@_) != 1)
	{
		return;
	}
	my $userid = int($_[0]);
	my @det = getUserDetails($userid);
	my $company = 'My Company';
	my $pdf = new PDF::Create('filename'     => 'invoice'.$userid.'.pdf',
							  'Version'      => 1.2,
							  'PageMode'     => 'UseOutlines',
							  'Author'       => $company,
							  'Title'        => 'Invoice',
							  'CreationDate' => [ localtime ],
						 );
	my $root = $pdf->new_page('MediaBox' => [ 0, 0, 612, 792 ]);

	my $page = $root->new_page;

	my $win = $pdf->font('Subtype'  => 'Type1',
						'Encoding' => 'WinAnsiEncoding',
						'BaseFont' => 'Helvetica');

	my $toc = $pdf->new_outline('Title' => 'Document',
								'Destination' => $page);

	$toc->new_outline('Title' => 'Page 1');
	
	my $offset = 526;
	my $name = $det[0][0].' '.$det[0][1].' '.$det[0][2];
	my $address = $det[0][3];
	my $pageNum = 2;
	my $index = 1;
	$page->string($win, 20, 90, $offset , "Name:$name");
	$page->string($win, 20, 90, $offset - 20 , "Address:$address");
	$offset -= 100;
	foreach my $row (@det)
	{	

		if ($index eq scalar(@det)  )
		{
			$page->string($win, 7, 100, $offset ,"Total ". @{$row}[5]);
			$page->line(100, $offset-1, 140, $offset-1);
			last;
		}
		$index++;
		
		if ($offset <= 0)
		{
			$page = $root->new_page;
			$toc = $pdf->new_outline('Title' => 'Document',
			'Destination' => $page);

			$toc->new_outline('Title' => 'Page '.$pageNum++);
			$offset = 782;
		}
		
		$page->string($win, 7, 100, $offset , @{$row}[5]);
		$page->line(100, $offset-1, 140, $offset-1);
		$offset -= 10;
		

		
	}
	$page->string($win, 5, 500, $offset - 10,
				   "Created by $company");

	
	$pdf->close;
};
1