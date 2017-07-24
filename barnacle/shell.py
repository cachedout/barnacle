'''
Module to start container
'''

# import third party libraries
import dockerpty

# import barnacle modules
import barnacle
import barnacle.helper


def shell(os_tag, conf):
    '''
    initialize a shell and start container
    '''
    salt_volume = conf['salt_dir']
    docker_volume = '/testing/'
    client = barnacle.helper.get_client()

    container = client.create_container(
        host_config=client.create_host_config(binds=[
            salt_volume + ':' + docker_volume,
        ]),
        image='salt-' + os_tag,
        stdin_open=True,
        tty=True,
        command='/bin/bash',
    )

    dockerpty.start(client, container)


def main():
    '''
    main method to start shell form container
    '''
    s_client = barnacle.Barnacle()
    s_os = s_client.args.os
    if not s_os:
        raise Exception('You require the os argument alongside the shell argument')
    shell(s_os, s_client.opts)


if __name__ == "__main__":
    main()
