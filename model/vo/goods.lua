local var0_0 = class("Goods", import(".BaseVO"))

var0_0.TYPE_SHOPSTREET = 1
var0_0.TYPE_MILITARY = 2
var0_0.TYPE_CHARGE = 3
var0_0.TYPE_GIFT_PACKAGE = 4
var0_0.TYPE_SKIN = 6
var0_0.TYPE_ACTIVITY = 7
var0_0.TYPE_ACTIVITY_EXTRA = 8
var0_0.TYPE_GUILD = 9
var0_0.TYPE_SHAM_BATTLE = 10
var0_0.TYPE_ESCORT = 11
var0_0.TYPE_FRAGMENT = 12
var0_0.TYPE_WORLD = 13
var0_0.TYPE_FRAGMENT_NORMAL = 14
var0_0.TYPE_NEW_SERVER = 15
var0_0.TYPE_MINI_GAME = 16
var0_0.TYPE_QUOTA = 17
var0_0.TYPE_WORLD_NSHOP = 18
var0_0.GEM = 0
var0_0.GIFT_BOX = 1
var0_0.MONTH_CARD = 2
var0_0.ITEM_BOX = 3
var0_0.PASS_ITEM = 4
var0_0.EQUIP_BAG_SIZE_ITEM = 59100
var0_0.SHIP_BAG_SIZE_ITEM = 59101
var0_0.COMMANDER_BAG_SIZE_ITEM = 59114
var0_0.SPWEAPON_BAG_SIZE_ITEM = 59360
var0_0.Tec_Ship_Gift_Type = 3
var0_0.Tec_Ship_Gift_Arg = {
	High = 1,
	Up = 3,
	Show = 0,
	Normal = 2
}
var0_0.CUR_PACKET_ID = 138

function var0_0.Ctor(arg0_1)
	assert(false, "does not call this function, use Create instead")
end

local var1_0 = {
	[var0_0.TYPE_CHARGE] = function(arg0_2, arg1_2)
		return ChargeCommodity.New(arg0_2, arg1_2)
	end,
	[var0_0.TYPE_ACTIVITY] = function(arg0_3, arg1_3)
		return ActivityCommodity.New(arg0_3, arg1_3)
	end,
	[var0_0.TYPE_SHAM_BATTLE] = function(arg0_4, arg1_4)
		return ActivityCommodity.New(arg0_4, arg1_4)
	end,
	[var0_0.TYPE_FRAGMENT] = function(arg0_5, arg1_5)
		return ActivityCommodity.New(arg0_5, arg1_5)
	end,
	[var0_0.TYPE_FRAGMENT_NORMAL] = function(arg0_6, arg1_6)
		return ActivityCommodity.New(arg0_6, arg1_6)
	end,
	[var0_0.TYPE_ESCORT] = function(arg0_7, arg1_7)
		return ActivityCommodity.New(arg0_7, arg1_7)
	end,
	[var0_0.TYPE_ACTIVITY_EXTRA] = function(arg0_8, arg1_8)
		return ActivityExtraCommodity.New(arg0_8, arg1_8)
	end,
	[var0_0.TYPE_MINI_GAME] = function(arg0_9, arg1_9)
		return MiniGameGoods.New(arg0_9, arg1_9)
	end,
	[var0_0.TYPE_QUOTA] = function(arg0_10, arg1_10)
		return QuotaCommodity.New(arg0_10, arg1_10)
	end,
	[var0_0.TYPE_ESCORT] = function(arg0_11, arg1_11)
		return ActivityCommodity.New(arg0_11, arg1_11)
	end,
	[var0_0.TYPE_WORLD_NSHOP] = function(arg0_12, arg1_12)
		return WorldNShopCommodity.New(arg0_12, arg1_12)
	end
}

function var0_0.Create(arg0_13, arg1_13)
	return switch(arg1_13, var1_0, function(arg0_14, arg1_14)
		return CommonCommodity.New(arg0_14, arg1_14)
	end, arg0_13, arg1_13)
end

function var0_0.ExistFurniture(arg0_15)
	return pg.shop_furniture_relation[arg0_15] ~= nil
end

function var0_0.Id2FurnitureId(arg0_16)
	return pg.shop_furniture_relation[arg0_16].fur_id
end

function var0_0.FurnitureId2Id(arg0_17)
	local var0_17 = pg.shop_furniture_relation.get_id_list_by_fur_id[arg0_17]

	return var0_17 and var0_17[1]
end

function var0_0.GetFurnitureConfig(arg0_18)
	return pg.shop_furniture_relation[arg0_18]
end

function var0_0.Id2ShipSkinId(arg0_19)
	return pg.shop_template[arg0_19].effect_args[1]
end

return var0_0
