#!/usr/bin/python

import json
import sys
from datetime import datetime
import time


try:
    import requests
except ImportError:
    print "Please install the python-requests module."
    sys.exit(1)

# URL to RHSS6
URL = "https://sa6host.some.domain"
SAT_API = "%s/api/v2" % URL

USERNAME = "sat6user"
PASSWORD = "changeme"

SSL_VERIFY = False
LOGFILE = "/var/log/lastseen/lastseen.log"

def get_json(location):
    """
    Perform GET using the url given as location
    """

    payload = {'per_page': '5000',
               'search': 'hostgroup_fullname ~ pattern* '}
    
    r = requests.get(location, auth=(USERNAME,PASSWORD), verify=SSL_VERIFY, params=payload)

    return r.json()


def main():
    """
    Main function
    """

    pml = get_json(SAT_API + "/hosts/")
    f = open(LOGFILE, "w")

    for pm in pml['results']:
        pnam = pm['name']
        ptimestamp = str(pm['last_report'])
        if ptimestamp == "None":
          pvalue = None
        else:
          ts = datetime.strptime(ptimestamp, "%Y-%m-%d %H:%M:%S UTC" )
          pvalue = ts.strftime('%Y%m%d%H%M')
        f.write("{} {}\n".format(pnam,pvalue))

    f.close()

if __name__ == "__main__":
    main()

