include:
  - api.cherrypy.users

add_api_config:
  file.managed:
    - name: /etc/salt/master.d/api.conf
    - contents: |
        rest_cherrypy:
          port: 8000
          disable_ssl: True # Don't do this in production
          debug: True
          host: 0.0.0.0
          webhook_url: /hook
          webhook_disable_auth: True
        external_auth:
          pam:
            saltdev:
              - .*
              - '@runner'
              - '@wheel'
              - '@jobs'
            root:
              - .*
              - '@runner'
              - '@wheel'
              - '@jobs'
