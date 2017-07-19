import yaml

def _get_conf(path):
    '''
    helper method to get all config values from config file
    '''
    with open(path, 'r') as conf:
        try:
            config = yaml.safe_load(conf.read()) or {}
        except yaml.YAMLError as err:
            raise "Yaml Error. Could not Parse Config"
        return config
