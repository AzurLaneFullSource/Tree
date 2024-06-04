local var0 = class("CommanderBoxesPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderBoxesUI"
end

function var0.OnLoaded(arg0)
	arg0.boxCards = {}
	arg0.startBtn = arg0._tf:Find("frame/boxes/start_btn")
	arg0.finishBtn = arg0._tf:Find("frame/boxes/finish_btn")
	arg0.quicklyFinishAllBtn = arg0._tf:Find("frame/boxes/quick_all")
	arg0.settingsBtn = arg0._tf:Find("frame/boxes/setting_btn")
	arg0.closeBtn = arg0._tf:Find("frame/close_btn")
	arg0.boxesList = UIItemList.New(arg0._tf:Find("frame/boxes/mask/content"), arg0._tf:Find("frame/boxes/mask/content/frame"))
	arg0.scrollRect = arg0._tf:Find("frame/boxes/mask")
	arg0.traningCnt = arg0._tf:Find("frame/boxes/statistics/traning"):GetComponent(typeof(Text))
	arg0.waitCnt = arg0._tf:Find("frame/boxes/statistics/wait"):GetComponent(typeof(Text))
	arg0.itemCnt = arg0._tf:Find("frame/item/Text"):GetComponent(typeof(Text))

	setActive(arg0._tf:Find("frame/item"), not LOCK_CATTERY)

	arg0.mask = arg0._tf:Find("mask")

	setActive(arg0.mask, false)

	arg0.buildPoolPanel = CommanderBuildPoolPanel.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.quicklyToolPage = CommanderQuicklyToolPage.New(arg0._tf, arg0.event)
	arg0.quicklyToolMsgbox = CommanderQuicklyFinishBoxMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.lockFlagSettingPage = CommanderLockFlagSettingPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.buildResultPage = GetCommanderResultPage.New(arg0._tf, arg0.event)

	setActive(arg0._tf:Find("frame"), true)
end

function var0.OnInit(arg0)
	arg0:RegisterEvent()
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.boxes) do
			if iter1:getState() == CommanderBox.STATE_EMPTY then
				var0 = var0 + 1
			end
		end

		if var0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_solt_deficiency"))

			return
		end

		arg0.buildPoolPanel:ExecuteAction("Show", arg0.pools, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.finishBtn, function()
		if #arg0.boxes <= 0 then
			return
		end

		if getProxy(PlayerProxy):getRawData().commanderBagMax <= getProxy(CommanderProxy):getCommanderCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

			if callback then
				callback()
			end

			return
		end

		scrollTo(arg0.scrollRect, nil, 1)
		arg0:emit(CommanderCatMediator.BATCH_GET, arg0.boxes)
	end, SFX_PANEL)
	onButton(arg0, arg0.settingsBtn, function()
		arg0.lockFlagSettingPage:ExecuteAction("Show")
	end, SFX_PANEL)
	setActive(arg0.settingsBtn, false)
	onButton(arg0, arg0.quicklyFinishAllBtn, function()
		local var0 = Item.COMMANDER_QUICKLY_TOOL_ID

		if getProxy(BagProxy):getItemCountById(var0) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_accelfrate_notenough"))

			return
		end

		local var1, var2, var3, var4 = getProxy(CommanderProxy):CalcQuickItemUsageCnt()

		if var1 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("noacceleration_tips"))

			return
		end

		arg0.contextData.msgBox:ExecuteAction("Show", {
			content = i18n("acceleration_tips_1", var1, var2),
			content1 = i18n("acceleration_tips_2", var4[1], var4[2], var4[3]),
			onYes = function()
				arg0:emit(CommanderCatMediator.ONE_KEY, var1, var2, var3)
			end
		})
	end, SFX_PANEL)
end

function var0.RegisterEvent(arg0)
	arg0:bind(CommanderCatScene.MSG_QUICKLY_FINISH_TOOL_ERROR, function(arg0)
		pg.TipsMgr.GetInstance():ShowTips(i18n("comander_tool_cnt_is_reclac"))
		triggerButton(arg0.quicklyFinishAllBtn)
	end)
	arg0:bind(CommanderCatScene.MSG_BUILD, function(arg0)
		arg0:Flush()
	end)
	arg0:bind(CommanderCatScene.MSG_BATCH_BUILD, function(arg0, arg1)
		print(#arg1)

		if arg1 and #arg1 > 0 then
			arg0.buildResultPage:ExecuteAction("Show", arg1)
		end
	end)
	arg0:bind(CommanderCatScene.EVENT_QUICKLY_TOOL, function(arg0, arg1)
		local var0 = Item.COMMANDER_QUICKLY_TOOL_ID

		arg0.quicklyToolPage:ExecuteAction("Show", arg1, var0)
	end)
	arg0:bind(CommanderCatScene.MSG_OPEN_BOX, function(arg0, arg1, arg2)
		arg0:PlayAnimation(arg1, arg2)
	end)
end

function var0.Update(arg0)
	arg0:Show()
	arg0:Flush()
end

function var0.Flush(arg0)
	arg0.boxes = getProxy(CommanderProxy):getBoxes()
	arg0.pools = getProxy(CommanderProxy):getPools()

	arg0:UpdateList()
	arg0:UpdateItem()
	arg0:updateCntLabel()
end

function var0.UpdateList(arg0)
	local var0 = _.map(arg0.boxes, function(arg0)
		arg0.state = arg0:getState()

		return arg0
	end)

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0.state
		local var1 = arg1.state

		if var0 == var1 then
			return arg0.index < arg1.index
		else
			return var1 < var0
		end
	end)
	arg0.boxesList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = arg0.boxCards[arg1]

			if not var1 then
				var1 = CommanderBoxCard.New(arg0, arg2)
				arg0.boxCards[arg1] = var1
			end

			local var2 = arg1 > 3 and var0.state == CommanderBox.STATE_EMPTY

			if not var2 then
				var1:Update(var0)
			else
				var1:Clear()
			end

			setActive(arg2, not var2)
		end
	end)
	arg0.boxesList:align(#var0)
end

function var0.updateCntLabel(arg0)
	local var0 = 0
	local var1 = 0

	_.each(arg0.boxes, function(arg0)
		arg0.state = arg0:getState()

		if arg0.state == CommanderBox.STATE_WAITING then
			var1 = var1 + 1
		elseif arg0.state == CommanderBox.STATE_STARTING then
			var0 = var0 + 1
		end
	end)

	arg0.traningCnt.text = var0 .. "/" .. CommanderProxy.MAX_WORK_COUNT
	arg0.waitCnt.text = var1 .. "/" .. CommanderProxy.MAX_SLOT - CommanderProxy.MAX_WORK_COUNT
end

function var0.Show(arg0)
	arg0.activation = true

	setActive(arg0._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	arg0.activation = false

	setActive(arg0._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.isShow(arg0)
	return arg0.activation
end

function var0.PlayAnimation(arg0, arg1, arg2)
	local var0

	for iter0, iter1 in pairs(arg0.boxCards) do
		if iter1.boxVO and iter1.boxVO.id == arg1 then
			var0 = iter1

			break
		end
	end

	if var0 then
		var0:playAnim(arg2)
	else
		arg2()
	end
end

function var0.CanBack(arg0)
	if arg0.buildPoolPanel and arg0.buildPoolPanel:GetLoaded() and arg0.buildPoolPanel:isShowing() then
		arg0.buildPoolPanel:Hide()

		return false
	end

	if arg0.quicklyToolPage and arg0.quicklyToolPage:GetLoaded() and arg0.quicklyToolPage:isShowing() then
		arg0.quicklyToolPage:Hide()

		return false
	end

	if arg0.quicklyToolMsgbox and arg0.quicklyToolMsgbox:GetLoaded() and arg0.quicklyToolMsgbox:isShowing() then
		arg0.quicklyToolMsgbox:Hide()

		return false
	end

	if arg0.lockFlagSettingPage and arg0.lockFlagSettingPage:GetLoaded() and arg0.lockFlagSettingPage:isShowing() then
		arg0.lockFlagSettingPage:Hide()

		return false
	end

	if arg0.buildResultPage and arg0.buildResultPage:GetLoaded() and arg0.buildResultPage:isShowing() then
		arg0.buildResultPage:Hide()

		return false
	end

	return true
end

function var0.UpdateItem(arg0)
	arg0.itemCnt.text = getProxy(BagProxy):getItemCountById(Item.COMMANDER_QUICKLY_TOOL_ID)
end

function var0.OnDestroy(arg0)
	arg0:Hide()

	for iter0, iter1 in pairs(arg0.boxCards or {}) do
		iter1:Destroy()
	end

	arg0.boxCards = {}

	if arg0.quicklyToolMsgbox then
		arg0.quicklyToolMsgbox:Destroy()

		arg0.quicklyToolMsgbox = nil
	end

	if arg0.lockFlagSettingPage then
		arg0.lockFlagSettingPage:Destroy()

		arg0.lockFlagSettingPage = nil
	end

	if arg0.buildResultPage then
		arg0.buildResultPage:Destroy()

		arg0.buildResultPage = nil
	end
end

return var0
