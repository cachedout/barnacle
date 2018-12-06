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
        self.opts = barnacle.conf.get_conf('/etc/barnacle.conf')
        self.args = barnacle.parser.get_args().parse_args()
