
## Usage

- SSH into Ops Manager
- Log in to your BOSH director (`bosh --ca-cert /var/tempest/workspaces/default/root_ca_certificate target DIRECTOR-IP-ADDRESS`)
- Target your cf deployment (`bosh deployment DEPLOYMENT-FILENAME.yml`)
- Run `pcf-aws-start-stop.sh`
 - Optionally, add to crontab to schedule

## WARNING
- Think about what the primary purpose of this script is: to save money by shutting things down when you don't need them. It assumes your deployment is using external blob storage (eg S3) and an external database (eg RDS), which will retain the state of your CF deployment even if every single CF VM is destroyed and re-created (note that Ops Manager and BOSH are not part of a cf manifest, so they will not be deleted by this script). If you chose the 'internal' options for those things, running this script will indeed result in the loss of everything.

If you don't like this behaviour, use the fork!
