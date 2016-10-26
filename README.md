
## Usage

- SSH into Ops Manager
- Log in to your BOSH director (`bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target DIRECTOR-IP-ADDRESS`)
- Target your cf deployment (`bosh deployment DEPLOYMENT-FILENAME.yml`)
- Run `pcf-aws-start-stop.sh`
 - Optionally, add to crontab to schedule

## Notes
- The `bosh stop` command will actually blow away virtual machines. Therefore, if you have chosen the 'internal' file storage and database options during PCF deployment, your entire environment will be lost. I highly recommend that you use an external file store (eg S3) and database (eg RDS), which will retain all the state of your deployment even if every PCF VM is destroyed and recreated (note that Ops Manager and BOSH are not part of a cf manifest, so they will not be deleted by this script).
