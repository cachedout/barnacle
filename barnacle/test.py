'''
module to run salt tests with containers
'''
# import barnacle modules
import barnacle
import barnacle.conf
import barnacle.helper

# import third party libraries
import dockerpty

def run_test(test, test_os, conf, image='salt-'):
    '''
    method to run a salt test with container
    '''
    client = barnacle.helper.get_client()

    container = client.create_container(
        host_config=client.create_host_config(binds=[
            conf.get('salt_dir') + ':' + conf.get('docker_volume'),
        ]),
        image=image + test_os,
        stdin_open=True,
        tty=True,
        command='python2 /testing/tests/runtests.py -n {0}'.format(test),
    )
    dockerpty.start(client, container)


def main():
    '''
    main method to start tests
    '''
    t_client = barnacle.Barnacle()
    t_os = t_client.args.os
    test = t_client.args.test
    if not (t_os, test):
        raise Exception('You require the os argument alongside the shell argument')
    run_test(test, t_os, t_client.opts)


if __name__ == "__main__":
    main()
