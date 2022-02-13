function [geo_base, geo_multi, geo_ship] = get_geomeans(base, multi, ship)
geo_base = geomean(base);
geo_multi = geomean(multi);
geo_ship = geomean(ship);
end