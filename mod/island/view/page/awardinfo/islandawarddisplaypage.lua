local var0_0 = class("IslandAwardDisplayPage", import("view.base.BaseSubView"))

var0_0.TYPE_COMMON = 1
var0_0.TYPE_SHIP_SKILL = 2
var0_0.TYPE_SHIP_BREAK = 3
var0_0.TYPE_SIGN_GIFT = 4
var0_0.AUTO_COLLECT = 5

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayConatiner"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.windows = {
		[var0_0.TYPE_COMMON] = IslandAwardDisplayWindow.New(arg0_2._tf),
		[var0_0.TYPE_SHIP_SKILL] = IslandAwardDisplay4ShipSkillWindow.New(arg0_2._tf),
		[var0_0.TYPE_SHIP_BREAK] = IslandAwardDisplay4ShipBreakWindow.New(arg0_2._tf),
		[var0_0.TYPE_SIGN_GIFT] = IslandAwardDisplay4SignGiftWindow.New(arg0_2._tf),
		[var0_0.AUTO_COLLECT] = IslandAutoCollectAwardDisplayWindow.New(arg0_2._tf)
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		if not arg0_3.window then
			return
		end

		if arg0_3.playing then
			return
		end

		arg0_3.playing = true

		arg0_3.window:PlayExitAniamtion(function()
			arg0_3.playing = false

			if arg0_3.callback then
				arg0_3.callback()

				arg0_3.callback = nil
			end

			arg0_3:Hide()
		end)

		arg0_3.window = nil
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)
	assert(not arg0_6:AnyWindowShowing(), "同时只能存在一个奖励界面")
	arg0_6:HideWindows()

	local var0_6 = arg1_6.type or var0_0.TYPE_COMMON

	arg0_6.callback = arg1_6.callback

	local var1_6 = arg0_6.windows[var0_6]

	var1_6:ExecuteAction("Show", arg1_6)

	arg0_6.window = var1_6
end

function var0_0.AnyWindowShowing(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.windows) do
		if iter1_7:GetLoaded() and iter1_7:isShowing() then
			return true
		end
	end

	return false
end

function var0_0.HideWindows(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.windows) do
		arg0_8:HideWindow(iter1_8, iter0_8)
	end
end

function var0_0.HideWindow(arg0_9, arg1_9, arg2_9)
	if arg1_9:GetLoaded() and arg1_9:isShowing() then
		if arg2_9 == var0_0.TYPE_COMMON then
			arg1_9:Hide()
		else
			arg1_9:Destroy()
			arg1_9:Reset()
		end
	end
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	arg0_10:HideWindows()

	arg0_10.callback = nil
end

function var0_0.OnDestroy(arg0_11)
	local var0_11 = arg0_11.windows[var0_0.TYPE_COMMON]

	if var0_11:GetLoaded() and var0_11:isShowing() then
		var0_11:Destroy()
		window:Reset()
	end
end

return var0_0
