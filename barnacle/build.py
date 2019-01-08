'''
Module to build images
'''

# third party imports
import os
import re
import sys
import docker
from distutils.version import LooseVersion

# barnacle imports
import barnacle
import barnacle.helper


def _get_dockerfile(b_dir):
    '''
    helper method to find dockerfiles in a directory
    '''
    files = []
    for root, dirs, d_file in os.walk(b_dir):
        if 'Dockerfile' in d_file:
            files.append(root)
    return files

def build(conf, img_os=None, all_os=False, no_cache=False):
    '''
    build docker images
    '''
    def _build_image(path, img_os, no_cache):
        try:
            kwargs = {'path': path, 'tag': 'salt-' + img_os,
                      'nocache': no_cache}
            if LooseVersion(docker.version) < LooseVersion('3.0.0'):
                kwargs['stream'] = True
            for line in client.build(**kwargs):
                line = line.decode()
                if '":"' in line:
                    print(re.split('":"|}', line)[1])
        except docker.errors.APIError as err:
            print("There was an issue building the VM: {0}".format(err))
            sys.exit(1)
    client = barnacle.helper.get_client()

    if all_os:
        for dirs in _get_dockerfile(conf.get('barnacle_dir')):
            img_os = dirs.split('/')[-1]
            _build_image(dirs, img_os, no_cache)
    else:
        _build_image(conf.get('barnacle_dir') + img_os, img_os, no_cache)

def main():
    '''
    main method for building images
    '''
    b_client = barnacle.Barnacle()
    build(b_client.opts, img_os=b_client.args.os, all_os=b_client.args.all,
          no_cache=b_client.args.no_cache)


if __name__ == "__main__":
    main()
