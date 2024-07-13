local var0_0 = class("TaskPtAwardPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ActivitybonusWindow"
end

function var0_0.Display(arg0_2, arg1_2)
	if not arg0_2.window then
		arg0_2.window = TaskPtAwardWindow.New(arg0_2._tf, arg0_2)
	end

	arg0_2.window:Show(arg1_2)
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3.window then
		arg0_3.window:Dispose()

		arg0_3.window = nil
	end
end

return var0_0
