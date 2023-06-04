#!/bin/python3
import os
import sys
import pandas as pd
from pathlib import Path

script_path = os.path.abspath(os.path.dirname(__file__))
configuration = None


def get_physical_hosts(hosts: pd.DataFrame):
    df = get_configuration()
    # TODO:


def write_templates(dir: Path):
    # TODO:
    print("")


def load_plans(dir: Path):
    hosts = file_to_dataframe(dir/'hosts.csv').to_dict()
    containers = file_to_dataframe(dir/'k3s.csv').to_dict()
    secrets = file_to_dataframe(dir/'secrets.csv').to_dict()


def get_configuration():
    global configuration
    if configuration == None:
        print >> sys.stderr, "Error: access to uninitialized configuration"
        sys.exit(1)
    else:
        return configuration


def file_to_dataframe(filename):
    df = pd.read_csv(filename)
    df.columns = df.columns.str.lower().str.strip()
    for col in df.select_dtypes('object'):
        df[col] = df[col].str.strip()
    return df
