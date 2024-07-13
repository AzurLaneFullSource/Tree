local var0_0 = import("..observer.Notifier")
local var1_0 = class("MacroCommand", var0_0)

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.subCommands = {}

	arg0_1:initializeMacroCommand()
end

function var1_0.initializeMacroCommand(arg0_2)
	return
end

function var1_0.addSubCommand(arg0_3, arg1_3)
	table.insert(arg0_3.subCommands, arg1_3)
end

function var1_0.execute(arg0_4, arg1_4)
	while #arg0_4.subCommands > 0 do
		local var0_4 = table.remove(arg0_4.subCommands, 1).New()

		var0_4:initializeNotifier(arg0_4.multitonKey)
		var0_4:execute(arg1_4)
	end
end

return var1_0
