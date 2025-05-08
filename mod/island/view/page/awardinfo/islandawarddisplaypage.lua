local var0_0 = class("IslandAwardDisplayPage", import("view.base.BaseSubView"))

var0_0.TYPE_COMMON = 1

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayConatiner"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.windows = {
		[var0_0.TYPE_COMMON] = IslandAwardDisplayWindow.New(arg0_2._tf)
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.callback then
			arg0_3.callback()

			arg0_3.callback = nil
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)
	assert(not arg0_5:AnyWindowShowing(), "同时只能存在一个奖励界面")
	arg0_5:HideWindows()

	local var0_5 = arg1_5.type or var0_0.TYPE_COMMON

	arg0_5.callback = arg1_5.callback

	arg0_5.windows[var0_5]:ExecuteAction("Show", arg1_5)
end

function var0_0.AnyWindowShowing(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.windows) do
		if iter1_6:GetLoaded() and iter1_6:isShowing() then
			return true
		end
	end

	return false
end

function var0_0.HideWindows(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.windows) do
		arg0_7:HideWindow(iter1_7, iter0_7)
	end
end

function var0_0.HideWindow(arg0_8, arg1_8, arg2_8)
	if arg1_8:GetLoaded() and arg1_8:isShowing() then
		if arg2_8 == var0_0.TYPE_COMMON then
			arg1_8:Hide()
		else
			arg1_8:Destroy()
			arg1_8:Reset()
		end
	end
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)
	arg0_9:HideWindows()

	arg0_9.callback = nil
end

function var0_0.OnDestroy(arg0_10)
	local var0_10 = arg0_10.windows[var0_0.TYPE_COMMON]

	if var0_10:GetLoaded() and var0_10:isShowing() then
		var0_10:Destroy()
		window:Reset()
	end
end

return var0_0
