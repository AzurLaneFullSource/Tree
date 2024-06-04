local var0 = class("StartupCommand", pm.MacroCommand)

function var0.initializeMacroCommand(arg0)
	arg0:addSubCommand(PrepControllerCommand)
	arg0:addSubCommand(PrepModelCommand)
	arg0:addSubCommand(PrepViewCommand)
end

return var0
