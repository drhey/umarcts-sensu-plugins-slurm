## umarcts-sensu-plugins-slurm

### To build gem
- Clone this repo
- cd into this repo's dir
- `gem build umarcts-sensu-plugins-slurm.gemspec`

### To use handler-scontrol in Sensu
### Define handler

```
{
  "handlers": {
    "slurm": {
      "command": "/opt/sensu/embedded/bin/handler-scontrol.rb",
      "type": "pipe",
      "severities": [ "critical" ]
    }
  }
}
```

### Set `handled_by_scontrol: true` in check definition(s)

```      
{
  "checks": {
    "check_slurmd_process": {
      "command": "check-process.rb -p slurmd",
      "interval": 30,
      "occurrences": 2,
      "handled_by_scontrol": true,
      "subscribers": [ "compute" ],
      "handlers": [ "slurm" ]
    }
  }
}
```
