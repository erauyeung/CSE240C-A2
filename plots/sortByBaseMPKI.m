% only for the S-curve at the start....
function [MPKIbase, MPKImulti, MPKIship, IPCbase, IPCmulti, IPCship] = sortByBaseMPKI(config)
    if (config == 1)
        % do all the config1s (no prefetcher)
        base = readstats('datapoints/base-config1');
        multi = readstats('datapoints/ship-config1');
        ship = readstats('datapoints/multi-config1');
    else
        % do all the config2s (with prefetcher)
        base = readstats('datapoints/base-config2');
        multi = readstats('datapoints/ship-config2');
        ship = readstats('datapoints/multi-config2');
    end

    % misses / (instructions / 1000)
    MPKIbase = base{1,2} ./ (base{1,3} ./ 1000);
    MPKImulti = multi{1,2} ./ (multi{1,3} ./ 1000);
    MPKIship = ship{1,2} ./ (ship{1,3} ./ 1000);

    IPCbase = base{1,4};
    IPCmulti = multi{1,4};
    IPCship = ship{1,4};

    % traces should already be in consistent order across all datapoints/
    % trace name, MPKIs, IPCs
    data = createBaseCellArray(base{1}, MPKIbase, MPKImulti, MPKIship);
    % sort by baseline MPKI
    sortedData = sortrows(data,2);

    if (config == 1)
        graphBaseComparison(sortedData,1)
    else
        graphBaseComparison(sortedData,3)
    end
end