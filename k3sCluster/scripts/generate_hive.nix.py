import configuration
from jinja2 import Template


def write_hive_nix(plan_dir: str):
    configuration.load_plans(plan_dir)
    config = configuration.get_configuration()
    for host, value in config["cluster"]["hosts"].items():
        host_vars = {
            "hostname": host,
            "k3sServer": "",
            "k3sAgent": "",
            "customModule": "",
            "ip": value["ip"],
        }
        print(populate_host(host_vars))


def populate_host(vars):
    hostTemplate = "  \
{{hostname}} = {\n\
  imports = [\n\
    ./modules/admin.nix\n\
    ./modules/network.nix\n\
    ./modules/ssh.nix\n\
    {{k3sServer}}\n\
    {{k3sAgent}}\n\
    {{customModule}}\n\
    ];\n\
  deployment.targetHost = {{ip}};\n\
  cluster.hosts.{{hostname}}\n\
  };\n\
"
    return Template(hostTemplate).render(vars)


write_hive_nix("examples/plans")
