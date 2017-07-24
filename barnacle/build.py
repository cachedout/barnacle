'''
Module to build images
'''

# third party imports
import os
import sys
import docker

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

def build(conf, img_os=None, all_os=False):
    '''
    build docker images
    '''
    def _build_image(path, img_os):
        try:
            for line in client.build(path=path,
                                     tag='salt-' + img_os,
                                     stream=True):
                print(line.split('":"')[1])
        except docker.errors.APIError as err:
            print("There was an issue building the VM: {0}".format(err))
            sys.exit(1)
    build_dir = conf['barnacle_dir']
    client = barnacle.helper.get_client()

    if all_os:
        for dirs in _get_dockerfile(build_dir):
            img_os = dirs.split('/')[-1]
            _build_image(dirs, img_os)
    else:
        _build_image(build_dir + img_os, img_os)

def main():
    '''
    main method for building images
    '''
    b_client = barnacle.Barnacle()
    build(b_client.opts, img_os=b_client.args.os, all_os=b_client.args.all)


if __name__ == "__main__":
    main()
