## umarcts-sensu-plugins-slurm

### Overview

This package/handler is meant for use in HPC setups that use SchedMD/Slurm. The main purpose of this handler is the notify the scheduler when a node is down so jobs can be drained and no new jobs land on that node. The mechanism for this is `scontrol`. 

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
