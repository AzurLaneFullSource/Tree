local var0_0 = class("Item", import(".BaseVO"))

var0_0.REVERT_EQUIPMENT_ID = 15007
var0_0.COMMANDER_QUICKLY_TOOL_ID = 20010
var0_0.QUICK_TASK_PASS_TICKET_ID = 15013
var0_0.DOA_SELECT_CHAR_ID = 70144
var0_0.INVISIBLE_TYPE = {
	[0] = true,
	[9] = true
}
var0_0.PUZZLA_TYPE = 0
var0_0.EQUIPMENT_BOX_TYPE_5 = 5
var0_0.LESSON_TYPE = 10
var0_0.EQUIPMENT_SKIN_BOX = 11
var0_0.BLUEPRINT_TYPE = 12
var0_0.ASSIGNED_TYPE = 13
var0_0.GOLD_BOX_TYPE = 14
var0_0.OIL_BOX_TYPE = 15
var0_0.EQUIPMENT_ASSIGNED_TYPE = 16
var0_0.GIFT_BOX = 17
var0_0.TEC_SPEEDUP_TYPE = 18
var0_0.SPECIAL_OPERATION_TICKET = 19
var0_0.GUILD_OPENABLE = 20
var0_0.INVITATION_TYPE = 21
var0_0.EXP_BOOK_TYPE = 22
var0_0.LOVE_LETTER_TYPE = 23
var0_0.SPWEAPON_MATERIAL_TYPE = 24
var0_0.METALESSON_TYPE = 25
var0_0.SKIN_ASSIGNED_TYPE = 26

function var0_0.Ctor(arg0_1, arg1_1)
	assert(not arg1_1.type or arg1_1.type == DROP_TYPE_VITEM or arg1_1.type == DROP_TYPE_ITEM)

	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.count
	arg0_1.name = arg1_1.name
	arg0_1.extra = arg1_1.extra

	arg0_1:InitConfig()
end

function var0_0.CanOpen(arg0_2)
	local var0_2 = arg0_2:getConfig("type")

	return var0_2 == var0_0.EQUIPMENT_BOX_TYPE_5 or var0_2 == var0_0.EQUIPMENT_SKIN_BOX or var0_2 == var0_0.GOLD_BOX_TYPE or var0_2 == var0_0.OIL_BOX_TYPE or var0_2 == var0_0.GIFT_BOX or var0_2 == var0_0.GUILD_OPENABLE
end

function var0_0.IsShipExpType(arg0_3)
	return arg0_3:getConfig("type") == var0_0.EXP_BOOK_TYPE
end

function var0_0.getConfigData(arg0_4)
	local var0_4 = {
		pg.item_virtual_data_statistics,
		pg.item_data_statistics
	}
	local var1_4

	if underscore.any(var0_4, function(arg0_5)
		return arg0_5[arg0_4] ~= nil
	end) then
		var1_4 = setmetatable({}, {
			__index = function(arg0_6, arg1_6)
				for iter0_6, iter1_6 in ipairs(var0_4) do
					if iter1_6[arg0_4] and iter1_6[arg0_4][arg1_6] ~= nil then
						arg0_6[arg1_6] = iter1_6[arg0_4][arg1_6]

						return arg0_6[arg1_6]
					end
				end
			end
		})
	end

	return var1_4
end

function var0_0.InitConfig(arg0_7)
	arg0_7.cfg = var0_0.getConfigData(arg0_7.configId)

	assert(arg0_7.cfg, string.format("without item config from id_%d", arg0_7.id))
end

function var0_0.getConfigTable(arg0_8)
	return arg0_8.cfg
end

function var0_0.CanInBag(arg0_9)
	return tobool(pg.item_data_statistics[arg0_9])
end

function var0_0.couldSell(arg0_10)
	return table.getCount(arg0_10:getConfig("price")) > 0
end

function var0_0.isEnough(arg0_11, arg1_11)
	return arg1_11 <= arg0_11.count
end

function var0_0.consume(arg0_12, arg1_12)
	arg0_12.count = arg0_12.count - arg1_12
end

function var0_0.isDesignDrawing(arg0_13)
	return arg0_13:getConfig("type") == 9
end

function var0_0.isVirtualItem(arg0_14)
	return arg0_14:getConfig("type") == 0
end

function var0_0.isEquipmentSkinBox(arg0_15)
	return arg0_15:getConfig("type") == var0_0.EQUIPMENT_SKIN_BOX
end

function var0_0.isBluePrintType(arg0_16)
	return arg0_16:getConfig("type") == var0_0.BLUEPRINT_TYPE
end

function var0_0.isTecSpeedUpType(arg0_17)
	return arg0_17:getConfig("type") == var0_0.TEC_SPEEDUP_TYPE
end

function var0_0.IsMaxCnt(arg0_18)
	return arg0_18:getConfig("max_num") <= arg0_18.count
end

function var0_0.IsDoaSelectCharItem(arg0_19)
	return arg0_19.id == var0_0.DOA_SELECT_CHAR_ID
end

function var0_0.getConfig(arg0_20, arg1_20)
	if arg1_20 == "display" then
		local var0_20 = var0_0.super.getConfig(arg0_20, "combination_display")

		if var0_20 and #var0_20 > 0 then
			return arg0_20:CombinationDisplay(var0_20)
		end
	end

	return var0_0.super.getConfig(arg0_20, arg1_20)
end

function var0_0.StaticCombinationDisplay(arg0_21)
	local var0_21 = _.map(arg0_21, function(arg0_22)
		local var0_22 = string.format("%0.1f", arg0_22[2] / 100)
		local var1_22 = ShipSkin.New({
			id = arg0_22[1]
		})
		local var2_22 = ""

		if var1_22:IsLive2d() then
			var2_22 = "（<color=#92fc63>" .. i18n("luckybag_skin_islive2d") .. "</color>）"
		elseif var1_22:IsSpine() then
			var2_22 = "（<color=#92fc63>" .. i18n("luckybag_skin_isani") .. "</color>）"
		end

		local var3_22 = i18n("random_skin_list_item_desc_label")
		local var4_22 = ""

		if var1_22:ExistReward() then
			var4_22 = i18n("word_show_extra_reward_at_fudai_dialog", var1_22:GetRewardListDesc())
		end

		return "\n（<color=#92fc63>" .. var0_22 .. "%%</color>）" .. var1_22.shipName .. var3_22 .. var1_22.skinName .. var2_22 .. var4_22
	end)
	local var1_21 = table.concat(var0_21, ";")

	return i18n("skin_gift_desc", var1_21)
end

function var0_0.CombinationDisplay(arg0_23, arg1_23)
	return var0_0.StaticCombinationDisplay(arg1_23)
end

function var0_0.InTimeLimitSkinAssigned(arg0_24)
	local var0_24 = var0_0.getConfigData(arg0_24)

	if var0_24.type ~= var0_0.SKIN_ASSIGNED_TYPE then
		return false
	end

	local var1_24 = var0_24.usage_arg[1]

	return getProxy(ActivityProxy):IsActivityNotEnd(var1_24)
end

function var0_0.GetValidSkinList(arg0_25)
	assert(arg0_25:getConfig("type") == var0_0.SKIN_ASSIGNED_TYPE)

	local var0_25 = arg0_25:getConfig("usage_arg")

	if Item.InTimeLimitSkinAssigned(arg0_25.id) then
		return table.mergeArray(var0_25[2], var0_25[3], true)
	else
		return underscore.rest(var0_25[3], 1)
	end
end

function var0_0.IsAllSkinOwner(arg0_26)
	assert(arg0_26:getConfig("type") == var0_0.SKIN_ASSIGNED_TYPE)

	local var0_26 = getProxy(ShipSkinProxy)

	return underscore.all(arg0_26:GetValidSkinList(), function(arg0_27)
		return var0_26:hasNonLimitSkin(arg0_27)
	end)
end

function var0_0.GetOverflowCheckItems(arg0_28, arg1_28)
	arg1_28 = arg1_28 or 1

	local var0_28 = {}

	if arg0_28:getConfig("usage") == ItemUsage.DROP_TEMPLATE then
		local var1_28, var2_28, var3_28 = unpack(arg0_28:getConfig("usage_arg"))

		if var2_28 > 0 then
			table.insert(var0_28, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold,
				count = var2_28 * arg1_28
			})
		end

		if var3_28 > 0 then
			table.insert(var0_28, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResOil,
				count = var3_28 * arg1_28
			})
		end
	end

	switch(arg0_28:getConfig("type"), {
		[Item.EQUIPMENT_BOX_TYPE_5] = function()
			table.insert(var0_28, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1_28
			})
		end,
		[Item.EQUIPMENT_ASSIGNED_TYPE] = function()
			table.insert(var0_28, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1_28
			})
		end
	})
	underscore.map(var0_28, function(arg0_31)
		return Drop.New(arg0_31)
	end)

	return var0_28
end

function var0_0.IsSkinShopDiscountType(arg0_32)
	return arg0_32:getConfig("usage") == ItemUsage.SKIN_SHOP_DISCOUNT
end

function var0_0.CanUseForShop(arg0_33, arg1_33)
	if arg0_33:IsSkinShopDiscountType() then
		local var0_33 = arg0_33:getConfig("usage_arg")

		if not var0_33 or type(var0_33) ~= "table" then
			return false
		end

		local var1_33 = var0_33[1] or {}

		return #var1_33 == 1 and var1_33[1] == 0 or table.contains(var1_33, arg1_33)
	end

	return false
end

function var0_0.GetConsumeForSkinShopDiscount(arg0_34, arg1_34)
	if arg0_34:IsSkinShopDiscountType() then
		local var0_34 = pg.item_data_statistics[arg0_34.configId].usage_arg[2] or 0
		local var1_34 = Goods.Create({
			shop_id = arg1_34
		}, Goods.TYPE_SKIN)

		return math.max(0, var1_34:GetPrice() - var0_34), var1_34:getConfig("resource_type")
	else
		return 0
	end
end

function var0_0.getName(arg0_35)
	return arg0_35.name or arg0_35:getConfig("name")
end

function var0_0.getIcon(arg0_36)
	return arg0_36:getConfig("Icon")
end

return var0_0
