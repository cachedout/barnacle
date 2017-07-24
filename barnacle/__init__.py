'''
Barnacle Class
'''

import barnacle.parser
import barnacle.conf


class Barnacle(object):
    '''
    Barnacle Class to gather configurations
    '''
    def __init__(self):
        config = '/etc/barnacle.conf'
        self.opts = barnacle.conf.get_conf(config)
        parser = barnacle.parser.get_args()
        self.args = parser.parse_args()
