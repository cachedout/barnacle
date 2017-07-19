'''
File for helper methods used within barnacle
'''

# import third party libraries
import docker
import dockerpty


def _get_client():
    client = docker.APIClient(base_url='unix://var/run/docker.sock')
    return client
