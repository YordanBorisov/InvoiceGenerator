#!/usr/bin/perl
use HTTP::Daemon;
use HTTP::Status;
use URI::QueryParam;

require 'pdf_format.pl';
require 'xls_format.pl';
 
my $server = HTTP::Daemon->new(
         
         LocalPort => 8000,
     ) || die;
print "Server start at: <URL:", $server->url, ">\n";
while (my $client = $server->accept)
{
    while (my $request = $client->get_request)
	{
		if ($request->method eq 'GET')
		{
			if (defined($request))
			{
				
				my $uri   = URI->new($request->url);
				
				my $doc =  $uri->query_param("doc");
				my $userid = int($uri->query_param("userid"));
				my $status = "";
				if ($doc eq "pdf")
				{
					createPDF($userid);
					$status = "PDF ready";
					$client->send_response("Content-type: text/html\n\n$status");
				}
				elsif ($doc eq "xls")
				{
					createXLS($userid);
					$status = "Excel ready";
					$client->send_response("Content-type: text/html\n\n$status");
				}else
				{
					$status = "Invalid document type!";
					$client->send_response("Content-type: text/html\n\n$status");
				}
			}
        }
        else {
            $client->send_error(RC_FORBIDDEN)
        }
    }
    $client->close;
    undef($client);
}