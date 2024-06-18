local var0_0 = class("TechnologyTreeSetAttrLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TechnologyTreeSetAttrUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:initUITips()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = arg0_3:getWeightFromData()
	})
	arg0_3:updateTypeList()
	triggerToggle(arg0_3.typeContainer:GetChild(0), true)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
	arg0_4.resLoader:Clear()
end

function var0_0.onBackPressed(arg0_5)
	triggerButton(arg0_5.closeBtn)
end

function var0_0.initData(arg0_6)
	arg0_6.tecNationProxy = getProxy(TechnologyNationProxy)
	arg0_6.cacheAdditionMap = {}
	arg0_6.curAdditionMap = arg0_6.tecNationProxy:getSetableAttrAddition()
	arg0_6.maxAdditionMap = nil
	arg0_6.typeOrderList = nil
	arg0_6.typeAttrOrderListTable = nil
	arg0_6.maxAdditionMap, arg0_6.typeOrderList, arg0_6.typeAttrOrderListTable = arg0_6.tecNationProxy:getTecBuff()
	arg0_6.typeOrderList = ShipType.FilterOverQuZhuType(arg0_6.typeOrderList)
	arg0_6.resLoader = AutoLoader.New()
	arg0_6.curType = 0
	arg0_6.typeToggleTable = {}
	arg0_6.typeAttrTFTable = {}
end

function var0_0.initUITips(arg0_7)
	local var0_7 = arg0_7:findTF("Adapt/Content/ResetBtn/Text")
	local var1_7 = arg0_7:findTF("Adapt/Content/SaveBtn/Text")

	setText(var0_7, i18n("attrset_reset"))
	setText(var1_7, i18n("attrset_save"))
end

function var0_0.findUI(arg0_8)
	arg0_8.typeTpl = arg0_8:findTF("TypeTpl")
	arg0_8.attrTpl = arg0_8:findTF("AttrTpl")
	arg0_8.backBGTF = arg0_8:findTF("Adapt/BackBG")

	local var0_8 = arg0_8:findTF("Adapt/Content")

	arg0_8.closeBtn = arg0_8:findTF("CloseBtn", var0_8)
	arg0_8.arrowTF = arg0_8:findTF("Arrow", var0_8)
	arg0_8.typeContainer = arg0_8:findTF("TypeScrollView/Content", var0_8)
	arg0_8.attrContainer = arg0_8:findTF("AttrPanel", var0_8)
	arg0_8.resetBtn = arg0_8:findTF("ResetBtn", var0_8)
	arg0_8.saveBtn = arg0_8:findTF("SaveBtn", var0_8)
	arg0_8.typeUIItemList = UIItemList.New(arg0_8.typeContainer, arg0_8.typeTpl)
	arg0_8.attrUIItemList = UIItemList.New(arg0_8.attrContainer, arg0_8.attrTpl)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.closeBtn, function()
		if arg0_9:isChanged() then
			local function var0_10()
				return
			end

			local function var1_10()
				arg0_9:closeView()
			end

			local function var2_10()
				arg0_9:save(function()
					arg0_9:closeView()
				end)
			end

			arg0_9:openSaveBox(var2_10, var1_10, var0_10)
		else
			arg0_9:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.backBGTF, function()
		if arg0_9:isChanged() then
			local function var0_15()
				return
			end

			local function var1_15()
				arg0_9:closeView()
			end

			local function var2_15()
				arg0_9:save(function()
					arg0_9:closeView()
				end)
			end

			arg0_9:openSaveBox(var2_15, var1_15, var0_15)
		else
			arg0_9:closeView()
		end
	end, SFX_CANCEL)
	arg0_9.typeUIItemList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			arg1_20 = arg1_20 + 1

			arg0_9:updateTypeTF(arg1_20, arg2_20)
		end
	end)
	arg0_9.attrUIItemList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			arg1_21 = arg1_21 + 1

			arg0_9:updateAttrTF(arg1_21, arg2_21)
		end
	end)
	onButton(arg0_9, arg0_9.resetBtn, function()
		for iter0_22, iter1_22 in ipairs(arg0_9.typeAttrOrderListTable[arg0_9.curType]) do
			local var0_22 = arg0_9.maxAdditionMap[arg0_9.curType][iter1_22]

			arg0_9:setAttrValue(arg0_9.curType, iter1_22, var0_22)
			arg0_9:setAttrTFValue(arg0_9.typeAttrTFTable[arg0_9.curType][iter1_22], var0_22)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.saveBtn, function()
		if arg0_9:isChanged() then
			local function var0_23()
				arg0_9:clearCacheMap()

				arg0_9.curAdditionMap = arg0_9.tecNationProxy:getSetableAttrAddition()
			end

			arg0_9:save(var0_23)
		end
	end, SFX_PANEL)
end

function var0_0.updateTypeTF(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25:findTF("TypeNameUnSelect", arg2_25)
	local var1_25 = arg0_25:findTF("TypeNameSelected", arg2_25)
	local var2_25 = arg0_25:findTF("TypeImg", arg2_25)
	local var3_25 = arg0_25.typeOrderList[arg1_25]
	local var4_25 = ShipType.Type2Name(var3_25)

	setText(var0_25, var4_25)
	setText(var1_25, var4_25)
	arg0_25.resLoader:GetSprite("ShipType", "buffitem_tec_" .. var3_25, var2_25, false)
	onToggle(arg0_25, arg2_25, function(arg0_26)
		if arg0_26 and arg0_25.curType ~= var3_25 then
			if arg0_25:isChanged() then
				local function var0_26()
					triggerToggle(arg0_25.typeToggleTable[arg0_25.curType], true)
				end

				local function var1_26()
					arg0_25:clearCacheMap()

					arg0_25.curType = var3_25

					arg0_25:updateAttrList(arg0_25.curType)
				end

				local function var2_26()
					arg0_25:save(function()
						arg0_25:clearCacheMap()

						arg0_25.curAdditionMap = arg0_25.tecNationProxy:getSetableAttrAddition()
						arg0_25.curType = var3_25

						arg0_25:updateAttrList(arg0_25.curType)
					end)
				end

				arg0_25:openSaveBox(var2_26, var1_26, var0_26)
			else
				arg0_25:clearCacheMap()

				arg0_25.curType = var3_25

				arg0_25:updateAttrList(arg0_25.curType)
			end
		end
	end, SFX_PANEL)

	arg0_25.typeToggleTable[var3_25] = arg2_25
end

function var0_0.updateTypeList(arg0_31)
	arg0_31.typeUIItemList:align(#arg0_31.typeOrderList)
end

function var0_0.updateAttrTF(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32:findTF("AttrName", arg2_32)
	local var1_32 = arg0_32:findTF("Attr/Value/CurValue", arg2_32)
	local var2_32 = arg0_32:findTF("Attr/Value/MaxValue", arg2_32)
	local var3_32 = arg0_32:findTF("Attr/InputField", arg2_32)
	local var4_32 = arg0_32:findTF("Buttons/MinusBtn", arg2_32)
	local var5_32 = arg0_32:findTF("Buttons/MaxBtn", arg2_32)
	local var6_32 = arg0_32:findTF("Buttons/AddBtn", arg2_32)
	local var7_32 = arg0_32:findTF("Attr/InputField", arg2_32)
	local var8_32 = arg0_32.typeAttrOrderListTable[arg0_32.curType][arg1_32]
	local var9_32 = AttributeType.Type2Name(pg.attribute_info_by_type[var8_32].name)
	local var10_32 = arg0_32.maxAdditionMap[arg0_32.curType][var8_32]
	local var11_32 = arg0_32:getAddValueForShow(arg0_32.curType, var8_32)

	setText(var0_32, var9_32)
	setText(var1_32, var11_32)
	setText(var2_32, var10_32)
	onButton(arg0_32, var4_32, function()
		local var0_33 = arg0_32:getAddValueForShow(arg0_32.curType, var8_32)

		if var0_33 > 0 then
			local var1_33 = var0_33 - 1

			arg0_32:setAttrValue(arg0_32.curType, var8_32, var1_33)
			setText(var1_32, var1_33)
		end
	end, SFX_PANEL)
	onButton(arg0_32, var6_32, function()
		local var0_34 = arg0_32:getAddValueForShow(arg0_32.curType, var8_32)

		if var0_34 < var10_32 then
			local var1_34 = var0_34 + 1

			arg0_32:setAttrValue(arg0_32.curType, var8_32, var1_34)
			setText(var1_32, var1_34)
		end
	end, SFX_PANEL)
	onButton(arg0_32, var5_32, function()
		local var0_35 = arg0_32:getAddValueForShow(arg0_32.curType, var8_32)
		local var1_35 = var10_32

		arg0_32:setAttrValue(arg0_32.curType, var8_32, var1_35)
		setText(var1_32, var1_35)
	end, SFX_PANEL)
	onInputEndEdit(arg0_32, var7_32, function(arg0_36)
		local var0_36 = tonumber(arg0_36)

		if var0_36 then
			if var0_36 < 0 then
				var0_36 = nil
			else
				local var1_36 = math.floor(var0_36)

				if var1_36 == var0_36 then
					var0_36 = var1_36
				else
					var0_36 = nil
				end
			end
		end

		if var0_36 then
			var0_36 = math.min(var0_36, var10_32)

			arg0_32:setAttrValue(arg0_32.curType, var8_32, var0_36)
			setText(var1_32, var0_36)
		elseif not var0_36 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("attrset_input_ill"))
		end

		setInputText(var7_32, "")
	end)

	arg0_32.typeAttrTFTable[arg0_32.curType][var8_32] = arg2_32
end

function var0_0.updateAttrList(arg0_37, arg1_37)
	arg0_37.typeAttrTFTable = {}
	arg0_37.typeAttrTFTable[arg1_37] = {}

	arg0_37.attrUIItemList:align(#arg0_37.typeAttrOrderListTable[arg1_37])
end

function var0_0.setAttrTFValue(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38:findTF("Attr/Value/CurValue", arg1_38)

	setText(var0_38, arg2_38)
end

function var0_0.openSaveBox(arg0_39, arg1_39, arg2_39, arg3_39)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("attrset_ask_save"),
		onYes = arg1_39,
		onNo = arg2_39,
		onClose = arg3_39,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.getAddValueForShow(arg0_40, arg1_40, arg2_40)
	if arg0_40.cacheAdditionMap[arg1_40] and arg0_40.cacheAdditionMap[arg1_40][arg2_40] then
		return arg0_40.cacheAdditionMap[arg1_40][arg2_40]
	elseif arg0_40.curAdditionMap[arg0_40.curType] and arg0_40.curAdditionMap[arg0_40.curType][arg2_40] then
		return arg0_40.curAdditionMap[arg1_40][arg2_40]
	else
		return arg0_40.maxAdditionMap[arg1_40][arg2_40]
	end
end

function var0_0.setAttrValue(arg0_41, arg1_41, arg2_41, arg3_41)
	if not arg0_41.cacheAdditionMap[arg1_41] then
		arg0_41.cacheAdditionMap[arg1_41] = {}
	end

	arg0_41.cacheAdditionMap[arg1_41][arg2_41] = arg3_41
end

function var0_0.clearCacheMap(arg0_42)
	arg0_42.cacheAdditionMap = {}
end

function var0_0.isChanged(arg0_43)
	for iter0_43, iter1_43 in pairs(arg0_43.cacheAdditionMap) do
		for iter2_43, iter3_43 in pairs(iter1_43) do
			if iter3_43 ~= arg0_43.tecNationProxy:getSetableAttrAdditionValueByTypeAttr(iter0_43, iter2_43) then
				return true
			end
		end
	end

	return false
end

function var0_0.save(arg0_44, arg1_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.curAdditionMap) do
		if not var0_44[iter0_44] then
			var0_44[iter0_44] = {}
		end

		for iter2_44, iter3_44 in pairs(iter1_44) do
			var0_44[iter0_44][iter2_44] = iter3_44
		end
	end

	for iter4_44, iter5_44 in pairs(arg0_44.cacheAdditionMap) do
		if not var0_44[iter4_44] then
			var0_44[iter4_44] = {}
		end

		for iter6_44, iter7_44 in pairs(iter5_44) do
			var0_44[iter4_44][iter6_44] = iter7_44
		end
	end

	local var1_44 = {}

	for iter8_44, iter9_44 in pairs(var0_44) do
		for iter10_44, iter11_44 in pairs(iter9_44) do
			if iter11_44 ~= arg0_44.maxAdditionMap[iter8_44][iter10_44] then
				local var2_44 = {
					ship_type = iter8_44,
					attr_type = iter10_44,
					set_value = iter11_44
				}

				table.insert(var1_44, var2_44)
			end
		end
	end

	pg.m02:sendNotification(GAME.SET_TEC_ATTR_ADDITION, {
		sendList = var1_44,
		onSuccess = arg1_44
	})
end

function var0_0.reset(arg0_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in pairs(arg0_45.curAdditionMap) do
		if iter0_45 ~= arg0_45.curType then
			if not var0_45[iter0_45] then
				var0_45[iter0_45] = {}
			end

			for iter2_45, iter3_45 in pairs(iter1_45) do
				var0_45[iter0_45][iter2_45] = iter3_45
			end
		end
	end

	for iter4_45, iter5_45 in pairs(arg0_45.cacheAdditionMap) do
		if iter4_45 ~= arg0_45.curType then
			if not var0_45[iter4_45] then
				var0_45[iter4_45] = {}
			end

			for iter6_45, iter7_45 in pairs(iter5_45) do
				var0_45[iter4_45][iter6_45] = iter7_45
			end
		end
	end

	local var1_45 = {}

	for iter8_45, iter9_45 in pairs(var0_45) do
		for iter10_45, iter11_45 in pairs(iter9_45) do
			if iter11_45 ~= arg0_45.maxAdditionMap[iter8_45][iter10_45] then
				local var2_45 = {
					ship_type = iter8_45,
					attr_type = iter10_45,
					set_value = iter11_45
				}

				table.insert(var1_45, var2_45)
			end
		end
	end

	pg.m02:sendNotification(GAME.SET_TEC_ATTR_ADDITION, {
		sendList = var1_45
	})
end

return var0_0
