'''
Module for helper methods used within barnacle
'''

# import third party libraries
import docker


def get_client():
    '''
    initialize docker api client
    '''
    client = docker.APIClient(base_url='unix://var/run/docker.sock')
    return client
