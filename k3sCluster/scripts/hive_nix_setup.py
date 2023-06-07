import sys

import yaml
import configuration
from jinja2 import Template
import json


def get_hive_nix(config: dict):
    nix_config = "# This is an auto generated file.\n{\n"
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
    cluster = {hostname = \"{{hostname}}\";}//\n\
        builtins.fromJSON(''\n\
{{hostConfig}}\n\
    '');\n\
  };\n\
"
    return Template(hostTemplate).render(vars)


def main(yaml_str: str):
    config = yaml.safe_load(yaml_str)
    return get_hive_nix(config)


if __name__ == "__main__":
    # read yaml config from stdin
    input = ""
    for line in sys.stdin:
        input += line
    print(main(input))
