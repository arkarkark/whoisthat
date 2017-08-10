#!/usr/bin/python
"""Load up a bunch of employee json data and make a whoisthat config from it."""

import datetime
import json
import logging
import os
import sys
import textwrap
import urllib2
import urlparse

IMAGE_DIR = 'img'

def Main():
  """Make a config from a html file."""
  logging.basicConfig()
  logging.getLogger().setLevel(logging.DEBUG)
  base = open(os.path.join(os.path.dirname(sys.argv[0]), 'looker.url')).read().strip()
  image_base_dir = open(os.path.join(os.path.dirname(sys.argv[0]), 'image_base_dir.url')).read().strip()
  base_url = urlparse.urljoin(image_base_dir, "/")

  print '// Auto generated by genconfig.py at %s' % datetime.datetime.now().isoformat()

  looker_json = None
  # wget -O /Users/ark/Downloads/lookers.json $(cat looker.url)
  if os.path.exists('/Users/ark/Downloads/lookers.json'):
    looker_json = open('/Users/ark/Downloads/lookers.json').read()
  if not looker_json:
    looker_json = urllib2.urlopen(base).read()
  print "// %d employees" % len(json.loads(looker_json))
  print 'var peepsData = ['

  for emp in json.loads(looker_json):
    peep = []
    peep.append('%s%s.jpg' % (image_base_dir, emp['looker_profiles.username']))
    peep.append('%s %s' % (emp['looker_profiles.first_name'], emp['looker_profiles.last_name']))
    peep.append(emp['looker_profiles.teams'])
    print json.dumps(peep) + ","

  print textwrap.dedent("""
      ];

      var faviconUrl = '%(IMAGE_DIR)s/favicon.ico';
      var pageTitle = 'Looker\\'s lookers lookeraterer';
      var pageHeader = '<img src="%(IMAGE_DIR)s/logo.png">\\'s <img src="%(IMAGE_DIR)s/logo.png">s <img src="%(IMAGE_DIR)s/logo.png">aterer';
      var pageFooter = 'Not seeing any images? Make sure you have visited ' +
          '<a href="%(BASE_URL)s">this url<a/> first. ' +
          'Pro-tip you can use the number keys to make your selection.';

      var femaleNames = ('carolyn,lara,elfe,margaret,lissa,elena,anika,sara,emi,courtney,jenny,laura,' +
          'jeanne,esther,nicole,lindsey,erin,kendra,kimberly,abby,brie,amber,angela,kelly,alisa,haarthi,' +
          'pansy,avery,katherine,megan,jen,jennifer,renee,caitlin,grace,daina,elizabeth,melinda,michelle,' +
          'natalie,aisha,catherine,kim,cari,brynn,karina,shana,meg,loren,anicia,sarah,tig,danielle,' +
          'heidi,morgan,tamara,olivia,karishma,lynelle,sharon,jen,jessica,jennifer,louise,arielle,megan,' +
          'lara,paola,allegra,stacy,martha,vicki,lili,valia,maire,lisa,shilpa,alice,hidy,clara,zara,' +
          'wiebke,teresa,larissa,heather,sangita,joyce,alba,aine,summer,shelley,erin,jean,tiffany,aleli,' +
          'amy,jill,shanann,sooji,sara,alexis,ashley,alixandria,alix,jaime,danielle,sondra,hilary,' +
          'keerthana,kirti,mildred,' +
          'aishwarya,sloane,megan,emma,mary,kathryn,michelle,taylor,rachel').split(',');

      if (typeof module !== "object")
        module = {};

      module.exports = module.exports || {};

      module.exports.getPeepsData = function() {
        return peepsData;
      }
      """ % {"IMAGE_DIR": IMAGE_DIR, "BASE_URL": base_url})

if __name__ == '__main__':
  Main()
