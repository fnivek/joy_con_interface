#!/usr/bin/env python

import argparse
import bluetooth


def parse_cmd_line_args():
    parser = argparse.ArgumentParser(
        description='Interface with Nintendo switch joy con over bluetooth')
    parser.parse_args()


def main():
    print 'Searching for bluetooth devices...'
    nearby_devices = bluetooth.discover_devices()
    for addr in nearby_devices:
        print '\tFound: %s' % (bluetooth.lookup_name(addr),)


if __name__ == '__main__':
    parse_cmd_line_args()
    main()
