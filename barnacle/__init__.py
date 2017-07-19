import barnacle.parser
import barnacle.conf

class Barnacle():
    def __init__(self):
        config = '/etc/barnacle.conf'
        self.opts = barnacle.conf._get_conf(config)
        parser = barnacle.parser._get_args()
        self.args = parser.parse_args()
