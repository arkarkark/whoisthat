#!/usr/bin/python

import codecs
import logging
import os
import re
import textwrap
import HTMLParser

# visit http://www.looker.com/company and save as whole page Company.html

def Main():
  """Make a config from a html file."""
  logging.basicConfig()
  logging.getLogger().setLevel(logging.DEBUG)
  file_name = os.path.expanduser('~/Downloads/Company.html')
  print '// Auto generated by genconfig.py'
  print 'var peepsData = ['
  unescape = HTMLParser.HTMLParser().unescape

  for line in codecs.open(file_name, 'r', 'utf-8'):
    if 'data-role' in line:
      peep = {}
      for attr in re.findall(r'([a-z_]+)="([^"]*)"', line, re.IGNORECASE): # "
        peep[attr[0]] = unescape(unicode(attr[1]))
      peep['img'] = os.path.join('img', os.path.basename(peep['largesrc']).replace('-lg.', '-med.'))
      if os.path.exists(peep['img']):
        print "['%(img)s', '%(title)s', '%(role)s']," % peep
      else:
        logging.error('missing image: %s', peep['img'])

  print textwrap.dedent("""
      ];

      var faviconUrl = 'img/favicon.ico';
      var pageTitle = 'Looker\\'s lookers lookeraterer';
      var pageHeader = '<img src="img/logo.png">\\'s <img src="img/logo.png">s <img src="img/logo.png">aterer';

      var femaleNames = 'carolyn,lara,elfe,margaret,lissa,elena,anika,sara,emi,courtney,jenny,esther,nicole,lindsey,erin,kendra,kimberly'.split(',');

      module = module || {};
      module.exports = module.exports || {};

      module.exports.getPeepsData = function() {
        return peepsData;
      }
      """)

if __name__ == '__main__':
  Main()
