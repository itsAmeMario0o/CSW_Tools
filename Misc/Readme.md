Delete Agent v1.1
usage: delete_agent.py [-n <hostname> / -f <filename>] [-s <scope>] 
[-v][-h]
Delete agent hostname specified by required -n flag.
Optional -s flag specifies scope name to target in agent query.  If this 
flag is unspecified, 'Default' will be used.
Optional -v flag enables debugging output.
-f flag with filename specifies input filename (one hostname per line); if 
used, -n flag is ignored.
Either -f flag with filename or -n with single hostname option must be 
used, but not both simultaneously.
-h flag prints this usage.
