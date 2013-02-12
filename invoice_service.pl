#!/usr/bin/perl
use HTTP::Daemon;
use HTTP::Status;
use URI::QueryParam;
require 'DBHelper.pl';
 
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
				
				print $uri->query_param("doc");
				my $userid = int($uri->query_param("userid"));
				my @det = getUserDetails($userid);
				my $response = "";
				foreach my $row (@det)
				{
					$response .= join(" ",@{$row})."\n";
				}
				$client->send_response("Content-type: text/html\n\n$response");
			}
        }
        else {
            $client->send_error(RC_FORBIDDEN)
        }
    }
    $client->close;
    undef($client);
}