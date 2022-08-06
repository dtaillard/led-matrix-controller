#!/usr/bin/python3

import argparse
import imageio.v2 as imageio

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert image to memory file for Vivado.')
    parser.add_argument('infile', type=str,
            help='input image file (any image format supported by imageio')
    parser.add_argument('outfile', type=str,
            help='output memory file')
    parser.add_argument('--bits', '-b', type=int, default=8,
            help='bits per color channel (e.g. 8 bits for 24-bit color)')

    args = parser.parse_args()

    num_hex_digits = int((args.bits * 3) / 4)

    image = imageio.imread(args.infile)
    with open(args.outfile, 'w') as f:
        for row in range(len(image)):
            for col in range(len(image[0])):
                (r, g, b) = image[row][col]
                output_color = (r << 2*args.bits) | (g << args.bits) | b
                if(row != 0 and col == 0):
                    f.write('\n');
                f.write('{value:0{width}x} '.format(value=output_color, width=num_hex_digits))
    
    print('Note: Ensure the dimensions of your image match the LED matrix dimensions!')

