
TemperatureRanges_TemperatureStage1 = 30;
TemperatureRanges_TemperatureStage2 = 35;
TemperatureRanges_TemperatureStage3 = 45;

RTE_OK = 0;

try
    seat_heating_control_defineIntEnumTypes
end

addpath(fileparts(fileparts(mfilename('fullpath'))));
