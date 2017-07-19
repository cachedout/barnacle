# barnacle imports
import barnacle
import barnacle.helper

# third party imports
import argparse
import docker
import dockerpty
import os
import yaml

def _get_dockerfile(dir):
    '''
    helper method to find dockerfiles in a directory
    '''
    docker_file = 'Dockerfile'
    files = []
    for root, dirs, file in os.walk(dir):
        if docker_file in file:
            files.append(root)
    return files

def build(conf, os=None, all=False):
    '''
    build docker images
    '''
    def _build_image(path, os):
        for line in client.build(path=path,
                                 tag='salt' + os,
                                 stream=True):
            print(line.split('":"')[1])

    build_dir = conf['barnacle_dir']
    client = barnacle.helper._get_client()

    if all:
        all_os = (_get_dockerfile(build_dir))
        for dir in all_os:
            os = dir.split('/')[-1]
            _build_image(dir, os)
    else:
        _build_image(build_dir + os, os)

def main():
    b_client = barnacle.Barnacle()
    b_os = b_client.args.os
    b_all = b_client.args.all
    build(b_client.opts, os=b_client.args.os, all=b_all)


if __name__ == "__main__":
    main()
