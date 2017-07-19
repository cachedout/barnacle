# import barnacle modules
import barnacle
import barnacle.helper

# import third party libraries
import dockerpty

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

def shell(os_tag, conf):
    salt_volume = conf['salt_dir']
    docker_volume = '/testing/'
    client = barnacle.helper._get_client()

    container = client.create_container(
        host_config=client.create_host_config(binds=[
            salt_volume + ':' + docker_volume,
        ]),
        image=os_tag,
        stdin_open=True,
        tty=True,
        command='/bin/bash',
    )

    dockerpty.start(client, container)


def main():
    s_client = barnacle.Barnacle()
    s_os = s_client.args.os
    if not s_os:
        raise Exception('You require the os argument alongside the shell argument')
    shell(s_os, s_client.opts)


if __name__ == "__main__":
    main()
