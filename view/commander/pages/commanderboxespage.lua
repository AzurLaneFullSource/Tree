local var0_0 = class("CommanderBoxesPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderBoxesUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.boxCards = {}
	arg0_2.startBtn = arg0_2._tf:Find("frame/boxes/start_btn")
	arg0_2.finishBtn = arg0_2._tf:Find("frame/boxes/finish_btn")
	arg0_2.quicklyFinishAllBtn = arg0_2._tf:Find("frame/boxes/quick_all")
	arg0_2.settingsBtn = arg0_2._tf:Find("frame/boxes/setting_btn")
	arg0_2.closeBtn = arg0_2._tf:Find("frame/close_btn")
	arg0_2.boxesList = UIItemList.New(arg0_2._tf:Find("frame/boxes/mask/content"), arg0_2._tf:Find("frame/boxes/mask/content/frame"))
	arg0_2.scrollRect = arg0_2._tf:Find("frame/boxes/mask")
	arg0_2.traningCnt = arg0_2._tf:Find("frame/boxes/statistics/traning"):GetComponent(typeof(Text))
	arg0_2.waitCnt = arg0_2._tf:Find("frame/boxes/statistics/wait"):GetComponent(typeof(Text))
	arg0_2.itemCnt = arg0_2._tf:Find("frame/item/Text"):GetComponent(typeof(Text))

	setActive(arg0_2._tf:Find("frame/item"), not LOCK_CATTERY)

	arg0_2.mask = arg0_2._tf:Find("mask")

	setActive(arg0_2.mask, false)

	arg0_2.buildPoolPanel = CommanderBuildPoolPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.quicklyToolPage = CommanderQuicklyToolPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.quicklyToolMsgbox = CommanderQuicklyFinishBoxMsgBoxPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.lockFlagSettingPage = CommanderLockFlagSettingPage.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.buildResultPage = GetCommanderResultPage.New(arg0_2._tf, arg0_2.event)

	setActive(arg0_2._tf:Find("frame"), true)
end

function var0_0.OnInit(arg0_3)
	arg0_3:RegisterEvent()
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		local var0_6 = 0

		for iter0_6, iter1_6 in ipairs(arg0_3.boxes) do
			if iter1_6:getState() == CommanderBox.STATE_EMPTY then
				var0_6 = var0_6 + 1
			end
		end

		if var0_6 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_solt_deficiency"))

			return
		end

		arg0_3.buildPoolPanel:ExecuteAction("Show", arg0_3.pools, var0_6)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.finishBtn, function()
		if #arg0_3.boxes <= 0 then
			return
		end

		if getProxy(PlayerProxy):getRawData().commanderBagMax <= getProxy(CommanderProxy):getCommanderCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

			if callback then
				callback()
			end

			return
		end

		scrollTo(arg0_3.scrollRect, nil, 1)
		arg0_3:emit(CommanderCatMediator.BATCH_GET, arg0_3.boxes)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.settingsBtn, function()
		arg0_3.lockFlagSettingPage:ExecuteAction("Show")
	end, SFX_PANEL)
	setActive(arg0_3.settingsBtn, false)
	onButton(arg0_3, arg0_3.quicklyFinishAllBtn, function()
		local var0_9 = Item.COMMANDER_QUICKLY_TOOL_ID

		if getProxy(BagProxy):getItemCountById(var0_9) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_accelfrate_notenough"))

			return
		end

		local var1_9, var2_9, var3_9, var4_9 = getProxy(CommanderProxy):CalcQuickItemUsageCnt()

		if var1_9 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("noacceleration_tips"))

			return
		end

		arg0_3.contextData.msgBox:ExecuteAction("Show", {
			content = i18n("acceleration_tips_1", var1_9, var2_9),
			content1 = i18n("acceleration_tips_2", var4_9[1], var4_9[2], var4_9[3]),
			onYes = function()
				arg0_3:emit(CommanderCatMediator.ONE_KEY, var1_9, var2_9, var3_9)
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegisterEvent(arg0_11)
	arg0_11:bind(CommanderCatScene.MSG_QUICKLY_FINISH_TOOL_ERROR, function(arg0_12)
		pg.TipsMgr.GetInstance():ShowTips(i18n("comander_tool_cnt_is_reclac"))
		triggerButton(arg0_11.quicklyFinishAllBtn)
	end)
	arg0_11:bind(CommanderCatScene.MSG_BUILD, function(arg0_13)
		arg0_11:Flush()
	end)
	arg0_11:bind(CommanderCatScene.MSG_BATCH_BUILD, function(arg0_14, arg1_14)
		print(#arg1_14)

		if arg1_14 and #arg1_14 > 0 then
			arg0_11.buildResultPage:ExecuteAction("Show", arg1_14)
		end
	end)
	arg0_11:bind(CommanderCatScene.EVENT_QUICKLY_TOOL, function(arg0_15, arg1_15)
		local var0_15 = Item.COMMANDER_QUICKLY_TOOL_ID

		arg0_11.quicklyToolPage:ExecuteAction("Show", arg1_15, var0_15)
	end)
	arg0_11:bind(CommanderCatScene.MSG_OPEN_BOX, function(arg0_16, arg1_16, arg2_16)
		arg0_11:PlayAnimation(arg1_16, arg2_16)
	end)
end

function var0_0.Update(arg0_17)
	arg0_17:Show()
	arg0_17:Flush()
end

function var0_0.Flush(arg0_18)
	arg0_18.boxes = getProxy(CommanderProxy):getBoxes()
	arg0_18.pools = getProxy(CommanderProxy):getPools()

	arg0_18:UpdateList()
	arg0_18:UpdateItem()
	arg0_18:updateCntLabel()
end

function var0_0.UpdateList(arg0_19)
	local var0_19 = _.map(arg0_19.boxes, function(arg0_20)
		arg0_20.state = arg0_20:getState()

		return arg0_20
	end)

	table.sort(var0_19, function(arg0_21, arg1_21)
		local var0_21 = arg0_21.state
		local var1_21 = arg1_21.state

		if var0_21 == var1_21 then
			return arg0_21.index < arg1_21.index
		else
			return var1_21 < var0_21
		end
	end)
	arg0_19.boxesList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_19[arg1_22 + 1]
			local var1_22 = arg0_19.boxCards[arg1_22]

			if not var1_22 then
				var1_22 = CommanderBoxCard.New(arg0_19, arg2_22)
				arg0_19.boxCards[arg1_22] = var1_22
			end

			local var2_22 = arg1_22 > 3 and var0_22.state == CommanderBox.STATE_EMPTY

			if not var2_22 then
				var1_22:Update(var0_22)
			else
				var1_22:Clear()
			end

			setActive(arg2_22, not var2_22)
		end
	end)
	arg0_19.boxesList:align(#var0_19)
end

function var0_0.updateCntLabel(arg0_23)
	local var0_23 = 0
	local var1_23 = 0

	_.each(arg0_23.boxes, function(arg0_24)
		arg0_24.state = arg0_24:getState()

		if arg0_24.state == CommanderBox.STATE_WAITING then
			var1_23 = var1_23 + 1
		elseif arg0_24.state == CommanderBox.STATE_STARTING then
			var0_23 = var0_23 + 1
		end
	end)

	arg0_23.traningCnt.text = var0_23 .. "/" .. CommanderProxy.MAX_WORK_COUNT
	arg0_23.waitCnt.text = var1_23 .. "/" .. CommanderProxy.MAX_SLOT - CommanderProxy.MAX_WORK_COUNT
end

function var0_0.Show(arg0_25)
	arg0_25.activation = true

	setActive(arg0_25._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_25._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_26)
	arg0_26.activation = false

	setActive(arg0_26._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_26._tf, arg0_26._parentTf)
end

function var0_0.isShow(arg0_27)
	return arg0_27.activation
end

function var0_0.PlayAnimation(arg0_28, arg1_28, arg2_28)
	local var0_28

	for iter0_28, iter1_28 in pairs(arg0_28.boxCards) do
		if iter1_28.boxVO and iter1_28.boxVO.id == arg1_28 then
			var0_28 = iter1_28

			break
		end
	end

	if var0_28 then
		var0_28:playAnim(arg2_28)
	else
		arg2_28()
	end
end

function var0_0.CanBack(arg0_29)
	if arg0_29.buildPoolPanel and arg0_29.buildPoolPanel:GetLoaded() and arg0_29.buildPoolPanel:isShowing() then
		arg0_29.buildPoolPanel:Hide()

		return false
	end

	if arg0_29.quicklyToolPage and arg0_29.quicklyToolPage:GetLoaded() and arg0_29.quicklyToolPage:isShowing() then
		arg0_29.quicklyToolPage:Hide()

		return false
	end

	if arg0_29.quicklyToolMsgbox and arg0_29.quicklyToolMsgbox:GetLoaded() and arg0_29.quicklyToolMsgbox:isShowing() then
		arg0_29.quicklyToolMsgbox:Hide()

		return false
	end

	if arg0_29.lockFlagSettingPage and arg0_29.lockFlagSettingPage:GetLoaded() and arg0_29.lockFlagSettingPage:isShowing() then
		arg0_29.lockFlagSettingPage:Hide()

		return false
	end

	if arg0_29.buildResultPage and arg0_29.buildResultPage:GetLoaded() and arg0_29.buildResultPage:isShowing() then
		arg0_29.buildResultPage:Hide()

		return false
	end

	return true
end

function var0_0.UpdateItem(arg0_30)
	arg0_30.itemCnt.text = getProxy(BagProxy):getItemCountById(Item.COMMANDER_QUICKLY_TOOL_ID)
end

function var0_0.OnDestroy(arg0_31)
	arg0_31:Hide()

	for iter0_31, iter1_31 in pairs(arg0_31.boxCards or {}) do
		iter1_31:Destroy()
	end

	arg0_31.boxCards = {}

	if arg0_31.quicklyToolMsgbox then
		arg0_31.quicklyToolMsgbox:Destroy()

		arg0_31.quicklyToolMsgbox = nil
	end

	if arg0_31.lockFlagSettingPage then
		arg0_31.lockFlagSettingPage:Destroy()

		arg0_31.lockFlagSettingPage = nil
	end

	if arg0_31.buildResultPage then
		arg0_31.buildResultPage:Destroy()

		arg0_31.buildResultPage = nil
	end
end

return var0_0
