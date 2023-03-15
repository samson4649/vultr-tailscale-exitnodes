# Tailscale exitnodes with Vultr and Headscale coordination server

## Deployment
The deployment requires access to the headscale control plane to create a preauthentication key. If you are deploying to multiple locations, then the key needs to be generated with the `--reusable` switch. 

```bash 
headscale preauthkeys create -u exitnodes --tags tag:exitnode --ephemeral
```

### `-u production`
This preauthentication key is for the user `production`

### `--tags tag:exitnode`
The headscale server is configured with an ACL to enable auto approval of routes advertised with this tag. Additionally, this tag is enforced with the preauthentication key on join. 

```json
{
    "autoApprovers": {
        "exitNode": ["tag:exitnode"],
    },

    ...snip...
    
}
```

### `--ephemeral` 
The nodes are short lived. If the node provisioned doesnt checkin to the coordination server within the server defined time limit (1h default) then the node is expired. 