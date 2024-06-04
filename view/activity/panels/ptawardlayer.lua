local var0 = class("PtAwardLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "ActivitybonusWindow_btnVariant"
end

function var0.init(arg0)
	arg0.window = PtAwardWindow.New(arg0._tf, arg0)

	function arg0.window.Hide()
		arg0:Hide()
	end

	arg0.btn_banned = arg0._tf:Find("window/btn_banned")
	arg0.btn_get = arg0._tf:Find("window/btn_get")
	arg0.btn_got = arg0._tf:Find("window/btn_got")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btn_get, function()
		local var0 = arg0.contextData.ptData
		local var1, var2 = var0:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = var0:GetId(),
			arg1 = var2
		})
	end, SFX_PANEL)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	arg0.window:Show(arg0.contextData.ptData)

	local var0 = arg0.contextData.ptData:CanGetAward()

	setActive(arg0.btn_get, var0)
	setActive(arg0.btn_banned, not var0)
end

function var0.Hide(arg0)
	arg0:closeView()
end

function var0.willExit(arg0)
	if arg0.window then
		arg0.window:Dispose()

		arg0.window = nil
	end
end

return var0
