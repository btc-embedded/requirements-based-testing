bp = gcbp;
ca = bp.convertToCell;
ca{end} = [ ca{end} '/Subsystem/seat_heating_controller' ];
blockPath = Simulink.BlockPath(ca);
blockPath.open();
