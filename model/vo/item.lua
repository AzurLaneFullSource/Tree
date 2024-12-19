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

function var0_0.GetPrice(arg0_11)
	if arg0_11:couldSell() then
		return arg0_11:getConfig("price")
	else
		return nil
	end
end

function var0_0.isEnough(arg0_12, arg1_12)
	return arg1_12 <= arg0_12.count
end

function var0_0.consume(arg0_13, arg1_13)
	arg0_13.count = arg0_13.count - arg1_13
end

function var0_0.isDesignDrawing(arg0_14)
	return arg0_14:getConfig("type") == 9
end

function var0_0.isVirtualItem(arg0_15)
	return arg0_15:getConfig("type") == 0
end

function var0_0.isEquipmentSkinBox(arg0_16)
	return arg0_16:getConfig("type") == var0_0.EQUIPMENT_SKIN_BOX
end

function var0_0.isBluePrintType(arg0_17)
	return arg0_17:getConfig("type") == var0_0.BLUEPRINT_TYPE
end

function var0_0.isTecSpeedUpType(arg0_18)
	return arg0_18:getConfig("type") == var0_0.TEC_SPEEDUP_TYPE
end

function var0_0.IsMaxCnt(arg0_19)
	return arg0_19:getConfig("max_num") <= arg0_19.count
end

function var0_0.IsDoaSelectCharItem(arg0_20)
	return arg0_20.id == var0_0.DOA_SELECT_CHAR_ID
end

function var0_0.getConfig(arg0_21, arg1_21)
	if arg1_21 == "display" then
		local var0_21 = var0_0.super.getConfig(arg0_21, "combination_display")

		if var0_21 and #var0_21 > 0 then
			return arg0_21:CombinationDisplay(var0_21)
		end
	end

	return var0_0.super.getConfig(arg0_21, arg1_21)
end

function var0_0.StaticCombinationDisplay(arg0_22)
	local var0_22 = _.map(arg0_22, function(arg0_23)
		local var0_23 = string.format("%0.1f", arg0_23[2] / 100)
		local var1_23 = ShipSkin.New({
			id = arg0_23[1]
		})
		local var2_23 = ""

		if var1_23:IsLive2d() then
			var2_23 = "（<color=#92fc63>" .. i18n("luckybag_skin_islive2d") .. "</color>）"
		elseif var1_23:IsSpine() then
			var2_23 = "（<color=#92fc63>" .. i18n("luckybag_skin_isani") .. "</color>）"
		end

		local var3_23 = i18n("random_skin_list_item_desc_label")
		local var4_23 = ""

		if var1_23:ExistReward() then
			var4_23 = i18n("word_show_extra_reward_at_fudai_dialog", var1_23:GetRewardListDesc())
		end

		return "\n（<color=#92fc63>" .. var0_23 .. "%%</color>）" .. var1_23.shipName .. var3_23 .. var1_23.skinName .. var2_23 .. var4_23
	end)
	local var1_22 = table.concat(var0_22, ";")

	return i18n("skin_gift_desc", var1_22)
end

function var0_0.CombinationDisplay(arg0_24, arg1_24)
	return var0_0.StaticCombinationDisplay(arg1_24)
end

function var0_0.InTimeLimitSkinAssigned(arg0_25)
	local var0_25 = var0_0.getConfigData(arg0_25)

	if var0_25.type ~= var0_0.SKIN_ASSIGNED_TYPE then
		return false
	end

	local var1_25 = var0_25.usage_arg[1]

	return getProxy(ActivityProxy):IsActivityNotEnd(var1_25)
end

function var0_0.GetValidSkinList(arg0_26)
	assert(arg0_26:getConfig("type") == var0_0.SKIN_ASSIGNED_TYPE)

	local var0_26 = arg0_26:getConfig("usage_arg")

	if Item.InTimeLimitSkinAssigned(arg0_26.id) then
		return table.mergeArray(var0_26[2], var0_26[3], true)
	else
		return underscore.rest(var0_26[3], 1)
	end
end

function var0_0.IsAllSkinOwner(arg0_27)
	assert(arg0_27:getConfig("type") == var0_0.SKIN_ASSIGNED_TYPE)

	local var0_27 = getProxy(ShipSkinProxy)

	return underscore.all(arg0_27:GetValidSkinList(), function(arg0_28)
		return var0_27:hasNonLimitSkin(arg0_28)
	end)
end

function var0_0.GetOverflowCheckItems(arg0_29, arg1_29)
	arg1_29 = arg1_29 or 1

	local var0_29 = {}

	if arg0_29:getConfig("usage") == ItemUsage.DROP_TEMPLATE then
		local var1_29, var2_29, var3_29 = unpack(arg0_29:getConfig("usage_arg"))

		if var2_29 > 0 then
			table.insert(var0_29, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold,
				count = var2_29 * arg1_29
			})
		end

		if var3_29 > 0 then
			table.insert(var0_29, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResOil,
				count = var3_29 * arg1_29
			})
		end
	end

	switch(arg0_29:getConfig("type"), {
		[Item.EQUIPMENT_BOX_TYPE_5] = function()
			table.insert(var0_29, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1_29
			})
		end,
		[Item.EQUIPMENT_ASSIGNED_TYPE] = function()
			table.insert(var0_29, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1_29
			})
		end
	})
	underscore.map(var0_29, function(arg0_32)
		return Drop.New(arg0_32)
	end)

	return var0_29
end

function var0_0.IsSkinShopDiscountType(arg0_33)
	return arg0_33:getConfig("usage") == ItemUsage.SKIN_SHOP_DISCOUNT
end

function var0_0.IsExclusiveDiscountType(arg0_34)
	return arg0_34:getConfig("usage") == ItemUsage.USAGE_SHOP_DISCOUNT
end

function var0_0.IsSkinExperienceType(arg0_35)
	return arg0_35:getConfig("usage") == ItemUsage.USAGE_SKIN_EXP
end

function var0_0.CanUseForShop(arg0_36, arg1_36)
	if arg0_36:IsSkinShopDiscountType() then
		local var0_36 = arg0_36:getConfig("usage_arg")

		if not var0_36 or type(var0_36) ~= "table" then
			return false
		end

		local var1_36 = var0_36[1] or {}

		return #var1_36 == 1 and var1_36[1] == 0 or table.contains(var1_36, arg1_36)
	elseif arg0_36:IsSkinExperienceType() then
		local var2_36 = arg0_36:getConfig("usage_arg")

		if not var2_36 or type(var2_36) ~= "table" then
			return false
		end

		return (var2_36[1] or -1) == arg1_36
	elseif arg0_36:IsExclusiveDiscountType() then
		local var3_36 = arg0_36:getConfig("usage_arg")[1]

		if not var3_36 or type(var3_36) ~= "table" then
			return false
		end

		return (var3_36[1] or -1) == arg1_36
	end

	return false
end

function var0_0.GetConsumeForSkinShopDiscount(arg0_37, arg1_37)
	if arg0_37:IsSkinShopDiscountType() or arg0_37:IsExclusiveDiscountType() and arg0_37:CanUseForShop(arg1_37) then
		local var0_37 = pg.item_data_statistics[arg0_37.configId].usage_arg[2] or 0
		local var1_37 = Goods.Create({
			shop_id = arg1_37
		}, Goods.TYPE_SKIN)

		return math.max(0, var1_37:GetPrice() - var0_37), var1_37:getConfig("resource_type")
	else
		return 0
	end
end

function var0_0.getName(arg0_38)
	return arg0_38.name or arg0_38:getConfig("name")
end

function var0_0.getIcon(arg0_39)
	return arg0_39:getConfig("Icon")
end

local var1_0

function var0_0.IsLoveLetterCheckItem(arg0_40)
	if not var1_0 then
		var1_0 = {}

		for iter0_40, iter1_40 in ipairs(getGameset("loveletter_item_old_year")[2]) do
			local var0_40, var1_40 = unpack(iter1_40)

			var1_0[var0_40] = underscore.flatten({
				var1_40
			})
		end

		for iter2_40, iter3_40 in ipairs(pg.loveletter_2018_2021.all) do
			var1_0[iter3_40] = {
				pg.loveletter_2018_2021[iter3_40].year
			}
		end
	end

	return var1_0[arg0_40]
end

return var0_0
