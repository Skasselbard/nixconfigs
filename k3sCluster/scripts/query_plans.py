#!/bin/python3
import argparse
import os
import pandas as pd

script_path = os.path.abspath(os.path.dirname(__file__))


def file_to_dataframe(filename):
    df = pd.read_csv(filename)
    df.columns = df.columns.str.lower().str.strip()
    for col in df.select_dtypes('object'):
        df[col] = df[col].str.strip()
    return df


def get_params(args):
    if args.bootdrive:
        print(get_boot_drive(args.host))


def get_boot_drive(hostname: str):
    df = file_to_dataframe(script_path + '/HardDisks.csv')
    result = df.loc[(df['hostname'] == hostname.lower())
                    & (df['boot'] == 'Yes')]
    return result['id'].values[0]


def get_ip(hostname: str):
    df = file_to_dataframe(getHostsCsv(hostname))
    result = df.loc[(df['hostname'] == hostname.lower())]
    return result['default ip'].values[0]


def get_interface(hostname: str):
    df = file_to_dataframe(getHostsCsv(hostname))
    result = df.loc[(df['hostname'] == hostname.lower())]
    return result['defaultinterface'].values[0]


def is_vm(hostname):
    df = file_to_dataframe(script_path + '/virtualHosts.csv')
    return 0 != len(df.loc[(df['hostname'] == hostname.lower())].values)


def is_physical(hostname):
    df = file_to_dataframe(script_path + '/physicalHosts.csv')
    return 0 != len(df.loc[(df['hostname'] == hostname.lower())].values)


def getHostsCsv(hostname):
    if is_vm(hostname):
        return script_path + '/virtualHosts.csv'
    if is_physical(hostname):
        return script_path + '/physicalHosts.csv'
    else:
        raise LookupError('Given hostname was not found in CSV data.')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Parse data from the csv plans")
    parser.add_argument(
        '-b', '--bootdrive', help="get the boot drive for the given host", action='store_true')
    parser.add_argument('--host')
    args = parser.parse_args()
    get_params(args)
