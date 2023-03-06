import sys
import os

def main():
    assert len(sys.argv) == 2, 'You need to pass exactly one input file'

    input_file         = sys.argv[1]
    sorted_output_file = os.path.splitext(input_file)[0] + '_sorted_output'
    numa_output_file   = os.path.splitext(input_file)[0] + '_numa_output'

    ''' 
    Reading input file

    Line Example:
        <index> <numba_node> <frequency> 
    '''
    numa_data = []
    with open(input_file, 'r') as f:
        for line in f.readlines():
            data = line.strip().split()
            data = [int(x) for x in data]
            numa_data.append(data)

    ''' 
    Writing sorted output file

    Line Example:
        <index> <numba_node> <frequency> 
    Sorted by <index>
    '''
    numa_data = sorted(numa_data)
    with open(sorted_output_file, 'w') as f:
        for line in numa_data:
            f.write(f"{line[0]} {line[1]} {line[2]} \n")
    
    # Writing file with numba information
    prev  = numa_data[0][1] # last numba_node
    first = numa_data[0][0] # first index in the sequence
    last  = numa_data[0][0] # last index in the sequence

    ''' 
    Writing numa info output file

    Line Example:
        <start>-<end>: <NUMA node> 
    Each line represents a sequence of <index>, starting at
    <start> and ending at <end>, that are contained in <NUMA node>
    '''
    with open(numa_output_file, 'w') as f:
        for line in numa_data[1:]:
            curr = line[1]
            if curr != prev:
                f.write(f"{first}-{last}: {prev}\n")
                prev = curr
                first = line[0]
            last = line[0]

        f.write(f"{first}-{last}: {prev}\n")
        

if __name__ == "__main__":
    main()
