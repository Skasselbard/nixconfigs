{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "cpu"
      "cpufreq"
      "diskstats"
      "edac"
      "filesystem"
      "hwmon"
      "loadavg"
      "meminfo"
      "netclass"
      "uname"

      "ethtool"
      "meminfo_numa"
      "processes"
      "mountstats"
      "logind"
      "systemd"
    ];
    disabledCollectors = [
      "textfile"
    ];
    # openFirewall = true; #TODO add prometheus ports to firewall?
    # firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };
}