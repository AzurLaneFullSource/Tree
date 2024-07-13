local var0_0 = class("SelectSkinLayer", import(".SkinAtlasScene"))

var0_0.MODE_SELECT = 1
var0_0.MODE_VIEW = 2

function var0_0.getUIName(arg0_1)
	return "SelectSkinUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_2.msgBox = SelectSkinMsgbox.New(arg0_2._tf, arg0_2.event)
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)
end

function var0_0.GetSkinList(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.contextData.selectableSkinList or {}
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var2_4 = iter1_4:ToShipSkin()

		if (arg1_4 == var0_0.PAGE_ALL or var2_4:IsType(arg1_4)) and not var2_4:IsDefault() and var2_4:IsMatchKey(arg2_4) and arg0_4:MatchIndex(var2_4) then
			table.insert(var1_4, iter1_4)
		end
	end

	return var1_4
end

function var0_0.SortDisplay(arg0_5, arg1_5)
	table.sort(arg1_5, function(arg0_6, arg1_6)
		local var0_6 = arg0_6:GetTimeLimitWeight()
		local var1_6 = arg1_6:GetTimeLimitWeight()

		if var0_6 == var1_6 then
			local var2_6 = arg0_6:GetOwnWeight()
			local var3_6 = arg1_6:GetOwnWeight()

			if var2_6 == var3_6 then
				return arg0_6.skinId > arg1_6.skinId
			else
				return var3_6 < var2_6
			end
		else
			return var1_6 < var0_6
		end
	end)
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = SelectSkinCard.New(arg1_7)

	onButton(arg0_7, var0_7._tf, function()
		if arg0_7.contextData.mode == var0_0.MODE_VIEW then
			return
		end

		arg0_7:Check(var0_7.skin)
	end, SFX_PANEL)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_9, arg1_9, arg2_9)
	if not arg0_9.cards[arg2_9] then
		arg0_9:OnInitItem(arg2_9)
	end

	local var0_9 = arg0_9.cards[arg2_9]
	local var1_9 = arg0_9.displays[arg1_9 + 1]
	local var2_9 = var1_9:ToShipSkin()

	var0_9:Update(var2_9, arg1_9 + 1, var1_9:IsTimeLimit(), var1_9:OwnSkin())
end

function var0_0.Check(arg0_10, arg1_10)
	if getProxy(ShipSkinProxy):hasSkin(arg1_10.id) then
		return
	end

	local var0_10 = arg0_10.contextData.itemId
	local var1_10 = Item.getConfigData(var0_10).name

	arg0_10.msgBox:ExecuteAction("Show", {
		content = i18n("skin_exchange_confirm", var1_10, arg1_10.skinName),
		leftDrop = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = var0_10
		},
		rightDrop = {
			count = 1,
			type = DROP_TYPE_SKIN,
			id = arg1_10.id
		},
		onYes = function()
			arg0_10.contextData.OnConfirm(arg1_10.id)
			arg0_10:closeView()
		end
	})
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
	arg0_12.msgBox:Destroy()
	var0_0.super.willExit(arg0_12)
end

return var0_0
