#!/usr/bin/env python

import argparse
import bluetooth

joy_con_names = ['Joy-Con (L)', 'Joy-Con (R)']


def parse_cmd_line_args():
    parser = argparse.ArgumentParser(
        description='Interface with Nintendo switch joy con over bluetooth')
    parser.parse_args()


def main():
    # Find services
    print 'Looking for services'
    services = bluetooth.find_service()
    joy_cons = []
    for service in services:
        print 'Found service: \n\t%s' % (service,)
        # Lookup the host name to see if its a Joy-Con
        name = bluetooth.lookup_name(service['host'])
        print 'The device providing the service is named: %s' % (name)
        if name in joy_con_names:
            print 'Found a Joy-Con'
            joy_cons.append(service)

    # Connect to all Found Joy-Cons
    print 'Connecting to all Joy-Cons'
    sockets = []
    for service in joy_cons:
        # Get the protocol and start a socket
        socket = None
        protocol = service['protocol']
        if protocol == 'RFCOMM':
            socket = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
        elif protocol == 'L2CAP':
            socket = bluetooth.BluetoothSocket(bluetooth.L2CAP)
        else:
            print "Unkown protocol!"
            continue

        # Connect to the socket on the correct port
        socket.connect((service['host'], service['port']))
        sockets.append(socket)
        print 'Connected'

    # Print all raw data
    while True:
        for i, socket in enumerate(sockets):
            print '-----------------------\nSocket %d' % (i,)
            socket.send(b'\x00\x01\x00')
            raw_data = socket.recv(1024)
            print raw_data.encode('hex')
            formated_data = [ord(c) for c in raw_data]
            print formated_data

    # Close all sockets
    for socket in sockets:
        socket.close()


if __name__ == '__main__':
    parse_cmd_line_args()
    main()
