local var0_0 = class("ShopArgs")

var0_0.EffecetEquipBagSize = "equip_bag_size"
var0_0.EffecetShipBagSize = "ship_bag_size"
var0_0.EffectDromExpPos = "dorm_exp_pos"
var0_0.EffectDromFixPos = "dorm_fix_pos"
var0_0.EffectDromFoodMax = "dorm_food_max"
var0_0.EffectShopStreetFlash = "shop_street_flash"
var0_0.EffectShopStreetLevel = "shop_street_level"
var0_0.EffectOilFieldLevel = "oilfield_level"
var0_0.EffectTradingPortLevel = "tradingport_level"
var0_0.EffectClassLevel = "class_room_level"
var0_0.EffectGuildFlash = "guild_store_flash"
var0_0.EffectDormFloor = "dorm_floor"
var0_0.EffectSkillPos = "skill_room_pos"
var0_0.EffectCommanderBagSize = "commander_bag_size"
var0_0.EffectSpWeaponBagSize = "spweapon_bag_size"
var0_0.ShoppingStreetUpgrade = "shop_street_upgrade"
var0_0.BackyardFoodExtend = "backyard_food_extend"
var0_0.BuyOil = "buy_oil"
var0_0.ShoppingStreetLimit = "shopping_street"
var0_0.ArenaShopLimit = "arena_shop"
var0_0.GiftPackage = "gift_package"
var0_0.GenShop = "gem_shop"
var0_0.SkinShop = "skin_shop"
var0_0.ActivityShop = "activity_shop"
var0_0.guildShop = "guild_store"
var0_0.guildShopFlash = "guild_shop_flash"
var0_0.skillRoomUpgrade = "skill_room_upgrade"
var0_0.SkinShopTimeLimit = "skin_shop_timelimit"
var0_0.WorldShop = "world"
var0_0.WorldCollection = "world_collection_task"
var0_0.NewServerShop = "new_server_shop"
var0_0.ShopStreet = 1
var0_0.MilitaryShop = 2
var0_0.ShopActivity = 3
var0_0.ShopGUILD = 4
var0_0.ShopShamBattle = 5
var0_0.ShopEscort = 6
var0_0.ShopFragment = 7
var0_0.ShopMedal = 8
var0_0.ShopMiniGame = 9
var0_0.ShopQuota = 10
var0_0.DORM_FLOOR_ID = 19
var0_0.LIMIT_ARGS_META_SHIP_EXISTENCE = 1
var0_0.LIMIT_ARGS_SALE_START_TIME = 2
var0_0.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL = 3

function var0_0.getOilByLevel(arg0_1)
	return 500 + arg0_1 * 3
end

return var0_0
