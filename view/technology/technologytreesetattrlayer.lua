local var0 = class("TechnologyTreeSetAttrLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TechnologyTreeSetAttrUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:initUITips()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0:getWeightFromData()
	})
	arg0:updateTypeList()
	triggerToggle(arg0.typeContainer:GetChild(0), true)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.resLoader:Clear()
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.closeBtn)
end

function var0.initData(arg0)
	arg0.tecNationProxy = getProxy(TechnologyNationProxy)
	arg0.cacheAdditionMap = {}
	arg0.curAdditionMap = arg0.tecNationProxy:getSetableAttrAddition()
	arg0.maxAdditionMap = nil
	arg0.typeOrderList = nil
	arg0.typeAttrOrderListTable = nil
	arg0.maxAdditionMap, arg0.typeOrderList, arg0.typeAttrOrderListTable = arg0.tecNationProxy:getTecBuff()
	arg0.typeOrderList = ShipType.FilterOverQuZhuType(arg0.typeOrderList)
	arg0.resLoader = AutoLoader.New()
	arg0.curType = 0
	arg0.typeToggleTable = {}
	arg0.typeAttrTFTable = {}
end

function var0.initUITips(arg0)
	local var0 = arg0:findTF("Adapt/Content/ResetBtn/Text")
	local var1 = arg0:findTF("Adapt/Content/SaveBtn/Text")

	setText(var0, i18n("attrset_reset"))
	setText(var1, i18n("attrset_save"))
end

function var0.findUI(arg0)
	arg0.typeTpl = arg0:findTF("TypeTpl")
	arg0.attrTpl = arg0:findTF("AttrTpl")
	arg0.backBGTF = arg0:findTF("Adapt/BackBG")

	local var0 = arg0:findTF("Adapt/Content")

	arg0.closeBtn = arg0:findTF("CloseBtn", var0)
	arg0.arrowTF = arg0:findTF("Arrow", var0)
	arg0.typeContainer = arg0:findTF("TypeScrollView/Content", var0)
	arg0.attrContainer = arg0:findTF("AttrPanel", var0)
	arg0.resetBtn = arg0:findTF("ResetBtn", var0)
	arg0.saveBtn = arg0:findTF("SaveBtn", var0)
	arg0.typeUIItemList = UIItemList.New(arg0.typeContainer, arg0.typeTpl)
	arg0.attrUIItemList = UIItemList.New(arg0.attrContainer, arg0.attrTpl)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.closeBtn, function()
		if arg0:isChanged() then
			local function var0()
				return
			end

			local function var1()
				arg0:closeView()
			end

			local function var2()
				arg0:save(function()
					arg0:closeView()
				end)
			end

			arg0:openSaveBox(var2, var1, var0)
		else
			arg0:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.backBGTF, function()
		if arg0:isChanged() then
			local function var0()
				return
			end

			local function var1()
				arg0:closeView()
			end

			local function var2()
				arg0:save(function()
					arg0:closeView()
				end)
			end

			arg0:openSaveBox(var2, var1, var0)
		else
			arg0:closeView()
		end
	end, SFX_CANCEL)
	arg0.typeUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateTypeTF(arg1, arg2)
		end
	end)
	arg0.attrUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateAttrTF(arg1, arg2)
		end
	end)
	onButton(arg0, arg0.resetBtn, function()
		for iter0, iter1 in ipairs(arg0.typeAttrOrderListTable[arg0.curType]) do
			local var0 = arg0.maxAdditionMap[arg0.curType][iter1]

			arg0:setAttrValue(arg0.curType, iter1, var0)
			arg0:setAttrTFValue(arg0.typeAttrTFTable[arg0.curType][iter1], var0)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.saveBtn, function()
		if arg0:isChanged() then
			local function var0()
				arg0:clearCacheMap()

				arg0.curAdditionMap = arg0.tecNationProxy:getSetableAttrAddition()
			end

			arg0:save(var0)
		end
	end, SFX_PANEL)
end

function var0.updateTypeTF(arg0, arg1, arg2)
	local var0 = arg0:findTF("TypeNameUnSelect", arg2)
	local var1 = arg0:findTF("TypeNameSelected", arg2)
	local var2 = arg0:findTF("TypeImg", arg2)
	local var3 = arg0.typeOrderList[arg1]
	local var4 = ShipType.Type2Name(var3)

	setText(var0, var4)
	setText(var1, var4)
	arg0.resLoader:GetSprite("ShipType", "buffitem_tec_" .. var3, var2, false)
	onToggle(arg0, arg2, function(arg0)
		if arg0 and arg0.curType ~= var3 then
			if arg0:isChanged() then
				local function var0()
					triggerToggle(arg0.typeToggleTable[arg0.curType], true)
				end

				local function var1()
					arg0:clearCacheMap()

					arg0.curType = var3

					arg0:updateAttrList(arg0.curType)
				end

				local function var2()
					arg0:save(function()
						arg0:clearCacheMap()

						arg0.curAdditionMap = arg0.tecNationProxy:getSetableAttrAddition()
						arg0.curType = var3

						arg0:updateAttrList(arg0.curType)
					end)
				end

				arg0:openSaveBox(var2, var1, var0)
			else
				arg0:clearCacheMap()

				arg0.curType = var3

				arg0:updateAttrList(arg0.curType)
			end
		end
	end, SFX_PANEL)

	arg0.typeToggleTable[var3] = arg2
end

function var0.updateTypeList(arg0)
	arg0.typeUIItemList:align(#arg0.typeOrderList)
end

function var0.updateAttrTF(arg0, arg1, arg2)
	local var0 = arg0:findTF("AttrName", arg2)
	local var1 = arg0:findTF("Attr/Value/CurValue", arg2)
	local var2 = arg0:findTF("Attr/Value/MaxValue", arg2)
	local var3 = arg0:findTF("Attr/InputField", arg2)
	local var4 = arg0:findTF("Buttons/MinusBtn", arg2)
	local var5 = arg0:findTF("Buttons/MaxBtn", arg2)
	local var6 = arg0:findTF("Buttons/AddBtn", arg2)
	local var7 = arg0:findTF("Attr/InputField", arg2)
	local var8 = arg0.typeAttrOrderListTable[arg0.curType][arg1]
	local var9 = AttributeType.Type2Name(pg.attribute_info_by_type[var8].name)
	local var10 = arg0.maxAdditionMap[arg0.curType][var8]
	local var11 = arg0:getAddValueForShow(arg0.curType, var8)

	setText(var0, var9)
	setText(var1, var11)
	setText(var2, var10)
	onButton(arg0, var4, function()
		local var0 = arg0:getAddValueForShow(arg0.curType, var8)

		if var0 > 0 then
			local var1 = var0 - 1

			arg0:setAttrValue(arg0.curType, var8, var1)
			setText(var1, var1)
		end
	end, SFX_PANEL)
	onButton(arg0, var6, function()
		local var0 = arg0:getAddValueForShow(arg0.curType, var8)

		if var0 < var10 then
			local var1 = var0 + 1

			arg0:setAttrValue(arg0.curType, var8, var1)
			setText(var1, var1)
		end
	end, SFX_PANEL)
	onButton(arg0, var5, function()
		local var0 = arg0:getAddValueForShow(arg0.curType, var8)
		local var1 = var10

		arg0:setAttrValue(arg0.curType, var8, var1)
		setText(var1, var1)
	end, SFX_PANEL)
	onInputEndEdit(arg0, var7, function(arg0)
		local var0 = tonumber(arg0)

		if var0 then
			if var0 < 0 then
				var0 = nil
			else
				local var1 = math.floor(var0)

				if var1 == var0 then
					var0 = var1
				else
					var0 = nil
				end
			end
		end

		if var0 then
			var0 = math.min(var0, var10)

			arg0:setAttrValue(arg0.curType, var8, var0)
			setText(var1, var0)
		elseif not var0 then
			pg.TipsMgr:GetInstance():ShowTips(i18n("attrset_input_ill"))
		end

		setInputText(var7, "")
	end)

	arg0.typeAttrTFTable[arg0.curType][var8] = arg2
end

function var0.updateAttrList(arg0, arg1)
	arg0.typeAttrTFTable = {}
	arg0.typeAttrTFTable[arg1] = {}

	arg0.attrUIItemList:align(#arg0.typeAttrOrderListTable[arg1])
end

function var0.setAttrTFValue(arg0, arg1, arg2)
	local var0 = arg0:findTF("Attr/Value/CurValue", arg1)

	setText(var0, arg2)
end

function var0.openSaveBox(arg0, arg1, arg2, arg3)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("attrset_ask_save"),
		onYes = arg1,
		onNo = arg2,
		onClose = arg3,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.getAddValueForShow(arg0, arg1, arg2)
	if arg0.cacheAdditionMap[arg1] and arg0.cacheAdditionMap[arg1][arg2] then
		return arg0.cacheAdditionMap[arg1][arg2]
	elseif arg0.curAdditionMap[arg0.curType] and arg0.curAdditionMap[arg0.curType][arg2] then
		return arg0.curAdditionMap[arg1][arg2]
	else
		return arg0.maxAdditionMap[arg1][arg2]
	end
end

function var0.setAttrValue(arg0, arg1, arg2, arg3)
	if not arg0.cacheAdditionMap[arg1] then
		arg0.cacheAdditionMap[arg1] = {}
	end

	arg0.cacheAdditionMap[arg1][arg2] = arg3
end

function var0.clearCacheMap(arg0)
	arg0.cacheAdditionMap = {}
end

function var0.isChanged(arg0)
	for iter0, iter1 in pairs(arg0.cacheAdditionMap) do
		for iter2, iter3 in pairs(iter1) do
			if iter3 ~= arg0.tecNationProxy:getSetableAttrAdditionValueByTypeAttr(iter0, iter2) then
				return true
			end
		end
	end

	return false
end

function var0.save(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.curAdditionMap) do
		if not var0[iter0] then
			var0[iter0] = {}
		end

		for iter2, iter3 in pairs(iter1) do
			var0[iter0][iter2] = iter3
		end
	end

	for iter4, iter5 in pairs(arg0.cacheAdditionMap) do
		if not var0[iter4] then
			var0[iter4] = {}
		end

		for iter6, iter7 in pairs(iter5) do
			var0[iter4][iter6] = iter7
		end
	end

	local var1 = {}

	for iter8, iter9 in pairs(var0) do
		for iter10, iter11 in pairs(iter9) do
			if iter11 ~= arg0.maxAdditionMap[iter8][iter10] then
				local var2 = {
					ship_type = iter8,
					attr_type = iter10,
					set_value = iter11
				}

				table.insert(var1, var2)
			end
		end
	end

	pg.m02:sendNotification(GAME.SET_TEC_ATTR_ADDITION, {
		sendList = var1,
		onSuccess = arg1
	})
end

function var0.reset(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.curAdditionMap) do
		if iter0 ~= arg0.curType then
			if not var0[iter0] then
				var0[iter0] = {}
			end

			for iter2, iter3 in pairs(iter1) do
				var0[iter0][iter2] = iter3
			end
		end
	end

	for iter4, iter5 in pairs(arg0.cacheAdditionMap) do
		if iter4 ~= arg0.curType then
			if not var0[iter4] then
				var0[iter4] = {}
			end

			for iter6, iter7 in pairs(iter5) do
				var0[iter4][iter6] = iter7
			end
		end
	end

	local var1 = {}

	for iter8, iter9 in pairs(var0) do
		for iter10, iter11 in pairs(iter9) do
			if iter11 ~= arg0.maxAdditionMap[iter8][iter10] then
				local var2 = {
					ship_type = iter8,
					attr_type = iter10,
					set_value = iter11
				}

				table.insert(var1, var2)
			end
		end
	end

	pg.m02:sendNotification(GAME.SET_TEC_ATTR_ADDITION, {
		sendList = var1
	})
end

return var0
