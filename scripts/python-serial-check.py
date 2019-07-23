import csv
import argparse

##########################
# Created by Christian Bermejo
# Date: March 21, 2019
#
#
# Read serials from another file then print lines which are not found in another file
##########################

def parse_serials():
    parser = argparse.ArgumentParser(description='Read serials from another file to search')
    parser.add_argument('--read', '-r', dest='read', default=None, help='Source file to read')
    parser.add_argument('--search', '-s', dest='search', default=None, help='Source file to search')
    
    return parser.parse_args()
    
def get_lines_from_src(file):
    with open(file) as read:
        # get lines
        lines = [line.rstrip('\n') for line in read]
    return lines
    
def search_and_print(lines,file):
    # search and print lines which are not found in the file parameter
    with open(file) as search:
        all = search.read()
        for line in lines:
            if all.find(line) == -1:
                print("Not found: " + line)
                    
args = parse_serials()
readfrom = args.read
searchfrom = args.search


lines_read = get_lines_from_src(readfrom)

search_and_print(lines_read,searchfrom)
            
    