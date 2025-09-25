local var0_0 = class("MetaQuickTacticsLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaQuickTacticsUI"
end

function var0_0.getGroupName(arg0_2)
	return "MetaCharacterScene"
end

function var0_0.init(arg0_3)
	arg0_3:initUITextTips()
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:addListener()
	arg0_3:overlayPanel(true)
end

function var0_0.didEnter(arg0_4)
	arg0_4:initSkillInfoPanel()
	arg0_4:initUIItemList()
end

function var0_0.willExit(arg0_5)
	arg0_5:overlayPanel(false)
end

function var0_0.onBackPressed(arg0_6)
	arg0_6:closeView()
end

function var0_0.initUITextTips(arg0_7)
	local var0_7 = arg0_7:findTF("Content/SkillInfo/UseTip")

	setText(var0_7, i18n("metaskill_up"))
end

function var0_0.initData(arg0_8)
	arg0_8.metaProxy = getProxy(MetaCharacterProxy)
	arg0_8.bagProxy = getProxy(BagProxy)
	arg0_8.bayProxy = getProxy(BayProxy)
	arg0_8.shipID = arg0_8.contextData.shipID
	arg0_8.skillID = arg0_8.contextData.skillID
	arg0_8.bookIDList = pg.item_data_statistics.get_id_list_by_type[Item.METALESSON_TYPE]
	arg0_8.useCountDict = {}
	arg0_8.maxCountDict = {}
	arg0_8.useCountTextDict = {}

	arg0_8:resetUseData()

	arg0_8.colorDict = {
		[ItemRarity.Blue] = "#70D4FAFF",
		[ItemRarity.Purple] = "#C380FBFF",
		[ItemRarity.Gold] = "#FFCC4DFF"
	}
	arg0_8.expDict = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.bookIDList) do
		arg0_8.expDict[iter1_8] = tonumber(Item.getConfigData(iter1_8).usage_arg)
	end
end

function var0_0.initUI(arg0_9)
	arg0_9.bg = arg0_9:findTF("BG")
	arg0_9.tpl = arg0_9:findTF("TacticsTpl")

	local var0_9 = arg0_9:findTF("Content")

	arg0_9.closeBtn = arg0_9:findTF("Title/CloseBtn", var0_9)

	local var1_9 = arg0_9:findTF("SkillInfo", var0_9)
	local var2_9 = arg0_9:findTF("Skill", var1_9)

	arg0_9.skillNameText = arg0_9:findTF("Name", var2_9)
	arg0_9.skillLevelText = arg0_9:findTF("LevelNum", var2_9)
	arg0_9.skillLevelUpText = arg0_9:findTF("LevelUp", var2_9)

	local var3_9 = arg0_9:findTF("Exp", var1_9)

	arg0_9.curExpText = arg0_9:findTF("CurExp", var3_9)
	arg0_9.addExpText = arg0_9:findTF("AddExp", var3_9)
	arg0_9.totalExpText = arg0_9:findTF("TotalExp", var3_9)
	arg0_9.progressBar = arg0_9:findTF("Slider", var1_9)
	arg0_9.containerTF = arg0_9:findTF("Container", var0_9)

	local var4_9 = arg0_9:findTF("Action", var0_9)

	arg0_9.clearBtn = arg0_9:findTF("ClearBtn", var4_9)
	arg0_9.onestepBtn = arg0_9:findTF("OneStepBtn", var4_9)
	arg0_9.confirmBtn = arg0_9:findTF("ConfirmBtn", var4_9)
end

function var0_0.addListener(arg0_10)
	local function var0_10()
		arg0_10:closeView()
	end

	onButton(arg0_10, arg0_10.bg, var0_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.closeBtn, var0_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.clearBtn, function()
		arg0_10:resetUseData()
		arg0_10:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.onestepBtn, function()
		arg0_10:oneStep()
		arg0_10:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.confirmBtn, function()
		local var0_14 = 0

		for iter0_14, iter1_14 in ipairs(arg0_10.bookIDList) do
			var0_14 = var0_14 + arg0_10.useCountDict[iter1_14]
		end

		if var0_14 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var1_14, var2_14 = arg0_10:preCalcExpOverFlow(0, 0)

			if var1_14 then
				arg0_10:emit(MetaQuickTacticsMediator.OPEN_OVERFLOW_LAYER, arg0_10.shipID, arg0_10.skillID, arg0_10.useCountDict, var2_14)
			else
				arg0_10:emit(MetaQuickTacticsMediator.USE_TACTICS_BOOK, arg0_10.shipID, arg0_10.skillID, arg0_10.useCountDict)
			end
		end
	end, SFX_PANEL)
end

function var0_0.overlayPanel(arg0_15, arg1_15)
	if arg1_15 and arg0_15._tf then
		arg0_15:OverlayPanel(arg0_15._tf)
	elseif arg0_15._tf then
		arg0_15:UnOverlayPanel(arg0_15._tf)
	end
end

function var0_0.initSkillInfoPanel(arg0_16)
	local var0_16 = arg0_16.skillID
	local var1_16 = arg0_16.bayProxy:getShipById(arg0_16.shipID):getMetaSkillLevelBySkillID(var0_16)
	local var2_16 = getSkillConfig(var0_16)
	local var3_16 = getSkillName(var2_16.id)

	setText(arg0_16.skillNameText, var3_16)
	setText(arg0_16.skillLevelText, "LEVEL:" .. var1_16)
	setText(arg0_16.skillLevelUpText, "")

	local var4_16 = arg0_16.metaProxy:getMetaTacticsInfoByShipID(arg0_16.shipID):getSkillExp(var0_16)
	local var5_16 = MetaCharacterConst.getMetaSkillTacticsConfig(var0_16, var1_16).need_exp

	setText(arg0_16.curExpText, var4_16)
	setText(arg0_16.totalExpText, var5_16)
	setText(arg0_16.addExpText, "[+0]")
	setSlider(arg0_16.progressBar, 0, var5_16, var4_16)
end

function var0_0.initUIItemList(arg0_17)
	arg0_17.uiitemList = UIItemList.New(arg0_17.containerTF, arg0_17.tpl)

	arg0_17.uiitemList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg1_18 = arg1_18 + 1

			arg0_17:updateTpl(arg1_18, arg2_18)
		end
	end)
	arg0_17.uiitemList:align(#arg0_17.bookIDList)
end

function var0_0.updateUIItemList(arg0_19)
	arg0_19.uiitemList:align(#arg0_19.bookIDList)
end

function var0_0.updateTpl(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20:findTF("IconTpl", arg2_20)
	local var1_20 = arg0_20:findTF("Name", arg2_20)
	local var2_20 = arg0_20:findTF("MinusTenBtn", arg2_20)
	local var3_20 = arg0_20:findTF("AddTenBtn", arg2_20)
	local var4_20 = arg0_20:findTF("MinusBtn", arg2_20)
	local var5_20 = arg0_20:findTF("AddBtn", arg2_20)
	local var6_20 = arg0_20:findTF("TextBG/UseNum", arg2_20)
	local var7_20 = arg0_20.bookIDList[arg1_20]
	local var8_20 = arg0_20:getBookItem(var7_20)
	local var9_20 = arg0_20.bagProxy:getItemCountById(var7_20)

	if var9_20 == 0 then
		var9_20 = "0"
	end

	local var10_20 = Drop.New({
		id = var7_20,
		type = DROP_TYPE_ITEM,
		count = var9_20
	})

	updateDrop(var0_20, var10_20)

	local var11_20 = var8_20:getConfig("name")
	local var12_20 = var8_20:getConfig("rarity")
	local var13_20 = setColorStr(var11_20, arg0_20.colorDict[var12_20])

	setText(var1_20, var13_20)

	arg0_20.useCountTextDict[var7_20] = var6_20

	onButton(arg0_20, var2_20, function()
		arg0_20:tryModifyUseCount(var7_20, -10)
		arg0_20:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_20, var3_20, function()
		if not arg0_20:isMaxLevel() and not arg0_20:isCanUpMax() then
			arg0_20:tryModifyUseCount(var7_20, 10)
			arg0_20:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
	onButton(arg0_20, var4_20, function()
		arg0_20:tryModifyUseCount(var7_20, -1)
		arg0_20:updateAfterModifyUseCount()
	end, SFX_PANEL)
	onButton(arg0_20, var5_20, function()
		if not arg0_20:isMaxLevel() and not arg0_20:isCanUpMax() then
			arg0_20:tryModifyUseCount(var7_20, 1)
			arg0_20:updateAfterModifyUseCount()
		end
	end, SFX_PANEL)
end

function var0_0.updateAfterModifyUseCount(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.bookIDList) do
		local var0_25 = arg0_25.useCountTextDict[iter1_25]
		local var1_25 = arg0_25.useCountDict[iter1_25]

		setText(var0_25, var1_25)
	end

	local var2_25 = arg0_25.shipID
	local var3_25 = arg0_25.skillID
	local var4_25 = arg0_25.bayProxy:getShipById(var2_25):getMetaSkillLevelBySkillID(var3_25)
	local var5_25 = arg0_25:calcAwardExp()
	local var6_25 = arg0_25:calcLevelWithAwardExp(var5_25) - var4_25

	if var6_25 > 0 then
		setText(arg0_25.skillLevelUpText, "+" .. var6_25)
	else
		setText(arg0_25.skillLevelUpText, "")
	end

	setText(arg0_25.addExpText, string.format("[+%d]", var5_25))

	local var7_25 = MetaCharacterConst.getMetaSkillTacticsConfig(var3_25, var4_25)

	if var7_25 then
		local var8_25 = var7_25.need_exp
		local var9_25 = arg0_25.metaProxy:getMetaTacticsInfoByShipID(var2_25):getSkillExp(var3_25)

		setText(arg0_25.curExpText, var9_25)
		setText(arg0_25.totalExpText, var8_25)
		setSlider(arg0_25.progressBar, 0, var8_25, var9_25 + var5_25)
	end
end

function var0_0.updateAfterUse(arg0_26)
	local var0_26 = arg0_26.shipID
	local var1_26 = arg0_26.skillID
	local var2_26 = arg0_26.bayProxy:getShipById(var0_26):getMetaSkillLevelBySkillID(var1_26)

	setText(arg0_26.skillLevelText, "LEVEL:" .. var2_26)

	if arg0_26:isMaxLevel() then
		setText(arg0_26.curExpText, "MAX")
		setSlider(arg0_26.progressBar, 0, 1, 1)
	end

	arg0_26:updateUIItemList()
end

function var0_0.getBookItem(arg0_27, arg1_27)
	return arg0_27.bagProxy:getItemById(arg1_27) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1_27
	})
end

function var0_0.resetUseData(arg0_28)
	arg0_28.useCountDict = arg0_28.useCountDict or {}
	arg0_28.maxCountDict = arg0_28.maxCountDict or {}

	for iter0_28, iter1_28 in ipairs(arg0_28.bookIDList) do
		arg0_28.useCountDict[iter1_28] = 0
		arg0_28.maxCountDict[iter1_28] = arg0_28.bagProxy:getItemCountById(iter1_28)
	end
end

function var0_0.tryModifyUseCount(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.maxCountDict[arg1_29]
	local var1_29 = arg0_29.useCountDict[arg1_29]

	if var0_29 <= 0 then
		return
	end

	if arg2_29 < 0 then
		local var2_29 = math.clamp(var1_29 + arg2_29, 0, var0_29)

		arg0_29.useCountDict[arg1_29] = var2_29
	else
		local var3_29 = math.min(var0_29, arg2_29)
		local var4_29 = arg0_29.expDict[arg1_29]
		local var5_29 = 0

		for iter0_29 = 0, var3_29 do
			local var6_29 = var5_29 * var4_29

			if not arg0_29:preCalcExpOverFlow(var6_29, 0) then
				var5_29 = iter0_29

				if var3_29 <= var5_29 or var0_29 <= var1_29 + var5_29 then
					break
				end
			end
		end

		arg0_29.useCountDict[arg1_29] = var1_29 + var5_29
	end
end

function var0_0.getLevelTotalExp(arg0_30, arg1_30)
	local var0_30 = arg0_30.skillID
	local var1_30 = arg0_30.bayProxy:getShipById(arg0_30.shipID)
	local var2_30 = pg.skill_data_template[var0_30].max_level
	local var3_30 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var0_30]
	local var4_30 = 0

	for iter0_30, iter1_30 in ipairs(var3_30) do
		local var5_30 = pg.ship_meta_skilltask[iter1_30]
		local var6_30 = var5_30.level
		local var7_30 = var5_30.need_exp

		if var6_30 < arg1_30 then
			var4_30 = var4_30 + var7_30
		end
	end

	return var4_30
end

function var0_0.getCurLevelExp(arg0_31)
	local var0_31 = arg0_31.skillID
	local var1_31 = arg0_31.bayProxy:getShipById(arg0_31.shipID):getMetaSkillLevelBySkillID(var0_31)
	local var2_31 = arg0_31.metaProxy:getMetaTacticsInfoByShipID(arg0_31.shipID):getSkillExp(var0_31)

	return arg0_31:getLevelTotalExp(var1_31) + var2_31
end

function var0_0.calcAwardExp(arg0_32)
	local var0_32 = 0

	for iter0_32, iter1_32 in ipairs(arg0_32.bookIDList) do
		var0_32 = var0_32 + arg0_32.useCountDict[iter1_32] * arg0_32.expDict[iter1_32]
	end

	return var0_32
end

function var0_0.calcLevelWithAwardExp(arg0_33, arg1_33)
	local var0_33 = arg0_33:getCurLevelExp() + arg1_33
	local var1_33 = arg0_33.skillID
	local var2_33 = pg.ship_meta_skilltask.get_id_list_by_skill_ID[var1_33]
	local var3_33 = 1

	for iter0_33, iter1_33 in ipairs(var2_33) do
		local var4_33 = pg.ship_meta_skilltask[iter1_33].need_exp

		if var4_33 <= var0_33 then
			var0_33 = var0_33 - var4_33
			var3_33 = var3_33 + 1
		else
			break
		end
	end

	return var3_33
end

function var0_0.isCanUpMax(arg0_34)
	local var0_34 = arg0_34.skillID
	local var1_34 = pg.skill_data_template[var0_34].max_level

	return arg0_34:getLevelTotalExp(var1_34) <= arg0_34:getCurLevelExp() + arg0_34:calcAwardExp()
end

function var0_0.preCalcExpOverFlow(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.skillID
	local var1_35 = pg.skill_data_template[var0_35].max_level
	local var2_35 = arg0_35:getLevelTotalExp(var1_35) - arg0_35:getCurLevelExp()
	local var3_35 = arg0_35:calcAwardExp()
	local var4_35 = false
	local var5_35
	local var6_35 = var3_35 + arg1_35

	if var2_35 <= var6_35 then
		var5_35 = var6_35 - var2_35

		if arg2_35 <= var5_35 then
			var4_35 = true
		end
	end

	return var4_35, var5_35
end

function var0_0.oneStep(arg0_36)
	if arg0_36:isMaxLevel() then
		return
	end

	arg0_36:resetUseData()

	local var0_36 = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.bookIDList) do
		if arg0_36:getBookItem(iter1_36).count > 0 then
			table.insert(var0_36, iter1_36)
		end
	end

	table.sort(var0_36, function(arg0_37, arg1_37)
		return arg1_37 < arg0_37
	end)

	for iter2_36, iter3_36 in ipairs(var0_36) do
		local var1_36 = arg0_36:getBookItem(iter3_36)
		local var2_36 = arg0_36.expDict[iter3_36]
		local var3_36 = iter2_36 + 1 > #var0_36 and 0 or arg0_36.expDict[var0_36[iter2_36 + 1]]

		for iter4_36 = 1, var1_36.count do
			if iter2_36 < #var0_36 and arg0_36:preCalcExpOverFlow(var2_36, var3_36) then
				break
			else
				arg0_36.useCountDict[iter3_36] = arg0_36.useCountDict[iter3_36] + 1

				if arg0_36:isCanUpMax() then
					return
				end
			end
		end
	end
end

function var0_0.isMaxLevel(arg0_38)
	local var0_38 = arg0_38.skillID
	local var1_38 = arg0_38.shipID

	return arg0_38.bayProxy:getShipById(var1_38):isSkillLevelMax(var0_38)
end

return var0_0
