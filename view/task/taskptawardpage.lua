local var0 = class("TaskPtAwardPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "ActivitybonusWindow"
end

function var0.Display(arg0, arg1)
	if not arg0.window then
		arg0.window = TaskPtAwardWindow.New(arg0._tf, arg0)
	end

	arg0.window:Show(arg1)
	arg0:Show()
end

function var0.OnDestroy(arg0)
	if arg0.window then
		arg0.window:Dispose()

		arg0.window = nil
	end
end

return var0
