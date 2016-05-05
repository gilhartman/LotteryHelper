import argparse
import os
import sys
import xml.etree.ElementTree as ET


def parse_args():
    parser = argparse.ArgumentParser(description='Parse netbet xml files')
    parser.add_argument('input_file', help='netbet xml input file')
    parser.add_argument('main_number', type=int, help='Main number to appear')
    parser.add_argument('-l', '--list', nargs='+', type=int, help='<Required> Set flag', required=True)
    return parser.parse_args()


def does_block_match(blockDict, main_number, numbers_list):
    guess_nums = [int(n) for n in blockDict['RegularGuess'].split(',')]
    extra_number = main_number in guess_nums
    extra_number_winner = general_winner = False
    count = 0
    for num in numbers_list:
        if num in guess_nums:
            count += 1
    if count == 2 and extra_number:
        extra_number_winner = True
    if count >= 3:
        general_winner = True
    return general_winner, extra_number_winner


def main():
    args = parse_args()
    if not os.path.exists(args.input_file):
        print "The file %s does not exist" % (args.input_file,)
        sys.exit(1)

    if args.main_number in args.list:
        print "Main number should not be part of list"
        sys.exit(1)

    tree = ET.parse(args.input_file)
    root = tree.getroot()
    winning_tickets = []
    regular_tickets = []
    for bet in root:
        is_ticket_winner = False
        # del ticket_extra_number_winners[:]
        ticket_extra_number_winners = []
        for block in bet:
            general_winner, extra_number_winner = does_block_match(block.attrib, args.main_number, args.list)
            is_ticket_winner |= general_winner
            if extra_number_winner:
                ticket_extra_number_winners.append((bet.attrib['OrdinalNumber'], block.tag.replace("Block", "")))

        if is_ticket_winner:
            winning_tickets += ticket_extra_number_winners[:]
        else:
            regular_tickets += ticket_extra_number_winners[:]

    print "Non winning tickets\n==============="
    for i in regular_tickets:
        print "Ticket %s - Row %s" % (i[0], i[1])
    print "\nWinning tickets\n============"
    for i in winning_tickets:
        print "Ticket %s - Row %s" % (i[0], i[1])


if __name__ == "__main__":
    main()
