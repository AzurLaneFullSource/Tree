local var0_0 = class("IslandOpView", import(".IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.inputController = IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController))
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.interactionPanel = arg0_2._tf:Find("interaction_btns")
	arg0_2.interactionUIItemList = UIItemList.New(arg0_2.interactionPanel, arg0_2.interactionPanel:Find("interaction"))
	arg0_2.opPanel = arg0_2._tf:Find("op_btns")
	arg0_2.plantBtn = arg0_2.opPanel:Find("plant")
	arg0_2.areaChangeBtn = arg0_2.opPanel:Find("scope")
	arg0_2.interactionBtnOther = arg0_2.opPanel:Find("interaction")
	arg0_2.syncInteractionBtn = arg0_2.opPanel:Find("sync_interaction")
	arg0_2.run = arg0_2.opPanel:Find("run")
	arg0_2.moveBtn = arg0_2.opPanel:Find("move")

	setActive(arg0_2.opPanel, true)

	arg0_2.targetTracker = IslandTargetTracker.New(arg0_2._tf)

	arg0_2:ShowInterActionPanel({
		displayTpye = "normal",
		type = -1
	})
end

function var0_0.ShowInterActionPanel(arg0_3, arg1_3)
	arg0_3:UpdateInteractionBtns(arg1_3)

	local var0_3 = arg1_3.displayTpye

	if var0_3 then
		if var0_3 == "plant" or var0_3 == "collect" then
			setActive(arg0_3.plantBtn, true)

			if var0_3 == "plant" then
				onButton(arg0_3, arg0_3.plantBtn, function()
					arg0_3:Emit(ISLAND_EVT.PLANT)
				end, SFX_PANEL)
				setActive(arg0_3.areaChangeBtn, true)
			else
				onButton(arg0_3, arg0_3.plantBtn, function()
					pg.TipsMgr.GetInstance():ShowTips("开始采集,播放采集动作")
					arg1_3.nearItem:StartColloct()
				end, SFX_PANEL)
				setActive(arg0_3.areaChangeBtn, false)
			end

			setActive(arg0_3.interactionBtnOther, false)
		else
			setActive(arg0_3.plantBtn, false)
			setActive(arg0_3.areaChangeBtn, false)
			setActive(arg0_3.interactionBtnOther, false)
		end
	end

	onButton(arg0_3, arg0_3.areaChangeBtn, function()
		arg0_3:Emit(ISLAND_EVT.AREACHANGE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.run, function()
		return
	end, SFX_PANEL)
	setActive(arg0_3.syncInteractionBtn, false)
	onButton(arg0_3, arg0_3.syncInteractionBtn, function()
		arg0_3:Emit(ISLAND_EVT.SYNC_INTERACTION, IslandConst.SYNC_TYPE_INTERACTION_TEST, IslandConst.SYNC_TYPE_INTERACTION_TIME)
	end)
end

function var0_0.UpdateInteractionBtns(arg0_9, arg1_9)
	local var0_9 = arg1_9.id
	local var1_9 = IslandInteractionUntil.GetInteractionOptions(arg1_9.type)

	arg0_9.interactionUIItemList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var1_9[arg1_10 + 1]

			onButton(arg0_9, arg2_10, function()
				if arg1_9.callback then
					arg1_9.callback()
				end

				IslandInteractionUntil.Response(arg0_9, var0_9, var0_10.id)
			end, SFX_PANEL)
			setText(arg2_10:Find("Text"), var0_10.text)
		end
	end)
	arg0_9.interactionUIItemList:align(#var1_9)
end

function var0_0.HideInterActionPanel(arg0_12)
	arg0_12.interactionUIItemList:align(0)
	removeOnButton(arg0_12.plantBtn)
end

function var0_0.DisablePlayerOp(arg0_13)
	setActive(arg0_13.opPanel, false)
	setActive(arg0_13.interactionPanel, false)
	arg0_13.inputController:DisablePlayerInput()
end

function var0_0.EnablePlayerOp(arg0_14)
	setActive(arg0_14.opPanel, true)
	setActive(arg0_14.interactionPanel, true)
	arg0_14.inputController:EnablePlayerInput()
end

function var0_0.SetTrackingTarget(arg0_15, arg1_15, arg2_15)
	arg0_15.targetTracker:Tracking(arg1_15._go, arg2_15._go)
end

function var0_0.CancelTracking(arg0_16)
	arg0_16.targetTracker:UnTracking()
end

function var0_0.OnDestroy(arg0_17)
	pg.DelegateInfo.Dispose(arg0_17)

	if arg0_17.targetTracker then
		arg0_17.targetTracker:Dispose()

		arg0_17.targetTracker = nil
	end
end

return var0_0
