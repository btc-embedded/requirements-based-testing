TemperatureRanges_LOW = 30;
TemperatureRanges_MEDIUM = 35;
TemperatureRanges_HIGH = 45;

RTE_OK = 0;

try
    Simulink.defineIntEnumType( 'IDT_PowerState', ...
   {'NOK','OK'}, ...
   [0 1], ...
   'AddClassNameToEnumNames', false);
end
