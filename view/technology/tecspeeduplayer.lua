local var0_0 = class("TecSpeedUpLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TecSpeedUpUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initTaskPanel()
	arg0_2:initItem()
	setText(arg0_2.useCountText, 0)
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:tryPlayGuide()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)

	if arg0_4.minusTimer then
		arg0_4.minusTimer:Stop()
	end

	if arg0_4.addTimer then
		arg0_4.addTimer:Stop(0)
	end
end

function var0_0.tryPlayGuide(arg0_5)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0021")
end

function var0_0.initData(arg0_6)
	arg0_6.technologyProxy = getProxy(TechnologyProxy)
	arg0_6.taskProxy = getProxy(TaskProxy)
	arg0_6.bagProxy = getProxy(BagProxy)
	arg0_6.shipBluePrintOnDev = nil

	local var0_6 = arg0_6.technologyProxy:getBluePrints()

	for iter0_6, iter1_6 in pairs(var0_6) do
		if iter1_6:isDeving() then
			arg0_6.shipBluePrintOnDev = iter1_6

			break
		end
	end

	local var1_6 = arg0_6.shipBluePrintOnDev:getTaskIds()
	local var2_6 = arg0_6.shipBluePrintOnDev:getTaskStateById(var1_6[1])
	local var3_6 = arg0_6.shipBluePrintOnDev:getTaskStateById(var1_6[4])

	arg0_6.expTaskID = nil

	if var2_6 == ShipBluePrint.TASK_STATE_START then
		arg0_6.expTaskID = var1_6[1]
	elseif var3_6 == ShipBluePrint.TASK_STATE_START then
		arg0_6.expTaskID = var1_6[4]
	end

	arg0_6.expTaskVO = arg0_6.taskProxy:getTaskVO(arg0_6.expTaskID)
	arg0_6.bluePrintVersion = arg0_6.shipBluePrintOnDev:getConfig("blueprint_version")
	arg0_6.itemID = pg.gameset.technology_catchup_itemid.description[arg0_6.bluePrintVersion][1]
	arg0_6.itemExp = pg.gameset.technology_catchup_itemid.description[arg0_6.bluePrintVersion][2]
	arg0_6.curUseNum = 0

	local var4_6 = arg0_6.expTaskVO:getProgress()
	local var5_6 = arg0_6.expTaskVO:getConfig("target_num") - var4_6
	local var6_6 = math.ceil(var5_6 / arg0_6.itemExp)
	local var7_6 = arg0_6.bagProxy:getItemCountById(arg0_6.itemID)

	arg0_6.maxUseNum = math.min(var6_6, var7_6)
end

function var0_0.findUI(arg0_7)
	local var0_7 = arg0_7:findTF("Window/top/bg/obtain/title")

	setText(var0_7, i18n("tec_speedup_title"))

	local var1_7 = arg0_7:findTF("Window")

	arg0_7.backBtn = arg0_7:findTF("top/btnBack", var1_7)
	arg0_7.bg = arg0_7:findTF("BG")

	local var2_7 = arg0_7:findTF("Panel", var1_7)
	local var3_7 = arg0_7:findTF("Task", var2_7)

	arg0_7.taskNameText = arg0_7:findTF("Name/Text", var3_7)
	arg0_7.expProgressText = arg0_7:findTF("ExpProgressText", var3_7)
	arg0_7.expProgressSlider = arg0_7:findTF("Slider", var3_7)
	arg0_7.taskText = arg0_7:findTF("TaskText", var3_7)
	arg0_7.progressNumText = arg0_7:findTF("ProgressNumText", var3_7)

	local var4_7 = arg0_7:findTF("ItemPanel", var2_7)

	arg0_7.itemIcon = arg0_7:findTF("Item/Icon", var4_7)
	arg0_7.itemCountText = arg0_7:findTF("Item/CountText", var4_7)
	arg0_7.itemNameText = arg0_7:findTF("NameText", var4_7)
	arg0_7.minusBtn = arg0_7:findTF("UsePanel/MinusBtn", var4_7)
	arg0_7.addBtn = arg0_7:findTF("UsePanel/AddBtn", var4_7)
	arg0_7.maxBtn = arg0_7:findTF("UsePanel/MaxBtn", var4_7)
	arg0_7.useCountText = arg0_7:findTF("UsePanel/UseCountText", var4_7)
	arg0_7.confirmBtn = arg0_7:findTF("ConfirmBtn", var1_7)
	arg0_7.helpBtn = arg0_7:findTF("HelpBtn", var1_7)
	arg0_7.helpPanel = arg0_7:findTF("HelpPanel", var1_7)
	arg0_7.helpText = arg0_7:findTF("Text", arg0_7.helpPanel)

	setText(arg0_7.helpText, pg.gametip.tec_speedup_help_tip.tip)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg0_8.curUseNum == 0 then
			return
		end

		local var0_11, var1_11 = arg0_8:isExpOverFlow()

		if arg0_8:isExpOverFlow() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_speedup_overflow", var1_11),
				onYes = function()
					pg.m02:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM, {
						blueprintid = arg0_8.shipBluePrintOnDev.id,
						itemid = arg0_8.itemID,
						number = arg0_8.curUseNum,
						taskID = arg0_8.expTaskID
					})
				end
			})
		else
			pg.m02:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM, {
				blueprintid = arg0_8.shipBluePrintOnDev.id,
				itemid = arg0_8.itemID,
				number = arg0_8.curUseNum,
				taskID = arg0_8.expTaskID
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		if isActive(arg0_8.helpPanel) then
			setActive(arg0_8.helpPanel, false)
		else
			setActive(arg0_8.helpPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.maxBtn, function()
		if arg0_8.curUseNum ~= arg0_8.maxUseNum then
			arg0_8.curUseNum = arg0_8.maxUseNum

			setText(arg0_8.useCountText, arg0_8.curUseNum)
			arg0_8:updateTaskPanel(arg0_8.curUseNum)
		end
	end, SFX_PANEL)

	local var0_8 = 0

	local function var1_8()
		if arg0_8.curUseNum > 0 then
			arg0_8.curUseNum = arg0_8.curUseNum - 1

			setText(arg0_8.useCountText, arg0_8.curUseNum)
			arg0_8:updateTaskPanel(arg0_8.curUseNum)
		end
	end

	onButton(arg0_8, arg0_8.minusBtn, var1_8, SFX_PANEL)

	local var2_8 = GetOrAddComponent(arg0_8.minusBtn, typeof(EventTriggerListener))

	var2_8:AddPointDownFunc(function(arg0_16, arg1_16)
		if not arg0_8.minusTimer then
			arg0_8.minusTimer = Timer.New(function()
				if var0_8 < 1 then
					var0_8 = var0_8 + 0.2
				else
					var1_8()
				end
			end, 0.2, -1, 1)
		end

		arg0_8.minusTimer:Start()
	end)
	var2_8:AddPointUpFunc(function(arg0_18, arg1_18)
		if arg0_8.minusTimer then
			var0_8 = 0

			arg0_8.minusTimer:Stop()
		end
	end)

	local function var3_8()
		if arg0_8.curUseNum < arg0_8.maxUseNum then
			arg0_8.curUseNum = arg0_8.curUseNum + 1

			setText(arg0_8.useCountText, arg0_8.curUseNum)
			arg0_8:updateTaskPanel(arg0_8.curUseNum)
		end
	end

	onButton(arg0_8, arg0_8.addBtn, var3_8, SFX_PANEL)

	local var4_8 = GetOrAddComponent(arg0_8.addBtn, typeof(EventTriggerListener))

	var4_8:AddPointDownFunc(function(arg0_20, arg1_20)
		if not arg0_8.addTimer then
			arg0_8.addTimer = Timer.New(function()
				if var0_8 < 1 then
					var0_8 = var0_8 + 0.2
				else
					var3_8()
				end
			end, 0.2, -1, 1)
		end

		arg0_8.addTimer:Start()
	end)
	var4_8:AddPointUpFunc(function(arg0_22, arg1_22)
		if arg0_8.addTimer then
			var0_8 = 0

			arg0_8.addTimer:Stop()
		end
	end)
end

function var0_0.initTaskPanel(arg0_23)
	local var0_23 = arg0_23.expTaskVO:getConfig("name")

	setText(arg0_23.taskNameText, var0_23)

	local var1_23 = arg0_23.expTaskVO:getConfig("desc")

	setText(arg0_23.taskText, string.split(var1_23, i18n("tech_catchup_sentence_pauses"))[2])

	local var2_23 = arg0_23.expTaskVO:getProgress()
	local var3_23 = arg0_23.expTaskVO:getConfig("target_num")

	setText(arg0_23.expProgressText, i18n("tec_speedup_progress", math.floor(var2_23 / 10000), math.floor(var3_23 / 10000)))

	local var4_23 = var2_23 / var3_23

	setSlider(arg0_23.expProgressSlider, 0, 1, var4_23)
	setText(arg0_23.progressNumText, math.floor(var4_23 * 100) .. "%")
end

function var0_0.updateTaskPanel(arg0_24, arg1_24)
	local var0_24 = arg0_24.curUseNum * arg0_24.itemExp
	local var1_24 = arg0_24.expTaskVO:getProgress()
	local var2_24 = arg0_24.expTaskVO:getConfig("target_num")
	local var3_24 = var1_24 + var0_24

	setText(arg0_24.expProgressText, i18n("tec_speedup_progress", math.floor(var3_24 / 10000), math.floor(var2_24 / 10000)))

	local var4_24 = var3_24 / var2_24

	setSlider(arg0_24.expProgressSlider, 0, 1, var4_24)
	setText(arg0_24.progressNumText, math.floor(var4_24 * 100) .. "%")
end

function var0_0.initItem(arg0_25)
	local var0_25 = Item.getConfigData(arg0_25.itemID)

	GetImageSpriteFromAtlasAsync(var0_25.icon, "", arg0_25.itemIcon)
	setText(arg0_25.itemCountText, arg0_25.bagProxy:getItemCountById(arg0_25.itemID))
	setText(arg0_25.itemNameText, var0_25.name)
end

function var0_0.isExpOverFlow(arg0_26)
	local var0_26 = arg0_26.curUseNum * arg0_26.itemExp
	local var1_26 = arg0_26.expTaskVO:getProgress()
	local var2_26 = arg0_26.expTaskVO:getConfig("target_num")
	local var3_26 = var1_26 + var0_26
	local var4_26 = var2_26 < var3_26
	local var5_26 = var3_26 - var2_26

	return var4_26, var5_26
end

return var0_0
