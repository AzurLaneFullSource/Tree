local var0_0 = class("NewEducateReplaceTarotLayer", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateReplaceTarotUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2._tf:Find("title"), i18n("child2_replace_title"))
	setText(arg0_2._tf:Find("tip"), i18n("child2_replace_tip"))

	arg0_2.toggleTF = arg0_2._tf:Find("toggle")

	setText(arg0_2.toggleTF:Find("Text"), i18n("child2_show_detail_desc"))

	arg0_2.oldTF = arg0_2._tf:Find("old")
	arg0_2.oldCard = NewEducateTarotCard.New(arg0_2.oldTF)
	arg0_2.newTF = arg0_2._tf:Find("new")
	arg0_2.newCard = NewEducateTarotCard.New(arg0_2.newTF)
	arg0_2.cancelBtn = arg0_2._tf:Find("cancel_btn")

	setText(arg0_2.cancelBtn:Find("Text"), i18n("child2_replace_cancel"))

	arg0_2.sureBtn = arg0_2._tf:Find("sure_btn")

	setText(arg0_2.sureBtn:Find("Text"), i18n("child2_replace_sure"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:BlurPanel(arg0_3._tf, {
		groupDelta = 3
	})
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3.state:SetHoldId(arg0_3.oldId)
		arg0_3:CheckState()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sureBtn, function()
		arg0_3.state:SetHoldId(arg0_3.newId)
		arg0_3:CheckState()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.toggleTF, function(arg0_6)
		NewEducateHelper.SetTarotDeatilDescData(arg0_6)
		arg0_3.oldCard:UpdateDescMode(arg0_6)
		arg0_3.newCard:UpdateDescMode(arg0_6)
	end, SFX_PANEL)
	arg0_3:UpdateView()
	triggerToggle(arg0_3.toggleTF, NewEducateHelper.IsShowTarotDeatilDesc())
end

function var0_0.UpdateView(arg0_7)
	arg0_7.state = getProxy(NewEducateProxy):GetCurChar():GetFSM():GetPriorityState()
	arg0_7.oldId = arg0_7.state:GetHoldId()

	if arg0_7.oldId == 0 then
		arg0_7.oldId = arg0_7.contextData.char:GetTarotId()
	end

	arg0_7.newId = arg0_7.state:GetFirstId()

	arg0_7.oldCard:Update(arg0_7.oldId, NewEducateTarotCard.TYPE.CURRENT)
	arg0_7.newCard:Update(arg0_7.newId, NewEducateTarotCard.TYPE.REPLACE)
	triggerToggle(arg0_7.toggleTF, false)
end

function var0_0.CheckState(arg0_8)
	arg0_8.state:PopId()

	if arg0_8.state:IsFinish() then
		local var0_8 = arg0_8.contextData.char:GetTarotId()
		local var1_8 = arg0_8.state:GetHoldId() == var0_8 and 0 or arg0_8.state:GetHoldId()

		arg0_8:emit(NewEducateReplaceTarotMediator.ON_REPLACE_TAROT, var1_8)
	else
		arg0_8:closeView()
	end
end

function var0_0.OnReplaceDone(arg0_9, arg1_9)
	seriesAsync({
		function(arg0_10)
			arg0_9._tf:GetComponent(typeof(Animation)):Play("Anim_NewEducateReplaceTarotUI_cliek")
			onDelayTick(arg0_10, 0.4)
		end,
		function(arg0_11)
			if #arg1_9.drops > 0 then
				arg0_9:emit(var0_0.ON_DROP, {
					items = arg1_9.drops,
					removeFunc = function()
						arg0_11()
					end
				})
			else
				arg0_11()
			end
		end
	}, function()
		arg0_9:closeView()
	end)
end

function var0_0.onBackPressed(arg0_14)
	return
end

function var0_0.willExit(arg0_15)
	arg0_15.oldCard:Dispose()
	arg0_15.newCard:Dispose()
	arg0_15:UnOverlayPanel(arg0_15._tf)
	existCall(arg0_15.contextData.onExit)
end

return var0_0
