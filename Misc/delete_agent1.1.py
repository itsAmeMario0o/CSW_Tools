#!/usr/bin/env python3
"""
Delete Agent v1.1 - delete Cisco Secure Workload / Tetration agents individually or in bulk

usage: delete_agent.py [-n <hostname> / -f <filename>] [-s <scope>] [-v][-h]
Delete agent hostname specified by required -n flag.
Optional -s flag specifies scope name to target in agent query.  If this flag is unspecified, 'Default' will be used.
Optional -v flag enables debugging output.
-f flag with filename specifies input filename (one hostname per line); if used, -n flag is ignored.
Either -f flag with filename or -n with single hostname option must be used, but not both simultaneously.
-h flag prints this usage.
"""
from tetpyclient import RestClient
# this file is imported from credential.py and should be modified with your credentials
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json
import sys
import getopt
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

host_name = None
scope_name = "Default"
filename = None

debug = 0
run = 0

def main(host_name, scope_name, filename):
  if debug == 1:
    print("Hostname is: ", host_name)
    print("Scope name is: ", scope_name)
    print("Filename is: ", filename)

  if filename is not None:
    if host_name is not None:
      print("Ignoring hostname specified with -n flag, processing hostnames from filename instead.")
    with open(filename) as filename:
      try:
        for line in filename:
          host_name = line.strip()
          uuid = find_agent(host_name, scope_name)
          if not uuid:
            print ("Agent {} not found.".format(host_name))
          else:
            print ("Found agent {} with UUID of {}".format(host_name, uuid))
            delete_agent(uuid)
      except Exception as excp: 
        print(excp)

  elif host_name is not None and filename is None: 
    uuid = find_agent(host_name, scope_name)
    if not uuid:
      print ("Agent {} not found.".format(host_name))
    else:
      print ("Found agent {} with UUID of {}".format(host_name, uuid))
      delete_agent(uuid)

  elif host_name is None and filename is None:
    usage()

  else:
    usage()

def usage():
  print ("Delete Agent v1.1")
  print ("usage: delete_agent.py [-n <hostname> / -f <filename>] [-s <scope>] [-v][-h]")  
  print ("Delete agent hostname specified by required -n flag.")
  print ("Optional -s flag specifies scope name to target in agent query.  If this flag is unspecified, 'Default' will be used.")
  print ("Optional -v flag enables debugging output.") 
  print ("-f flag with filename specifies input filename (one hostname per line); if used, -n flag is ignored.")
  print ("Either -f flag with filename or -n with single hostname option must be used, but not both simultaneously.")
  print ("-h flag prints this usage.") 

def find_agent(host_name, scope_name):

  CURRENT_POST_ENDPOINT = '/inventory/search'
  CURRENT_POST_PAYLOAD = {
    "filter": {
      "type": "and",
      "filters": [
      {"type": "contains", "field": "hostname", "value": host_name}
      ]
    },
    "scopeName": scope_name,
    "limit": 1000
  }

  try:
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)    
    resp = rc.post(CURRENT_POST_ENDPOINT, json_body=json.dumps(CURRENT_POST_PAYLOAD))
    if debug == 1:
      print (resp.status_code)
    if resp.status_code == 200:
      subresp = resp.json()   
      if debug == 1:
        print ("Response: ", subresp)    
      for entry in subresp['results']:
        uuid = (entry['host_uuid'])
        if debug == 1:
          print ("uuid is", uuid)
          parsed_resp = json.loads(resp.content)
          print (json.dumps(parsed_resp, indent=4, sort_keys=True))
        if not uuid:
          pass
        else:
          return uuid

  except:
    usage()
    sys.exit(2)

def delete_agent(uuid):

  CURRENT_POST_ENDPOINT = '/sensors/' + uuid

  if debug == 1:
    print (uuid)
    print (CURRENT_POST_ENDPOINT)
    
  try:
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)    
    resp = rc.delete(CURRENT_POST_ENDPOINT)
    if debug == 1:
      print (resp.status_code)
    if resp.status_code == 200:
      subresp = resp.json()   
      if debug == 1:
        print (subresp)     
        parsed_resp = json.loads(resp.content)
        print (json.dumps(parsed_resp, indent=4, sort_keys=True))
    print ("Deleted agent with host_uuid", uuid)
  except:
    usage()
    sys.exit(2)

if __name__ == '__main__':

  try:
    opts, args = getopt.getopt(sys.argv[1:], "vhn:s:f:")
  except getopt.GetoptError as err:
    print(err)
    usage()
    sys.exit(2)
    
  for opt, arg in opts:
    if opt == "-h":
      usage()
      sys.exit()
    elif opt in ("-s"):
      scope_name = arg
    elif opt in ("-f"):
      filename = arg
      run = 1
    elif opt in ("-n"):
      host_name = arg
      run = 1            
    elif opt in ("-v"):
      debug = 1
    else:
      usage()
      sys.exit()
  if run == 1:  
    result = main(host_name, scope_name, filename)
  else:
    usage()
    sys.exit()    