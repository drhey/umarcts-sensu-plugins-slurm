## umarcts-sensu-plugins-slurm

### Overview

This package/handler is meant for use in HPC setups that use SchedMD/Slurm. The main purpose of this handler is the notify the scheduler when a node is down so jobs can be drained and no new jobs land on that node. The mechanism for this is `scontrol`. 

For HPC environments that have ALL checks handled by this packaged (i.e. `handler-scontrol.rb`) you do NOT have the use the `handled_by_scontrol` convention in your check definitions (see below).

For HPC environments that have a mix of checks (e.g. some handled by `handler-scontrol.rb` others handled by something else) you'll want to use the `handled_by_scontrol` convention (defined below). The script/handler (`handler-scontrol.rb`) specifically looks at whether or not sensu events exist for that client by querying the sensu events API. If you have two events, one handled by `handler-scontrol.rb` and one that isn't and the non-scontrol handled one clears first, then the second event, even if it clears, will never return the node to an undrain state.

The reason we are querying the events API is because we never want a scenario where a node is prematurely returned to service (and allowing jobs to land on it) when the actual issue isn't fixed. Also, by setting a piece of arbitrary json data (like `handled_by_scontrol: true`) in our check definition, we make it easier for this handler/script to find its own events in the events API and run the handler accordingly so the node can be returned to service, despite there being other events that might exist (from checks that, say, might be for more informational purposes and have no bearing on the health state of a node).

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
