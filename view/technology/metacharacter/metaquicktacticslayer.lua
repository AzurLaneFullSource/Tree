local var0_0 = class("MetaQuickTacticsLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaQuickTacticsUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:overlayPanel(true)
end

function var0_0.didEnter(arg0_3)
	arg0_3:initSkillInfoPanel()
	arg0_3:initUIItemList()
end

function var0_0.willExit(arg0_4)
	arg0_4:overlayPanel(false)
end

function var0_0.onBackPressed(arg0_5)
	arg0_5:closeView()
end

function var0_0.initUITextTips(arg0_6)
	local var0_6 = arg0_6:findTF("Content/SkillInfo/UseTip")

	setText(var0_6, i18n("metaskill_up"))
end

function var0_0.initData(arg0_7)
	arg0_7.metaProxy = getProxy(MetaCharacterProxy)
	arg0_7.bagProxy = getProxy(BagProxy)
	arg0_7.bayProxy = getProxy(BayProxy)
	arg0_7.shipID = arg0_7.contextData.shipID
	arg0_7.skillID = arg0_7.contextData.skillID
	arg0_7.bookIDList = pg.item_data_statistics.get_id_list_by_type[Item.METALESSON_TYPE]
	arg0_7.useCountDict = {}
	arg0_7.maxCountDict = {}
	arg0_7.useCountTextDict = {}

	arg0_7:resetUseData()

	arg0_7.colorDict = {
		[ItemRarity.Blue] = "#70D4FAFF",
		[ItemRarity.Purple] = "#C380FBFF",
		[ItemRarity.Gold] = "#FFCC4DFF"
	}
	arg0_7.expDict = {}

	for iter0_7, iter1_7 in ipairs(arg0_7.bookIDList) do
		arg0_7.expDict[iter1_7] = tonumber(Item.getConfigData(iter1_7).usage_arg)
	end
end

function var0_0.initUI(arg0_8)
	arg0_8.bg = arg0_8:findTF("BG")
	arg0_8.tpl = arg0_8:findTF("TacticsTpl")

	local var0_8 = arg0_8:findTF("Content")

	arg0_8.closeBtn = arg0_8:findTF("Title/CloseBtn", var0_8)

	local var1_8 = arg0_8:findTF("SkillInfo", var0_8)
	local var2_8 = arg0_8:findTF("Skill", var1_8)

	arg0_8.skillNameText = arg0_8:findTF("Name", var2_8)
	arg0_8.skillLevelText = arg0_8:findTF("LevelNum", var2_8)
	arg0_8.skillLevelUpText = arg0_8:findTF("LevelUp", var2_8)

	local var3_8 = arg0_8:findTF("Exp", var1_8)

	arg0_8.curExpText = arg0_8:findTF("CurExp", var3_8)
	arg0_8.addExpText = arg0_8:findTF("AddExp", var3_8)
	arg0_8.totalExpText = arg0_8:findTF("TotalExp", var3_8)
	arg0_8.progressBar = arg0_8:findTF("Slider", var1_8)
	arg0_8.containerTF = arg0_8:findTF("Container", var0_8)

	local var4_8 = arg0_8:findTF("Action", var0_8)

	arg0_8.clearBtn = arg0_8:findTF("ClearBtn", var4_8)
	arg0_8.onestepBtn = arg0_8:findTF("OneStepBtn", var4_8)
	arg0_8.confirmBtn = arg0_8:findTF("ConfirmBtn", var4_8)
end

function var0_0.addListener(arg0_9)
	local function var0_9()
		arg0_9:closeView()
	end

	onButton(arg0_9, arg0_9.bg, var0_9, SFX_PANEL)
	onButton(arg0_9, arg0_9.closeBtn, var0_9, SFX_PANEL)
	onButton(arg0_9, arg0_9.clearBtn, function()
		arg0_9:resetUseData()
		arg0_9:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.onestepBtn, function()
		arg0_9:oneStep()
		arg0_9:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.confirmBtn, function()
		local var0_13 = 0

		for iter0_13, iter1_13 in ipairs(arg0_9.bookIDList) do
			var0_13 = var0_13 + arg0_9.useCountDict[iter1_13]
		end

		if var0_13 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var1_13, var2_13 = arg0_9:preCalcExpOverFlow(0, 0)

			if var1_13 then
				arg0_9:emit(MetaQuickTacticsMediator.OPEN_OVERFLOW_LAYER, arg0_9.shipID, arg0_9.skillID, arg0_9.useCountDict, var2_13)
			else
				arg0_9:emit(MetaQuickTacticsMediator.USE_TACTICS_BOOK, arg0_9.shipID, arg0_9.skillID, arg0_9.useCountDict)
			end
		end
	end, SFX_PANEL)
end

function var0_0.overlayPanel(arg0_14, arg1_14)
	if arg1_14 and arg0_14._tf then
		pg.UIMgr.GetInstance():OverlayPanel(arg0_14._tf, {
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER
		})
	elseif arg0_14._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
	end
end

function var0_0.initSkillInfoPanel(arg0_15)
	local var0_15 = arg0_15.skillID
	local var1_15 = arg0_15.bayProxy:getShipById(arg0_15.shipID):getMetaSkillLevelBySkillID(var0_15)
	local var2_15 = getSkillConfig(var0_15)
	local var3_15 = getSkillName(var2_15.id)

	setText(arg0_15.skillNameText, var3_15)
	setText(arg0_15.skillLevelText, "LEVEL:" .. var1_15)
	setText(arg0_15.skillLevelUpText, "")

	local var4_15 = arg0_15.metaProxy:getMetaTacticsInfoByShipID(arg0_15.shipID):getSkillExp(var0_15)
	local var5_15 = MetaCharacterConst.getMetaSkillTacticsConfig(var0_15, var1_15).need_exp

	setText(arg0_15.curExpText, var4_15)
	setText(arg0_15.totalExpText, var5_15)
	setText(arg0_15.addExpText, "[+0]")
	setSlider(arg0_15.progressBar, 0, var5_15, var4_15)
end

function var0_0.initUIItemList(arg0_16)
	arg0_16.uiitemList = UIItemList.New(arg0_16.containerTF, arg0_16.tpl)

	arg0_16.uiitemList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			arg1_17 = arg1_17 + 1

			arg0_16:updateTpl(arg1_17, arg2_17)
		end
	end)
	arg0_16.uiitemList:align(#arg0_16.bookIDList)
end

function var0_0.updateUIItemList(arg0_18)
	arg0_18.uiitemList:align(#arg0_18.bookIDList)
end

function var0_0.updateTpl(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:findTF("IconTpl", arg2_19)
	local var1_19 = arg0_19:findTF("Name", arg2_19)
	local var2_19 = arg0_19:findTF("MinusTenBtn", arg2_19)
	local var3_19 = arg0_19:findTF("AddTenBtn", arg2_19)
	local var4_19 = arg0_19:findTF("MinusBtn", arg2_19)
	local var5_19 = arg0_19:findTF("AddBtn", arg2_19)
	local var6_19 = arg0_19:findTF("TextBG/UseNum", arg2_19)
	local var7_19 = arg0_19.bookIDList[arg1_19]
	local var8_19 = arg0_19:getBookItem(var7_19)
	local var9_19 = arg0_19.bagProxy:getItemCountById(var7_19)

	if var9_19 == 0 then
		var9_19 = "0"
	end

	local var10_19 = Drop.New({
		id = var7_19,
		type = DROP_TYPE_ITEM,
		count = var9_19
	})

	updateDrop(var0_19, var10_19)

	local var11_19 = var8_19:getConfig("name")
	local var12_19 = var8_19:getConfig("rarity")
	local var13_19 = setColorStr(var11_19, arg0_19.colorDict[var12_19])

	setText(var1_19, var13_19)

	arg0_19.useCountTextDict[var7_19] = var6_19

	onButton(arg0_19, var2_19, function()
		arg0_19:tryModifyUseCount(var7_19, -10)
		arg0_19:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_19, var3_19, function()
		if not arg0_19:isMaxLevel() and not arg0_19:isCanUpMax() then
			arg0_19:tryModifyUseCount(var7_19, 10)
			arg0_19:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
	onButton(arg0_19, var4_19, function()
		arg0_19:tryModifyUseCount(var7_19, -1)
		arg0_19:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_19, var5_19, function()
		if not arg0_19:isMaxLevel() and not arg0_19:isCanUpMax() then
			arg0_19:tryModifyUseCount(var7_19, 1)
			arg0_19:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
end

function var0_0.updateAfterModifyUseCount(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.bookIDList) do
		local var0_24 = arg0_24.useCountTextDict[iter1_24]
		local var1_24 = arg0_24.useCountDict[iter1_24]

		setText(var0_24, var1_24)
	end

	local var2_24 = arg0_24.shipID
	local var3_24 = arg0_24.skillID
	local var4_24 = arg0_24.bayProxy:getShipById(var2_24):getMetaSkillLevelBySkillID(var3_24)
	local var5_24 = arg0_24:calcAwardExp()
	local var6_24 = arg0_24:calcLevelWithAwardExp(var5_24) - var4_24

	if var6_24 > 0 then
		setText(arg0_24.skillLevelUpText, "+" .. var6_24)
	else
		setText(arg0_24.skillLevelUpText, "")
	end

	setText(arg0_24.addExpText, string.format("[+%d]", var5_24))

	local var7_24 = MetaCharacterConst.getMetaSkillTacticsConfig(var3_24, var4_24)

	if var7_24 then
		local var8_24 = var7_24.need_exp
		local var9_24 = arg0_24.metaProxy:getMetaTacticsInfoByShipID(var2_24):getSkillExp(var3_24)

		setText(arg0_24.curExpText, var9_24)
		setText(arg0_24.totalExpText, var8_24)
		setSlider(arg0_24.progressBar, 0, var8_24, var9_24 + var5_24)
	end
end

function var0_0.updateAfterUse(arg0_25)
	local var0_25 = arg0_25.shipID
	local var1_25 = arg0_25.skillID
	local var2_25 = arg0_25.bayProxy:getShipById(var0_25):getMetaSkillLevelBySkillID(var1_25)

	setText(arg0_25.skillLevelText, "LEVEL:" .. var2_25)

	if arg0_25:isMaxLevel() then
		setText(arg0_25.curExpText, "MAX")
		setSlider(arg0_25.progressBar, 0, 1, 1)
	end

	arg0_25:updateUIItemList()
end

function var0_0.getBookItem(arg0_26, arg1_26)
	return arg0_26.bagProxy:getItemById(arg1_26) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1_26
	})
end

function var0_0.resetUseData(arg0_27)
	arg0_27.useCountDict = arg0_27.useCountDict or {}
	arg0_27.maxCountDict = arg0_27.maxCountDict or {}

	for iter0_27, iter1_27 in ipairs(arg0_27.bookIDList) do
		arg0_27.useCountDict[iter1_27] = 0
		arg0_27.maxCountDict[iter1_27] = arg0_27.bagProxy:getItemCountById(iter1_27)
	end
end

function var0_0.tryModifyUseCount(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.maxCountDict[arg1_28]
	local var1_28 = arg0_28.useCountDict[arg1_28]

	if var0_28 <= 0 then
		return
	end

	if arg2_28 < 0 then
		local var2_28 = math.clamp(var1_28 + arg2_28, 0, var0_28)

		arg0_28.useCountDict[arg1_28] = var2_28
	else
		local var3_28 = math.min(var0_28, arg2_28)
		local var4_28 = arg0_28.expDict[arg1_28]
		local var5_28 = 0

		for iter0_28 = 0, var3_28 do
			local var6_28 = var5_28 * var4_28

			if not arg0_28:preCalcExpOverFlow(var6_28, 0) then
				var5_28 = iter0_28

				if var3_28 <= var5_28 or var0_28 <= var1_28 + var5_28 then
					break
				end
			end
		end

		arg0_28.useCountDict[arg1_28] = var1_28 + var5_28
	end
end

function var0_0.getLevelTotalExp(arg0_29, arg1_29)
	local var0_29 = arg0_29.skillID
	local var1_29 = arg0_29.bayProxy:getShipById(arg0_29.shipID)
	local var2_29 = pg.skill_data_template[var0_29].max_level
	local var3_29 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var0_29]
	local var4_29 = 0

	for iter0_29, iter1_29 in ipairs(var3_29) do
		local var5_29 = pg.ship_meta_skilltask[iter1_29]
		local var6_29 = var5_29.level
		local var7_29 = var5_29.need_exp

		if var6_29 < arg1_29 then
			var4_29 = var4_29 + var7_29
		end
	end

	return var4_29
end

function var0_0.getCurLevelExp(arg0_30)
	local var0_30 = arg0_30.skillID
	local var1_30 = arg0_30.bayProxy:getShipById(arg0_30.shipID):getMetaSkillLevelBySkillID(var0_30)
	local var2_30 = arg0_30.metaProxy:getMetaTacticsInfoByShipID(arg0_30.shipID):getSkillExp(var0_30)

	return arg0_30:getLevelTotalExp(var1_30) + var2_30
end

function var0_0.calcAwardExp(arg0_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31.bookIDList) do
		var0_31 = var0_31 + arg0_31.useCountDict[iter1_31] * arg0_31.expDict[iter1_31]
	end

	return var0_31
end

function var0_0.calcLevelWithAwardExp(arg0_32, arg1_32)
	local var0_32 = arg0_32:getCurLevelExp() + arg1_32
	local var1_32 = arg0_32.skillID
	local var2_32 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var1_32]
	local var3_32 = 1

	for iter0_32, iter1_32 in ipairs(var2_32) do
		local var4_32 = pg.ship_meta_skilltask[iter1_32].need_exp

		if var4_32 <= var0_32 then
			var0_32 = var0_32 - var4_32
			var3_32 = var3_32 + 1
		else
			break
		end
	end

	return var3_32
end

function var0_0.isCanUpMax(arg0_33)
	local var0_33 = arg0_33.skillID
	local var1_33 = pg.skill_data_template[var0_33].max_level

	return arg0_33:getLevelTotalExp(var1_33) <= arg0_33:getCurLevelExp() + arg0_33:calcAwardExp()
end

function var0_0.preCalcExpOverFlow(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.skillID
	local var1_34 = pg.skill_data_template[var0_34].max_level
	local var2_34 = arg0_34:getLevelTotalExp(var1_34) - arg0_34:getCurLevelExp()
	local var3_34 = arg0_34:calcAwardExp()
	local var4_34 = false
	local var5_34
	local var6_34 = var3_34 + arg1_34

	if var2_34 <= var6_34 then
		var5_34 = var6_34 - var2_34

		if arg2_34 <= var5_34 then
			var4_34 = true
		end
	end

	return var4_34, var5_34
end

function var0_0.oneStep(arg0_35)
	if arg0_35:isMaxLevel() then
		return
	end

	arg0_35:resetUseData()

	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.bookIDList) do
		if arg0_35:getBookItem(iter1_35).count > 0 then
			table.insert(var0_35, iter1_35)
		end
	end

	table.sort(var0_35, function(arg0_36, arg1_36)
		return arg1_36 < arg0_36
	end)

	for iter2_35, iter3_35 in ipairs(var0_35) do
		local var1_35 = arg0_35:getBookItem(iter3_35)
		local var2_35 = arg0_35.expDict[iter3_35]
		local var3_35 = iter2_35 + 1 > #var0_35 and 0 or arg0_35.expDict[var0_35[iter2_35 + 1]]

		for iter4_35 = 1, var1_35.count do
			if iter2_35 < #var0_35 and arg0_35:preCalcExpOverFlow(var2_35, var3_35) then
				break
			else
				arg0_35.useCountDict[iter3_35] = arg0_35.useCountDict[iter3_35] + 1

				if arg0_35:isCanUpMax() then
					return
				end
			end
		end
	end
end

function var0_0.isMaxLevel(arg0_37)
	local var0_37 = arg0_37.skillID
	local var1_37 = arg0_37.shipID

	return arg0_37.bayProxy:getShipById(var1_37):isSkillLevelMax(var0_37)
end

return var0_0
