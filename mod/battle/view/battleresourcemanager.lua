ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = require("Mgr/Pool/PoolUtil")
local var5_0 = singletonClass("BattleResourceManager")

var0_0.Battle.BattleResourceManager = var5_0
var5_0.__name = "BattleResourceManager"

function var5_0.Ctor(arg0_1)
	arg0_1.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})
end

function var5_0.Init(arg0_2)
	arg0_2._preloadList = {}
	arg0_2._resCacheList = {}
	arg0_2._allPool = {}
	arg0_2._ob2Pool = {}

	local var0_2 = GameObject()

	var0_2:SetActive(false)

	var0_2.name = "PoolRoot"
	var0_2.transform.position = Vector3(-10000, -10000, 0)
	arg0_2._poolRoot = var0_2
	arg0_2._bulletContainer = GameObject("BulletContainer")
	arg0_2._battleCVList = {}
end

function var5_0.Clear(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3._allPool) do
		iter1_3:Dispose()
	end

	for iter2_3, iter3_3 in pairs(arg0_3._resCacheList) do
		if string.find(iter2_3, "Char/") then
			var5_0.ClearCharRes(iter2_3, iter3_3)
		elseif string.find(iter2_3, "painting/") then
			var5_0.ClearPaintingRes(iter2_3, iter3_3)
		else
			var4_0.Destroy(iter3_3)
		end
	end

	arg0_3._resCacheList = {}
	arg0_3._ob2Pool = {}
	arg0_3._allPool = {}

	Object.Destroy(arg0_3._poolRoot)

	arg0_3._poolRoot = nil

	Object.Destroy(arg0_3._bulletContainer)

	arg0_3._bulletContainer = nil
	arg0_3.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})

	for iter4_3, iter5_3 in pairs(arg0_3._battleCVList) do
		pg.CriMgr.UnloadCVBank(iter5_3)
	end

	arg0_3._battleCVList = {}

	var0_0.Battle.BattleDataFunction.ClearConvertedBarrage()
end

function var5_0.GetBulletPath(arg0_4)
	return "Item/" .. arg0_4
end

function var5_0.GetOrbitPath(arg0_5)
	return "orbit/" .. arg0_5
end

function var5_0.GetCharacterPath(arg0_6)
	return "Char/" .. arg0_6
end

function var5_0.GetCharacterGoPath(arg0_7)
	return "chargo/" .. arg0_7
end

function var5_0.GetAircraftIconPath(arg0_8)
	return "AircraftIcon/" .. arg0_8
end

function var5_0.GetFXPath(arg0_9)
	return "Effect/" .. arg0_9
end

function var5_0.GetPaintingPath(arg0_10)
	return "painting/" .. arg0_10
end

function var5_0.GetHrzIcon(arg0_11)
	return "herohrzicon/" .. arg0_11
end

function var5_0.GetSquareIcon(arg0_12)
	return "squareicon/" .. arg0_12
end

function var5_0.GetQIcon(arg0_13)
	return "qicon/" .. arg0_13
end

function var5_0.GetCommanderHrzIconPath(arg0_14)
	return "commanderhrz/" .. arg0_14
end

function var5_0.GetCommanderIconPath(arg0_15)
	return "commandericon/" .. arg0_15
end

function var5_0.GetShipTypeIconPath(arg0_16)
	return "shiptype/" .. arg0_16
end

function var5_0.GetMapPath(arg0_17)
	return "Map/" .. arg0_17
end

function var5_0.GetUIPath(arg0_18)
	return "UI/" .. arg0_18
end

function var5_0.GetResName(arg0_19)
	local var0_19 = arg0_19
	local var1_19 = string.find(var0_19, "%/")

	while var1_19 do
		var0_19 = string.sub(var0_19, var1_19 + 1)
		var1_19 = string.find(var0_19, "%/")
	end

	return var0_19
end

function var5_0.ClearCharRes(arg0_20, arg1_20)
	local var0_20 = var5_0.GetResName(arg0_20)
	local var1_20 = arg1_20:GetComponent("SkeletonRenderer").skeletonDataAsset

	if not PoolMgr.GetInstance():IsSpineSkelCached(var0_20) then
		UIUtil.ClearSharedMaterial(arg1_20)
	end

	var4_0.Destroy(arg1_20)
end

function var5_0.ClearPaintingRes(arg0_21, arg1_21)
	local var0_21 = var5_0.GetResName(arg0_21)

	PoolMgr.GetInstance():ReturnPainting(var5_0.GetPaintingName(var0_21), arg1_21)
end

function var5_0.DestroyOb(arg0_22, arg1_22)
	local var0_22 = arg0_22._ob2Pool[arg1_22]

	if var0_22 then
		var0_22:Recycle(arg1_22)
	else
		var4_0.Destroy(arg1_22)
	end
end

function var5_0.popPool(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:GetObject()

	if not arg2_23 then
		var0_23.transform.parent = nil
	end

	arg0_23._ob2Pool[var0_23] = arg1_23

	return var0_23
end

function var5_0.InstCharacter(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.GetCharacterPath(arg1_24)
	local var1_24 = arg0_24._allPool[var0_24]

	if var1_24 then
		local var2_24 = arg0_24:popPool(var1_24)

		arg2_24(var2_24)
	elseif arg0_24._resCacheList[var0_24] ~= nil then
		arg0_24:InitPool(var0_24, arg0_24._resCacheList[var0_24])

		var1_24 = arg0_24._allPool[var0_24]

		local var3_24 = arg0_24:popPool(var1_24)

		arg2_24(var3_24)
	else
		arg0_24:LoadSpineAsset(arg1_24, function(arg0_25)
			if not arg0_24._poolRoot then
				var5_0.ClearCharRes(var0_24, arg0_25)

				return
			end

			assert(arg0_25, "角色资源加载失败：" .. arg1_24)

			local var0_25 = SpineAnim.AnimChar(arg1_24, arg0_25)

			var0_25:SetActive(false)
			arg0_24:InitPool(var0_24, var0_25)

			var1_24 = arg0_24._allPool[var0_24]

			local var1_25 = arg0_24:popPool(var1_24)

			arg2_24(var1_25)
		end)
	end
end

function var5_0.LoadSpineAsset(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.GetCharacterPath(arg1_26)

	if not PoolMgr.GetInstance():IsSpineSkelCached(arg1_26) then
		ResourceMgr.Inst:getAssetAsync(var0_26, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_27)
			arg2_26(arg0_27)
		end), true, true)
	else
		PoolMgr.GetInstance():GetSpineSkel(arg1_26, true, arg2_26)
	end
end

function var5_0.InstAirCharacter(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.GetCharacterGoPath(arg1_28)
	local var1_28 = arg0_28._allPool[var0_28]

	if var1_28 then
		local var2_28 = arg0_28:popPool(var1_28)

		arg2_28(var2_28)
	elseif arg0_28._resCacheList[var0_28] ~= nil then
		arg0_28:InitPool(var0_28, arg0_28._resCacheList[var0_28])

		var1_28 = arg0_28._allPool[var0_28]

		local var3_28 = arg0_28:popPool(var1_28)

		arg2_28(var3_28)
	else
		ResourceMgr.Inst:getAssetAsync(var0_28, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_29)
			if not arg0_28._poolRoot then
				var4_0.Destroy(arg0_29)

				return
			else
				assert(arg0_29, "飞机资源加载失败：" .. arg1_28)
				arg0_28:InitPool(var0_28, arg0_29)

				var1_28 = arg0_28._allPool[var0_28]

				local var0_29 = arg0_28:popPool(var1_28)

				arg2_28(var0_29)
			end
		end), true, true)
	end
end

function var5_0.InstBullet(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.GetBulletPath(arg1_30)
	local var1_30 = arg0_30._allPool[var0_30]

	if var1_30 then
		local var2_30 = arg0_30:popPool(var1_30, true)

		if string.find(arg1_30, "_trail") then
			local var3_30 = var2_30:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var3_30 then
				var3_30:Clear()
			end
		end

		arg2_30(var2_30)

		return true
	elseif arg0_30._resCacheList[var0_30] ~= nil then
		arg0_30:InitPool(var0_30, arg0_30._resCacheList[var0_30])

		var1_30 = arg0_30._allPool[var0_30]

		local var4_30 = arg0_30:popPool(var1_30, true)

		if string.find(arg1_30, "_trail") then
			local var5_30 = var4_30:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var5_30 then
				var5_30:Clear()
			end
		end

		arg2_30(var4_30)

		return true
	else
		ResourceMgr.Inst:getAssetAsync(var0_30, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_31)
			if not arg0_30._poolRoot then
				var4_0.Destroy(arg0_31)

				return
			else
				assert(arg0_31, "子弹资源加载失败：" .. arg1_30)
				arg0_30:InitPool(var0_30, arg0_31)

				var1_30 = arg0_30._allPool[var0_30]

				local var0_31 = arg0_30:popPool(var1_30, true)

				arg2_30(var0_31)
			end
		end), true, true)

		return false
	end
end

function var5_0.InstFX(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.GetFXPath(arg1_32)
	local var1_32
	local var2_32 = arg0_32._allPool[var0_32]

	if var2_32 then
		var1_32 = arg0_32:popPool(var2_32, arg2_32)
	elseif arg0_32._resCacheList[var0_32] ~= nil then
		arg0_32:InitPool(var0_32, arg0_32._resCacheList[var0_32])

		local var3_32 = arg0_32._allPool[var0_32]

		var1_32 = arg0_32:popPool(var3_32, arg2_32)
	else
		ResourceMgr.Inst:getAssetAsync(var0_32, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_33)
			if not arg0_32._poolRoot then
				var4_0.Destroy(arg0_33)

				return
			else
				assert(arg0_33, "特效资源加载失败：" .. arg1_32)
				arg0_32:InitPool(var0_32, arg0_33)
			end
		end), true, true)

		var1_32 = GameObject(arg1_32 .. "临时假obj")

		var1_32:SetActive(false)

		arg0_32._resCacheList[var0_32] = var1_32
	end

	local var4_32 = tf(var1_32):Find("bullet")

	if var4_32 and var4_32:GetComponent(typeof(SpineAnim)) then
		var4_32:GetComponent(typeof(SpineAnim)):SetAction("normal", 0, false)
	end

	return var1_32
end

function var5_0.InstOrbit(arg0_34, arg1_34)
	local var0_34 = arg0_34.GetOrbitPath(arg1_34)
	local var1_34
	local var2_34 = arg0_34._allPool[var0_34]

	if var2_34 then
		var1_34 = arg0_34:popPool(var2_34)
	elseif arg0_34._resCacheList[var0_34] ~= nil then
		arg0_34:InitPool(var0_34, arg0_34._resCacheList[var0_34])

		local var3_34 = arg0_34._allPool[var0_34]

		var1_34 = arg0_34:popPool(var3_34)
	else
		ResourceMgr.Inst:getAssetAsync(var0_34, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_35)
			if not arg0_34._poolRoot then
				var4_0.Destroy(arg0_35)

				return
			else
				assert(arg0_35, "特效资源加载失败：" .. arg1_34)
				arg0_34:InitPool(var0_34, arg0_35)
			end
		end), true, true)

		var1_34 = GameObject(arg1_34 .. "临时假obj")

		var1_34:SetActive(false)

		arg0_34._resCacheList[var0_34] = var1_34
	end

	return var1_34
end

function var5_0.InstSkillPaintingUI(arg0_36)
	local var0_36 = arg0_36._allPool["UI/SkillPainting"]
	local var1_36 = var0_36:GetObject()

	arg0_36._ob2Pool[var1_36] = var0_36

	return var1_36
end

function var5_0.InstBossWarningUI(arg0_37)
	local var0_37 = arg0_37._allPool["UI/MonsterAppearUI"]
	local var1_37 = var0_37:GetObject()

	arg0_37._ob2Pool[var1_37] = var0_37

	return var1_37
end

function var5_0.InstGridmanSkillUI(arg0_38)
	local var0_38 = arg0_38._allPool["UI/combatgridmanskillfloat"]
	local var1_38 = var0_38:GetObject()

	arg0_38._ob2Pool[var1_38] = var0_38

	return var1_38
end

function var5_0.InstReisalinAPUI(arg0_39)
	local var0_39 = arg0_39._allPool["UI/combatreisalinapui"]
	local var1_39 = var0_39:GetObject()

	arg0_39._ob2Pool[var1_39] = var0_39

	return var1_39
end

function var5_0.InstYumiaManaUI(arg0_40)
	local var0_40 = arg0_40._allPool["UI/combatyumiamanaui"]
	local var1_40 = var0_40:GetObject()

	arg0_40._ob2Pool[var1_40] = var0_40

	return var1_40
end

function var5_0.InstPainting(arg0_41, arg1_41)
	local var0_41 = arg0_41.GetPaintingPath(arg1_41)
	local var1_41
	local var2_41 = arg0_41._allPool[var0_41]

	if var2_41 then
		var1_41 = var2_41:GetObject()
		arg0_41._ob2Pool[var1_41] = var2_41
	elseif arg0_41._resCacheList[var0_41] ~= nil then
		var1_41 = Object.Instantiate(arg0_41._resCacheList[var0_41])

		var1_41:SetActive(true)
	end

	return var1_41
end

function var5_0.InstMap(arg0_42, arg1_42)
	local var0_42 = arg0_42.GetMapPath(arg1_42)
	local var1_42
	local var2_42 = arg0_42._allPool[var0_42]

	if var2_42 then
		var1_42 = var2_42:GetObject()
		arg0_42._ob2Pool[var1_42] = var2_42
	elseif arg0_42._resCacheList[var0_42] ~= nil then
		var1_42 = Object.Instantiate(arg0_42._resCacheList[var0_42])
	else
		assert(false, "地图资源没有预加载：" .. arg1_42)
	end

	var1_42:SetActive(true)

	return var1_42
end

function var5_0.InstCardPuzzleCard(arg0_43)
	local var0_43 = arg0_43._allPool["UI/CardTowerCardCombat"]
	local var1_43 = var0_43:GetObject()

	arg0_43._ob2Pool[var1_43] = var0_43

	return var1_43
end

function var5_0.GetCharacterIcon(arg0_44, arg1_44)
	return arg0_44._resCacheList[var5_0.GetHrzIcon(arg1_44)]
end

function var5_0.GetCharacterSquareIcon(arg0_45, arg1_45)
	return arg0_45._resCacheList[var5_0.GetSquareIcon(arg1_45)]
end

function var5_0.GetCharacterQIcon(arg0_46, arg1_46)
	return arg0_46._resCacheList[var5_0.GetQIcon(arg1_46)]
end

function var5_0.GetAircraftIcon(arg0_47, arg1_47)
	return arg0_47._resCacheList[var5_0.GetAircraftIconPath(arg1_47)]
end

function var5_0.GetShipTypeIcon(arg0_48, arg1_48)
	return arg0_48._resCacheList[var5_0.GetShipTypeIconPath(arg1_48)]
end

function var5_0.GetCommanderHrzIcon(arg0_49, arg1_49)
	return arg0_49._resCacheList[var5_0.GetCommanderHrzIconPath(arg1_49)]
end

function var5_0.GetCommanderIcon(arg0_50, arg1_50)
	return arg0_50._resCacheList[var5_0.GetCommanderIconPath(arg1_50)]
end

function var5_0.GetShader(arg0_51, arg1_51)
	return (pg.ShaderMgr.GetInstance():GetShader(var3_0.BATTLE_SHADER[arg1_51]))
end

function var5_0.AddPreloadResource(arg0_52, arg1_52)
	if type(arg1_52) == "string" then
		arg0_52._preloadList[arg1_52] = false
	elseif type(arg1_52) == "table" then
		for iter0_52, iter1_52 in ipairs(arg1_52) do
			arg0_52._preloadList[iter1_52] = false
		end
	end
end

function var5_0.AddPreloadCV(arg0_53, arg1_53)
	local var0_53 = Ship.getCVKeyID(arg1_53)

	if var0_53 > 0 then
		arg0_53._battleCVList[var0_53] = pg.CriMgr.GetBattleCVBankName(var0_53)
	end
end

function var5_0.StartPreload(arg0_54, arg1_54, arg2_54)
	local var0_54 = 0
	local var1_54 = 0

	for iter0_54, iter1_54 in pairs(arg0_54._preloadList) do
		var1_54 = var1_54 + 1
	end

	for iter2_54, iter3_54 in pairs(arg0_54._battleCVList) do
		var1_54 = var1_54 + 1
	end

	local function var2_54()
		if not arg0_54._poolRoot then
			return
		end

		var0_54 = var0_54 + 1

		if var0_54 > var1_54 then
			return
		end

		if arg2_54 then
			arg2_54(var0_54)
		end

		if var0_54 == var1_54 then
			arg0_54._preloadList = nil

			arg1_54()
		end
	end

	for iter4_54, iter5_54 in pairs(arg0_54._battleCVList) do
		pg.CriMgr.GetInstance():LoadBattleCV(iter4_54, var2_54)
	end

	for iter6_54, iter7_54 in pairs(arg0_54._preloadList) do
		local var3_54 = arg0_54.GetResName(iter6_54)

		if var3_54 == "" or arg0_54._resCacheList[iter6_54] ~= nil then
			var2_54()
		elseif string.find(iter6_54, "herohrzicon/") or string.find(iter6_54, "qicon/") or string.find(iter6_54, "squareicon/") or string.find(iter6_54, "commanderhrz/") or string.find(iter6_54, "commandericon/") or string.find(iter6_54, "AircraftIcon/") then
			local var4_54, var5_54 = HXSet.autoHxShiftPath(iter6_54, var3_54)

			ResourceMgr.Inst:getAssetAsync(var4_54, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_56)
				if arg0_56 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					if not arg0_54._poolRoot then
						var4_0.Destroy(arg0_56)

						return
					end

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_56
					end
				end

				var2_54()
			end), true, true)
		elseif string.find(iter6_54, "shiptype/") then
			local var6_54 = string.split(iter6_54, "/")[2]

			GetSpriteFromAtlasAsync("shiptype", var6_54, function(arg0_57)
				if arg0_57 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					if not arg0_54._poolRoot then
						var4_0.Destroy(arg0_57)

						return
					end

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_57
					end
				end

				var2_54()
			end)
		elseif string.find(iter6_54, "painting/") then
			PoolMgr.GetInstance():GetPainting(var5_0.GetPaintingName(var3_54), true, function(arg0_58)
				if arg0_58 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					if not arg0_54._poolRoot then
						var5_0.ClearPaintingRes(iter6_54, arg0_58)

						return
					end

					ShipExpressionHelper.SetExpression(arg0_58, var3_54)
					arg0_58:SetActive(false)

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_58
					end
				end

				var2_54()
			end)
		elseif string.find(iter6_54, "Char/") then
			arg0_54:LoadSpineAsset(var3_54, function(arg0_59)
				if arg0_59 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					arg0_59 = SpineAnim.AnimChar(var3_54, arg0_59)

					if not arg0_54._poolRoot then
						var5_0.ClearCharRes(iter6_54, arg0_59)

						return
					end

					arg0_59:SetActive(false)

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_59
					end
				end

				arg0_54:InitPool(iter6_54, arg0_59)
				var2_54()
			end)
		elseif string.find(iter6_54, "UI/") then
			LoadAndInstantiateAsync("UI", var3_54, function(arg0_60)
				if arg0_60 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					if not arg0_54._poolRoot then
						var4_0.Destroy(arg0_60)

						return
					end

					arg0_60:SetActive(false)

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_60
					end
				end

				arg0_54:InitPool(iter6_54, arg0_60)
				var2_54()
			end, true, true)
		else
			ResourceMgr.Inst:getAssetAsync(iter6_54, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_61)
				if arg0_61 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_54 .. "<<")
				else
					if not arg0_54._poolRoot then
						var4_0.Destroy(arg0_61)

						return
					end

					if arg0_54._resCacheList then
						arg0_54._resCacheList[iter6_54] = arg0_61
					end
				end

				arg0_54:InitPool(iter6_54, arg0_61)
				var2_54()
			end), true, true)
		end
	end

	return var1_54
end

function var5_0.GetPaintingName(arg0_62)
	local var0_62 = false

	if PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) > 0 then
		var0_62 = checkABExist("painting/" .. arg0_62 .. "_n")
	else
		var0_62 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_62, 0) ~= 0 and checkABExist("painting/" .. arg0_62 .. "_n")
	end

	return arg0_62 .. (var0_62 and "_n" or "")
end

local var6_0 = Vector3(0, 10000, 0)

function var5_0.HideBullet(arg0_63)
	arg0_63.transform.position = var6_0
end

function var5_0.InitParticleSystemCB(arg0_64)
	pg.EffectMgr.GetInstance():CommonEffectEvent(arg0_64)
end

function var5_0.InitPool(arg0_65, arg1_65, arg2_65)
	local var0_65 = arg0_65._poolRoot.transform

	if string.find(arg1_65, "Item/") then
		if arg2_65:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or arg2_65:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			arg0_65._allPool[arg1_65] = pg.Pool.New(arg0_65._bulletContainer.transform, arg2_65, 15, 20, true, false):InitSize()
		else
			local var1_65 = pg.Pool.New(arg0_65._bulletContainer.transform, arg2_65, 20, 20, true, true)

			var1_65:SetRecycleFuncs(var5_0.HideBullet)
			var1_65:InitSize()

			arg0_65._allPool[arg1_65] = var1_65
		end
	elseif string.find(arg1_65, "Effect/") then
		if arg2_65:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			local var2_65 = 5

			if string.find(arg1_65, "smoke") and not string.find(arg1_65, "smokeboom") then
				var2_65 = 30
			elseif string.find(arg1_65, "feijiyingzi") then
				var2_65 = 1
			end

			local var3_65 = pg.Pool.New(var0_65, arg2_65, var2_65, 20, false, false)

			var3_65:SetInitFuncs(var5_0.InitParticleSystemCB)
			var3_65:InitSize()

			arg0_65._allPool[arg1_65] = var3_65
		else
			local var4_65 = 8

			if string.find(arg1_65, "AntiAirArea") or string.find(arg1_65, "AntiSubArea") then
				var4_65 = 1
			end

			GetOrAddComponent(arg2_65, typeof(ParticleSystemEvent))

			local var5_65 = pg.Pool.New(var0_65, arg2_65, var4_65, 20, false, false)

			var5_65:InitSize()

			arg0_65._allPool[arg1_65] = var5_65
		end
	elseif string.find(arg1_65, "Char/") then
		local var6_65 = 1

		if string.find(arg1_65, "danchuan") then
			var6_65 = 3
		end

		local var7_65 = pg.Pool.New(var0_65, arg2_65, var6_65, 20, false, false):InitSize()

		var7_65:SetRecycleFuncs(var5_0.ResetSpineAction)

		arg0_65._allPool[arg1_65] = var7_65
	elseif string.find(arg1_65, "chargo/") then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 3, 20, false, false):InitSize()
	elseif string.find(arg1_65, "orbit/") then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 2, 20, false, false):InitSize()
	elseif arg1_65 == "UI/SkillPainting" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 1, 20, false, false):InitSize()
	elseif arg1_65 == "UI/MonsterAppearUI" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 1, 20, false, false):InitSize()
	elseif arg1_65 == "UI/CardTowerCardCombat" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 7, 20, false, false):InitSize()
	elseif arg1_65 == "UI/combatgridmanskillfloat" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 1, 20, false, false):InitSize()
	elseif arg1_65 == "UI/combatreisalinapui" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 1, 20, false, false):InitSize()
	elseif arg1_65 == "UI/combatyumiamanaui" then
		arg0_65._allPool[arg1_65] = pg.Pool.New(var0_65, arg2_65, 1, 20, false, false):InitSize()
	elseif arg1_65 == "UI/CombatHPBar" .. var0_0.Battle.BattleState.GetCombatSkinKey() then
		var0_0.Battle.BattleHPBarManager.GetInstance():Init(arg2_65, var0_65)
	elseif string.find(arg1_65, "UI/CombatHPPop") then
		var0_0.Battle.BattlePopNumManager.GetInstance():Init(arg2_65, var0_65)
	end
end

function var5_0.GetRotateScript(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg0_66.rotateScriptMap

	if var0_66[arg1_66] then
		return var0_66[arg1_66]
	end

	local var1_66 = GetOrAddComponent(arg1_66, "BulletRotation")

	var0_66[arg1_66] = var1_66

	return var1_66
end

function var5_0.GetCommonResource()
	return {
		var5_0.GetMapPath("visionLine"),
		var5_0.GetMapPath("exposeLine"),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleBossCharacterFactory.BOMB_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleAircraftCharacterFactory.BOMB_FX_NAME),
		var5_0.GetFXPath("AlertArea"),
		var5_0.GetFXPath("TorAlert"),
		var5_0.GetFXPath("SquareAlert"),
		var5_0.GetFXPath("AntiAirArea"),
		var5_0.GetFXPath("AntiSubArea"),
		var5_0.GetFXPath("AimBiasArea"),
		var5_0.GetFXPath("shock"),
		var5_0.GetFXPath("qianting_chushui"),
		var5_0.GetFXPath(var3_0.PLAYER_SUB_BUBBLE_FX),
		var5_0.GetFXPath("weaponrange"),
		var5_0.GetUIPath("SkillPainting"),
		var5_0.GetUIPath("MonsterAppearUI"),
		var5_0.GetUIPath("combatreisalinapui"),
		var5_0.GetUIPath("combatyumiamanaui"),
		var5_0.GetUIPath("CombatHPBar" .. var0_0.Battle.BattleState.GetCombatSkinKey()),
		var5_0.GetUIPath("CombatHPPop" .. var0_0.Battle.BattleState.GetCombatSkinKey())
	}
end

function var5_0.GetDisplayCommonResource()
	return {
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.DANCHUAN_MOVE_WAVE_FX_NAME)
	}
end

function var5_0.GetMapResource(arg0_69)
	local var0_69 = {}
	local var1_69 = var0_0.Battle.BattleMap

	for iter0_69, iter1_69 in ipairs(var1_69.LAYERS) do
		local var2_69 = var1_69.GetMapResNames(arg0_69, iter1_69)

		for iter2_69, iter3_69 in ipairs(var2_69) do
			var0_69[#var0_69 + 1] = var5_0.GetMapPath(iter3_69)
		end
	end

	return var0_69
end

function var5_0.GetBuffResource()
	local var0_70 = {}
	local var1_70 = require("buffFXPreloadList")

	for iter0_70, iter1_70 in ipairs(var1_70) do
		var0_70[#var0_70 + 1] = var5_0.GetFXPath(iter1_70)
	end

	return var0_70
end

function var5_0.GetShipResource(arg0_71, arg1_71, arg2_71)
	local var0_71 = {}
	local var1_71 = var1_0.GetPlayerShipTmpDataFromID(arg0_71)

	if arg1_71 == nil or arg1_71 == 0 then
		arg1_71 = var1_71.skin_id
	end

	local var2_71 = var1_0.GetPlayerShipSkinDataFromID(arg1_71)

	var0_71[#var0_71 + 1] = var5_0.GetCharacterPath(var2_71.prefab)
	var0_71[#var0_71 + 1] = var5_0.GetHrzIcon(var2_71.painting)
	var0_71[#var0_71 + 1] = var5_0.GetQIcon(var2_71.painting)
	var0_71[#var0_71 + 1] = var5_0.GetSquareIcon(var2_71.painting)

	if arg2_71 and var1_0.GetShipTypeTmp(var1_71.type).team_type == TeamType.Main then
		var0_71[#var0_71 + 1] = var5_0.GetPaintingPath(var2_71.painting)
	end

	return var0_71
end

function var5_0.GetEnemyResource(arg0_72)
	local var0_72 = {}
	local var1_72 = arg0_72.monsterTemplateID
	local var2_72 = arg0_72.bossData ~= nil
	local var3_72 = arg0_72.buffList or {}
	local var4_72 = arg0_72.phase or {}
	local var5_72 = var1_0.GetMonsterTmpDataFromID(var1_72)

	var0_72[#var0_72 + 1] = var5_0.GetCharacterPath(var5_72.prefab)
	var0_72[#var0_72 + 1] = var5_0.GetFXPath(var5_72.wave_fx)

	if var5_72.fog_fx then
		var0_72[#var0_72 + 1] = var5_0.GetFXPath(var5_72.fog_fx)
	end

	for iter0_72, iter1_72 in ipairs(var5_72.appear_fx) do
		var0_72[#var0_72 + 1] = var5_0.GetFXPath(iter1_72)
	end

	for iter2_72, iter3_72 in ipairs(var5_72.smoke) do
		local var6_72 = iter3_72[2]

		for iter4_72, iter5_72 in ipairs(var6_72) do
			var0_72[#var0_72 + 1] = var5_0.GetFXPath(iter5_72[1])
		end
	end

	if arg0_72.deadFX then
		var0_72[#var0_72 + 1] = var5_0.GetFXPath(arg0_72.deadFX)
	end

	if type(var5_72.bubble_fx) == "table" then
		var0_72[#var0_72 + 1] = var5_0.GetFXPath(var5_72.bubble_fx[1])
	end

	local function var7_72(arg0_73)
		local var0_73 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg0_73, 1)

		for iter0_73, iter1_73 in pairs(var0_73.effect_list) do
			local var1_73 = iter1_73.arg_list.skill_id

			if var1_73 then
				local var2_73 = var0_0.Battle.BattleDataFunction.GetSkillTemplate(var1_73).painting

				if var2_73 == 1 then
					var0_72[#var0_72 + 1] = var5_0.GetHrzIcon(var5_72.icon)
					var0_72[#var0_72 + 1] = var5_0.GetSquareIcon(var5_72.icon)
				elseif type(var2_73) == "string" then
					var0_72[#var0_72 + 1] = var5_0.GetHrzIcon(var2_73)
					var0_72[#var0_72 + 1] = var5_0.GetSquareIcon(var2_73)
				end
			end

			local var3_73 = iter1_73.arg_list.buff_id

			if var3_73 then
				var7_72(var3_73)
			end
		end
	end

	for iter6_72, iter7_72 in ipairs(var3_72) do
		var7_72(iter7_72)
	end

	for iter8_72, iter9_72 in ipairs(var4_72) do
		if iter9_72.addBuff then
			for iter10_72, iter11_72 in ipairs(iter9_72.addBuff) do
				var7_72(iter11_72)
			end
		end
	end

	if var2_72 then
		var0_72[#var0_72 + 1] = var5_0.GetSquareIcon(var5_72.icon)
	end

	return var0_72
end

function var5_0.GetWeaponResource(arg0_74, arg1_74)
	local var0_74 = {}

	if arg0_74 == -1 then
		return var0_74
	end

	local var1_74 = var1_0.GetWeaponPropertyDataFromID(arg0_74)

	if var1_74.type == var2_0.EquipmentType.MAIN_CANNON or var1_74.type == var2_0.EquipmentType.SUB_CANNON or var1_74.type == var2_0.EquipmentType.TORPEDO or var1_74.type == var2_0.EquipmentType.ANTI_AIR or var1_74.type == var2_0.EquipmentType.ANTI_SEA or var1_74.type == var2_0.EquipmentType.POINT_HIT_AND_LOCK or var1_74.type == var2_0.EquipmentType.MANUAL_METEOR or var1_74.type == var2_0.EquipmentType.BOMBER_PRE_CAST_ALERT or var1_74.type == var2_0.EquipmentType.DEPTH_CHARGE or var1_74.type == var2_0.EquipmentType.MANUAL_TORPEDO or var1_74.type == var2_0.EquipmentType.DISPOSABLE_TORPEDO or var1_74.type == var2_0.EquipmentType.MANUAL_AAMISSILE or var1_74.type == var2_0.EquipmentType.BEAM or var1_74.type == var2_0.EquipmentType.SPACE_LASER or var1_74.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR or var1_74.type == var2_0.EquipmentType.MANUAL_MISSILE or var1_74.type == var2_0.EquipmentType.AUTO_MISSILE or var1_74.type == var2_0.EquipmentType.MISSILE then
		for iter0_74, iter1_74 in ipairs(var1_74.bullet_ID) do
			local var2_74 = var5_0.GetBulletResource(iter1_74, arg1_74)

			for iter2_74, iter3_74 in ipairs(var2_74) do
				var0_74[#var0_74 + 1] = iter3_74
			end
		end
	elseif var1_74.type == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or var1_74.type == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		var0_74 = var5_0.GetAircraftResource(arg0_74, nil, arg1_74)
	elseif var1_74.type == var2_0.EquipmentType.PREVIEW_ARICRAFT then
		for iter4_74, iter5_74 in ipairs(var1_74.bullet_ID) do
			var0_74 = var5_0.GetAircraftResource(iter5_74, nil, arg1_74)
		end
	end

	if var1_74.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR then
		local var3_74 = var5_0.GetBulletResource(var3_0.AntiAirConfig.RangeBulletID)

		for iter6_74, iter7_74 in ipairs(var3_74) do
			var0_74[#var0_74 + 1] = iter7_74
		end
	end

	local var4_74

	if arg1_74 and arg1_74 ~= 0 then
		var4_74 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_74)
	end

	if var4_74 and var4_74.fire_fx_name ~= "" then
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(var4_74.fire_fx_name)
	else
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(var1_74.fire_fx)
	end

	if var1_74.precast_param.fx then
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(var1_74.precast_param.fx)
	end

	if var4_74 then
		local var5_74 = var4_74.orbit_combat

		if var5_74 ~= "" then
			var0_74[#var0_74 + 1] = var5_0.GetOrbitPath(var5_74)
		end
	end

	return var0_74
end

function var5_0.GetEquipResource(arg0_75, arg1_75, arg2_75)
	local var0_75 = {}

	if arg1_75 ~= 0 then
		local var1_75 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_75)
		local var2_75 = var1_75.ship_skin_id

		if var2_75 ~= 0 then
			local var3_75 = var0_0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(var2_75)

			var0_75[#var0_75 + 1] = var5_0.GetCharacterPath(var3_75.prefab)
		end

		local var4_75 = var1_75.orbit_combat

		if var4_75 ~= "" then
			var0_75[#var0_75 + 1] = var5_0.GetOrbitPath(var4_75)
		end
	end

	local var5_75 = var0_0.Battle.BattleDataFunction.GetWeaponDataFromID(arg0_75)
	local var6_75 = var5_75.weapon_id

	for iter0_75, iter1_75 in ipairs(var6_75) do
		local var7_75 = var5_0.GetWeaponResource(iter1_75)

		for iter2_75, iter3_75 in ipairs(var7_75) do
			var0_75[#var0_75 + 1] = iter3_75
		end
	end

	local var8_75 = var5_75.skill_id

	for iter4_75, iter5_75 in ipairs(var8_75) do
		local var9_75 = arg2_75 and var0_0.Battle.BattleDataFunction.SkillTranform(arg2_75, iter5_75[1]) or iter5_75[1]
		local var10_75 = iter5_75[2] or 1
		local var11_75 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var9_75, var10_75, {})

		for iter6_75, iter7_75 in ipairs(var11_75) do
			var0_75[#var0_75 + 1] = iter7_75
		end
	end

	return var0_75
end

function var5_0.GetBulletResource(arg0_76, arg1_76)
	local var0_76 = {}
	local var1_76

	if arg1_76 ~= nil and arg1_76 ~= 0 then
		var1_76 = var1_0.GetEquipSkinDataFromID(arg1_76)
	end

	local var2_76 = var1_0.GetBulletTmpDataFromID(arg0_76)
	local var3_76

	if var1_76 then
		var3_76 = var1_76.bullet_name

		if var1_76.mirror == 1 then
			var0_76[#var0_76 + 1] = var5_0.GetBulletPath(var3_76 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		var3_76 = var2_76.modle_ID
	end

	if var2_76.type == var2_0.BulletType.BEAM or var2_76.type == var2_0.BulletType.SPACE_LASER or var2_76.type == var2_0.BulletType.MISSILE or var2_76.type == var2_0.BulletType.ELECTRIC_ARC then
		var0_76[#var0_76 + 1] = var5_0.GetFXPath(var2_76.modle_ID)
	else
		var0_76[#var0_76 + 1] = var5_0.GetBulletPath(var3_76)
	end

	if var2_76.extra_param.mirror then
		var0_76[#var0_76 + 1] = var5_0.GetBulletPath(var3_76 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
	end

	local var4_76

	if var1_76 and var1_76.hit_fx_name ~= "" then
		var4_76 = var1_76.hit_fx_name
	else
		var4_76 = var2_76.hit_fx
	end

	var0_76[#var0_76 + 1] = var5_0.GetFXPath(var4_76)
	var0_76[#var0_76 + 1] = var5_0.GetFXPath(var2_76.miss_fx)
	var0_76[#var0_76 + 1] = var5_0.GetFXPath(var2_76.alert_fx)

	if var2_76.extra_param.area_FX then
		var0_76[#var0_76 + 1] = var5_0.GetFXPath(var2_76.extra_param.area_FX)
	end

	if var2_76.extra_param.shrapnel then
		for iter0_76, iter1_76 in ipairs(var2_76.extra_param.shrapnel) do
			local var5_76 = var5_0.GetBulletResource(iter1_76.bullet_ID)

			for iter2_76, iter3_76 in ipairs(var5_76) do
				var0_76[#var0_76 + 1] = iter3_76
			end
		end
	end

	for iter4_76, iter5_76 in ipairs(var2_76.attach_buff) do
		if iter5_76.effect_id then
			var0_76[#var0_76 + 1] = var5_0.GetFXPath(iter5_76.effect_id)
		end

		if iter5_76.buff_id then
			local var6_76 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_76.buff_id, 1, {})

			for iter6_76, iter7_76 in ipairs(var6_76) do
				var0_76[#var0_76 + 1] = iter7_76
			end
		end
	end

	return var0_76
end

function var5_0.GetAircraftResource(arg0_77, arg1_77, arg2_77, arg3_77)
	local var0_77 = {}

	arg2_77 = arg2_77 or 0

	local var1_77 = var1_0.GetAircraftTmpDataFromID(arg0_77)
	local var2_77
	local var3_77
	local var4_77
	local var5_77

	if arg2_77 ~= 0 then
		local var6_77, var7_77, var8_77

		var2_77, var6_77, var7_77, var8_77 = var1_0.GetEquipSkin(arg2_77)

		if var6_77 ~= "" then
			var0_77[#var0_77 + 1] = var5_0.GetBulletPath(var6_77)
		end

		if var7_77 ~= "" then
			var0_77[#var0_77 + 1] = var5_0.GetBulletPath(var7_77)
		end

		if var8_77 ~= "" then
			var0_77[#var0_77 + 1] = var5_0.GetBulletPath(var8_77)
		end
	else
		var2_77 = var1_77.model_ID
	end

	var0_77[#var0_77 + 1] = var5_0.GetCharacterGoPath(var2_77)

	if arg3_77 then
		var0_77[#var0_77 + 1] = var5_0.GetAircraftIconPath(var1_77.model_ID)
	end

	local var9_77 = arg1_77 or var1_77.weapon_ID

	if type(var9_77) == "table" then
		for iter0_77, iter1_77 in ipairs(var9_77) do
			local var10_77 = var5_0.GetWeaponResource(iter1_77)

			for iter2_77, iter3_77 in ipairs(var10_77) do
				var0_77[#var0_77 + 1] = iter3_77
			end
		end
	else
		local var11_77 = var5_0.GetWeaponResource(var9_77)

		for iter4_77, iter5_77 in ipairs(var11_77) do
			var0_77[#var0_77 + 1] = iter5_77
		end
	end

	return var0_77
end

function var5_0.GetCommanderResource(arg0_78)
	local var0_78 = {}
	local var1_78 = arg0_78[1]

	var0_78[#var0_78 + 1] = var5_0.GetCommanderHrzIconPath(var1_78:getPainting())
	var0_78[#var0_78 + 1] = var5_0.GetCommanderIconPath(var1_78:getPainting())

	local var2_78 = var1_78:getSkills()[1]:getLevel()

	for iter0_78, iter1_78 in ipairs(arg0_78[2]) do
		local var3_78 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_78, var2_78, {})

		for iter2_78, iter3_78 in ipairs(var3_78) do
			var0_78[#var0_78 + 1] = iter3_78
		end
	end

	return var0_78
end

function var5_0.GetStageResource(arg0_79)
	local var0_79 = var0_0.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0_79)
	local var1_79 = {}
	local var2_79 = {}

	for iter0_79, iter1_79 in ipairs(var0_79.stages) do
		if iter1_79.stageBuff then
			for iter2_79, iter3_79 in ipairs(iter1_79.stageBuff) do
				local var3_79 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter3_79.id, iter3_79.level, {})

				for iter4_79, iter5_79 in ipairs(var3_79) do
					var1_79[#var1_79 + 1] = iter5_79
				end
			end
		end

		for iter6_79, iter7_79 in ipairs(iter1_79.waves) do
			if iter7_79.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter8_79, iter9_79 in ipairs(iter7_79.spawn) do
					local var4_79 = var5_0.GetMonsterRes(iter9_79)

					for iter10_79, iter11_79 in ipairs(var4_79) do
						table.insert(var1_79, iter11_79)
					end
				end

				if iter7_79.reinforcement then
					for iter12_79, iter13_79 in ipairs(iter7_79.reinforcement) do
						local var5_79 = var5_0.GetMonsterRes(iter13_79)

						for iter14_79, iter15_79 in ipairs(var5_79) do
							table.insert(var1_79, iter15_79)
						end
					end
				end
			elseif iter7_79.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.AID then
				local var6_79 = iter7_79.triggerParams.vanguard_unitList
				local var7_79 = iter7_79.triggerParams.main_unitList
				local var8_79 = iter7_79.triggerParams.sub_unitList

				local function var9_79(arg0_80)
					local var0_80 = var5_0.GetAidUnitsRes(arg0_80)

					for iter0_80, iter1_80 in ipairs(var0_80) do
						table.insert(var1_79, iter1_80)
					end

					for iter2_80, iter3_80 in ipairs(arg0_80) do
						var2_79[#var2_79 + 1] = iter3_80.skinId
					end
				end

				if var6_79 then
					var9_79(var6_79)
				end

				if var7_79 then
					var9_79(var7_79)
				end

				if var8_79 then
					var9_79(var8_79)
				end
			elseif iter7_79.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for iter16_79, iter17_79 in ipairs(iter7_79.spawn) do
					var5_0.GetEnvironmentRes(var1_79, iter17_79)
				end
			elseif iter7_79.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.CARD_PUZZLE then
				local var10_79 = var0_0.Battle.BattleDataFunction.GetCardRes(iter7_79.triggerParams.card_id)

				for iter18_79, iter19_79 in ipairs(var10_79) do
					table.insert(var1_79, iter19_79)
				end
			end

			if iter7_79.airFighter ~= nil then
				for iter20_79, iter21_79 in pairs(iter7_79.airFighter) do
					local var11_79 = var5_0.GetAircraftResource(iter21_79.templateID, iter21_79.weaponID, nil, true)

					for iter22_79, iter23_79 in ipairs(var11_79) do
						var1_79[#var1_79 + 1] = iter23_79
					end
				end
			end
		end
	end

	return var1_79, var2_79
end

function var5_0.GetEnvironmentRes(arg0_81, arg1_81)
	table.insert(arg0_81, arg1_81.prefab and var5_0.GetFXPath(arg1_81.prefab))

	local var0_81 = arg1_81.behaviours
	local var1_81 = var0_0.Battle.BattleDataFunction.GetEnvironmentBehaviour(var0_81).behaviour_list

	for iter0_81, iter1_81 in ipairs(var1_81) do
		local var2_81 = iter1_81.type

		if var2_81 == var0_0.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			local var3_81 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_81.buff_id, 1, {})

			for iter2_81, iter3_81 in ipairs(var3_81) do
				arg0_81[#arg0_81 + 1] = iter3_81
			end
		elseif var2_81 == var0_0.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			local var4_81 = iter1_81.content and iter1_81.content.alert and iter1_81.content.alert.alert_fx

			table.insert(arg0_81, var4_81 and var5_0.GetFXPath(var4_81))

			local var5_81 = iter1_81.content and iter1_81.content.child_prefab

			if var5_81 then
				var5_0.GetEnvironmentRes(arg0_81, var5_81)
			end
		elseif var2_81 == var0_0.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			arg0_81[#arg0_81 + 1] = var5_0.GetFXPath(iter1_81.FX_ID)
		end
	end
end

function var5_0.GetMonsterRes(arg0_82)
	local var0_82 = {}
	local var1_82 = var5_0.GetEnemyResource(arg0_82)

	for iter0_82, iter1_82 in ipairs(var1_82) do
		var0_82[#var0_82 + 1] = iter1_82
	end

	local var2_82 = var0_0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0_82.monsterTemplateID)
	local var3_82 = Clone(var2_82.equipment_list)
	local var4_82 = var2_82.buff_list
	local var5_82 = Clone(arg0_82.buffList) or {}

	if arg0_82.phase then
		for iter2_82, iter3_82 in ipairs(arg0_82.phase) do
			if iter3_82.addWeapon then
				for iter4_82, iter5_82 in ipairs(iter3_82.addWeapon) do
					var3_82[#var3_82 + 1] = iter5_82
				end
			end

			if iter3_82.addRandomWeapon then
				for iter6_82, iter7_82 in ipairs(iter3_82.addRandomWeapon) do
					for iter8_82, iter9_82 in ipairs(iter7_82) do
						var3_82[#var3_82 + 1] = iter9_82
					end
				end
			end

			if iter3_82.addBuff then
				for iter10_82, iter11_82 in ipairs(iter3_82.addBuff) do
					var5_82[#var5_82 + 1] = iter11_82
				end
			end
		end
	end

	for iter12_82, iter13_82 in ipairs(var4_82) do
		local var6_82 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter13_82.ID, iter13_82.LV, {})

		for iter14_82, iter15_82 in ipairs(var6_82) do
			var0_82[#var0_82 + 1] = iter15_82
		end
	end

	for iter16_82, iter17_82 in ipairs(var5_82) do
		local var7_82 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter17_82, 1, {})

		for iter18_82, iter19_82 in ipairs(var7_82) do
			var0_82[#var0_82 + 1] = iter19_82
		end

		local var8_82 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(iter17_82, 1)

		for iter20_82, iter21_82 in pairs(var8_82.effect_list) do
			local var9_82 = iter21_82.arg_list.skill_id

			if var9_82 and var0_0.Battle.BattleDataFunction.NeedSkillPainting(var9_82) then
				var0_82[#var0_82 + 1] = var5_0.GetPaintingPath(var1_0.GetMonsterTmpDataFromID(arg0_82.monsterTemplateID).icon)

				break
			end
		end
	end

	for iter22_82, iter23_82 in ipairs(var3_82) do
		local var10_82 = var5_0.GetWeaponResource(iter23_82)

		for iter24_82, iter25_82 in ipairs(var10_82) do
			var0_82[#var0_82 + 1] = iter25_82
		end
	end

	return var0_82
end

function var5_0.GetEquipSkinPreviewRes(arg0_83)
	local var0_83 = {}
	local var1_83 = var1_0.GetEquipSkinDataFromID(arg0_83)

	for iter0_83, iter1_83 in ipairs(var1_83.weapon_ids) do
		local var2_83 = var5_0.GetWeaponResource(iter1_83)

		for iter2_83, iter3_83 in ipairs(var2_83) do
			var0_83[#var0_83 + 1] = iter3_83
		end
	end

	local function var3_83(arg0_84)
		if arg0_84 ~= "" then
			var0_83[#var0_83 + 1] = var5_0.GetBulletPath(arg0_84)
		end
	end

	local var4_83, var5_83, var6_83, var7_83, var8_83, var9_83 = var1_0.GetEquipSkin(arg0_83)

	if _.any(EquipType.AirProtoEquipTypes, function(arg0_85)
		return table.contains(var1_83.equip_type, arg0_85)
	end) then
		var0_83[#var0_83 + 1] = var5_0.GetCharacterGoPath(var4_83)
	else
		var0_83[#var0_83 + 1] = var5_0.GetBulletPath(var4_83)
	end

	var3_83(var5_83)
	var3_83(var6_83)
	var3_83(var7_83)

	if var8_83 and var8_83 ~= "" then
		var0_83[#var0_83 + 1] = var5_0.GetFXPath(var8_83)
	end

	if var9_83 and var9_83 ~= "" then
		var0_83[#var0_83 + 1] = var5_0.GetFXPath(var9_83)
	end

	return var0_83
end

function var5_0.GetEquipSkinBulletRes(arg0_86)
	local var0_86 = {}
	local var1_86, var2_86, var3_86, var4_86 = var1_0.GetEquipSkin(arg0_86)

	local function var5_86(arg0_87)
		if arg0_87 ~= "" then
			var0_86[#var0_86 + 1] = var5_0.GetBulletPath(arg0_87)
		end
	end

	local var6_86 = var1_0.GetEquipSkinDataFromID(arg0_86)
	local var7_86 = false

	for iter0_86, iter1_86 in ipairs(var6_86.equip_type) do
		if table.contains(EquipType.AircraftSkinType, iter1_86) then
			var7_86 = true
		end
	end

	if var7_86 then
		if var1_86 ~= "" then
			var0_86[#var0_86 + 1] = var5_0.GetCharacterGoPath(var1_86)
		end
	else
		var5_86(var1_86)

		if var1_0.GetEquipSkinDataFromID(arg0_86).mirror == 1 then
			var0_86[#var0_86 + 1] = var5_0.GetBulletPath(var1_86 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	var5_86(var2_86)
	var5_86(var3_86)
	var5_86(var4_86)

	return var0_86
end

function var5_0.GetAidUnitsRes(arg0_88)
	local var0_88 = {}

	for iter0_88, iter1_88 in ipairs(arg0_88) do
		local var1_88 = var5_0.GetShipResource(iter1_88.tmpID, nil, true)

		for iter2_88, iter3_88 in ipairs(iter1_88.equipment) do
			if iter3_88 ~= 0 then
				if iter2_88 <= Ship.WEAPON_COUNT then
					local var2_88 = var1_0.GetWeaponDataFromID(iter3_88).weapon_id

					for iter4_88, iter5_88 in ipairs(var2_88) do
						local var3_88 = var5_0.GetWeaponResource(iter5_88)

						for iter6_88, iter7_88 in ipairs(var3_88) do
							table.insert(var1_88, iter7_88)
						end
					end
				else
					local var4_88 = var5_0.GetEquipResource(iter3_88)

					for iter8_88, iter9_88 in ipairs(var4_88) do
						table.insert(var1_88, iter9_88)
					end
				end
			end
		end

		for iter10_88, iter11_88 in ipairs(var1_88) do
			table.insert(var0_88, iter11_88)
		end
	end

	return var0_88
end

function var5_0.GetSpWeaponResource(arg0_89, arg1_89)
	local var0_89 = {}
	local var1_89 = var0_0.Battle.BattleDataFunction.GetSpWeaponDataFromID(arg0_89).effect_id

	if var1_89 ~= 0 then
		var1_89 = arg1_89 and var0_0.Battle.BattleDataFunction.SkillTranform(arg1_89, var1_89) or var1_89

		local var2_89 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var1_89, 1, {})

		for iter0_89, iter1_89 in ipairs(var2_89) do
			var0_89[#var0_89 + 1] = iter1_89
		end
	end

	return var0_89
end
