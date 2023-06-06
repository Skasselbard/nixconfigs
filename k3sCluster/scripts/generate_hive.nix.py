import configuration
from jinja2 import Template
import json


def write_hive_nix(plan_dir: str):
    configuration.load_plans(plan_dir)
    config = configuration.get_configuration()
    nix_config = "{\n"
    for host, values in config["cluster"]["hosts"].items():
        server_module, agent_module = "", ""
        if "server" in values["k3s"]:
            server_module = "      ./modules/k3sServer.nix\n"
        if "agent" in values["k3s"]:
            agent_module = "      ./modules/k3sAgent.nix\n"
        json_values = ""
        for line in str.splitlines(json.dumps(values, indent=2), keepends=True):
            line = "      "+line
            json_values += line
        host_vars = {
            "hostname": host,
            "k3sServer": server_module,
            "k3sAgent": agent_module,
            "customModule": "",
            "ip": values["ip"],
            "hostConfig": json_values,
        }
        nix_config += populate_host(host_vars) + "\n"
    nix_config += "}"
    return nix_config


def populate_host(vars):
    hostTemplate = "\
  {{hostname}} = {\n\
    imports = [\n\
      ./modules/admin.nix\n\
      ./modules/network.nix\n\
      ./modules/ssh.nix\n\
{{k3sServer}}\
{{k3sAgent}}\
{{customModule}}\
      ];\n\
    deployment.targetHost = \"{{ip}}\";\n\
    cluster.hostname = \"{{hostname}}\";\n\
    cluster = builtins.fromJSON(''\n\
{{hostConfig}}\n\
    '');\n\
  };\n\
"
    return Template(hostTemplate).render(vars)


# configuration.write_as_yaml()
print(write_hive_nix("examples/plans"))
