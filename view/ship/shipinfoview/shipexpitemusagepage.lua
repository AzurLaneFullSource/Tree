local var0 = class("ShipExpItemUsagePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipExpItemUsagePage"
end

function var0.OnLoaded(arg0)
	arg0.backBtn = arg0:findTF("frame/top/btnBack")
	arg0.confirmBtn = arg0:findTF("frame/buttons/confirm")
	arg0.recomBtn = arg0:findTF("frame/buttons/recom")
	arg0.clearBtn = arg0:findTF("frame/buttons/clear")
	arg0.levelTxt = arg0:findTF("frame/content/level/Text"):GetComponent(typeof(Text))
	arg0.expTxt = arg0:findTF("frame/content/level/exp"):GetComponent(typeof(Text))
	arg0.currentProgress = arg0:findTF("frame/content/level/y"):GetComponent(typeof(Slider))
	arg0.tipProgress = arg0:findTF("frame/content/level/w"):GetComponent(typeof(Slider))
	arg0.previewProgress = arg0:findTF("frame/content/level/g"):GetComponent(typeof(Slider))
	arg0.itemIds = arg0:GetAllItemIDs()

	local var0 = #arg0.itemIds <= 3

	if var0 then
		arg0.uiItemList = UIItemList.New(arg0:findTF("frame/content/items"), arg0:findTF("frame/content/items/tpl"))
	else
		arg0.uiItemList = UIItemList.New(arg0:findTF("frame/content/scrollrect/content"), arg0:findTF("frame/content/items/tpl"))
	end

	setActive(arg0:findTF("frame/content/items"), var0)
	setActive(arg0:findTF("frame/content/scrollrect"), not var0)
	setText(arg0:findTF("frame/top/bg/infomation/title"), i18n("ship_exp_item_title"))
	setText(arg0:findTF("frame/content/label"), i18n("coures_level_tip"))
	setText(arg0.confirmBtn:Find("pic"), i18n("ship_exp_item_label_confirm"))
	setText(arg0.recomBtn:Find("pic"), i18n("ship_exp_item_label_recom"))
	setText(arg0.clearBtn:Find("pic"), i18n("ship_exp_item_label_clear"))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.recomBtn, function()
		triggerButton(arg0.clearBtn)

		local var0 = arg0:Recommand()

		for iter0, iter1 in pairs(arg0.cards) do
			iter1.value = var0[iter1.item.id] or 0

			iter1:UpdateValue()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.clearBtn, function()
		for iter0, iter1 in pairs(arg0.cards) do
			iter1.value = 0

			iter1:UpdateValue()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if _.all(_.values(arg0.itemCnts), function(arg0)
			return arg0 == 0
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_no_material"))

			return
		end

		local function var0(arg0)
			arg0:emit(ShipMainMediator.ON_ADD_SHIP_EXP, arg0.shipVO.id, arg0.itemCnts)

			if arg0 then
				arg0:Hide()
			else
				arg0:Flush(arg0.shipVO)
			end
		end

		local var1 = arg0:GetAdditionExp()
		local var2 = Clone(arg0.shipVO)
		local var3 = var2:getMaxLevel()

		var2.exp = var2.exp + var1

		local var4 = false

		while var2:canLevelUp() do
			var2.exp = var2.exp - var2:getLevelExpConfig().exp_interval
			var2.level = math.min(var2.level + 1, var3)
			var4 = true
		end

		local var5 = var2.maxLevel <= var2.level

		if var4 and (var2.maxLevel == var2.level and var2.exp > 0 or var2.maxLevel < var2.level) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("coures_exp_overflow_tip", var2.exp),
				onYes = function()
					var0(var5)
				end
			})
		else
			var0(var5)
		end
	end, SFX_PANEL)
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.itemIds[arg1 + 1]

			arg0:UpdateItemPanel(var0, arg2)
		end
	end)
end

function var0.GetItem(arg0, arg1)
	return getProxy(BagProxy):getItemById(arg1) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1
	})
end

function var0.Recommand(arg0)
	local var0 = {}
	local var1 = Clone(arg0.shipVO)
	local var2 = underscore.map(arg0:GetAllItemIDs(), function(arg0)
		return arg0:GetItem(arg0)
	end)

	table.sort(var2, CompareFuncs({
		function(arg0)
			return -arg0.id
		end
	}))

	for iter0, iter1 in ipairs(var2) do
		var0[iter1.id] = 0

		local var3 = iter1:getConfig("usage_arg")
		local var4 = iter0 < #var2 and var2[iter0 + 1]:getConfig("usage_arg") or 0

		for iter2 = 1, iter1.count do
			if iter0 ~= #var2 and arg0:PreCalcExpOverFlow(var1, tonumber(var3), tonumber(var4)) then
				break
			else
				var1:addExp(tonumber(var3))

				var0[iter1.id] = var0[iter1.id] + 1

				if var1.maxLevel == var1.level then
					return var0
				end
			end
		end
	end

	return var0
end

function var0.PreCalcExpOverFlow(arg0, arg1, arg2, arg3)
	local var0 = arg1.exp
	local var1 = arg1.level

	arg1.exp = arg1.exp + arg2

	local var2 = arg1:getMaxLevel()

	while arg1:canLevelUp() do
		arg1.exp = arg1.exp - arg1:getLevelExpConfig().exp_interval
		arg1.level = math.min(arg1.level + 1, var2)
	end

	local var3 = var2 <= arg1.level and arg3 < arg1.exp

	arg1.exp = var0
	arg1.level = var1

	return var3
end

function var0.GetAllItemIDs(arg0)
	local var0 = pg.gameset.ship_exp_books.description
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if Item.getConfigData(iter1) then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.Show(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.BASE_LAYER + 2
	})
	var0.super.Show(arg0)
	arg0:Flush(arg1)
end

function var0.Flush(arg0, arg1)
	arg0.itemCnts = {}
	arg0.shipVO = arg1

	arg0:InitItems()
	arg0:UpdateLevelInfo()
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
end

function var0.InitItems(arg0)
	table.sort(arg0.itemIds, function(arg0, arg1)
		return arg0 < arg1
	end)
	arg0.uiItemList:align(#arg0.itemIds)
end

function var0.UpdateItemPanel(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		var0 = ShipExpItemUsageCard.New(arg2)

		var0:SetCallBack(function(arg0, arg1, arg2, arg3)
			arg0:OnAddItem(arg0, arg1, arg2, arg3)
		end)

		arg0.cards[arg2] = var0
	end

	var0:Update(arg1)
end

function var0.OnAddItem(arg0, arg1, arg2, arg3, arg4)
	if arg0.shipVO.maxLevel == arg0.shipVO.level then
		arg1:ForceUpdateValue(arg0.itemCnts[arg2])
		pg.TipsMgr.GetInstance():ShowTips(i18n("coures_tip_exceeded_lv"))

		return
	end

	local var0 = Clone(arg0.shipVO)
	local var1 = 0

	for iter0, iter1 in pairs(arg0.itemCnts) do
		if iter0 ~= arg2 then
			local var2 = Item.getConfigData(iter0).usage_arg

			var1 = var1 + tonumber(var2) * iter1
		end
	end

	var0:addExp(var1)

	local var3 = Item.getConfigData(arg2).usage_arg
	local var4 = 0

	if arg4 then
		var4 = arg3
	elseif var0.level ~= var0.maxLevel then
		for iter2 = 1, arg3 do
			var0:addExp(tonumber(var3))

			var4 = var4 + 1

			if var0.maxLevel == var0.level then
				break
			end
		end
	end

	if arg3 > (arg0.itemCnts[arg2] or 0) then
		var4 = math.max(arg0.itemCnts[arg2] or 0, var4)
	end

	if arg3 ~= var4 then
		arg1:ForceUpdateValue(var4)

		arg3 = var4
	end

	arg0.itemCnts[arg2] = arg3

	arg0:UpdateLevelInfo()
end

function var0.GetTempShipVO(arg0, arg1, arg2)
	if arg2 > 0 then
		local var0 = Clone(arg1)

		var0:addExp(arg2)

		return var0
	end

	return arg1
end

function var0.GetAdditionExp(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.itemCnts) do
		local var1 = Item.getConfigData(iter0).usage_arg

		var0 = var0 + tonumber(var1) * iter1
	end

	return var0
end

function var0.UpdateLevelInfo(arg0)
	local var0 = arg0.shipVO
	local var1 = arg0:GetAdditionExp()
	local var2 = arg0:GetTempShipVO(var0, var1)
	local var3 = var2.level - var0.level
	local var4 = var3 <= 0 and (var1 > 0 and "+0" or "") or "<color=" .. COLOR_GREEN .. ">+" .. var3 .. "</color>"

	arg0.levelTxt.text = var0.level .. var4

	local var5 = var0:getLevelExpConfig().exp_interval

	arg0.expTxt.text = string.format("%d<color=%s>(+%d)</color>/%d", var0.exp, COLOR_GREEN, var1, var5)

	local var6 = var0.exp / var5

	arg0.currentProgress.value = var6
	arg0.tipProgress.value = var1 <= 0 and var6 or var6 + 0.003
	arg0.previewProgress.value = var1 <= 0 and 0 or var3 >= 1 and 1 or var2.exp / var5
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil
end

return var0
