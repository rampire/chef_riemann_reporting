require 'chef/handler'
require 'riemann/client'

class RiemannReporting < Chef::Handler
  attr_writer :riemann_host, :riemann_port, :ttl, :tags

  def initialize(options={})
    @riemann_host = options[:riemann_host]
    @riemann_port = options[:riemann_port]
    @ttl = options[:ttl]
    @tags = options[:tags] || []
  end

  def report
    riemann = Riemann::Client.new(:host => @riemann_host, :port => @riemann_port)

    if run_status.success?
      run_status_metric = 1
      run_state = "ok"
    else
      run_status_metric = 0
      run_state = "critical"
    end

    # run status
    run_event = {
      host: node[:hostname],
      service: "chef run_status",
      metric: run_status_metric,
      state: run_state,
      tags: @tags,
      ttl: @ttl
    }

    # updated resources
    updated_resources = {
      host: node[:hostname],
      service: "chef updated_resources",
      metric: run_status.respond_to?(:updated_resources) ? run_status.updated_resources.length : 0,
      state: run_state,
      tags: @tags,
      ttl: @ttl
    }

    # all resources
    all_resources = {
      host: node[:hostname],
      service: "chef all_resources",
      metric: run_status.respond_to?(:all_resources) ? run_status.all_resources.length : 0,
      state: run_state,
      tags: @tags,
      ttl: @ttl
    }

    # elapsed time
    elapsed_time = {
      host: node[:hostname],
      service: "chef elapsed_time",
      metric: run_status.elapsed_time,
      state: run_state,
      tags: @tags,
      ttl: @ttl
    }

    # submit events
    riemann << run_event
    riemann << updated_resources
    riemann << all_resources
    riemann << elapsed_time
  end
end
