local var0_0 = class("PtAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ActivitybonusWindow_btnVariant"
end

function var0_0.init(arg0_2)
	arg0_2.window = PtAwardWindow.New(arg0_2._tf, arg0_2)

	function arg0_2.window.Hide()
		arg0_2:Hide()
	end

	arg0_2.btn_banned = arg0_2._tf:Find("window/btn_banned")
	arg0_2.btn_get = arg0_2._tf:Find("window/btn_get")
	arg0_2.btn_got = arg0_2._tf:Find("window/btn_got")
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.btn_get, function()
		local var0_5 = arg0_4.contextData.ptData
		local var1_5, var2_5 = var0_5:GetResProgress()

		arg0_4:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = var0_5:GetId(),
			arg1 = var2_5
		})
	end, SFX_PANEL)
	arg0_4:UpdateView()
end

function var0_0.UpdateView(arg0_6)
	arg0_6.window:Show(arg0_6.contextData.ptData)

	local var0_6 = arg0_6.contextData.ptData:CanGetAward()

	setActive(arg0_6.btn_get, var0_6)
	setActive(arg0_6.btn_banned, not var0_6)
end

function var0_0.Hide(arg0_7)
	arg0_7:closeView()
end

function var0_0.willExit(arg0_8)
	if arg0_8.window then
		arg0_8.window:Dispose()

		arg0_8.window = nil
	end
end

return var0_0
