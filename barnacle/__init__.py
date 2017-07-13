import docker
import dockerpty
import argparse


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-s', '--shell',
        action="store_true",
        help='Call the shell method'
    )
    parser.add_argument(
        '-o', '--os',
        help='Specific OS:tag. Ex. cent7 or cent7:7'
    )

    return parser

def get_client():
    client = docker.APIClient(base_url='unix://var/run/docker.sock')
    return client

def shell(os_tag):
    client = get_client()

    container = client.create_container(
        image=os_tag,
        stdin_open=True,
        tty=True,
        command='/bin/bash',
    )

    dockerpty.start(client, container)

def main():
    parser = get_args()
    args = parser.parse_args()
    if args.shell and args.os:
        shell(args.os)
    elif args.shell and not args.os:
        raise Exception('You require the os argument alongside the shell argument')


if __name__ == "__main__":
    main()
