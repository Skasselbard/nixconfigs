#!/bin/python3
import os
import sys
import yaml
import pandas as pd
from pathlib import Path
import csv
import copy
import json

script_path = os.path.abspath(os.path.dirname(__file__))
configuration = None
secrets_dir: Path = None


def get_yaml():
    return yaml.dump(configuration, explicit_start=True)


def load_plans(path: str):
    global configuration
    global secrets_dir
    path = Path(path)
    hosts = read_csv(path / "plans/hosts.csv")
    containers = read_csv(path / "plans/k3s.csv")
    init_container = check_containers(containers)
    secrets_dir = path / "secrets"
    host_dict = {}
    # reformat csv data to a nix style dict
    for host in hosts:
        k3s = get_host_containers(host["name"], containers)
        k3s_dict = {}
        for container in k3s:
            format_container(container)
            k3s_dict.update(container)
        k3s_dict["init"] = {
            "ip": init_container["server"]["ip"],
        }
        host["k3s"] = k3s_dict
        format_host(host)
        host_dict.update(host)
    configuration = {
        "cluster": {
            "hosts": host_dict,
            "token": get_init_token(),
        },
    }


def check_containers(containers):
    init_variants = ["init", "init-server", "init_server"]
    init = None
    for i, container in enumerate(containers):
        if container["type"] in init_variants:
            if init != None:
                print("Error: found multiple init servers", file=sys.stderr)
                sys.exit(1)
            else:
                init = i
    if init == None:
        print("Error: No init server found", file=sys.stderr)
        sys.exit(1)
    return containers[init]


def get_host_containers(hostname: str, containers: list):
    # also deletes matches from the container list
    matches = []
    match_indices = []
    for i, container in enumerate(containers):
        if container["host"] == hostname:
            matches.append(container)
            match_indices.append(i)
    if len(matches) > 2:
        print(
            f"Error: {hostname} has more than two k3s containers defined",
            file=sys.stderr,
        )
        sys.exit(1)
    if len(matches) == 2 and matches[0]["type"] == matches[1]["type"]:
        print(
            f"Error: k3s containers for {hostname} have the same type", file=sys.stderr
        )
        sys.exit(1)
    for container in matches:
        container.pop("host")
    # delete matches from original list
    match_indices.reverse()
    for i in match_indices:
        containers.pop(i)
    return matches


def format_container(container: dict):
    con_type = container["type"]
    container.pop("type")
    backup = copy.deepcopy(container)
    container.clear()
    if con_type == "agent":
        container["agent"] = backup
    else:
        container["server"] = backup


def format_host(host: dict):
    admin_name = host["admin"]
    host["admin"] = {
        "name": admin_name,
        "hashedPwd": get_admin_password(host["name"]),
    }
    host_name = host["name"]
    host.pop("name")
    backup = copy.deepcopy(host)
    host.clear()
    host[host_name] = backup


def get_init_token():
    token_path = secrets_dir / "init-token"
    if not token_path.exists():
        print(f"Error: {token_path} does not exists", file=sys.stderr)
        sys.exit(1)
    if not token_path.is_file():
        print(f"Error: {token_path} is not a file", file=sys.stderr)
        sys.exit(1)
    return token_path.read_text()


def get_admin_password(hostname: str):
    passwd_path = secrets_dir / "passwd"
    special_path = secrets_dir / f"{hostname}_passwd"
    if special_path.exists():
        return special_path.read_text()
    else:
        return passwd_path.read_text()


def get_configuration():
    global configuration
    if configuration == None:
        print("Error: access to uninitialized configuration", file=sys.stderr)
        sys.exit(1)
    else:
        return configuration


def read_csv(file: str):
    csv_data = []
    with open(file, newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            # strip whitespace and normalize to lower case
            row = {
                k.strip().lower(): removew(v)
                if isinstance(v, dict)
                else v.strip().lower()
                for k, v in row.items()
            }
            csv_data.append(row)
    return csv_data


def to_json():
    return json.dumps(get_configuration(), indent=1)


def main(path: Path = None):
    if path == None:
        path = Path().cwd()
    load_plans(path)
    return get_yaml()


if __name__ == "__main__":
    path = None
    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
    print(main(path))
