# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "PX_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_RES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_RES" -parent ${Page_0}


}

proc update_PARAM_VALUE.PX_WIDTH { PARAM_VALUE.PX_WIDTH } {
	# Procedure called to update PX_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PX_WIDTH { PARAM_VALUE.PX_WIDTH } {
	# Procedure called to validate PX_WIDTH
	return true
}

proc update_PARAM_VALUE.X_RES { PARAM_VALUE.X_RES } {
	# Procedure called to update X_RES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_RES { PARAM_VALUE.X_RES } {
	# Procedure called to validate X_RES
	return true
}

proc update_PARAM_VALUE.Y_RES { PARAM_VALUE.Y_RES } {
	# Procedure called to update Y_RES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_RES { PARAM_VALUE.Y_RES } {
	# Procedure called to validate Y_RES
	return true
}


proc update_MODELPARAM_VALUE.X_RES { MODELPARAM_VALUE.X_RES PARAM_VALUE.X_RES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_RES}] ${MODELPARAM_VALUE.X_RES}
}

proc update_MODELPARAM_VALUE.Y_RES { MODELPARAM_VALUE.Y_RES PARAM_VALUE.Y_RES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_RES}] ${MODELPARAM_VALUE.Y_RES}
}

proc update_MODELPARAM_VALUE.PX_WIDTH { MODELPARAM_VALUE.PX_WIDTH PARAM_VALUE.PX_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PX_WIDTH}] ${MODELPARAM_VALUE.PX_WIDTH}
}

