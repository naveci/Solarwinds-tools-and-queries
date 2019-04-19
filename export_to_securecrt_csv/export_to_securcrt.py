#!/usr/bin/python

import csv
import requests
from orionsdk import SwisClient
import logging
from datetime import datetime
import yaml
import sys, os


def filedt():
    return datetime.strftime(datetime.utcnow(), "%Y-%m-%d")

def time():
    return datetime.strftime(datetime.utcnow(), "%Y-%m-%d %H:%M:%S.%f")

def cfg():
    filedir = os.path.dirname(os.path.abspath(sys.argv[0]))
    configfile = filedir + '\config.yml'
    with open(configfile, 'r') as ymlfile:
        cfg = yaml.load(ymlfile)
    return cfg

def main():
    # serverdate & credentials
    logging.info(
        "{} :: Trying to connect to Solarwinds on {} with account {}.".format(time(), cfg()['solarwinds']['server'],
                                                                              cfg()['solarwinds']['user']))
    swis = SwisClient(cfg()['solarwinds']['server'], cfg()['solarwinds']['user'], cfg()['solarwinds']['password'])

    # CSV file name
    if cfg()['file']['include_date'] == True:
        securecrtcsv = str(cfg()['file']['name'] + '_' + filedt() + '.csv')
    elif cfg()['file']['include_date'] == False:
        securecrtcsv = str(cfg()['file']['name'] + '.csv')
    else:
        logging.error("{} :: Incorrect dateformat (" + cfg()['file']['include_date'] +
                      ") in config file. Using date format.".format(time()))
        securecrtcsv = str(cfg()['file']['name'] + '_' + filedt() + '.csv')

    # File path
    if cfg()['file']['path'].endswith('/'):
        path = cfg()['file']['path'][:-1]
    if cfg()['file']['path'].endswith('\\'):
        path = cfg()['file']['path'][:-1]
    if str.startswith(path, '\\\\'):
        securecrtcsv = path + '\\' + securecrtcsv
    elif not path:
        logging.error("{} :: Incorrect filepath options specified. Defaulting to script path.".format(time()))
    else:
        securecrtcsv = path + '/' + securecrtcsv

    # Clean old csv files
    files = [os.path.join(path, filename) for filename in os.listdir(path)]
    for filename in files:
        if cfg()['file']['name'] in filename:
            os.remove(filename)

    # open CSV file for writing
    try:
        with open(securecrtcsv, mode='w') as crt_file:
            crt_writer = csv.writer(crt_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL,
                                    lineterminator='\n')
            crt_writer.writerow(['session_name', 'hostname', 'folder', 'protocol'])

            # execute query
            logging.info("{} :: Quering Solarwinds.".format(time()))
            ncmquery = swis.query(
                """SELECT Caption, IPAddress, Location
                FROM Orion.Nodes AS NID
                LEFT JOIN Orion.NodesCustomProperties AS NCP ON NID.NodeID = NCP.NodeID
                WHERE NCP.DeviceCategory = 'Network'
                ORDER BY Location""")
            logging.info("{} :: Retrieved {} results from Solarwinds.".format(time(), len(ncmquery["results"])))

            # about to write the results to file
            logging.info("{} :: Writing results to {}.".format(time(), securecrtcsv))
            for result in ncmquery['results']:
                # check for excludes
                includedlist = [result["Caption"] for exc in cfg()['exclude'] if exc not in result["Caption"]]
                if len(includedlist) < len(cfg()['exclude']):
                    logging.info("{} :: Excluding {} because of configuration.".format(time(), result["Caption"]))
                else:
                    location = result['Location'].replace("_", "\\", 2)
                    crt_writer.writerow([result['Caption'], result['IPAddress'], location, 'ssh2'])

            # Including systems from config file
            for included in cfg()['include']:
                for key in included:
                    hostname = key
                    if 'protocol' in included[key]:
                        protocol = included[key]['protocol']
                    else:
                        protocol = 'ssh2'
                    crt_writer.writerow([hostname, included[key]['address'], included[key]['folder'], protocol])
                    logging.info("{} :: Including {}.".format(time(), hostname))

            logging.info("{} :: Done writing.".format(time()))
        logging.info("{} :: Saving Data.".format(time()))
    except Exception as exc:
        logging.critical("{} :: {}".format(time(), exc))


# Disable https cert warnings
requests.packages.urllib3.disable_warnings()

# logging setup
if cfg()['logging-level'] not in ['debug', 'info', 'warning', 'error', 'critical']:
    logging.error("{} :: Incorrect logging level in config file. Continueing in INFO level".format(time()))
    LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO').upper()
else:
    LOGLEVEL = os.environ.get('LOGLEVEL', cfg()['logging-level']).upper()
if cfg()['logging'] == 'file':
    logfile = sys.argv[0] + '.log'
    logging.basicConfig(filename=logfile, level=LOGLEVEL)
elif cfg()['logging'] == 'screen':
    logging.basicConfig(stream=sys.stdout, level=LOGLEVEL)
else:
    logging.error("{} :: Incorrect logging setup in config file. Logging to screen".format(time()))
    logging.basicConfig(stream=sys.stdout, level=LOGLEVEL)


if __name__ == '__main__':
    main()

logging.info("{} :: Closing.".format(time()))
