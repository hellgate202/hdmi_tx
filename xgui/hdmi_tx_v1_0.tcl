# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "PX_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.PX_WIDTH { PARAM_VALUE.PX_WIDTH } {
	# Procedure called to update PX_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PX_WIDTH { PARAM_VALUE.PX_WIDTH } {
	# Procedure called to validate PX_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.X_RES { MODELPARAM_VALUE.X_RES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "X_RES". Setting updated value from the model parameter.
set_property value 1920 ${MODELPARAM_VALUE.X_RES}
}

proc update_MODELPARAM_VALUE.Y_RES { MODELPARAM_VALUE.Y_RES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "Y_RES". Setting updated value from the model parameter.
set_property value 1080 ${MODELPARAM_VALUE.Y_RES}
}

proc update_MODELPARAM_VALUE.PX_WIDTH { MODELPARAM_VALUE.PX_WIDTH PARAM_VALUE.PX_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PX_WIDTH}] ${MODELPARAM_VALUE.PX_WIDTH}
}

