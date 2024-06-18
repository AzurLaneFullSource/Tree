local var0_0 = class("StartupCommand", pm.MacroCommand)

function var0_0.initializeMacroCommand(arg0_1)
	arg0_1:addSubCommand(PrepControllerCommand)
	arg0_1:addSubCommand(PrepModelCommand)
	arg0_1:addSubCommand(PrepViewCommand)
end

return var0_0
