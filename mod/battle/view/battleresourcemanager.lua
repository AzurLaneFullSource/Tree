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

	PoolMgr.GetInstance():ReturnPainting(var0_21, arg1_21)
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
		ResourceMgr.Inst:getAssetAsync(var0_26, arg1_26 .. "_SkeletonData", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_27)
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
		ResourceMgr.Inst:getAssetAsync(var0_28, arg1_28, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_29)
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
		ResourceMgr.Inst:getAssetAsync(var0_30, arg1_30, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_31)
			if arg0_30._poolRoot then
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
		ResourceMgr.Inst:getAssetAsync(var0_32, arg1_32, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_33)
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
		ResourceMgr.Inst:getAssetAsync(var0_34, arg1_34, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_35)
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

function var5_0.InstPainting(arg0_39, arg1_39)
	local var0_39 = arg0_39.GetPaintingPath(arg1_39)
	local var1_39
	local var2_39 = arg0_39._allPool[var0_39]

	if var2_39 then
		var1_39 = var2_39:GetObject()
		arg0_39._ob2Pool[var1_39] = var2_39
	elseif arg0_39._resCacheList[var0_39] ~= nil then
		var1_39 = Object.Instantiate(arg0_39._resCacheList[var0_39])

		var1_39:SetActive(true)
	end

	return var1_39
end

function var5_0.InstMap(arg0_40, arg1_40)
	local var0_40 = arg0_40.GetMapPath(arg1_40)
	local var1_40
	local var2_40 = arg0_40._allPool[var0_40]

	if var2_40 then
		var1_40 = var2_40:GetObject()
		arg0_40._ob2Pool[var1_40] = var2_40
	elseif arg0_40._resCacheList[var0_40] ~= nil then
		var1_40 = Object.Instantiate(arg0_40._resCacheList[var0_40])
	else
		assert(false, "地图资源没有预加载：" .. arg1_40)
	end

	var1_40:SetActive(true)

	return var1_40
end

function var5_0.InstCardPuzzleCard(arg0_41)
	local var0_41 = arg0_41._allPool["UI/CardTowerCardCombat"]
	local var1_41 = var0_41:GetObject()

	arg0_41._ob2Pool[var1_41] = var0_41

	return var1_41
end

function var5_0.GetCharacterIcon(arg0_42, arg1_42)
	return arg0_42._resCacheList[var5_0.GetHrzIcon(arg1_42)]
end

function var5_0.GetCharacterSquareIcon(arg0_43, arg1_43)
	return arg0_43._resCacheList[var5_0.GetSquareIcon(arg1_43)]
end

function var5_0.GetCharacterQIcon(arg0_44, arg1_44)
	return arg0_44._resCacheList[var5_0.GetQIcon(arg1_44)]
end

function var5_0.GetAircraftIcon(arg0_45, arg1_45)
	return arg0_45._resCacheList[var5_0.GetAircraftIconPath(arg1_45)]
end

function var5_0.GetShipTypeIcon(arg0_46, arg1_46)
	return arg0_46._resCacheList[var5_0.GetShipTypeIconPath(arg1_46)]
end

function var5_0.GetCommanderHrzIcon(arg0_47, arg1_47)
	return arg0_47._resCacheList[var5_0.GetCommanderHrzIconPath(arg1_47)]
end

function var5_0.GetCommanderIcon(arg0_48, arg1_48)
	return arg0_48._resCacheList[var5_0.GetCommanderIconPath(arg1_48)]
end

function var5_0.GetShader(arg0_49, arg1_49)
	return (pg.ShaderMgr.GetInstance():GetShader(var3_0.BATTLE_SHADER[arg1_49]))
end

function var5_0.AddPreloadResource(arg0_50, arg1_50)
	if type(arg1_50) == "string" then
		arg0_50._preloadList[arg1_50] = false
	elseif type(arg1_50) == "table" then
		for iter0_50, iter1_50 in ipairs(arg1_50) do
			arg0_50._preloadList[iter1_50] = false
		end
	end
end

function var5_0.AddPreloadCV(arg0_51, arg1_51)
	local var0_51 = Ship.getCVKeyID(arg1_51)

	if var0_51 > 0 then
		arg0_51._battleCVList[var0_51] = pg.CriMgr.GetBattleCVBankName(var0_51)
	end
end

function var5_0.StartPreload(arg0_52, arg1_52, arg2_52)
	local var0_52 = 0
	local var1_52 = 0

	for iter0_52, iter1_52 in pairs(arg0_52._preloadList) do
		var1_52 = var1_52 + 1
	end

	for iter2_52, iter3_52 in pairs(arg0_52._battleCVList) do
		var1_52 = var1_52 + 1
	end

	local function var2_52()
		if not arg0_52._poolRoot then
			return
		end

		var0_52 = var0_52 + 1

		if var0_52 > var1_52 then
			return
		end

		if arg2_52 then
			arg2_52(var0_52)
		end

		if var0_52 == var1_52 then
			arg0_52._preloadList = nil

			arg1_52()
		end
	end

	for iter4_52, iter5_52 in pairs(arg0_52._battleCVList) do
		pg.CriMgr.GetInstance():LoadBattleCV(iter4_52, var2_52)
	end

	for iter6_52, iter7_52 in pairs(arg0_52._preloadList) do
		local var3_52 = arg0_52.GetResName(iter6_52)

		if var3_52 == "" or arg0_52._resCacheList[iter6_52] ~= nil then
			var2_52()
		elseif string.find(iter6_52, "herohrzicon/") or string.find(iter6_52, "qicon/") or string.find(iter6_52, "squareicon/") or string.find(iter6_52, "commanderhrz/") or string.find(iter6_52, "commandericon/") or string.find(iter6_52, "AircraftIcon/") then
			local var4_52, var5_52 = HXSet.autoHxShiftPath(iter6_52, var3_52)

			ResourceMgr.Inst:getAssetAsync(var4_52, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_54)
				if arg0_54 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					if not arg0_52._poolRoot then
						var4_0.Destroy(arg0_54)

						return
					end

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_54
					end
				end

				var2_52()
			end), true, true)
		elseif string.find(iter6_52, "shiptype/") then
			local var6_52 = string.split(iter6_52, "/")[2]

			ResourceMgr.Inst:getAssetAsync("shiptype", var6_52, typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_55)
				if arg0_55 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					if not arg0_52._poolRoot then
						var4_0.Destroy(arg0_55)

						return
					end

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_55
					end
				end

				var2_52()
			end), true, true)
		elseif string.find(iter6_52, "painting/") then
			local var7_52 = false

			if PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) > 0 then
				var7_52 = checkABExist("painting/" .. var3_52 .. "_n")
			else
				var7_52 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var3_52, 0) ~= 0 and checkABExist("painting/" .. var3_52 .. "_n")
			end

			PoolMgr.GetInstance():GetPainting(var3_52 .. (var7_52 and "_n" or ""), true, function(arg0_56)
				if arg0_56 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					if not arg0_52._poolRoot then
						var5_0.ClearPaintingRes(iter6_52, arg0_56)

						return
					end

					ShipExpressionHelper.SetExpression(arg0_56, var3_52)
					arg0_56:SetActive(false)

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_56
					end
				end

				var2_52()
			end)
		elseif string.find(iter6_52, "Char/") then
			arg0_52:LoadSpineAsset(var3_52, function(arg0_57)
				if arg0_57 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					arg0_57 = SpineAnim.AnimChar(var3_52, arg0_57)

					if not arg0_52._poolRoot then
						var5_0.ClearCharRes(iter6_52, arg0_57)

						return
					end

					arg0_57:SetActive(false)

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_57
					end
				end

				arg0_52:InitPool(iter6_52, arg0_57)
				var2_52()
			end)
		elseif string.find(iter6_52, "UI/") then
			LoadAndInstantiateAsync("UI", var3_52, function(arg0_58)
				if arg0_58 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					if not arg0_52._poolRoot then
						var4_0.Destroy(arg0_58)

						return
					end

					arg0_58:SetActive(false)

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_58
					end
				end

				arg0_52:InitPool(iter6_52, arg0_58)
				var2_52()
			end, true, true)
		else
			ResourceMgr.Inst:getAssetAsync(iter6_52, var3_52, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_59)
				if arg0_59 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_52 .. "<<")
				else
					if not arg0_52._poolRoot then
						var4_0.Destroy(arg0_59)

						return
					end

					if arg0_52._resCacheList then
						arg0_52._resCacheList[iter6_52] = arg0_59
					end
				end

				arg0_52:InitPool(iter6_52, arg0_59)
				var2_52()
			end), true, true)
		end
	end

	return var1_52
end

local var6_0 = Vector3(0, 10000, 0)

function var5_0.HideBullet(arg0_60)
	arg0_60.transform.position = var6_0
end

function var5_0.InitParticleSystemCB(arg0_61)
	pg.EffectMgr.GetInstance():CommonEffectEvent(arg0_61)
end

function var5_0.InitPool(arg0_62, arg1_62, arg2_62)
	local var0_62 = arg0_62._poolRoot.transform

	if string.find(arg1_62, "Item/") then
		if arg2_62:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or arg2_62:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			arg0_62._allPool[arg1_62] = pg.Pool.New(arg0_62._bulletContainer.transform, arg2_62, 15, 20, true, false):InitSize()
		else
			local var1_62 = pg.Pool.New(arg0_62._bulletContainer.transform, arg2_62, 20, 20, true, true)

			var1_62:SetRecycleFuncs(var5_0.HideBullet)
			var1_62:InitSize()

			arg0_62._allPool[arg1_62] = var1_62
		end
	elseif string.find(arg1_62, "Effect/") then
		if arg2_62:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			local var2_62 = 5

			if string.find(arg1_62, "smoke") and not string.find(arg1_62, "smokeboom") then
				var2_62 = 30
			elseif string.find(arg1_62, "feijiyingzi") then
				var2_62 = 1
			end

			local var3_62 = pg.Pool.New(var0_62, arg2_62, var2_62, 20, false, false)

			var3_62:SetInitFuncs(var5_0.InitParticleSystemCB)
			var3_62:InitSize()

			arg0_62._allPool[arg1_62] = var3_62
		else
			local var4_62 = 8

			if string.find(arg1_62, "AntiAirArea") or string.find(arg1_62, "AntiSubArea") then
				var4_62 = 1
			end

			GetOrAddComponent(arg2_62, typeof(ParticleSystemEvent))

			local var5_62 = pg.Pool.New(var0_62, arg2_62, var4_62, 20, false, false)

			var5_62:InitSize()

			arg0_62._allPool[arg1_62] = var5_62
		end
	elseif string.find(arg1_62, "Char/") then
		local var6_62 = 1

		if string.find(arg1_62, "danchuan") then
			var6_62 = 3
		end

		local var7_62 = pg.Pool.New(var0_62, arg2_62, var6_62, 20, false, false):InitSize()

		var7_62:SetRecycleFuncs(var5_0.ResetSpineAction)

		arg0_62._allPool[arg1_62] = var7_62
	elseif string.find(arg1_62, "chargo/") then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 3, 20, false, false):InitSize()
	elseif string.find(arg1_62, "orbit/") then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 2, 20, false, false):InitSize()
	elseif arg1_62 == "UI/SkillPainting" then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 1, 20, false, false):InitSize()
	elseif arg1_62 == "UI/MonsterAppearUI" then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 1, 20, false, false):InitSize()
	elseif arg1_62 == "UI/CardTowerCardCombat" then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 7, 20, false, false):InitSize()
	elseif arg1_62 == "UI/combatgridmanskillfloat" then
		arg0_62._allPool[arg1_62] = pg.Pool.New(var0_62, arg2_62, 1, 20, false, false):InitSize()
	elseif arg1_62 == "UI/CombatHPBar" .. var0_0.Battle.BattleState.GetCombatSkinKey() then
		var0_0.Battle.BattleHPBarManager.GetInstance():Init(arg2_62, var0_62)
	elseif string.find(arg1_62, "UI/CombatHPPop") then
		var0_0.Battle.BattlePopNumManager.GetInstance():Init(arg2_62, var0_62)
	end
end

function var5_0.GetRotateScript(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg0_63.rotateScriptMap

	if var0_63[arg1_63] then
		return var0_63[arg1_63]
	end

	local var1_63 = GetOrAddComponent(arg1_63, "BulletRotation")

	var0_63[arg1_63] = var1_63

	return var1_63
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

function var5_0.GetMapResource(arg0_66)
	local var0_66 = {}
	local var1_66 = var0_0.Battle.BattleMap

	for iter0_66, iter1_66 in ipairs(var1_66.LAYERS) do
		local var2_66 = var1_66.GetMapResNames(arg0_66, iter1_66)

		for iter2_66, iter3_66 in ipairs(var2_66) do
			var0_66[#var0_66 + 1] = var5_0.GetMapPath(iter3_66)
		end
	end

	return var0_66
end

function var5_0.GetBuffResource()
	local var0_67 = {}
	local var1_67 = require("buffFXPreloadList")

	for iter0_67, iter1_67 in ipairs(var1_67) do
		var0_67[#var0_67 + 1] = var5_0.GetFXPath(iter1_67)
	end

	return var0_67
end

function var5_0.GetShipResource(arg0_68, arg1_68, arg2_68)
	local var0_68 = {}
	local var1_68 = var1_0.GetPlayerShipTmpDataFromID(arg0_68)

	if arg1_68 == nil or arg1_68 == 0 then
		arg1_68 = var1_68.skin_id
	end

	local var2_68 = var1_0.GetPlayerShipSkinDataFromID(arg1_68)

	var0_68[#var0_68 + 1] = var5_0.GetCharacterPath(var2_68.prefab)
	var0_68[#var0_68 + 1] = var5_0.GetHrzIcon(var2_68.painting)
	var0_68[#var0_68 + 1] = var5_0.GetQIcon(var2_68.painting)
	var0_68[#var0_68 + 1] = var5_0.GetSquareIcon(var2_68.painting)

	if arg2_68 and var1_0.GetShipTypeTmp(var1_68.type).team_type == TeamType.Main then
		var0_68[#var0_68 + 1] = var5_0.GetPaintingPath(var2_68.painting)
	end

	return var0_68
end

function var5_0.GetEnemyResource(arg0_69)
	local var0_69 = {}
	local var1_69 = arg0_69.monsterTemplateID
	local var2_69 = arg0_69.bossData ~= nil
	local var3_69 = arg0_69.buffList or {}
	local var4_69 = arg0_69.phase or {}
	local var5_69 = var1_0.GetMonsterTmpDataFromID(var1_69)

	var0_69[#var0_69 + 1] = var5_0.GetCharacterPath(var5_69.prefab)
	var0_69[#var0_69 + 1] = var5_0.GetFXPath(var5_69.wave_fx)

	if var5_69.fog_fx then
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(var5_69.fog_fx)
	end

	for iter0_69, iter1_69 in ipairs(var5_69.appear_fx) do
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(iter1_69)
	end

	for iter2_69, iter3_69 in ipairs(var5_69.smoke) do
		local var6_69 = iter3_69[2]

		for iter4_69, iter5_69 in ipairs(var6_69) do
			var0_69[#var0_69 + 1] = var5_0.GetFXPath(iter5_69[1])
		end
	end

	if arg0_69.deadFX then
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(arg0_69.deadFX)
	end

	if type(var5_69.bubble_fx) == "table" then
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(var5_69.bubble_fx[1])
	end

	local function var7_69(arg0_70)
		local var0_70 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg0_70, 1)

		for iter0_70, iter1_70 in pairs(var0_70.effect_list) do
			local var1_70 = iter1_70.arg_list.skill_id

			if var1_70 then
				local var2_70 = var0_0.Battle.BattleDataFunction.GetSkillTemplate(var1_70).painting

				if var2_70 == 1 then
					var0_69[#var0_69 + 1] = var5_0.GetHrzIcon(var5_69.icon)
				elseif type(var2_70) == "string" then
					var0_69[#var0_69 + 1] = var5_0.GetHrzIcon(var2_70)
				end
			end

			local var3_70 = iter1_70.arg_list.buff_id

			if var3_70 then
				var7_69(var3_70)
			end
		end
	end

	for iter6_69, iter7_69 in ipairs(var3_69) do
		var7_69(iter7_69)
	end

	for iter8_69, iter9_69 in ipairs(var4_69) do
		if iter9_69.addBuff then
			for iter10_69, iter11_69 in ipairs(iter9_69.addBuff) do
				var7_69(iter11_69)
			end
		end
	end

	if var2_69 then
		var0_69[#var0_69 + 1] = var5_0.GetSquareIcon(var5_69.icon)
	end

	return var0_69
end

function var5_0.GetWeaponResource(arg0_71, arg1_71)
	local var0_71 = {}

	if arg0_71 == -1 then
		return var0_71
	end

	local var1_71 = var1_0.GetWeaponPropertyDataFromID(arg0_71)

	if var1_71.type == var2_0.EquipmentType.MAIN_CANNON or var1_71.type == var2_0.EquipmentType.SUB_CANNON or var1_71.type == var2_0.EquipmentType.TORPEDO or var1_71.type == var2_0.EquipmentType.ANTI_AIR or var1_71.type == var2_0.EquipmentType.ANTI_SEA or var1_71.type == var2_0.EquipmentType.POINT_HIT_AND_LOCK or var1_71.type == var2_0.EquipmentType.MANUAL_METEOR or var1_71.type == var2_0.EquipmentType.BOMBER_PRE_CAST_ALERT or var1_71.type == var2_0.EquipmentType.DEPTH_CHARGE or var1_71.type == var2_0.EquipmentType.MANUAL_TORPEDO or var1_71.type == var2_0.EquipmentType.DISPOSABLE_TORPEDO or var1_71.type == var2_0.EquipmentType.MANUAL_AAMISSILE or var1_71.type == var2_0.EquipmentType.BEAM or var1_71.type == var2_0.EquipmentType.SPACE_LASER or var1_71.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR or var1_71.type == var2_0.EquipmentType.MANUAL_MISSILE or var1_71.type == var2_0.EquipmentType.AUTO_MISSILE or var1_71.type == var2_0.EquipmentType.MISSILE then
		for iter0_71, iter1_71 in ipairs(var1_71.bullet_ID) do
			local var2_71 = var5_0.GetBulletResource(iter1_71, arg1_71)

			for iter2_71, iter3_71 in ipairs(var2_71) do
				var0_71[#var0_71 + 1] = iter3_71
			end
		end
	elseif var1_71.type == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or var1_71.type == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		var0_71 = var5_0.GetAircraftResource(arg0_71, nil, arg1_71)
	elseif var1_71.type == var2_0.EquipmentType.PREVIEW_ARICRAFT then
		for iter4_71, iter5_71 in ipairs(var1_71.bullet_ID) do
			var0_71 = var5_0.GetAircraftResource(iter5_71, nil, arg1_71)
		end
	end

	if var1_71.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR then
		local var3_71 = var5_0.GetBulletResource(var3_0.AntiAirConfig.RangeBulletID)

		for iter6_71, iter7_71 in ipairs(var3_71) do
			var0_71[#var0_71 + 1] = iter7_71
		end
	end

	local var4_71

	if arg1_71 and arg1_71 ~= 0 then
		var4_71 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_71)
	end

	if var4_71 and var4_71.fire_fx_name ~= "" then
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(var4_71.fire_fx_name)
	else
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(var1_71.fire_fx)
	end

	if var1_71.precast_param.fx then
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(var1_71.precast_param.fx)
	end

	if var4_71 then
		local var5_71 = var4_71.orbit_combat

		if var5_71 ~= "" then
			var0_71[#var0_71 + 1] = var5_0.GetOrbitPath(var5_71)
		end
	end

	return var0_71
end

function var5_0.GetEquipResource(arg0_72, arg1_72, arg2_72)
	local var0_72 = {}

	if arg1_72 ~= 0 then
		local var1_72 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_72)
		local var2_72 = var1_72.ship_skin_id

		if var2_72 ~= 0 then
			local var3_72 = var0_0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(var2_72)

			var0_72[#var0_72 + 1] = var5_0.GetCharacterPath(var3_72.prefab)
		end

		local var4_72 = var1_72.orbit_combat

		if var4_72 ~= "" then
			var0_72[#var0_72 + 1] = var5_0.GetOrbitPath(var4_72)
		end
	end

	local var5_72 = var0_0.Battle.BattleDataFunction.GetWeaponDataFromID(arg0_72)
	local var6_72 = var5_72.weapon_id

	for iter0_72, iter1_72 in ipairs(var6_72) do
		local var7_72 = var5_0.GetWeaponResource(iter1_72)

		for iter2_72, iter3_72 in ipairs(var7_72) do
			var0_72[#var0_72 + 1] = iter3_72
		end
	end

	local var8_72 = var5_72.skill_id

	for iter4_72, iter5_72 in ipairs(var8_72) do
		iter5_72 = arg2_72 and var0_0.Battle.BattleDataFunction.SkillTranform(arg2_72, iter5_72) or iter5_72

		local var9_72 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_72, 1, {})

		for iter6_72, iter7_72 in ipairs(var9_72) do
			var0_72[#var0_72 + 1] = iter7_72
		end
	end

	return var0_72
end

function var5_0.GetBulletResource(arg0_73, arg1_73)
	local var0_73 = {}
	local var1_73

	if arg1_73 ~= nil and arg1_73 ~= 0 then
		var1_73 = var1_0.GetEquipSkinDataFromID(arg1_73)
	end

	local var2_73 = var1_0.GetBulletTmpDataFromID(arg0_73)
	local var3_73

	if var1_73 then
		var3_73 = var1_73.bullet_name

		if var1_73.mirror == 1 then
			var0_73[#var0_73 + 1] = var5_0.GetBulletPath(var3_73 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		var3_73 = var2_73.modle_ID
	end

	if var2_73.type == var2_0.BulletType.BEAM or var2_73.type == var2_0.BulletType.SPACE_LASER or var2_73.type == var2_0.BulletType.MISSILE or var2_73.type == var2_0.BulletType.ELECTRIC_ARC then
		var0_73[#var0_73 + 1] = var5_0.GetFXPath(var2_73.modle_ID)
	else
		var0_73[#var0_73 + 1] = var5_0.GetBulletPath(var3_73)
	end

	if var2_73.extra_param.mirror then
		var0_73[#var0_73 + 1] = var5_0.GetBulletPath(var3_73 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
	end

	local var4_73

	if var1_73 and var1_73.hit_fx_name ~= "" then
		var4_73 = var1_73.hit_fx_name
	else
		var4_73 = var2_73.hit_fx
	end

	var0_73[#var0_73 + 1] = var5_0.GetFXPath(var4_73)
	var0_73[#var0_73 + 1] = var5_0.GetFXPath(var2_73.miss_fx)
	var0_73[#var0_73 + 1] = var5_0.GetFXPath(var2_73.alert_fx)

	if var2_73.extra_param.area_FX then
		var0_73[#var0_73 + 1] = var5_0.GetFXPath(var2_73.extra_param.area_FX)
	end

	if var2_73.extra_param.shrapnel then
		for iter0_73, iter1_73 in ipairs(var2_73.extra_param.shrapnel) do
			local var5_73 = var5_0.GetBulletResource(iter1_73.bullet_ID)

			for iter2_73, iter3_73 in ipairs(var5_73) do
				var0_73[#var0_73 + 1] = iter3_73
			end
		end
	end

	for iter4_73, iter5_73 in ipairs(var2_73.attach_buff) do
		if iter5_73.effect_id then
			var0_73[#var0_73 + 1] = var5_0.GetFXPath(iter5_73.effect_id)
		end

		if iter5_73.buff_id then
			local var6_73 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_73.buff_id, 1, {})

			for iter6_73, iter7_73 in ipairs(var6_73) do
				var0_73[#var0_73 + 1] = iter7_73
			end
		end
	end

	return var0_73
end

function var5_0.GetAircraftResource(arg0_74, arg1_74, arg2_74)
	local var0_74 = {}

	arg2_74 = arg2_74 or 0

	local var1_74 = var1_0.GetAircraftTmpDataFromID(arg0_74)
	local var2_74
	local var3_74
	local var4_74
	local var5_74

	if arg2_74 ~= 0 then
		local var6_74, var7_74, var8_74

		var2_74, var6_74, var7_74, var8_74 = var1_0.GetEquipSkin(arg2_74)

		if var6_74 ~= "" then
			var0_74[#var0_74 + 1] = var5_0.GetBulletPath(var6_74)
		end

		if var7_74 ~= "" then
			var0_74[#var0_74 + 1] = var5_0.GetBulletPath(var7_74)
		end

		if var8_74 ~= "" then
			var0_74[#var0_74 + 1] = var5_0.GetBulletPath(var8_74)
		end
	else
		var2_74 = var1_74.model_ID
	end

	var0_74[#var0_74 + 1] = var5_0.GetCharacterGoPath(var2_74)
	var0_74[#var0_74 + 1] = var5_0.GetAircraftIconPath(var1_74.model_ID)

	local var9_74 = arg1_74 or var1_74.weapon_ID

	if type(var9_74) == "table" then
		for iter0_74, iter1_74 in ipairs(var9_74) do
			local var10_74 = var5_0.GetWeaponResource(iter1_74)

			for iter2_74, iter3_74 in ipairs(var10_74) do
				var0_74[#var0_74 + 1] = iter3_74
			end
		end
	else
		local var11_74 = var5_0.GetWeaponResource(var9_74)

		for iter4_74, iter5_74 in ipairs(var11_74) do
			var0_74[#var0_74 + 1] = iter5_74
		end
	end

	return var0_74
end

function var5_0.GetCommanderResource(arg0_75)
	local var0_75 = {}
	local var1_75 = arg0_75[1]

	var0_75[#var0_75 + 1] = var5_0.GetCommanderHrzIconPath(var1_75:getPainting())
	var0_75[#var0_75 + 1] = var5_0.GetCommanderIconPath(var1_75:getPainting())

	local var2_75 = var1_75:getSkills()[1]:getLevel()

	for iter0_75, iter1_75 in ipairs(arg0_75[2]) do
		local var3_75 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_75, var2_75, {})

		for iter2_75, iter3_75 in ipairs(var3_75) do
			var0_75[#var0_75 + 1] = iter3_75
		end
	end

	return var0_75
end

function var5_0.GetStageResource(arg0_76)
	local var0_76 = var0_0.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0_76)
	local var1_76 = {}
	local var2_76 = {}

	for iter0_76, iter1_76 in ipairs(var0_76.stages) do
		for iter2_76, iter3_76 in ipairs(iter1_76.waves) do
			if iter3_76.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter4_76, iter5_76 in ipairs(iter3_76.spawn) do
					local var3_76 = var5_0.GetMonsterRes(iter5_76)

					for iter6_76, iter7_76 in ipairs(var3_76) do
						table.insert(var1_76, iter7_76)
					end
				end

				if iter3_76.reinforcement then
					for iter8_76, iter9_76 in ipairs(iter3_76.reinforcement) do
						local var4_76 = var5_0.GetMonsterRes(iter9_76)

						for iter10_76, iter11_76 in ipairs(var4_76) do
							table.insert(var1_76, iter11_76)
						end
					end
				end
			elseif iter3_76.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.AID then
				local var5_76 = iter3_76.triggerParams.vanguard_unitList
				local var6_76 = iter3_76.triggerParams.main_unitList
				local var7_76 = iter3_76.triggerParams.sub_unitList

				local function var8_76(arg0_77)
					local var0_77 = var5_0.GetAidUnitsRes(arg0_77)

					for iter0_77, iter1_77 in ipairs(var0_77) do
						table.insert(var1_76, iter1_77)
					end

					for iter2_77, iter3_77 in ipairs(arg0_77) do
						var2_76[#var2_76 + 1] = iter3_77.skinId
					end
				end

				if var5_76 then
					var8_76(var5_76)
				end

				if var6_76 then
					var8_76(var6_76)
				end

				if var7_76 then
					var8_76(var7_76)
				end
			elseif iter3_76.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for iter12_76, iter13_76 in ipairs(iter3_76.spawn) do
					var5_0.GetEnvironmentRes(var1_76, iter13_76)
				end
			elseif iter3_76.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.CARD_PUZZLE then
				local var9_76 = var0_0.Battle.BattleDataFunction.GetCardRes(iter3_76.triggerParams.card_id)

				for iter14_76, iter15_76 in ipairs(var9_76) do
					table.insert(var1_76, iter15_76)
				end
			end

			if iter3_76.airFighter ~= nil then
				for iter16_76, iter17_76 in pairs(iter3_76.airFighter) do
					local var10_76 = var5_0.GetAircraftResource(iter17_76.templateID, iter17_76.weaponID)

					for iter18_76, iter19_76 in ipairs(var10_76) do
						var1_76[#var1_76 + 1] = iter19_76
					end
				end
			end
		end
	end

	return var1_76, var2_76
end

function var5_0.GetEnvironmentRes(arg0_78, arg1_78)
	table.insert(arg0_78, arg1_78.prefab and var5_0.GetFXPath(arg1_78.prefab))

	local var0_78 = arg1_78.behaviours
	local var1_78 = var0_0.Battle.BattleDataFunction.GetEnvironmentBehaviour(var0_78).behaviour_list

	for iter0_78, iter1_78 in ipairs(var1_78) do
		local var2_78 = iter1_78.type

		if var2_78 == var0_0.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			local var3_78 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_78.buff_id, 1, {})

			for iter2_78, iter3_78 in ipairs(var3_78) do
				arg0_78[#arg0_78 + 1] = iter3_78
			end
		elseif var2_78 == var0_0.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			local var4_78 = iter1_78.content and iter1_78.content.alert and iter1_78.content.alert.alert_fx

			table.insert(arg0_78, var4_78 and var5_0.GetFXPath(var4_78))

			local var5_78 = iter1_78.content and iter1_78.content.child_prefab

			if var5_78 then
				var5_0.GetEnvironmentRes(arg0_78, var5_78)
			end
		elseif var2_78 == var0_0.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			arg0_78[#arg0_78 + 1] = var5_0.GetFXPath(iter1_78.FX_ID)
		end
	end
end

function var5_0.GetMonsterRes(arg0_79)
	local var0_79 = {}
	local var1_79 = var5_0.GetEnemyResource(arg0_79)

	for iter0_79, iter1_79 in ipairs(var1_79) do
		var0_79[#var0_79 + 1] = iter1_79
	end

	local var2_79 = var0_0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0_79.monsterTemplateID)
	local var3_79 = Clone(var2_79.equipment_list)
	local var4_79 = var2_79.buff_list
	local var5_79 = Clone(arg0_79.buffList) or {}

	if arg0_79.phase then
		for iter2_79, iter3_79 in ipairs(arg0_79.phase) do
			if iter3_79.addWeapon then
				for iter4_79, iter5_79 in ipairs(iter3_79.addWeapon) do
					var3_79[#var3_79 + 1] = iter5_79
				end
			end

			if iter3_79.addRandomWeapon then
				for iter6_79, iter7_79 in ipairs(iter3_79.addRandomWeapon) do
					for iter8_79, iter9_79 in ipairs(iter7_79) do
						var3_79[#var3_79 + 1] = iter9_79
					end
				end
			end

			if iter3_79.addBuff then
				for iter10_79, iter11_79 in ipairs(iter3_79.addBuff) do
					var5_79[#var5_79 + 1] = iter11_79
				end
			end
		end
	end

	for iter12_79, iter13_79 in ipairs(var4_79) do
		local var6_79 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter13_79.ID, iter13_79.LV, {})

		for iter14_79, iter15_79 in ipairs(var6_79) do
			var0_79[#var0_79 + 1] = iter15_79
		end
	end

	for iter16_79, iter17_79 in ipairs(var5_79) do
		local var7_79 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter17_79, 1, {})

		for iter18_79, iter19_79 in ipairs(var7_79) do
			var0_79[#var0_79 + 1] = iter19_79
		end

		local var8_79 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(iter17_79, 1)

		for iter20_79, iter21_79 in pairs(var8_79.effect_list) do
			local var9_79 = iter21_79.arg_list.skill_id

			if var9_79 and var0_0.Battle.BattleDataFunction.NeedSkillPainting(var9_79) then
				var0_79[#var0_79 + 1] = var5_0.GetPaintingPath(var1_0.GetMonsterTmpDataFromID(arg0_79.monsterTemplateID).icon)

				break
			end
		end
	end

	for iter22_79, iter23_79 in ipairs(var3_79) do
		local var10_79 = var5_0.GetWeaponResource(iter23_79)

		for iter24_79, iter25_79 in ipairs(var10_79) do
			var0_79[#var0_79 + 1] = iter25_79
		end
	end

	return var0_79
end

function var5_0.GetEquipSkinPreviewRes(arg0_80)
	local var0_80 = {}
	local var1_80 = var1_0.GetEquipSkinDataFromID(arg0_80)

	for iter0_80, iter1_80 in ipairs(var1_80.weapon_ids) do
		local var2_80 = var5_0.GetWeaponResource(iter1_80)

		for iter2_80, iter3_80 in ipairs(var2_80) do
			var0_80[#var0_80 + 1] = iter3_80
		end
	end

	local function var3_80(arg0_81)
		if arg0_81 ~= "" then
			var0_80[#var0_80 + 1] = var5_0.GetBulletPath(arg0_81)
		end
	end

	local var4_80, var5_80, var6_80, var7_80, var8_80, var9_80 = var1_0.GetEquipSkin(arg0_80)

	if _.any(EquipType.AirProtoEquipTypes, function(arg0_82)
		return table.contains(var1_80.equip_type, arg0_82)
	end) then
		var0_80[#var0_80 + 1] = var5_0.GetCharacterGoPath(var4_80)
	else
		var0_80[#var0_80 + 1] = var5_0.GetBulletPath(var4_80)
	end

	var3_80(var5_80)
	var3_80(var6_80)
	var3_80(var7_80)

	if var8_80 and var8_80 ~= "" then
		var0_80[#var0_80 + 1] = var5_0.GetFXPath(var8_80)
	end

	if var9_80 and var9_80 ~= "" then
		var0_80[#var0_80 + 1] = var5_0.GetFXPath(var9_80)
	end

	return var0_80
end

function var5_0.GetEquipSkinBulletRes(arg0_83)
	local var0_83 = {}
	local var1_83, var2_83, var3_83, var4_83 = var1_0.GetEquipSkin(arg0_83)

	local function var5_83(arg0_84)
		if arg0_84 ~= "" then
			var0_83[#var0_83 + 1] = var5_0.GetBulletPath(arg0_84)
		end
	end

	local var6_83 = var1_0.GetEquipSkinDataFromID(arg0_83)
	local var7_83 = false

	for iter0_83, iter1_83 in ipairs(var6_83.equip_type) do
		if table.contains(EquipType.AircraftSkinType, iter1_83) then
			var7_83 = true
		end
	end

	if var7_83 then
		if var1_83 ~= "" then
			var0_83[#var0_83 + 1] = var5_0.GetCharacterGoPath(var1_83)
		end
	else
		var5_83(var1_83)

		if var1_0.GetEquipSkinDataFromID(arg0_83).mirror == 1 then
			var0_83[#var0_83 + 1] = var5_0.GetBulletPath(var1_83 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	var5_83(var2_83)
	var5_83(var3_83)
	var5_83(var4_83)

	return var0_83
end

function var5_0.GetAidUnitsRes(arg0_85)
	local var0_85 = {}

	for iter0_85, iter1_85 in ipairs(arg0_85) do
		local var1_85 = var5_0.GetShipResource(iter1_85.tmpID, nil, true)

		for iter2_85, iter3_85 in ipairs(iter1_85.equipment) do
			if iter3_85 ~= 0 then
				if iter2_85 <= Ship.WEAPON_COUNT then
					local var2_85 = var1_0.GetWeaponDataFromID(iter3_85).weapon_id

					for iter4_85, iter5_85 in ipairs(var2_85) do
						local var3_85 = var5_0.GetWeaponResource(iter5_85)

						for iter6_85, iter7_85 in ipairs(var3_85) do
							table.insert(var1_85, iter7_85)
						end
					end
				else
					local var4_85 = var5_0.GetEquipResource(iter3_85)

					for iter8_85, iter9_85 in ipairs(var4_85) do
						table.insert(var1_85, iter9_85)
					end
				end
			end
		end

		for iter10_85, iter11_85 in ipairs(var1_85) do
			table.insert(var0_85, iter11_85)
		end
	end

	return var0_85
end

function var5_0.GetSpWeaponResource(arg0_86, arg1_86)
	local var0_86 = {}
	local var1_86 = var0_0.Battle.BattleDataFunction.GetSpWeaponDataFromID(arg0_86).effect_id

	if var1_86 ~= 0 then
		var1_86 = arg1_86 and var0_0.Battle.BattleDataFunction.SkillTranform(arg1_86, var1_86) or var1_86

		local var2_86 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var1_86, 1, {})

		for iter0_86, iter1_86 in ipairs(var2_86) do
			var0_86[#var0_86 + 1] = iter1_86
		end
	end

	return var0_86
end
