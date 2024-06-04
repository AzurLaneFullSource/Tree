local var0 = class("MetaQuickTacticsLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaQuickTacticsUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:overlayPanel(true)
end

function var0.didEnter(arg0)
	arg0:initSkillInfoPanel()
	arg0:initUIItemList()
end

function var0.willExit(arg0)
	arg0:overlayPanel(false)
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("Content/SkillInfo/UseTip")

	setText(var0, i18n("metaskill_up"))
end

function var0.initData(arg0)
	arg0.metaProxy = getProxy(MetaCharacterProxy)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.shipID = arg0.contextData.shipID
	arg0.skillID = arg0.contextData.skillID
	arg0.bookIDList = pg.item_data_statistics.get_id_list_by_type[Item.METALESSON_TYPE]
	arg0.useCountDict = {}
	arg0.maxCountDict = {}
	arg0.useCountTextDict = {}

	arg0:resetUseData()

	arg0.colorDict = {
		[ItemRarity.Blue] = "#70D4FAFF",
		[ItemRarity.Purple] = "#C380FBFF",
		[ItemRarity.Gold] = "#FFCC4DFF"
	}
	arg0.expDict = {}

	for iter0, iter1 in ipairs(arg0.bookIDList) do
		arg0.expDict[iter1] = tonumber(Item.getConfigData(iter1).usage_arg)
	end
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.tpl = arg0:findTF("TacticsTpl")

	local var0 = arg0:findTF("Content")

	arg0.closeBtn = arg0:findTF("Title/CloseBtn", var0)

	local var1 = arg0:findTF("SkillInfo", var0)
	local var2 = arg0:findTF("Skill", var1)

	arg0.skillNameText = arg0:findTF("Name", var2)
	arg0.skillLevelText = arg0:findTF("LevelNum", var2)
	arg0.skillLevelUpText = arg0:findTF("LevelUp", var2)

	local var3 = arg0:findTF("Exp", var1)

	arg0.curExpText = arg0:findTF("CurExp", var3)
	arg0.addExpText = arg0:findTF("AddExp", var3)
	arg0.totalExpText = arg0:findTF("TotalExp", var3)
	arg0.progressBar = arg0:findTF("Slider", var1)
	arg0.containerTF = arg0:findTF("Container", var0)

	local var4 = arg0:findTF("Action", var0)

	arg0.clearBtn = arg0:findTF("ClearBtn", var4)
	arg0.onestepBtn = arg0:findTF("OneStepBtn", var4)
	arg0.confirmBtn = arg0:findTF("ConfirmBtn", var4)
end

function var0.addListener(arg0)
	local function var0()
		arg0:closeView()
	end

	onButton(arg0, arg0.bg, var0, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.clearBtn, function()
		arg0:resetUseData()
		arg0:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0, arg0.onestepBtn, function()
		arg0:oneStep()
		arg0:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.bookIDList) do
			var0 = var0 + arg0.useCountDict[iter1]
		end

		if var0 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var1, var2 = arg0:preCalcExpOverFlow(0, 0)

			if var1 then
				arg0:emit(MetaQuickTacticsMediator.OPEN_OVERFLOW_LAYER, arg0.shipID, arg0.skillID, arg0.useCountDict, var2)
			else
				arg0:emit(MetaQuickTacticsMediator.USE_TACTICS_BOOK, arg0.shipID, arg0.skillID, arg0.useCountDict)
			end
		end
	end, SFX_PANEL)
end

function var0.overlayPanel(arg0, arg1)
	if arg1 and arg0._tf then
		pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER
		})
	elseif arg0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	end
end

function var0.initSkillInfoPanel(arg0)
	local var0 = arg0.skillID
	local var1 = arg0.bayProxy:getShipById(arg0.shipID):getMetaSkillLevelBySkillID(var0)
	local var2 = getSkillConfig(var0)
	local var3 = getSkillName(var2.id)

	setText(arg0.skillNameText, var3)
	setText(arg0.skillLevelText, "LEVEL:" .. var1)
	setText(arg0.skillLevelUpText, "")

	local var4 = arg0.metaProxy:getMetaTacticsInfoByShipID(arg0.shipID):getSkillExp(var0)
	local var5 = MetaCharacterConst.getMetaSkillTacticsConfig(var0, var1).need_exp

	setText(arg0.curExpText, var4)
	setText(arg0.totalExpText, var5)
	setText(arg0.addExpText, "[+0]")
	setSlider(arg0.progressBar, 0, var5, var4)
end

function var0.initUIItemList(arg0)
	arg0.uiitemList = UIItemList.New(arg0.containerTF, arg0.tpl)

	arg0.uiitemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateTpl(arg1, arg2)
		end
	end)
	arg0.uiitemList:align(#arg0.bookIDList)
end

function var0.updateUIItemList(arg0)
	arg0.uiitemList:align(#arg0.bookIDList)
end

function var0.updateTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("IconTpl", arg2)
	local var1 = arg0:findTF("Name", arg2)
	local var2 = arg0:findTF("MinusTenBtn", arg2)
	local var3 = arg0:findTF("AddTenBtn", arg2)
	local var4 = arg0:findTF("MinusBtn", arg2)
	local var5 = arg0:findTF("AddBtn", arg2)
	local var6 = arg0:findTF("TextBG/UseNum", arg2)
	local var7 = arg0.bookIDList[arg1]
	local var8 = arg0:getBookItem(var7)
	local var9 = arg0.bagProxy:getItemCountById(var7)

	if var9 == 0 then
		var9 = "0"
	end

	local var10 = Drop.New({
		id = var7,
		type = DROP_TYPE_ITEM,
		count = var9
	})

	updateDrop(var0, var10)

	local var11 = var8:getConfig("name")
	local var12 = var8:getConfig("rarity")
	local var13 = setColorStr(var11, arg0.colorDict[var12])

	setText(var1, var13)

	arg0.useCountTextDict[var7] = var6

	onButton(arg0, var2, function()
		arg0:tryModifyUseCount(var7, -10)
		arg0:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0, var3, function()
		if not arg0:isMaxLevel() and not arg0:isCanUpMax() then
			arg0:tryModifyUseCount(var7, 10)
			arg0:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
	onButton(arg0, var4, function()
		arg0:tryModifyUseCount(var7, -1)
		arg0:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0, var5, function()
		if not arg0:isMaxLevel() and not arg0:isCanUpMax() then
			arg0:tryModifyUseCount(var7, 1)
			arg0:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
end

function var0.updateAfterModifyUseCount(arg0)
	for iter0, iter1 in ipairs(arg0.bookIDList) do
		local var0 = arg0.useCountTextDict[iter1]
		local var1 = arg0.useCountDict[iter1]

		setText(var0, var1)
	end

	local var2 = arg0.shipID
	local var3 = arg0.skillID
	local var4 = arg0.bayProxy:getShipById(var2):getMetaSkillLevelBySkillID(var3)
	local var5 = arg0:calcAwardExp()
	local var6 = arg0:calcLevelWithAwardExp(var5) - var4

	if var6 > 0 then
		setText(arg0.skillLevelUpText, "+" .. var6)
	else
		setText(arg0.skillLevelUpText, "")
	end

	setText(arg0.addExpText, string.format("[+%d]", var5))

	local var7 = MetaCharacterConst.getMetaSkillTacticsConfig(var3, var4)

	if var7 then
		local var8 = var7.need_exp
		local var9 = arg0.metaProxy:getMetaTacticsInfoByShipID(var2):getSkillExp(var3)

		setText(arg0.curExpText, var9)
		setText(arg0.totalExpText, var8)
		setSlider(arg0.progressBar, 0, var8, var9 + var5)
	end
end

function var0.updateAfterUse(arg0)
	local var0 = arg0.shipID
	local var1 = arg0.skillID
	local var2 = arg0.bayProxy:getShipById(var0):getMetaSkillLevelBySkillID(var1)

	setText(arg0.skillLevelText, "LEVEL:" .. var2)

	if arg0:isMaxLevel() then
		setText(arg0.curExpText, "MAX")
		setSlider(arg0.progressBar, 0, 1, 1)
	end

	arg0:updateUIItemList()
end

function var0.getBookItem(arg0, arg1)
	return arg0.bagProxy:getItemById(arg1) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1
	})
end

function var0.resetUseData(arg0)
	arg0.useCountDict = arg0.useCountDict or {}
	arg0.maxCountDict = arg0.maxCountDict or {}

	for iter0, iter1 in ipairs(arg0.bookIDList) do
		arg0.useCountDict[iter1] = 0
		arg0.maxCountDict[iter1] = arg0.bagProxy:getItemCountById(iter1)
	end
end

function var0.tryModifyUseCount(arg0, arg1, arg2)
	local var0 = arg0.maxCountDict[arg1]
	local var1 = arg0.useCountDict[arg1]

	if var0 <= 0 then
		return
	end

	if arg2 < 0 then
		local var2 = math.clamp(var1 + arg2, 0, var0)

		arg0.useCountDict[arg1] = var2
	else
		local var3 = math.min(var0, arg2)
		local var4 = arg0.expDict[arg1]
		local var5 = 0

		for iter0 = 0, var3 do
			local var6 = var5 * var4

			if not arg0:preCalcExpOverFlow(var6, 0) then
				var5 = iter0

				if var3 <= var5 or var0 <= var1 + var5 then
					break
				end
			end
		end

		arg0.useCountDict[arg1] = var1 + var5
	end
end

function var0.getLevelTotalExp(arg0, arg1)
	local var0 = arg0.skillID
	local var1 = arg0.bayProxy:getShipById(arg0.shipID)
	local var2 = pg.skill_data_template[var0].max_level
	local var3 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var0]
	local var4 = 0

	for iter0, iter1 in ipairs(var3) do
		local var5 = pg.ship_meta_skilltask[iter1]
		local var6 = var5.level
		local var7 = var5.need_exp

		if var6 < arg1 then
			var4 = var4 + var7
		end
	end

	return var4
end

function var0.getCurLevelExp(arg0)
	local var0 = arg0.skillID
	local var1 = arg0.bayProxy:getShipById(arg0.shipID):getMetaSkillLevelBySkillID(var0)
	local var2 = arg0.metaProxy:getMetaTacticsInfoByShipID(arg0.shipID):getSkillExp(var0)

	return arg0:getLevelTotalExp(var1) + var2
end

function var0.calcAwardExp(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.bookIDList) do
		var0 = var0 + arg0.useCountDict[iter1] * arg0.expDict[iter1]
	end

	return var0
end

function var0.calcLevelWithAwardExp(arg0, arg1)
	local var0 = arg0:getCurLevelExp() + arg1
	local var1 = arg0.skillID
	local var2 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var1]
	local var3 = 1

	for iter0, iter1 in ipairs(var2) do
		local var4 = pg.ship_meta_skilltask[iter1].need_exp

		if var4 <= var0 then
			var0 = var0 - var4
			var3 = var3 + 1
		else
			break
		end
	end

	return var3
end

function var0.isCanUpMax(arg0)
	local var0 = arg0.skillID
	local var1 = pg.skill_data_template[var0].max_level

	return arg0:getLevelTotalExp(var1) <= arg0:getCurLevelExp() + arg0:calcAwardExp()
end

function var0.preCalcExpOverFlow(arg0, arg1, arg2)
	local var0 = arg0.skillID
	local var1 = pg.skill_data_template[var0].max_level
	local var2 = arg0:getLevelTotalExp(var1) - arg0:getCurLevelExp()
	local var3 = arg0:calcAwardExp()
	local var4 = false
	local var5
	local var6 = var3 + arg1

	if var2 <= var6 then
		var5 = var6 - var2

		if arg2 <= var5 then
			var4 = true
		end
	end

	return var4, var5
end

function var0.oneStep(arg0)
	if arg0:isMaxLevel() then
		return
	end

	arg0:resetUseData()

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.bookIDList) do
		if arg0:getBookItem(iter1).count > 0 then
			table.insert(var0, iter1)
		end
	end

	table.sort(var0, function(arg0, arg1)
		return arg1 < arg0
	end)

	for iter2, iter3 in ipairs(var0) do
		local var1 = arg0:getBookItem(iter3)
		local var2 = arg0.expDict[iter3]
		local var3 = iter2 + 1 > #var0 and 0 or arg0.expDict[var0[iter2 + 1]]

		for iter4 = 1, var1.count do
			if iter2 < #var0 and arg0:preCalcExpOverFlow(var2, var3) then
				break
			else
				arg0.useCountDict[iter3] = arg0.useCountDict[iter3] + 1

				if arg0:isCanUpMax() then
					return
				end
			end
		end
	end
end

function var0.isMaxLevel(arg0)
	local var0 = arg0.skillID
	local var1 = arg0.shipID

	return arg0.bayProxy:getShipById(var1):isSkillLevelMax(var0)
end

return var0
