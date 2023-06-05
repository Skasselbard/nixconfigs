#!/bin/python3
import os
import sys
import yaml
import pandas as pd
from pathlib import Path
import csv
import copy

script_path = os.path.abspath(os.path.dirname(__file__))
configuration = None


def get_physical_hosts(hosts: pd.DataFrame):
    df = get_configuration()
    # TODO:


def write_as_yaml():
    print(yaml.dump(configuration, default_flow_style=False,
                    explicit_start=True))


def load_plans(dir: Path):
    global configuration
    hosts = read_csv(dir/'hosts.csv')
    containers = read_csv(dir/'k3s.csv')
    initContainer = check_containers(containers)
    secrets = read_csv(dir/'secrets.csv')
    for host in hosts:
        format_host(host)
        k3s = get_host_containers(host["name"], containers)
        for container in k3s:
            format_container(container)
        host["k3s"] = k3s
    configuration = {
        "cluster": {
            "hosts": hosts,
            "init": {
                "ip": initContainer["server"]["ip"]
            }
        },
    }
    print("")


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
            f"Error: {hostname} has more than two k3s containers defined", file=sys.stderr)
        sys.exit(1)
    if len(matches) == 2 and matches[0]["type"] == matches[1]["type"]:
        print(
            f"Error: k3s containers for {hostname} have the same type", file=sys.stderr)
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
    adminName = host["admin"]
    host['admin'] = {
        "name": adminName,
        "hashedPwd": get_admin_password(host["name"]),
    }


def get_admin_password(hostname: str):
    return "NOT IMPLEMENTED"


def get_configuration():
    global configuration
    if configuration == None:
        print >> sys.stderr, "Error: access to uninitialized configuration"
        sys.exit(1)
    else:
        return configuration


def read_csv(file: Path):
    csvData = []
    with open(file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # strip whitespace and normalize to lower case
            row = {k.strip().lower(): removew(v)
                   if isinstance(v, dict)
                   else v.strip().lower()
                   for k, v in row.items()}
            csvData.append(row)
    return csvData


load_plans(Path('examples/plans'))
write_as_yaml()
