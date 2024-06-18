local var0_0 = class("ShipExpItemUsagePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipExpItemUsagePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("frame/top/btnBack")
	arg0_2.confirmBtn = arg0_2:findTF("frame/buttons/confirm")
	arg0_2.recomBtn = arg0_2:findTF("frame/buttons/recom")
	arg0_2.clearBtn = arg0_2:findTF("frame/buttons/clear")
	arg0_2.levelTxt = arg0_2:findTF("frame/content/level/Text"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("frame/content/level/exp"):GetComponent(typeof(Text))
	arg0_2.currentProgress = arg0_2:findTF("frame/content/level/y"):GetComponent(typeof(Slider))
	arg0_2.tipProgress = arg0_2:findTF("frame/content/level/w"):GetComponent(typeof(Slider))
	arg0_2.previewProgress = arg0_2:findTF("frame/content/level/g"):GetComponent(typeof(Slider))
	arg0_2.itemIds = arg0_2:GetAllItemIDs()

	local var0_2 = #arg0_2.itemIds <= 3

	if var0_2 then
		arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/content/items"), arg0_2:findTF("frame/content/items/tpl"))
	else
		arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/content/scrollrect/content"), arg0_2:findTF("frame/content/items/tpl"))
	end

	setActive(arg0_2:findTF("frame/content/items"), var0_2)
	setActive(arg0_2:findTF("frame/content/scrollrect"), not var0_2)
	setText(arg0_2:findTF("frame/top/bg/infomation/title"), i18n("ship_exp_item_title"))
	setText(arg0_2:findTF("frame/content/label"), i18n("coures_level_tip"))
	setText(arg0_2.confirmBtn:Find("pic"), i18n("ship_exp_item_label_confirm"))
	setText(arg0_2.recomBtn:Find("pic"), i18n("ship_exp_item_label_recom"))
	setText(arg0_2.clearBtn:Find("pic"), i18n("ship_exp_item_label_clear"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.cards = {}

	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.recomBtn, function()
		triggerButton(arg0_3.clearBtn)

		local var0_6 = arg0_3:Recommand()

		for iter0_6, iter1_6 in pairs(arg0_3.cards) do
			iter1_6.value = var0_6[iter1_6.item.id] or 0

			iter1_6:UpdateValue()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.clearBtn, function()
		for iter0_7, iter1_7 in pairs(arg0_3.cards) do
			iter1_7.value = 0

			iter1_7:UpdateValue()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if _.all(_.values(arg0_3.itemCnts), function(arg0_9)
			return arg0_9 == 0
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_no_material"))

			return
		end

		local function var0_8(arg0_10)
			arg0_3:emit(ShipMainMediator.ON_ADD_SHIP_EXP, arg0_3.shipVO.id, arg0_3.itemCnts)

			if arg0_10 then
				arg0_3:Hide()
			else
				arg0_3:Flush(arg0_3.shipVO)
			end
		end

		local var1_8 = arg0_3:GetAdditionExp()
		local var2_8 = Clone(arg0_3.shipVO)
		local var3_8 = var2_8:getMaxLevel()

		var2_8.exp = var2_8.exp + var1_8

		local var4_8 = false

		while var2_8:canLevelUp() do
			var2_8.exp = var2_8.exp - var2_8:getLevelExpConfig().exp_interval
			var2_8.level = math.min(var2_8.level + 1, var3_8)
			var4_8 = true
		end

		local var5_8 = var2_8.maxLevel <= var2_8.level

		if var4_8 and (var2_8.maxLevel == var2_8.level and var2_8.exp > 0 or var2_8.maxLevel < var2_8.level) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("coures_exp_overflow_tip", var2_8.exp),
				onYes = function()
					var0_8(var5_8)
				end
			})
		else
			var0_8(var5_8)
		end
	end, SFX_PANEL)
	arg0_3.uiItemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_3.itemIds[arg1_12 + 1]

			arg0_3:UpdateItemPanel(var0_12, arg2_12)
		end
	end)
end

function var0_0.GetItem(arg0_13, arg1_13)
	return getProxy(BagProxy):getItemById(arg1_13) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1_13
	})
end

function var0_0.Recommand(arg0_14)
	local var0_14 = {}
	local var1_14 = Clone(arg0_14.shipVO)
	local var2_14 = underscore.map(arg0_14:GetAllItemIDs(), function(arg0_15)
		return arg0_14:GetItem(arg0_15)
	end)

	table.sort(var2_14, CompareFuncs({
		function(arg0_16)
			return -arg0_16.id
		end
	}))

	for iter0_14, iter1_14 in ipairs(var2_14) do
		var0_14[iter1_14.id] = 0

		local var3_14 = iter1_14:getConfig("usage_arg")
		local var4_14 = iter0_14 < #var2_14 and var2_14[iter0_14 + 1]:getConfig("usage_arg") or 0

		for iter2_14 = 1, iter1_14.count do
			if iter0_14 ~= #var2_14 and arg0_14:PreCalcExpOverFlow(var1_14, tonumber(var3_14), tonumber(var4_14)) then
				break
			else
				var1_14:addExp(tonumber(var3_14))

				var0_14[iter1_14.id] = var0_14[iter1_14.id] + 1

				if var1_14.maxLevel == var1_14.level then
					return var0_14
				end
			end
		end
	end

	return var0_14
end

function var0_0.PreCalcExpOverFlow(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg1_17.exp
	local var1_17 = arg1_17.level

	arg1_17.exp = arg1_17.exp + arg2_17

	local var2_17 = arg1_17:getMaxLevel()

	while arg1_17:canLevelUp() do
		arg1_17.exp = arg1_17.exp - arg1_17:getLevelExpConfig().exp_interval
		arg1_17.level = math.min(arg1_17.level + 1, var2_17)
	end

	local var3_17 = var2_17 <= arg1_17.level and arg3_17 < arg1_17.exp

	arg1_17.exp = var0_17
	arg1_17.level = var1_17

	return var3_17
end

function var0_0.GetAllItemIDs(arg0_18)
	local var0_18 = pg.gameset.ship_exp_books.description
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if Item.getConfigData(iter1_18) then
			table.insert(var1_18, iter1_18)
		end
	end

	return var1_18
end

function var0_0.Show(arg0_19, arg1_19)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf, false, {
		weight = LayerWeightConst.BASE_LAYER + 2
	})
	var0_0.super.Show(arg0_19)
	arg0_19:Flush(arg1_19)
end

function var0_0.Flush(arg0_20, arg1_20)
	arg0_20.itemCnts = {}
	arg0_20.shipVO = arg1_20

	arg0_20:InitItems()
	arg0_20:UpdateLevelInfo()
end

function var0_0.Hide(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21._parentTf)
	var0_0.super.Hide(arg0_21)
end

function var0_0.InitItems(arg0_22)
	table.sort(arg0_22.itemIds, function(arg0_23, arg1_23)
		return arg0_23 < arg1_23
	end)
	arg0_22.uiItemList:align(#arg0_22.itemIds)
end

function var0_0.UpdateItemPanel(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cards[arg2_24]

	if not var0_24 then
		var0_24 = ShipExpItemUsageCard.New(arg2_24)

		var0_24:SetCallBack(function(arg0_25, arg1_25, arg2_25, arg3_25)
			arg0_24:OnAddItem(arg0_25, arg1_25, arg2_25, arg3_25)
		end)

		arg0_24.cards[arg2_24] = var0_24
	end

	var0_24:Update(arg1_24)
end

function var0_0.OnAddItem(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	if arg0_26.shipVO.maxLevel == arg0_26.shipVO.level then
		arg1_26:ForceUpdateValue(arg0_26.itemCnts[arg2_26])
		pg.TipsMgr.GetInstance():ShowTips(i18n("coures_tip_exceeded_lv"))

		return
	end

	local var0_26 = Clone(arg0_26.shipVO)
	local var1_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26.itemCnts) do
		if iter0_26 ~= arg2_26 then
			local var2_26 = Item.getConfigData(iter0_26).usage_arg

			var1_26 = var1_26 + tonumber(var2_26) * iter1_26
		end
	end

	var0_26:addExp(var1_26)

	local var3_26 = Item.getConfigData(arg2_26).usage_arg
	local var4_26 = 0

	if arg4_26 then
		var4_26 = arg3_26
	elseif var0_26.level ~= var0_26.maxLevel then
		for iter2_26 = 1, arg3_26 do
			var0_26:addExp(tonumber(var3_26))

			var4_26 = var4_26 + 1

			if var0_26.maxLevel == var0_26.level then
				break
			end
		end
	end

	if arg3_26 > (arg0_26.itemCnts[arg2_26] or 0) then
		var4_26 = math.max(arg0_26.itemCnts[arg2_26] or 0, var4_26)
	end

	if arg3_26 ~= var4_26 then
		arg1_26:ForceUpdateValue(var4_26)

		arg3_26 = var4_26
	end

	arg0_26.itemCnts[arg2_26] = arg3_26

	arg0_26:UpdateLevelInfo()
end

function var0_0.GetTempShipVO(arg0_27, arg1_27, arg2_27)
	if arg2_27 > 0 then
		local var0_27 = Clone(arg1_27)

		var0_27:addExp(arg2_27)

		return var0_27
	end

	return arg1_27
end

function var0_0.GetAdditionExp(arg0_28)
	local var0_28 = 0

	for iter0_28, iter1_28 in pairs(arg0_28.itemCnts) do
		local var1_28 = Item.getConfigData(iter0_28).usage_arg

		var0_28 = var0_28 + tonumber(var1_28) * iter1_28
	end

	return var0_28
end

function var0_0.UpdateLevelInfo(arg0_29)
	local var0_29 = arg0_29.shipVO
	local var1_29 = arg0_29:GetAdditionExp()
	local var2_29 = arg0_29:GetTempShipVO(var0_29, var1_29)
	local var3_29 = var2_29.level - var0_29.level
	local var4_29 = var3_29 <= 0 and (var1_29 > 0 and "+0" or "") or "<color=" .. COLOR_GREEN .. ">+" .. var3_29 .. "</color>"

	arg0_29.levelTxt.text = var0_29.level .. var4_29

	local var5_29 = var0_29:getLevelExpConfig().exp_interval

	arg0_29.expTxt.text = string.format("%d<color=%s>(+%d)</color>/%d", var0_29.exp, COLOR_GREEN, var1_29, var5_29)

	local var6_29 = var0_29.exp / var5_29

	arg0_29.currentProgress.value = var6_29
	arg0_29.tipProgress.value = var1_29 <= 0 and var6_29 or var6_29 + 0.003
	arg0_29.previewProgress.value = var1_29 <= 0 and 0 or var3_29 >= 1 and 1 or var2_29.exp / var5_29
end

function var0_0.OnDestroy(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.cards) do
		iter1_30:Dispose()
	end

	arg0_30.cards = nil
end

return var0_0
