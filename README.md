# Chef Riemann Reporting Handler

A chef reporting handler that will submit events to a
[riemann](http://riemann.io) instance.

It sends events for:

* general run status - success or failure
* updated resources - how many resources were updated this run
* all resources - total resources in the chef run
* elapsed time - time it took for chef to run


# Usage

Include the recipe at the start of your run list.

# Dependencies

[chef_handler](https://github.com/opscode-cookbooks/chef_handler) cookbook

# Attributes

* `riemann_host` - IP/Hostname of your riemann server
* `riemann_port` - Port for your riemann server
* `ttl` - TTL to set on events
* `tags` - Array of tags to add to events

