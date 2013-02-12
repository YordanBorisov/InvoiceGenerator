use PDF::Create;
use strict;
use open IO  => ":encoding(windows-1251)";

sub createPDF
{
	if (length(@_) != 1)
	{
		return;
	}
	my $company = 'My Company';
	my $pdf = new PDF::Create('filename'     => 'invoice'.$_[0].'.pdf',
							  'Version'      => 1.2,
							  'PageMode'     => 'UseOutlines',
							  'Author'       => $company,
							  'Title'        => 'Invoice',
							  'CreationDate' => [ localtime ],
						 );
	my $root = $pdf->new_page('MediaBox' => [ 0, 0, 612, 792 ]);

	# Add a page which inherits its attributes from $root
	my $page = $root->new_page;

	# Prepare 2 fonts
	my $win = $pdf->font('Subtype'  => 'Type1',
						'Encoding' => 'WinAnsiEncoding',
						'BaseFont' => 'Helvetica');
	my $utf = $pdf->font('Subtype'  => 'Type1',
						'Encoding' => 'WinAnsiEncoding',
						'BaseFont' => 'Helvetica-Bold');

	# Prepare a Table of Content
	my $toc = $pdf->new_outline('Title' => 'Document',
								'Destination' => $page);
	$toc->new_outline('Title' => 'Page 1');
	my $s2 = $toc->new_outline('Title' => 'Section 2',
							   'Status' => 'closed');
	

	$page->stringc($win, 40, 306, 426, "PDF::Create");
	$page->stringc($utf, 20, 306, 396, "version $PDF::Create::VERSION");

	# Add another page
	my $page2 = $root->new_page;
	$page2->line(0, 0, 612, 792);
	$page2->line(0, 792, 612, 0);

	$toc->new_outline('Title' => 'Section 3');
	$pdf->new_outline('Title' => 'Summary');

	# Add something to the first page
	$page->stringc($win, 20, 306, 300,
				   "Създанена от $company");

	# Add the missing PDF objects and a the footer then close the file
	$pdf->close;
};
createPDF(2);
1