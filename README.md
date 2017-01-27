
## Usage

- SSH into Ops Manager
- Log in to your BOSH director (`bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target DIRECTOR-IP-ADDRESS`)
- Target your cf deployment (`bosh deployment DEPLOYMENT-FILENAME.yml`)
- Run `pcf-start-stop.sh (start | stop) [--hard]`
 - Optionally, add to crontab to schedule

## NOTE
The `nfs_server` and `mysql` VMs (if they are present) will never be deleted, if this script is run with the `--hard` option they will just be shut down (and all other VMs will be deleted).
