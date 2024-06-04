local var0 = class("SelectSkinLayer", import(".SkinAtlasScene"))

var0.MODE_SELECT = 1
var0.MODE_VIEW = 2

function var0.getUIName(arg0)
	return "SelectSkinUI"
end

function var0.init(arg0)
	var0.super.init(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0.msgBox = SelectSkinMsgbox.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
end

function var0.GetSkinList(arg0, arg1, arg2)
	local var0 = arg0.contextData.selectableSkinList or {}
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1:ToShipSkin()

		if (arg1 == var0.PAGE_ALL or var2:IsType(arg1)) and not var2:IsDefault() and var2:IsMatchKey(arg2) and arg0:MatchIndex(var2) then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.SortDisplay(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0:GetTimeLimitWeight()
		local var1 = arg1:GetTimeLimitWeight()

		if var0 == var1 then
			local var2 = arg0:GetOwnWeight()
			local var3 = arg1:GetOwnWeight()

			if var2 == var3 then
				return arg0.skinId > arg1.skinId
			else
				return var3 < var2
			end
		else
			return var1 < var0
		end
	end)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = SelectSkinCard.New(arg1)

	onButton(arg0, var0._tf, function()
		if arg0.contextData.mode == var0.MODE_VIEW then
			return
		end

		arg0:Check(var0.skin)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	if not arg0.cards[arg2] then
		arg0:OnInitItem(arg2)
	end

	local var0 = arg0.cards[arg2]
	local var1 = arg0.displays[arg1 + 1]
	local var2 = var1:ToShipSkin()

	var0:Update(var2, arg1 + 1, var1:IsTimeLimit(), var1:OwnSkin())
end

function var0.Check(arg0, arg1)
	if getProxy(ShipSkinProxy):hasSkin(arg1.id) then
		return
	end

	local var0 = arg0.contextData.itemId
	local var1 = Item.getConfigData(var0).name

	arg0.msgBox:ExecuteAction("Show", {
		content = i18n("skin_exchange_confirm", var1, arg1.skinName),
		leftDrop = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = var0
		},
		rightDrop = {
			count = 1,
			type = DROP_TYPE_SKIN,
			id = arg1.id
		},
		onYes = function()
			arg0.contextData.OnConfirm(arg1.id)
			arg0:closeView()
		end
	})
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0.msgBox:Destroy()
	var0.super.willExit(arg0)
end

return var0
