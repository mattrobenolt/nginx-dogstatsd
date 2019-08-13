nginx-dogstatsd
===============

An nginx module for sending statistics to dogstatsd.

This is how to use the nginx-dogstatsd module:

	http {

		# Set the server that you want to send stats to.
		dogstatsd_server your.dogstatsd.server.com;

		# Randomly sample 10% of requests so that you do not overwhelm your dogstatsd server.
		# Defaults to sending all dogstatsd (100%).
		dogstatsd_sample_rate 10; # 10% of requests


		server {
			listen 80;
			server_name www.your.domain.com;

			# Increment "your_product.requests" by 1 whenever any request hits this server.
			dogstatsd_count "your_product.requests" 1;

			location / {

				# Increment the key by 1 when this location is hit.
				dogstatsd_count "your_product.pages.index_requests" 1;

				# Increment the key by 1 when this location is hit with a tag based on a variable
				dogstatsd_count "your_product.pages.index_requests" 1 "server:$server_name";

				# Increment the key by 1, but only if $request_completion is set to something.
				dogstatsd_count "your_product.pages.index_responses" 1 "" "$request_completion";

				# Send a timing to "your_product.pages.index_response_time" equal to the value
				# returned from the upstream server. If this value evaluates to empty-string
				# it will not be sent. Thus, there is no need to add a test. 0 values are sent as timings since they are significant.
				dogstatsd_timing "your_product.pages.index_response_time" "$upstream_response_time";

				# Increment a key based on the value of a custom header. Only sends the value if
				# the custom header exists in the upstream response.
				dogstatsd_count "your_product.custom_$upstream_http_x_some_custom_header" 1 ""
					"$upstream_http_x_some_custom_header";

				proxy_pass http://some.other.domain.com;
			}
		}
	}
