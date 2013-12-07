$title=Email Sending Checklist

#### Setup

Things most mail servers demand/require to ensure delivery:

+ rDNS of sender IP matches sender domain and/or SPF record
+ SPF record allows mail server to send mail for domain – see: wwwhttp://en.wikipedia.org/wiki/Sender_Policy_Framework
+ Setup DKIM/DomainKeys on DNS server + email server – see: our guide for DKIM and Postfix


#### Test

Send emails to either (or both) of these emails to test SFP records & other things

+ check-auth@verifier.port25.com
+ spf-test@openspf.org (the email will bounce, look for test ="pass" in the response error)