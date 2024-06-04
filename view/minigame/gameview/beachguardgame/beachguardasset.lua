local var0 = class("BeachGuardAsset")

var0.card_asset_path = "beachguardgameassets/char_icon"
var0.cardQ_asset_path = "beachguardgameassets/char_Qicon"
var0.map_asset_path = "beachguardgameassets/map"
var0.char_asset_path = "beachguardgameassets/char"
var0.bullet_asset_path = "beachguardgameassets/bullet"
var0.effect_asset_path = "beachguardgameassets/effect"

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
end

function var0.getCardIcon(arg0)
	return GetSpriteFromAtlas(BeachGuardAsset.card_asset_path, arg0)
end

function var0.getCardQIcon(arg0)
	return GetSpriteFromAtlas(BeachGuardAsset.cardQ_asset_path, arg0)
end

function var0.getBeachMap(arg0)
	return GetSpriteFromAtlas(BeachGuardAsset.map_asset_path, arg0)
end

var0.clearName = {}

function var0.getChar(arg0)
	local var0

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.char_asset_path, arg0, false, function(arg0)
		var0 = arg0

		if not table.contains(var0.clearName, arg0) then
			table.insert(var0.clearName, arg0)
		end
	end)

	return tf(var0)
end

function var0.getBullet(arg0)
	local var0

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.bullet_asset_path, arg0, false, function(arg0)
		var0 = arg0

		if not table.contains(var0.clearName, arg0) then
			table.insert(var0.clearName, arg0)
		end

		GetOrAddComponent(var0, typeof(CanvasGroup)).blocksRaycasts = false
	end)

	return tf(var0)
end

function var0.getEffect(arg0)
	local var0

	PoolMgr.GetInstance():GetPrefab(BeachGuardAsset.effect_asset_path, arg0, false, function(arg0)
		var0 = arg0

		if not table.contains(var0.clearName, arg0) then
			table.insert(var0.clearName, arg0)
		end

		GetOrAddComponent(var0, typeof(CanvasGroup)).blocksRaycasts = false
	end)

	return tf(var0)
end

function var0.clear()
	for iter0 = 1, #var0.clearName do
		PoolMgr.GetInstance():DestroyPrefab(BeachGuardAsset.char_asset_path, var0.clearName[iter0])
	end

	var0.clearName = {}
end

return var0
