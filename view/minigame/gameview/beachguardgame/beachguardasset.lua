local var0_0 = class("BeachGuardAsset")

var0_0.card_asset_path = "beachguardgameassets/char_icon"
var0_0.cardQ_asset_path = "beachguardgameassets/char_Qicon"
var0_0.map_asset_path = "beachguardgameassets/map"
var0_0.char_asset_path = "beachguardgameassets/char"
var0_0.bullet_asset_path = "beachguardgameassets/bullet"
var0_0.effect_asset_path = "beachguardgameassets/effect"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
end

function var0_0.getCardIcon(arg0_2)
	return GetSpriteFromAtlas(BeachGuardAsset.card_asset_path, arg0_2)
end

function var0_0.getCardQIcon(arg0_3)
	return GetSpriteFromAtlas(BeachGuardAsset.cardQ_asset_path, arg0_3)
end

function var0_0.getBeachMap(arg0_4)
	return GetSpriteFromAtlas(BeachGuardAsset.map_asset_path, arg0_4)
end

var0_0.clearName = {}

function var0_0.getChar(arg0_5)
	local var0_5

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.char_asset_path, arg0_5, false, function(arg0_6)
		var0_5 = arg0_6

		if not table.contains(var0_0.clearName, arg0_5) then
			table.insert(var0_0.clearName, arg0_5)
		end
	end)

	return tf(var0_5)
end

function var0_0.getBullet(arg0_7)
	local var0_7

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.bullet_asset_path, arg0_7, false, function(arg0_8)
		var0_7 = arg0_8

		if not table.contains(var0_0.clearName, arg0_7) then
			table.insert(var0_0.clearName, arg0_7)
		end

		GetOrAddComponent(var0_7, typeof(CanvasGroup)).blocksRaycasts = false
	end)

	return tf(var0_7)
end

function var0_0.getEffect(arg0_9)
	local var0_9

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.effect_asset_path, arg0_9, false, function(arg0_10)
		var0_9 = arg0_10

		if not table.contains(var0_0.clearName, arg0_9) then
			table.insert(var0_0.clearName, arg0_9)
		end

		GetOrAddComponent(var0_9, typeof(CanvasGroup)).blocksRaycasts = false
	end)

	return tf(var0_9)
end

function var0_0.clear()
	for iter0_11 = 1, #var0_0.clearName do
		PoolMgr.GetInstance():DestroyPrefab(BeachGuardAsset.char_asset_path, var0_0.clearName[iter0_11])
	end

	var0_0.clearName = {}
end

return var0_0
