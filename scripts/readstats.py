import re
import os

# CPU 0 cummulative IPC: 0.491518 instructions: 100000000 cycles: 203451296
# LLC TOTAL     ACCESS:     373285  HIT:     146976  MISS:     226309
d_reg = r'\d+\.?\d*'
reg1 = r'CPU \d+ cummulative IPC: \d+.\d+ instructions: \d+ cycles: \d+'
reg2 = r'LLC\s+TOTAL\s+ACCESS:\s+\d+\s+HIT:\s+\d+\s+MISS:\s+\d+'

datapts = './datapoints'

# baseline
baseline_traces = './output_base'
baseline_subfolders = ['base-config1', 'base-config2']

# basics
traces = './output'
subfolders = ['multi-config1','multi-config2','ship-config1','ship-config2']

# output_multim1,2
# multim1-1  multim1-2  multim1-3
multi_mod_traces = './output_multim'

# output ship++m1,2,3
# ship++m1-1  ship++m1-2  ship++m1-3
ship_mod_traces = './output_ship++m'

# design space
# multis-1  multis-2  multis-3
# multis2-1  multis2-2  multis2-3
multi_space_traces = './output_multis'

# Source: https://stackoverflow.com/questions/16891340/remove-a-prefix-from-a-string
def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text

def print_stats(folder, misses, instrs, ipcs):
    print("Average MPKI for {}\t= {}".format(folder, misses/instrs * 1000))
    print("Average IPC for {}\t= {}".format(folder, ipcs/51))
    print

def process_dir(trace_name, subf_name):
    n_traces = 0
    tot_instrs = 0
    tot_misses = 0
    tot_ipc = 0

    datalines = {}

    # Save data points into files for use in graphing...
    writefile = open(os.path.join(datapts, subf_name), "w")
    #writefile.write("Trace\tMisses\tTotal instructions\tIPC\n")

    # Chop off prefix that states binary, config, sim stats
    # Chop off ".trace.gz.txt"
    for f in os.listdir(os.path.join(trace_name,subf_name)):
        n_traces = n_traces + 1
        if trace_name is traces:
            for possible_subf in subfolders:
                if possible_subf is subf_name:
                    stripped_name = remove_prefix(f, subf_name + "-w10000000-s100000000-")
                    stripped_name = stripped_name[:len(stripped_name) - 13]
                    break
        elif trace_name is baseline_traces:
            for possible_subf in baseline_subfolders:
                if possible_subf is subf_name:
                    stripped_name = remove_prefix(f, subf_name + "-w10000000-s100000000-")
                    stripped_name = stripped_name[:len(stripped_name) - 13]
                    break
        else:
            stripped_name = remove_prefix(f, subf_name + "-config")[23:]
            stripped_name = stripped_name[:len(stripped_name) - 13]
        for line in open(os.path.join(trace_name,subf_name,f)):
            m1 = re.match(reg1, line)
            m2 = re.match(reg2, line)
            # IPC, num instructions
            if m1 is not None:
                nums = re.findall(d_reg, line)
                ipc = float(nums[1])
                num_instrs = nums[2]
            # misses
            if m2 is not None:
                num_misses = re.findall(d_reg, line)[2]

        assert num_misses != 0
        assert num_instrs != 0
        assert ipc != 0
        tot_instrs = tot_instrs + float(num_instrs)
        tot_misses = tot_misses + float(num_misses)
        tot_ipc = tot_ipc + ipc
        #writefile.write("{}\t{:d}\t{:d}\t{}\n".format(stripped_name, int(num_misses), int(num_instrs), ipc))
        datalines[stripped_name] = (int(num_misses), int(num_instrs), ipc)

    ordered_keys = sorted(datalines)
    for key in ordered_keys:
        writefile.write("{}\t{:d}\t{:d}\t{}\n".format(key, datalines[key][0], datalines[key][1], datalines[key][2]))
        
    #writefile.write("{}\t{:d}\t{:d}\t{}\n".format(stripped_name, int(num_misses), int(num_instrs), ipc))
    writefile.close()
    return n_traces, tot_instrs, tot_misses, tot_ipc

#for root, dirs, files in os.walk('traces'):
#    print(files)

# baseline
for subf in baseline_subfolders:
    print("Processing folder:\t" + baseline_traces + "/" + subf)
    n_traces, total_instrs, total_misses, total_ipc = process_dir(baseline_traces, subf)
    assert n_traces == 51
    print_stats(subf, total_misses, total_instrs, total_ipc)

# basics
for subf in subfolders:
    print("Processing folder:\t" + traces + "/" + subf)
    n_traces, total_instrs, total_misses, total_ipc = process_dir(traces, subf)
    assert n_traces == 51
    print_stats(subf, total_misses, total_instrs, total_ipc)

# multim1,2
for layer1 in range(1,3):
    top_folder = multi_mod_traces + str(layer1)
    print(top_folder)
    for layer2 in range(1,4):
        trace_folder = 'multim' + str(layer1) + '-' + str(layer2)
        print(trace_folder)

        n_traces, total_instrs, total_misses, total_ipc = process_dir(top_folder, trace_folder)
        assert n_traces == 51
        print_stats(trace_folder, total_misses, total_instrs, total_ipc)

# ship++1,2,3
for layer1 in range(1,4):
    top_folder = ship_mod_traces + str(layer1)
    print(top_folder)
    for layer2 in range(1,4):
        trace_folder = 'ship++m' + str(layer1) + '-' + str(layer2)
        print(trace_folder)

        n_traces, total_instrs, total_misses, total_ipc = process_dir(top_folder, trace_folder)
        assert n_traces == 51
        print_stats(trace_folder, total_misses, total_instrs, total_ipc)

# multi space exploration
for layer2 in range(1,4):
    trace_folder = 'multis-' + str(layer2)
    print(trace_folder)

    n_traces, total_instrs, total_misses, total_ipc = process_dir(multi_space_traces, trace_folder)
    assert n_traces == 51
    print_stats(trace_folder, total_misses, total_instrs, total_ipc)

for layer1 in range(2,4):
    for layer2 in range(1,4):
        trace_folder = 'multis' + str(layer1) + '-' + str(layer2)
        print(trace_folder)

        n_traces, total_instrs, total_misses, total_ipc = process_dir(multi_space_traces + str(layer1), trace_folder)
        assert n_traces == 51
        print_stats(trace_folder, total_misses, total_instrs, total_ipc)

# ship++s
print("Ship++s")
for layer2 in range(1,2):
    trace_folder = 'ship++s-' + str(layer2)
    print(trace_folder)

    n_traces, total_instrs, total_misses, total_ipc = process_dir('./output_ship++s', trace_folder)
    assert n_traces == 51
    print_stats(trace_folder, total_misses, total_instrs, total_ipc)
