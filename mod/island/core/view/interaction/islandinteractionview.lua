local var0_0 = class("IslandInteractionView", import("..IslandBaseOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandInteractionUI"
end

function var0_0.GetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().interactionContainer
end

function var0_0.OnInit(arg0_3, arg1_3)
	arg0_3.showBalance = 1
	arg0_3.timers = {}
	arg0_3.interactionPanel = arg0_3._tf:Find("interaction_btns")
	arg0_3.interactionUIItemList = UIItemList.New(arg0_3.interactionPanel, arg0_3.interactionPanel:Find("interaction"))

	arg0_3:ShowInterActionPanel({
		type = -1
	})
end

function var0_0.ShowInterActionPanel(arg0_4, arg1_4)
	arg0_4:UpdateInteractionBtns(arg1_4)
end

function var0_0.UpdateInteractionBtns(arg0_5, arg1_5)
	arg0_5.interactionData = arg1_5

	local var0_5 = arg0_5.interactionData.id
	local var1_5 = IslandInteractionUntil.GetInteractionOptions(arg0_5:GetView():GetIsland(), arg0_5.interactionData.type, var0_5)

	arg0_5:RemoveTimers()
	arg0_5.interactionUIItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var1_5[arg1_6 + 1]

			arg2_6.name = var0_6.id

			onButton(arg0_5, arg2_6, function()
				if arg0_5.interactionData.callback then
					arg0_5.interactionData.callback()
				end

				IslandInteractionUntil.Response(arg0_5, var0_5, var0_6.id)
			end, SFX_PANEL)
			arg0_5:SetInteractionText(arg2_6, var0_6)
		end
	end)
	arg0_5.interactionUIItemList:align(#var1_5)
end

function var0_0.CloseInterActionPanelByUnitIdRemove(arg0_8, arg1_8)
	if not arg0_8.interactionData then
		return
	end

	if arg0_8.interactionData.id == arg1_8 then
		arg0_8:HideInterActionPanel()
	end
end

function var0_0.ShowNextInteractionBtns(arg0_9, arg1_9)
	arg0_9.interactionData.type = tonumber(arg1_9)

	arg0_9:UpdateInteractionBtns(arg0_9.interactionData)
end

function var0_0.SetInteractionText(arg0_10, arg1_10, arg2_10)
	if arg2_10.id == IslandInteractionUntil.SIGNIN_TIME_ID then
		setActive(arg1_10:Find("time"), true)
		arg0_10:AddTimer(arg1_10, arg2_10)
	else
		setActive(arg1_10:Find("time"), false)
	end

	setText(arg1_10:Find("bg/Text"), HXSet.hxLan(arg2_10.text))

	local var0_10 = GetSpriteFromAtlas("island/IslandInteractionBtns", tostring(arg2_10.icon))

	setImageSprite(arg1_10:Find("icon_type"), var0_10, true)
end

function var0_0.AddTimer(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:GetView():GetIsland():GetSignInAgency():GetNextCanSignInTime()
	local var1_11 = Timer.New(function()
		local var0_12 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_12 = var0_11 - var0_12

		if var1_12 <= 0 then
			setActive(arg1_11:Find("time"), false)
			arg0_11:RemoveTimers()
			arg0_11:RefreshInteractionBtns()
		else
			setText(arg1_11:Find("time/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_12))
		end
	end, 1, -1)

	arg0_11.timers[arg2_11.id] = var1_11

	arg0_11.timers[arg2_11.id].func()
	var1_11:Start()
end

function var0_0.RemoveTimers(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.timers or {}) do
		iter1_13:Stop()
	end

	arg0_13.timers = {}
end

function var0_0.RefreshInteractionBtns(arg0_14)
	if not arg0_14.interactionData then
		return
	end

	arg0_14:UpdateInteractionBtns(arg0_14.interactionData)
end

function var0_0.HideInterActionPanel(arg0_15)
	arg0_15:RemoveTimers()

	arg0_15.interactionData = nil

	arg0_15.interactionUIItemList:align(0)
end

function var0_0.EnableInteraction(arg0_16)
	arg0_16:ShowOrHideGameObject(arg0_16.interactionPanel, true)
end

function var0_0.DisableInteraction(arg0_17)
	arg0_17:ShowOrHideGameObject(arg0_17.interactionPanel, false)
end

function var0_0.OnDestroy(arg0_18)
	arg0_18:RemoveTimers()
end

return var0_0
