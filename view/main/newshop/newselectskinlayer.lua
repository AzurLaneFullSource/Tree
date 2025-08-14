local var0_0 = class("NewSelectSkinLayer", import(".NewSkinAtlasLayer"))

var0_0.MODE_SELECT = 1
var0_0.MODE_VIEW = 2

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
	setText(arg0_1._tf:Find("adapt/top/title/Text"), i18n("shop_new_able_to_exchange"))
	setText(arg0_1._tf:Find("adapt/top/have/Text"), i18n("shop_new_able_to_exchange"))

	arg0_1.msgBox = SelectSkinMsgbox.New(arg0_1._tf, arg0_1.event)
end

function var0_0.InitData(arg0_2)
	arg0_2.skins = {}

	local var0_2 = arg0_2.contextData.selectableSkinList or {}

	table.sort(var0_2, function(arg0_3, arg1_3)
		local var0_3 = arg0_3:GetTimeLimitWeight()
		local var1_3 = arg1_3:GetTimeLimitWeight()

		if var0_3 == var1_3 then
			local var2_3 = arg0_3:GetOwnWeight()
			local var3_3 = arg1_3:GetOwnWeight()

			if var2_3 == var3_3 then
				return arg0_3.skinId > arg1_3.skinId
			else
				return var3_3 < var2_3
			end
		else
			return var1_3 < var0_3
		end
	end)

	for iter0_2, iter1_2 in ipairs(var0_2) do
		table.insert(arg0_2.skins, iter1_2:ToShipSkin())
	end

	arg0_2:GetSkinClassify()

	arg0_2.filterValues = {
		ownType = 0,
		shipHaveType = 0,
		typeType = {
			0
		},
		campType = {
			0
		},
		rarityType = {
			0
		},
		shipType = {
			0
		},
		themeType = {
			0
		}
	}
	arg0_2.filterValuesTemp = Clone(arg0_2.filterValues)
end

function var0_0.Check(arg0_4, arg1_4)
	if getProxy(ShipSkinProxy):hasSkin(arg1_4.id) then
		return
	end

	local var0_4 = arg0_4.contextData.itemId
	local var1_4 = Item.getConfigData(var0_4).name

	arg0_4.msgBox:ExecuteAction("Show", {
		content = i18n("skin_exchange_confirm", var1_4, arg1_4.skinName),
		leftDrop = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = var0_4
		},
		rightDrop = {
			count = 1,
			type = DROP_TYPE_SKIN,
			id = arg1_4.id
		},
		onYes = function()
			arg0_4.contextData.OnConfirm(arg1_4.id)
			arg0_4:closeView()
		end
	})
end

function var0_0.ClickTrigger(arg0_6, arg1_6, arg2_6)
	if arg0_6.contextData.mode == var0_0.MODE_VIEW then
		return
	end

	arg0_6:Check(arg1_6.skin)
end

function var0_0.willExit(arg0_7)
	var0_0.super.willExit(arg0_7)
	arg0_7.msgBox:Destroy()
end

return var0_0
