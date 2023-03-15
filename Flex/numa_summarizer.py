import sys
import os

def main():
    assert len(sys.argv) == 2, 'You need to pass exactly one input file'

    input_file              = sys.argv[1]
    numa_compacted          = os.path.splitext(input_file)[0] + '_numa_compacted'
    sorted_output_file      = os.path.splitext(input_file)[0] + '_sorted_output'
    numa_A_output_file      = os.path.splitext(input_file)[0] + '_numa_A_output'
    numa_B_output_file      = os.path.splitext(input_file)[0] + '_numa_B_output'
    numa_freq_output_file   = os.path.splitext(input_file)[0] + '_numa_freq_output'
    numa_matrix_output_file = os.path.splitext(input_file)[0] + '_numa_matrix_output'

    '''
    Reading input file

    Line Example:
        <index> <numba_node_A> <numba_node_B> 
    '''
    numa_data_1 = []
    with open(input_file, 'r') as f:
        for line in f.readlines():
            data = line.strip().split()
            data = [int(x) for x in data]
            numa_data_1.append(data) 

    '''
    Couting index frequency in file

    '''
    seen = []
    numa_data = []
    with open(numa_compacted, 'w') as f:
        for i in range(len(numa_data_1)):
            if numa_data_1[i] in seen:
                continue
            seen.append(numa_data_1[i])
            count = 1
            for j in range(i+1, len(numa_data_1)):
                if numa_data_1[i] == numa_data_1[j]: 
                    count += 1

            f.write(f"{numa_data_1[i][0]} {numa_data_1[i][1]} {numa_data_1[i][2]} {count}\n")
            numa_data_1[i].append(count)
            numa_data.append(numa_data_1[i])

    '''
    Writing sorted output file
    Sorted by <index>
    '''
    print(numa_data)
    numa_data = sorted(numa_data)
    with open(sorted_output_file, 'w') as f:
        for line in numa_data:
            f.write(f"{line[0]} {line[1]} {line[2]} \n")

    ''' 
    Writing files with numba information (A and B)
    One file for each

    Line Example:
        <start>-<end>: <NUMA node> 
    Each line represents a sequence of <index>, starting at
    <start> and ending at <end>, that are contained in <NUMA node>
    '''
    for i in (1, 2):
        prev  = numa_data[0][i] # last numba_node; 1 = A; 2 = B
        first = numa_data[0][0] # first index in the sequence
        last  = numa_data[0][0] # last index in the sequence

        output_file = numa_A_output_file if i == 1 else numa_B_output_file
        with open(output_file, 'w') as f:
            for line in numa_data[1:]:
                curr = line[i]
                if curr != prev:
                    f.write(f"{first}-{last}: {prev}\n")
                    prev = curr
                    first = line[0]
                last = line[0]

            f.write(f"{first}-{last}: {prev}\n")

    '''
    Writing file with total frequency for each NUMA node

    Line Example:
        <NUMA node>: <access frequency count>
    '''
    numa_freq = {}
    for line in numa_data:
        for i in (1, 2): # A and B
            numa = line[i]
            if numa not in numa_freq:
                numa_freq[numa] = line[-1]
            else:
                numa_freq[numa] += line[-1]

    with open(numa_freq_output_file, 'w') as f:
        for k in sorted(numa_freq.keys()):
            f.write(f"{k}: {numa_freq[k]}\n")
    
    '''
    Writing file with frequency matrix

    File Example with 2 NUMA nodes:
    0 0 <freq_0x0>
    0 1 <freq_0x1> 
    1 0 <freq_1x0>
    1 1 <freq_1x1>
    '''
    len_matrix = max(numa_freq.keys()) + 1
    print(len_matrix)
    numa_matrix = [[0 for _ in range(len_matrix)] for _ in range(len_matrix)]
    for line in numa_data:
        numa_matrix[line[1]][line[2]] += line[-1]
    
    with open(numa_matrix_output_file, 'w') as f:
        for i in range(len_matrix):
            for j in range(len_matrix):
                f.write(f"{i} {j} {numa_matrix[i][j]}\n")


if __name__ == "__main__":
    main()
