local var0 = import("..observer.Notifier")
local var1 = class("MacroCommand", var0)

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.subCommands = {}

	arg0:initializeMacroCommand()
end

function var1.initializeMacroCommand(arg0)
	return
end

function var1.addSubCommand(arg0, arg1)
	table.insert(arg0.subCommands, arg1)
end

function var1.execute(arg0, arg1)
	while #arg0.subCommands > 0 do
		local var0 = table.remove(arg0.subCommands, 1).New()

		var0:initializeNotifier(arg0.multitonKey)
		var0:execute(arg1)
	end
end

return var1
