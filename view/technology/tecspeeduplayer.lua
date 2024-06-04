local var0 = class("TecSpeedUpLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TecSpeedUpUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initTaskPanel()
	arg0:initItem()
	setText(arg0.useCountText, 0)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:tryPlayGuide()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.minusTimer then
		arg0.minusTimer:Stop()
	end

	if arg0.addTimer then
		arg0.addTimer:Stop(0)
	end
end

function var0.tryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0021")
end

function var0.initData(arg0)
	arg0.technologyProxy = getProxy(TechnologyProxy)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.shipBluePrintOnDev = nil

	local var0 = arg0.technologyProxy:getBluePrints()

	for iter0, iter1 in pairs(var0) do
		if iter1:isDeving() then
			arg0.shipBluePrintOnDev = iter1

			break
		end
	end

	local var1 = arg0.shipBluePrintOnDev:getTaskIds()
	local var2 = arg0.shipBluePrintOnDev:getTaskStateById(var1[1])
	local var3 = arg0.shipBluePrintOnDev:getTaskStateById(var1[4])

	arg0.expTaskID = nil

	if var2 == ShipBluePrint.TASK_STATE_START then
		arg0.expTaskID = var1[1]
	elseif var3 == ShipBluePrint.TASK_STATE_START then
		arg0.expTaskID = var1[4]
	end

	arg0.expTaskVO = arg0.taskProxy:getTaskVO(arg0.expTaskID)
	arg0.bluePrintVersion = arg0.shipBluePrintOnDev:getConfig("blueprint_version")
	arg0.itemID = pg.gameset.technology_catchup_itemid.description[arg0.bluePrintVersion][1]
	arg0.itemExp = pg.gameset.technology_catchup_itemid.description[arg0.bluePrintVersion][2]
	arg0.curUseNum = 0

	local var4 = arg0.expTaskVO:getProgress()
	local var5 = arg0.expTaskVO:getConfig("target_num") - var4
	local var6 = math.ceil(var5 / arg0.itemExp)
	local var7 = arg0.bagProxy:getItemCountById(arg0.itemID)

	arg0.maxUseNum = math.min(var6, var7)
end

function var0.findUI(arg0)
	local var0 = arg0:findTF("Window/top/bg/obtain/title")

	setText(var0, i18n("tec_speedup_title"))

	local var1 = arg0:findTF("Window")

	arg0.backBtn = arg0:findTF("top/btnBack", var1)
	arg0.bg = arg0:findTF("BG")

	local var2 = arg0:findTF("Panel", var1)
	local var3 = arg0:findTF("Task", var2)

	arg0.taskNameText = arg0:findTF("Name/Text", var3)
	arg0.expProgressText = arg0:findTF("ExpProgressText", var3)
	arg0.expProgressSlider = arg0:findTF("Slider", var3)
	arg0.taskText = arg0:findTF("TaskText", var3)
	arg0.progressNumText = arg0:findTF("ProgressNumText", var3)

	local var4 = arg0:findTF("ItemPanel", var2)

	arg0.itemIcon = arg0:findTF("Item/Icon", var4)
	arg0.itemCountText = arg0:findTF("Item/CountText", var4)
	arg0.itemNameText = arg0:findTF("NameText", var4)
	arg0.minusBtn = arg0:findTF("UsePanel/MinusBtn", var4)
	arg0.addBtn = arg0:findTF("UsePanel/AddBtn", var4)
	arg0.maxBtn = arg0:findTF("UsePanel/MaxBtn", var4)
	arg0.useCountText = arg0:findTF("UsePanel/UseCountText", var4)
	arg0.confirmBtn = arg0:findTF("ConfirmBtn", var1)
	arg0.helpBtn = arg0:findTF("HelpBtn", var1)
	arg0.helpPanel = arg0:findTF("HelpPanel", var1)
	arg0.helpText = arg0:findTF("Text", arg0.helpPanel)

	setText(arg0.helpText, pg.gametip.tec_speedup_help_tip.tip)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.curUseNum == 0 then
			return
		end

		local var0, var1 = arg0:isExpOverFlow()

		if arg0:isExpOverFlow() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_speedup_overflow", var1),
				onYes = function()
					pg.m02:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM, {
						blueprintid = arg0.shipBluePrintOnDev.id,
						itemid = arg0.itemID,
						number = arg0.curUseNum,
						taskID = arg0.expTaskID
					})
				end
			})
		else
			pg.m02:sendNotification(GAME.USE_TEC_SPEEDUP_ITEM, {
				blueprintid = arg0.shipBluePrintOnDev.id,
				itemid = arg0.itemID,
				number = arg0.curUseNum,
				taskID = arg0.expTaskID
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		if isActive(arg0.helpPanel) then
			setActive(arg0.helpPanel, false)
		else
			setActive(arg0.helpPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		if arg0.curUseNum ~= arg0.maxUseNum then
			arg0.curUseNum = arg0.maxUseNum

			setText(arg0.useCountText, arg0.curUseNum)
			arg0:updateTaskPanel(arg0.curUseNum)
		end
	end, SFX_PANEL)

	local var0 = 0

	local function var1()
		if arg0.curUseNum > 0 then
			arg0.curUseNum = arg0.curUseNum - 1

			setText(arg0.useCountText, arg0.curUseNum)
			arg0:updateTaskPanel(arg0.curUseNum)
		end
	end

	onButton(arg0, arg0.minusBtn, var1, SFX_PANEL)

	local var2 = GetOrAddComponent(arg0.minusBtn, typeof(EventTriggerListener))

	var2:AddPointDownFunc(function(arg0, arg1)
		if not arg0.minusTimer then
			arg0.minusTimer = Timer.New(function()
				if var0 < 1 then
					var0 = var0 + 0.2
				else
					var1()
				end
			end, 0.2, -1, 1)
		end

		arg0.minusTimer:Start()
	end)
	var2:AddPointUpFunc(function(arg0, arg1)
		if arg0.minusTimer then
			var0 = 0

			arg0.minusTimer:Stop()
		end
	end)

	local function var3()
		if arg0.curUseNum < arg0.maxUseNum then
			arg0.curUseNum = arg0.curUseNum + 1

			setText(arg0.useCountText, arg0.curUseNum)
			arg0:updateTaskPanel(arg0.curUseNum)
		end
	end

	onButton(arg0, arg0.addBtn, var3, SFX_PANEL)

	local var4 = GetOrAddComponent(arg0.addBtn, typeof(EventTriggerListener))

	var4:AddPointDownFunc(function(arg0, arg1)
		if not arg0.addTimer then
			arg0.addTimer = Timer.New(function()
				if var0 < 1 then
					var0 = var0 + 0.2
				else
					var3()
				end
			end, 0.2, -1, 1)
		end

		arg0.addTimer:Start()
	end)
	var4:AddPointUpFunc(function(arg0, arg1)
		if arg0.addTimer then
			var0 = 0

			arg0.addTimer:Stop()
		end
	end)
end

function var0.initTaskPanel(arg0)
	local var0 = arg0.expTaskVO:getConfig("name")

	setText(arg0.taskNameText, var0)

	local var1 = arg0.expTaskVO:getConfig("desc")

	setText(arg0.taskText, string.split(var1, i18n("tech_catchup_sentence_pauses"))[2])

	local var2 = arg0.expTaskVO:getProgress()
	local var3 = arg0.expTaskVO:getConfig("target_num")

	setText(arg0.expProgressText, i18n("tec_speedup_progress", math.floor(var2 / 10000), math.floor(var3 / 10000)))

	local var4 = var2 / var3

	setSlider(arg0.expProgressSlider, 0, 1, var4)
	setText(arg0.progressNumText, math.floor(var4 * 100) .. "%")
end

function var0.updateTaskPanel(arg0, arg1)
	local var0 = arg0.curUseNum * arg0.itemExp
	local var1 = arg0.expTaskVO:getProgress()
	local var2 = arg0.expTaskVO:getConfig("target_num")
	local var3 = var1 + var0

	setText(arg0.expProgressText, i18n("tec_speedup_progress", math.floor(var3 / 10000), math.floor(var2 / 10000)))

	local var4 = var3 / var2

	setSlider(arg0.expProgressSlider, 0, 1, var4)
	setText(arg0.progressNumText, math.floor(var4 * 100) .. "%")
end

function var0.initItem(arg0)
	local var0 = Item.getConfigData(arg0.itemID)

	GetImageSpriteFromAtlasAsync(var0.icon, "", arg0.itemIcon)
	setText(arg0.itemCountText, arg0.bagProxy:getItemCountById(arg0.itemID))
	setText(arg0.itemNameText, var0.name)
end

function var0.isExpOverFlow(arg0)
	local var0 = arg0.curUseNum * arg0.itemExp
	local var1 = arg0.expTaskVO:getProgress()
	local var2 = arg0.expTaskVO:getConfig("target_num")
	local var3 = var1 + var0
	local var4 = var2 < var3
	local var5 = var3 - var2

	return var4, var5
end

return var0
