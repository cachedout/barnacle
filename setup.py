#!/usr/bin/env python
'''
setup script for barnacle
'''
from setuptools import setup

setup(
    name='barnacle',
    version='0.1',
    packages=['barnacle'],
    license='Apache Software License 2.0',
    install_requires=[
      'docker',
      'dockerpty',
      'PyYaml',
    ],
    scripts=[
      'scripts/barnacle',
    ]
)
