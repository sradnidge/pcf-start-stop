
## Usage

- SSH into Ops Manager
- Log in to your BOSH director (`bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target DIRECTOR-IP-ADDRESS`)
- Target your cf deployment (`bosh deployment DEPLOYMENT-FILENAME.yml`)
- Run `pcf-start-stop.sh (start | stop) [--hard]`
 - Optionally, add to crontab to schedule

## WARNING
If you chose the 'internal' options for blob store and / or database when deploying PCF, running this script with the `--hard` option will indeed result in the loss of everything.
