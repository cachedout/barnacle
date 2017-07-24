'''
Main args parser
'''
import argparse

def get_args():
    '''
    parse all the args
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-o', '--os',
        help='Specific OS:tag. Ex. cent7 or cent7:7'
    )
    parser.add_argument(
        '-a', '--all',
        action="store_true",
        help='Build all OSs in a given directory'
    )
    parser.add_argument(
        '-t', '--test',
        help='Build all OSs in a given directory'
    )


    return parser
