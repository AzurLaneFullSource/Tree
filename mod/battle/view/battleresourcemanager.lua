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

function var5_0.GetShipTypeIconPath(arg0_15)
	return "shiptype/" .. arg0_15
end

function var5_0.GetMapPath(arg0_16)
	return "Map/" .. arg0_16
end

function var5_0.GetUIPath(arg0_17)
	return "UI/" .. arg0_17
end

function var5_0.GetResName(arg0_18)
	local var0_18 = arg0_18
	local var1_18 = string.find(var0_18, "%/")

	while var1_18 do
		var0_18 = string.sub(var0_18, var1_18 + 1)
		var1_18 = string.find(var0_18, "%/")
	end

	return var0_18
end

function var5_0.ClearCharRes(arg0_19, arg1_19)
	local var0_19 = var5_0.GetResName(arg0_19)
	local var1_19 = arg1_19:GetComponent("SkeletonRenderer").skeletonDataAsset

	if not PoolMgr.GetInstance():IsSpineSkelCached(var0_19) then
		UIUtil.ClearSharedMaterial(arg1_19)
	end

	var4_0.Destroy(arg1_19)
end

function var5_0.ClearPaintingRes(arg0_20, arg1_20)
	local var0_20 = var5_0.GetResName(arg0_20)

	PoolMgr.GetInstance():ReturnPainting(var0_20, arg1_20)
end

function var5_0.DestroyOb(arg0_21, arg1_21)
	local var0_21 = arg0_21._ob2Pool[arg1_21]

	if var0_21 then
		var0_21:Recycle(arg1_21)
	else
		var4_0.Destroy(arg1_21)
	end
end

function var5_0.popPool(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg1_22:GetObject()

	if not arg2_22 then
		var0_22.transform.parent = nil
	end

	arg0_22._ob2Pool[var0_22] = arg1_22

	return var0_22
end

function var5_0.InstCharacter(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.GetCharacterPath(arg1_23)
	local var1_23 = arg0_23._allPool[var0_23]

	if var1_23 then
		local var2_23 = arg0_23:popPool(var1_23)

		arg2_23(var2_23)
	elseif arg0_23._resCacheList[var0_23] ~= nil then
		arg0_23:InitPool(var0_23, arg0_23._resCacheList[var0_23])

		var1_23 = arg0_23._allPool[var0_23]

		local var3_23 = arg0_23:popPool(var1_23)

		arg2_23(var3_23)
	else
		arg0_23:LoadSpineAsset(arg1_23, function(arg0_24)
			if not arg0_23._poolRoot then
				var5_0.ClearCharRes(var0_23, arg0_24)

				return
			end

			assert(arg0_24, "角色资源加载失败：" .. arg1_23)

			local var0_24 = SpineAnim.AnimChar(arg1_23, arg0_24)

			var0_24:SetActive(false)
			arg0_23:InitPool(var0_23, var0_24)

			var1_23 = arg0_23._allPool[var0_23]

			local var1_24 = arg0_23:popPool(var1_23)

			arg2_23(var1_24)
		end)
	end
end

function var5_0.LoadSpineAsset(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.GetCharacterPath(arg1_25)

	if not PoolMgr.GetInstance():IsSpineSkelCached(arg1_25) then
		ResourceMgr.Inst:getAssetAsync(var0_25, arg1_25 .. "_SkeletonData", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_26)
			arg2_25(arg0_26)
		end), true, true)
	else
		PoolMgr.GetInstance():GetSpineSkel(arg1_25, true, arg2_25)
	end
end

function var5_0.InstAirCharacter(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.GetCharacterGoPath(arg1_27)
	local var1_27 = arg0_27._allPool[var0_27]

	if var1_27 then
		local var2_27 = arg0_27:popPool(var1_27)

		arg2_27(var2_27)
	elseif arg0_27._resCacheList[var0_27] ~= nil then
		arg0_27:InitPool(var0_27, arg0_27._resCacheList[var0_27])

		var1_27 = arg0_27._allPool[var0_27]

		local var3_27 = arg0_27:popPool(var1_27)

		arg2_27(var3_27)
	else
		ResourceMgr.Inst:getAssetAsync(var0_27, arg1_27, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_28)
			if not arg0_27._poolRoot then
				var4_0.Destroy(arg0_28)

				return
			else
				assert(arg0_28, "飞机资源加载失败：" .. arg1_27)
				arg0_27:InitPool(var0_27, arg0_28)

				var1_27 = arg0_27._allPool[var0_27]

				local var0_28 = arg0_27:popPool(var1_27)

				arg2_27(var0_28)
			end
		end), true, true)
	end
end

function var5_0.InstBullet(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.GetBulletPath(arg1_29)
	local var1_29 = arg0_29._allPool[var0_29]

	if var1_29 then
		local var2_29 = arg0_29:popPool(var1_29, true)

		if string.find(arg1_29, "_trail") then
			local var3_29 = var2_29:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var3_29 then
				var3_29:Clear()
			end
		end

		arg2_29(var2_29)

		return true
	elseif arg0_29._resCacheList[var0_29] ~= nil then
		arg0_29:InitPool(var0_29, arg0_29._resCacheList[var0_29])

		var1_29 = arg0_29._allPool[var0_29]

		local var4_29 = arg0_29:popPool(var1_29, true)

		if string.find(arg1_29, "_trail") then
			local var5_29 = var4_29:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var5_29 then
				var5_29:Clear()
			end
		end

		arg2_29(var4_29)

		return true
	else
		ResourceMgr.Inst:getAssetAsync(var0_29, arg1_29, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_30)
			if arg0_29._poolRoot then
				var4_0.Destroy(arg0_30)

				return
			else
				assert(arg0_30, "子弹资源加载失败：" .. arg1_29)
				arg0_29:InitPool(var0_29, arg0_30)

				var1_29 = arg0_29._allPool[var0_29]

				local var0_30 = arg0_29:popPool(var1_29, true)

				arg2_29(var0_30)
			end
		end), true, true)

		return false
	end
end

function var5_0.InstFX(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.GetFXPath(arg1_31)
	local var1_31
	local var2_31 = arg0_31._allPool[var0_31]

	if var2_31 then
		var1_31 = arg0_31:popPool(var2_31, arg2_31)
	elseif arg0_31._resCacheList[var0_31] ~= nil then
		arg0_31:InitPool(var0_31, arg0_31._resCacheList[var0_31])

		local var3_31 = arg0_31._allPool[var0_31]

		var1_31 = arg0_31:popPool(var3_31, arg2_31)
	else
		ResourceMgr.Inst:getAssetAsync(var0_31, arg1_31, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_32)
			if not arg0_31._poolRoot then
				var4_0.Destroy(arg0_32)

				return
			else
				assert(arg0_32, "特效资源加载失败：" .. arg1_31)
				arg0_31:InitPool(var0_31, arg0_32)
			end
		end), true, true)

		var1_31 = GameObject(arg1_31 .. "临时假obj")

		var1_31:SetActive(false)

		arg0_31._resCacheList[var0_31] = var1_31
	end

	return var1_31
end

function var5_0.InstOrbit(arg0_33, arg1_33)
	local var0_33 = arg0_33.GetOrbitPath(arg1_33)
	local var1_33
	local var2_33 = arg0_33._allPool[var0_33]

	if var2_33 then
		var1_33 = arg0_33:popPool(var2_33)
	elseif arg0_33._resCacheList[var0_33] ~= nil then
		arg0_33:InitPool(var0_33, arg0_33._resCacheList[var0_33])

		local var3_33 = arg0_33._allPool[var0_33]

		var1_33 = arg0_33:popPool(var3_33)
	else
		ResourceMgr.Inst:getAssetAsync(var0_33, arg1_33, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_34)
			if not arg0_33._poolRoot then
				var4_0.Destroy(arg0_34)

				return
			else
				assert(arg0_34, "特效资源加载失败：" .. arg1_33)
				arg0_33:InitPool(var0_33, arg0_34)
			end
		end), true, true)

		var1_33 = GameObject(arg1_33 .. "临时假obj")

		var1_33:SetActive(false)

		arg0_33._resCacheList[var0_33] = var1_33
	end

	return var1_33
end

function var5_0.InstSkillPaintingUI(arg0_35)
	local var0_35 = arg0_35._allPool["UI/SkillPainting"]
	local var1_35 = var0_35:GetObject()

	arg0_35._ob2Pool[var1_35] = var0_35

	return var1_35
end

function var5_0.InstBossWarningUI(arg0_36)
	local var0_36 = arg0_36._allPool["UI/MonsterAppearUI"]
	local var1_36 = var0_36:GetObject()

	arg0_36._ob2Pool[var1_36] = var0_36

	return var1_36
end

function var5_0.InstGridmanSkillUI(arg0_37)
	local var0_37 = arg0_37._allPool["UI/combatgridmanskillfloat"]
	local var1_37 = var0_37:GetObject()

	arg0_37._ob2Pool[var1_37] = var0_37

	return var1_37
end

function var5_0.InstPainting(arg0_38, arg1_38)
	local var0_38 = arg0_38.GetPaintingPath(arg1_38)
	local var1_38
	local var2_38 = arg0_38._allPool[var0_38]

	if var2_38 then
		var1_38 = var2_38:GetObject()
		arg0_38._ob2Pool[var1_38] = var2_38
	elseif arg0_38._resCacheList[var0_38] ~= nil then
		var1_38 = Object.Instantiate(arg0_38._resCacheList[var0_38])

		var1_38:SetActive(true)
	end

	return var1_38
end

function var5_0.InstMap(arg0_39, arg1_39)
	local var0_39 = arg0_39.GetMapPath(arg1_39)
	local var1_39
	local var2_39 = arg0_39._allPool[var0_39]

	if var2_39 then
		var1_39 = var2_39:GetObject()
		arg0_39._ob2Pool[var1_39] = var2_39
	elseif arg0_39._resCacheList[var0_39] ~= nil then
		var1_39 = Object.Instantiate(arg0_39._resCacheList[var0_39])
	else
		assert(false, "地图资源没有预加载：" .. arg1_39)
	end

	var1_39:SetActive(true)

	return var1_39
end

function var5_0.InstCardPuzzleCard(arg0_40)
	local var0_40 = arg0_40._allPool["UI/CardTowerCardCombat"]
	local var1_40 = var0_40:GetObject()

	arg0_40._ob2Pool[var1_40] = var0_40

	return var1_40
end

function var5_0.GetCharacterIcon(arg0_41, arg1_41)
	return arg0_41._resCacheList[var5_0.GetHrzIcon(arg1_41)]
end

function var5_0.GetCharacterSquareIcon(arg0_42, arg1_42)
	return arg0_42._resCacheList[var5_0.GetSquareIcon(arg1_42)]
end

function var5_0.GetCharacterQIcon(arg0_43, arg1_43)
	return arg0_43._resCacheList[var5_0.GetQIcon(arg1_43)]
end

function var5_0.GetAircraftIcon(arg0_44, arg1_44)
	return arg0_44._resCacheList[var5_0.GetAircraftIconPath(arg1_44)]
end

function var5_0.GetShipTypeIcon(arg0_45, arg1_45)
	return arg0_45._resCacheList[var5_0.GetShipTypeIconPath(arg1_45)]
end

function var5_0.GetCommanderHrzIcon(arg0_46, arg1_46)
	return arg0_46._resCacheList[var5_0.GetCommanderHrzIconPath(arg1_46)]
end

function var5_0.GetShader(arg0_47, arg1_47)
	return (pg.ShaderMgr.GetInstance():GetShader(var3_0.BATTLE_SHADER[arg1_47]))
end

function var5_0.AddPreloadResource(arg0_48, arg1_48)
	if type(arg1_48) == "string" then
		arg0_48._preloadList[arg1_48] = false
	elseif type(arg1_48) == "table" then
		for iter0_48, iter1_48 in ipairs(arg1_48) do
			arg0_48._preloadList[iter1_48] = false
		end
	end
end

function var5_0.AddPreloadCV(arg0_49, arg1_49)
	local var0_49 = Ship.getCVKeyID(arg1_49)

	if var0_49 > 0 then
		arg0_49._battleCVList[var0_49] = pg.CriMgr.GetBattleCVBankName(var0_49)
	end
end

function var5_0.StartPreload(arg0_50, arg1_50, arg2_50)
	local var0_50 = 0
	local var1_50 = 0

	for iter0_50, iter1_50 in pairs(arg0_50._preloadList) do
		var1_50 = var1_50 + 1
	end

	for iter2_50, iter3_50 in pairs(arg0_50._battleCVList) do
		var1_50 = var1_50 + 1
	end

	local function var2_50()
		if not arg0_50._poolRoot then
			return
		end

		var0_50 = var0_50 + 1

		if var0_50 > var1_50 then
			return
		end

		if arg2_50 then
			arg2_50(var0_50)
		end

		if var0_50 == var1_50 then
			arg0_50._preloadList = nil

			arg1_50()
		end
	end

	for iter4_50, iter5_50 in pairs(arg0_50._battleCVList) do
		pg.CriMgr.GetInstance():LoadBattleCV(iter4_50, var2_50)
	end

	for iter6_50, iter7_50 in pairs(arg0_50._preloadList) do
		local var3_50 = arg0_50.GetResName(iter6_50)

		if var3_50 == "" or arg0_50._resCacheList[iter6_50] ~= nil then
			var2_50()
		elseif string.find(iter6_50, "herohrzicon/") or string.find(iter6_50, "qicon/") or string.find(iter6_50, "squareicon/") or string.find(iter6_50, "commanderhrz/") or string.find(iter6_50, "AircraftIcon/") then
			local var4_50, var5_50 = HXSet.autoHxShiftPath(iter6_50, var3_50)

			ResourceMgr.Inst:getAssetAsync(var4_50, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_52)
				if arg0_52 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					if not arg0_50._poolRoot then
						var4_0.Destroy(arg0_52)

						return
					end

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_52
					end
				end

				var2_50()
			end), true, true)
		elseif string.find(iter6_50, "shiptype/") then
			local var6_50 = string.split(iter6_50, "/")[2]

			ResourceMgr.Inst:getAssetAsync("shiptype", var6_50, typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_53)
				if arg0_53 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					if not arg0_50._poolRoot then
						var4_0.Destroy(arg0_53)

						return
					end

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_53
					end
				end

				var2_50()
			end), true, true)
		elseif string.find(iter6_50, "painting/") then
			local var7_50 = false

			if PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) > 0 then
				var7_50 = checkABExist("painting/" .. var3_50 .. "_n")
			else
				var7_50 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var3_50, 0) ~= 0
			end

			PoolMgr.GetInstance():GetPainting(var3_50 .. (var7_50 and "_n" or ""), true, function(arg0_54)
				if arg0_54 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					if not arg0_50._poolRoot then
						var5_0.ClearPaintingRes(iter6_50, arg0_54)

						return
					end

					ShipExpressionHelper.SetExpression(arg0_54, var3_50)
					arg0_54:SetActive(false)

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_54
					end
				end

				var2_50()
			end)
		elseif string.find(iter6_50, "Char/") then
			arg0_50:LoadSpineAsset(var3_50, function(arg0_55)
				if arg0_55 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					arg0_55 = SpineAnim.AnimChar(var3_50, arg0_55)

					if not arg0_50._poolRoot then
						var5_0.ClearCharRes(iter6_50, arg0_55)

						return
					end

					arg0_55:SetActive(false)

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_55
					end
				end

				arg0_50:InitPool(iter6_50, arg0_55)
				var2_50()
			end)
		elseif string.find(iter6_50, "UI/") then
			LoadAndInstantiateAsync("UI", var3_50, function(arg0_56)
				if arg0_56 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					if not arg0_50._poolRoot then
						var4_0.Destroy(arg0_56)

						return
					end

					arg0_56:SetActive(false)

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_56
					end
				end

				arg0_50:InitPool(iter6_50, arg0_56)
				var2_50()
			end, true, true)
		else
			ResourceMgr.Inst:getAssetAsync(iter6_50, var3_50, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_57)
				if arg0_57 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_50 .. "<<")
				else
					if not arg0_50._poolRoot then
						var4_0.Destroy(arg0_57)

						return
					end

					if arg0_50._resCacheList then
						arg0_50._resCacheList[iter6_50] = arg0_57
					end
				end

				arg0_50:InitPool(iter6_50, arg0_57)
				var2_50()
			end), true, true)
		end
	end

	return var1_50
end

local var6_0 = Vector3(0, 10000, 0)

function var5_0.HideBullet(arg0_58)
	arg0_58.transform.position = var6_0
end

function var5_0.InitParticleSystemCB(arg0_59)
	pg.EffectMgr.GetInstance():CommonEffectEvent(arg0_59)
end

function var5_0.InitPool(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg0_60._poolRoot.transform

	if string.find(arg1_60, "Item/") then
		if arg2_60:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or arg2_60:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			arg0_60._allPool[arg1_60] = pg.Pool.New(arg0_60._bulletContainer.transform, arg2_60, 15, 20, true, false):InitSize()
		else
			local var1_60 = pg.Pool.New(arg0_60._bulletContainer.transform, arg2_60, 20, 20, true, true)

			var1_60:SetRecycleFuncs(var5_0.HideBullet)
			var1_60:InitSize()

			arg0_60._allPool[arg1_60] = var1_60
		end
	elseif string.find(arg1_60, "Effect/") then
		if arg2_60:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			local var2_60 = 5

			if string.find(arg1_60, "smoke") and not string.find(arg1_60, "smokeboom") then
				var2_60 = 30
			elseif string.find(arg1_60, "feijiyingzi") then
				var2_60 = 1
			end

			local var3_60 = pg.Pool.New(var0_60, arg2_60, var2_60, 20, false, false)

			var3_60:SetInitFuncs(var5_0.InitParticleSystemCB)
			var3_60:InitSize()

			arg0_60._allPool[arg1_60] = var3_60
		else
			local var4_60 = 8

			if string.find(arg1_60, "AntiAirArea") or string.find(arg1_60, "AntiSubArea") then
				var4_60 = 1
			end

			GetOrAddComponent(arg2_60, typeof(ParticleSystemEvent))

			local var5_60 = pg.Pool.New(var0_60, arg2_60, var4_60, 20, false, false)

			var5_60:InitSize()

			arg0_60._allPool[arg1_60] = var5_60
		end
	elseif string.find(arg1_60, "Char/") then
		local var6_60 = 1

		if string.find(arg1_60, "danchuan") then
			var6_60 = 3
		end

		local var7_60 = pg.Pool.New(var0_60, arg2_60, var6_60, 20, false, false):InitSize()

		var7_60:SetRecycleFuncs(var5_0.ResetSpineAction)

		arg0_60._allPool[arg1_60] = var7_60
	elseif string.find(arg1_60, "chargo/") then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 3, 20, false, false):InitSize()
	elseif string.find(arg1_60, "orbit/") then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 2, 20, false, false):InitSize()
	elseif arg1_60 == "UI/SkillPainting" then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 1, 20, false, false):InitSize()
	elseif arg1_60 == "UI/MonsterAppearUI" then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 1, 20, false, false):InitSize()
	elseif arg1_60 == "UI/CardTowerCardCombat" then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 7, 20, false, false):InitSize()
	elseif arg1_60 == "UI/combatgridmanskillfloat" then
		arg0_60._allPool[arg1_60] = pg.Pool.New(var0_60, arg2_60, 1, 20, false, false):InitSize()
	elseif arg1_60 == "UI/CombatHPBar" then
		var0_0.Battle.BattleHPBarManager.GetInstance():Init(arg2_60, var0_60)
	elseif arg1_60 == "UI/CombatHPPop" then
		var0_0.Battle.BattlePopNumManager.GetInstance():Init(arg2_60, var0_60)
	end
end

function var5_0.GetRotateScript(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg0_61.rotateScriptMap

	if var0_61[arg1_61] then
		return var0_61[arg1_61]
	end

	local var1_61 = GetOrAddComponent(arg1_61, "BulletRotation")

	var0_61[arg1_61] = var1_61

	return var1_61
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
		var5_0.GetUIPath("CombatHPBar"),
		var5_0.GetUIPath("CombatHPPop")
	}
end

function var5_0.GetDisplayCommonResource()
	return {
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		var5_0.GetFXPath(var0_0.Battle.BattleCharacterFactory.DANCHUAN_MOVE_WAVE_FX_NAME)
	}
end

function var5_0.GetMapResource(arg0_64)
	local var0_64 = {}
	local var1_64 = var0_0.Battle.BattleMap

	for iter0_64, iter1_64 in ipairs(var1_64.LAYERS) do
		local var2_64 = var1_64.GetMapResNames(arg0_64, iter1_64)

		for iter2_64, iter3_64 in ipairs(var2_64) do
			var0_64[#var0_64 + 1] = var5_0.GetMapPath(iter3_64)
		end
	end

	return var0_64
end

function var5_0.GetBuffResource()
	local var0_65 = {}
	local var1_65 = require("buffFXPreloadList")

	for iter0_65, iter1_65 in ipairs(var1_65) do
		var0_65[#var0_65 + 1] = var5_0.GetFXPath(iter1_65)
	end

	return var0_65
end

function var5_0.GetShipResource(arg0_66, arg1_66, arg2_66)
	local var0_66 = {}
	local var1_66 = var1_0.GetPlayerShipTmpDataFromID(arg0_66)

	if arg1_66 == nil or arg1_66 == 0 then
		arg1_66 = var1_66.skin_id
	end

	local var2_66 = var1_0.GetPlayerShipSkinDataFromID(arg1_66)

	var0_66[#var0_66 + 1] = var5_0.GetCharacterPath(var2_66.prefab)
	var0_66[#var0_66 + 1] = var5_0.GetHrzIcon(var2_66.painting)
	var0_66[#var0_66 + 1] = var5_0.GetQIcon(var2_66.painting)
	var0_66[#var0_66 + 1] = var5_0.GetSquareIcon(var2_66.painting)

	if arg2_66 and var1_0.GetShipTypeTmp(var1_66.type).team_type == TeamType.Main then
		var0_66[#var0_66 + 1] = var5_0.GetPaintingPath(var2_66.painting)
	end

	return var0_66
end

function var5_0.GetEnemyResource(arg0_67)
	local var0_67 = {}
	local var1_67 = arg0_67.monsterTemplateID
	local var2_67 = arg0_67.bossData ~= nil
	local var3_67 = arg0_67.buffList or {}
	local var4_67 = arg0_67.phase or {}
	local var5_67 = var1_0.GetMonsterTmpDataFromID(var1_67)

	var0_67[#var0_67 + 1] = var5_0.GetCharacterPath(var5_67.prefab)
	var0_67[#var0_67 + 1] = var5_0.GetFXPath(var5_67.wave_fx)

	if var5_67.fog_fx then
		var0_67[#var0_67 + 1] = var5_0.GetFXPath(var5_67.fog_fx)
	end

	for iter0_67, iter1_67 in ipairs(var5_67.appear_fx) do
		var0_67[#var0_67 + 1] = var5_0.GetFXPath(iter1_67)
	end

	for iter2_67, iter3_67 in ipairs(var5_67.smoke) do
		local var6_67 = iter3_67[2]

		for iter4_67, iter5_67 in ipairs(var6_67) do
			var0_67[#var0_67 + 1] = var5_0.GetFXPath(iter5_67[1])
		end
	end

	if arg0_67.deadFX then
		var0_67[#var0_67 + 1] = var5_0.GetFXPath(arg0_67.deadFX)
	end

	if type(var5_67.bubble_fx) == "table" then
		var0_67[#var0_67 + 1] = var5_0.GetFXPath(var5_67.bubble_fx[1])
	end

	local function var7_67(arg0_68)
		local var0_68 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg0_68, 1)

		for iter0_68, iter1_68 in pairs(var0_68.effect_list) do
			local var1_68 = iter1_68.arg_list.skill_id

			if var1_68 then
				local var2_68 = var0_0.Battle.BattleDataFunction.GetSkillTemplate(var1_68).painting

				if var2_68 == 1 then
					var0_67[#var0_67 + 1] = var5_0.GetHrzIcon(var5_67.icon)
				elseif type(var2_68) == "string" then
					var0_67[#var0_67 + 1] = var5_0.GetHrzIcon(var2_68)
				end
			end

			local var3_68 = iter1_68.arg_list.buff_id

			if var3_68 then
				var7_67(var3_68)
			end
		end
	end

	for iter6_67, iter7_67 in ipairs(var3_67) do
		var7_67(iter7_67)
	end

	for iter8_67, iter9_67 in ipairs(var4_67) do
		if iter9_67.addBuff then
			for iter10_67, iter11_67 in ipairs(iter9_67.addBuff) do
				var7_67(iter11_67)
			end
		end
	end

	if var2_67 then
		var0_67[#var0_67 + 1] = var5_0.GetSquareIcon(var5_67.icon)
	end

	return var0_67
end

function var5_0.GetWeaponResource(arg0_69, arg1_69)
	local var0_69 = {}

	if arg0_69 == -1 then
		return var0_69
	end

	local var1_69 = var1_0.GetWeaponPropertyDataFromID(arg0_69)

	if var1_69.type == var2_0.EquipmentType.MAIN_CANNON or var1_69.type == var2_0.EquipmentType.SUB_CANNON or var1_69.type == var2_0.EquipmentType.TORPEDO or var1_69.type == var2_0.EquipmentType.ANTI_AIR or var1_69.type == var2_0.EquipmentType.ANTI_SEA or var1_69.type == var2_0.EquipmentType.POINT_HIT_AND_LOCK or var1_69.type == var2_0.EquipmentType.MANUAL_METEOR or var1_69.type == var2_0.EquipmentType.BOMBER_PRE_CAST_ALERT or var1_69.type == var2_0.EquipmentType.DEPTH_CHARGE or var1_69.type == var2_0.EquipmentType.MANUAL_TORPEDO or var1_69.type == var2_0.EquipmentType.DISPOSABLE_TORPEDO or var1_69.type == var2_0.EquipmentType.MANUAL_AAMISSILE or var1_69.type == var2_0.EquipmentType.BEAM or var1_69.type == var2_0.EquipmentType.SPACE_LASER or var1_69.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR or var1_69.type == var2_0.EquipmentType.MANUAL_MISSILE or var1_69.type == var2_0.EquipmentType.AUTO_MISSILE or var1_69.type == var2_0.EquipmentType.MISSILE then
		for iter0_69, iter1_69 in ipairs(var1_69.bullet_ID) do
			local var2_69 = var5_0.GetBulletResource(iter1_69, arg1_69)

			for iter2_69, iter3_69 in ipairs(var2_69) do
				var0_69[#var0_69 + 1] = iter3_69
			end
		end
	elseif var1_69.type == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or var1_69.type == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		var0_69 = var5_0.GetAircraftResource(arg0_69, nil, arg1_69)
	elseif var1_69.type == var2_0.EquipmentType.PREVIEW_ARICRAFT then
		for iter4_69, iter5_69 in ipairs(var1_69.bullet_ID) do
			var0_69 = var5_0.GetAircraftResource(iter5_69, nil, arg1_69)
		end
	end

	if var1_69.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR then
		local var3_69 = var5_0.GetBulletResource(var3_0.AntiAirConfig.RangeBulletID)

		for iter6_69, iter7_69 in ipairs(var3_69) do
			var0_69[#var0_69 + 1] = iter7_69
		end
	end

	local var4_69

	if arg1_69 and arg1_69 ~= 0 then
		var4_69 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_69)
	end

	if var4_69 and var4_69.fire_fx_name ~= "" then
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(var4_69.fire_fx_name)
	else
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(var1_69.fire_fx)
	end

	if var1_69.precast_param.fx then
		var0_69[#var0_69 + 1] = var5_0.GetFXPath(var1_69.precast_param.fx)
	end

	if var4_69 then
		local var5_69 = var4_69.orbit_combat

		if var5_69 ~= "" then
			var0_69[#var0_69 + 1] = var5_0.GetOrbitPath(var5_69)
		end
	end

	return var0_69
end

function var5_0.GetEquipResource(arg0_70, arg1_70, arg2_70)
	local var0_70 = {}

	if arg1_70 ~= 0 then
		local var1_70 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_70)
		local var2_70 = var1_70.ship_skin_id

		if var2_70 ~= 0 then
			local var3_70 = var0_0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(var2_70)

			var0_70[#var0_70 + 1] = var5_0.GetCharacterPath(var3_70.prefab)
		end

		local var4_70 = var1_70.orbit_combat

		if var4_70 ~= "" then
			var0_70[#var0_70 + 1] = var5_0.GetOrbitPath(var4_70)
		end
	end

	local var5_70 = var0_0.Battle.BattleDataFunction.GetWeaponDataFromID(arg0_70)
	local var6_70 = var5_70.weapon_id

	for iter0_70, iter1_70 in ipairs(var6_70) do
		local var7_70 = var5_0.GetWeaponResource(iter1_70)

		for iter2_70, iter3_70 in ipairs(var7_70) do
			var0_70[#var0_70 + 1] = iter3_70
		end
	end

	local var8_70 = var5_70.skill_id

	for iter4_70, iter5_70 in ipairs(var8_70) do
		iter5_70 = arg2_70 and var0_0.Battle.BattleDataFunction.SkillTranform(arg2_70, iter5_70) or iter5_70

		local var9_70 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_70, 1, {})

		for iter6_70, iter7_70 in ipairs(var9_70) do
			var0_70[#var0_70 + 1] = iter7_70
		end
	end

	return var0_70
end

function var5_0.GetBulletResource(arg0_71, arg1_71)
	local var0_71 = {}
	local var1_71

	if arg1_71 ~= nil and arg1_71 ~= 0 then
		var1_71 = var1_0.GetEquipSkinDataFromID(arg1_71)
	end

	local var2_71 = var1_0.GetBulletTmpDataFromID(arg0_71)
	local var3_71

	if var1_71 then
		var3_71 = var1_71.bullet_name

		if var1_71.mirror == 1 then
			var0_71[#var0_71 + 1] = var5_0.GetBulletPath(var3_71 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		var3_71 = var2_71.modle_ID
	end

	if var2_71.type == var2_0.BulletType.BEAM or var2_71.type == var2_0.BulletType.SPACE_LASER or var2_71.type == var2_0.BulletType.MISSILE or var2_71.type == var2_0.BulletType.ELECTRIC_ARC then
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(var2_71.modle_ID)
	else
		var0_71[#var0_71 + 1] = var5_0.GetBulletPath(var3_71)
	end

	if var2_71.extra_param.mirror then
		var0_71[#var0_71 + 1] = var5_0.GetBulletPath(var3_71 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
	end

	local var4_71

	if var1_71 and var1_71.hit_fx_name ~= "" then
		var4_71 = var1_71.hit_fx_name
	else
		var4_71 = var2_71.hit_fx
	end

	var0_71[#var0_71 + 1] = var5_0.GetFXPath(var4_71)
	var0_71[#var0_71 + 1] = var5_0.GetFXPath(var2_71.miss_fx)
	var0_71[#var0_71 + 1] = var5_0.GetFXPath(var2_71.alert_fx)

	if var2_71.extra_param.area_FX then
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(var2_71.extra_param.area_FX)
	end

	if var2_71.extra_param.shrapnel then
		for iter0_71, iter1_71 in ipairs(var2_71.extra_param.shrapnel) do
			local var5_71 = var5_0.GetBulletResource(iter1_71.bullet_ID)

			for iter2_71, iter3_71 in ipairs(var5_71) do
				var0_71[#var0_71 + 1] = iter3_71
			end
		end
	end

	for iter4_71, iter5_71 in ipairs(var2_71.attach_buff) do
		if iter5_71.effect_id then
			var0_71[#var0_71 + 1] = var5_0.GetFXPath(iter5_71.effect_id)
		end

		if iter5_71.buff_id then
			local var6_71 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_71.buff_id, 1, {})

			for iter6_71, iter7_71 in ipairs(var6_71) do
				var0_71[#var0_71 + 1] = iter7_71
			end
		end
	end

	return var0_71
end

function var5_0.GetAircraftResource(arg0_72, arg1_72, arg2_72)
	local var0_72 = {}

	arg2_72 = arg2_72 or 0

	local var1_72 = var1_0.GetAircraftTmpDataFromID(arg0_72)
	local var2_72
	local var3_72
	local var4_72
	local var5_72

	if arg2_72 ~= 0 then
		local var6_72, var7_72, var8_72

		var2_72, var6_72, var7_72, var8_72 = var1_0.GetEquipSkin(arg2_72)

		if var6_72 ~= "" then
			var0_72[#var0_72 + 1] = var5_0.GetBulletPath(var6_72)
		end

		if var7_72 ~= "" then
			var0_72[#var0_72 + 1] = var5_0.GetBulletPath(var7_72)
		end

		if var8_72 ~= "" then
			var0_72[#var0_72 + 1] = var5_0.GetBulletPath(var8_72)
		end
	else
		var2_72 = var1_72.model_ID
	end

	var0_72[#var0_72 + 1] = var5_0.GetCharacterGoPath(var2_72)
	var0_72[#var0_72 + 1] = var5_0.GetAircraftIconPath(var1_72.model_ID)

	local var9_72 = arg1_72 or var1_72.weapon_ID

	if type(var9_72) == "table" then
		for iter0_72, iter1_72 in ipairs(var9_72) do
			local var10_72 = var5_0.GetWeaponResource(iter1_72)

			for iter2_72, iter3_72 in ipairs(var10_72) do
				var0_72[#var0_72 + 1] = iter3_72
			end
		end
	else
		local var11_72 = var5_0.GetWeaponResource(var9_72)

		for iter4_72, iter5_72 in ipairs(var11_72) do
			var0_72[#var0_72 + 1] = iter5_72
		end
	end

	return var0_72
end

function var5_0.GetCommanderResource(arg0_73)
	local var0_73 = {}
	local var1_73 = arg0_73[1]

	var0_73[#var0_73 + 1] = var5_0.GetCommanderHrzIconPath(var1_73:getPainting())

	local var2_73 = var1_73:getSkills()[1]:getLevel()

	for iter0_73, iter1_73 in ipairs(arg0_73[2]) do
		local var3_73 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_73, var2_73, {})

		for iter2_73, iter3_73 in ipairs(var3_73) do
			var0_73[#var0_73 + 1] = iter3_73
		end
	end

	return var0_73
end

function var5_0.GetStageResource(arg0_74)
	local var0_74 = var0_0.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0_74)
	local var1_74 = {}
	local var2_74 = {}

	for iter0_74, iter1_74 in ipairs(var0_74.stages) do
		for iter2_74, iter3_74 in ipairs(iter1_74.waves) do
			if iter3_74.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter4_74, iter5_74 in ipairs(iter3_74.spawn) do
					local var3_74 = var5_0.GetMonsterRes(iter5_74)

					for iter6_74, iter7_74 in ipairs(var3_74) do
						table.insert(var1_74, iter7_74)
					end
				end

				if iter3_74.reinforcement then
					for iter8_74, iter9_74 in ipairs(iter3_74.reinforcement) do
						local var4_74 = var5_0.GetMonsterRes(iter9_74)

						for iter10_74, iter11_74 in ipairs(var4_74) do
							table.insert(var1_74, iter11_74)
						end
					end
				end
			elseif iter3_74.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.AID then
				local var5_74 = iter3_74.triggerParams.vanguard_unitList
				local var6_74 = iter3_74.triggerParams.main_unitList
				local var7_74 = iter3_74.triggerParams.sub_unitList

				local function var8_74(arg0_75)
					local var0_75 = var5_0.GetAidUnitsRes(arg0_75)

					for iter0_75, iter1_75 in ipairs(var0_75) do
						table.insert(var1_74, iter1_75)
					end

					for iter2_75, iter3_75 in ipairs(arg0_75) do
						var2_74[#var2_74 + 1] = iter3_75.skinId
					end
				end

				if var5_74 then
					var8_74(var5_74)
				end

				if var6_74 then
					var8_74(var6_74)
				end

				if var7_74 then
					var8_74(var7_74)
				end
			elseif iter3_74.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for iter12_74, iter13_74 in ipairs(iter3_74.spawn) do
					var5_0.GetEnvironmentRes(var1_74, iter13_74)
				end
			elseif iter3_74.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.CARD_PUZZLE then
				local var9_74 = var0_0.Battle.BattleDataFunction.GetCardRes(iter3_74.triggerParams.card_id)

				for iter14_74, iter15_74 in ipairs(var9_74) do
					table.insert(var1_74, iter15_74)
				end
			end

			if iter3_74.airFighter ~= nil then
				for iter16_74, iter17_74 in pairs(iter3_74.airFighter) do
					local var10_74 = var5_0.GetAircraftResource(iter17_74.templateID, iter17_74.weaponID)

					for iter18_74, iter19_74 in ipairs(var10_74) do
						var1_74[#var1_74 + 1] = iter19_74
					end
				end
			end
		end
	end

	return var1_74, var2_74
end

function var5_0.GetEnvironmentRes(arg0_76, arg1_76)
	table.insert(arg0_76, arg1_76.prefab and var5_0.GetFXPath(arg1_76.prefab))

	local var0_76 = arg1_76.behaviours
	local var1_76 = var0_0.Battle.BattleDataFunction.GetEnvironmentBehaviour(var0_76).behaviour_list

	for iter0_76, iter1_76 in ipairs(var1_76) do
		local var2_76 = iter1_76.type

		if var2_76 == var0_0.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			local var3_76 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_76.buff_id, 1, {})

			for iter2_76, iter3_76 in ipairs(var3_76) do
				arg0_76[#arg0_76 + 1] = iter3_76
			end
		elseif var2_76 == var0_0.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			local var4_76 = iter1_76.content and iter1_76.content.alert and iter1_76.content.alert.alert_fx

			table.insert(arg0_76, var4_76 and var5_0.GetFXPath(var4_76))

			local var5_76 = iter1_76.content and iter1_76.content.child_prefab

			if var5_76 then
				var5_0.GetEnvironmentRes(arg0_76, var5_76)
			end
		elseif var2_76 == var0_0.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			arg0_76[#arg0_76 + 1] = var5_0.GetFXPath(iter1_76.FX_ID)
		end
	end
end

function var5_0.GetMonsterRes(arg0_77)
	local var0_77 = {}
	local var1_77 = var5_0.GetEnemyResource(arg0_77)

	for iter0_77, iter1_77 in ipairs(var1_77) do
		var0_77[#var0_77 + 1] = iter1_77
	end

	local var2_77 = var0_0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0_77.monsterTemplateID)
	local var3_77 = Clone(var2_77.equipment_list)
	local var4_77 = var2_77.buff_list
	local var5_77 = Clone(arg0_77.buffList) or {}

	if arg0_77.phase then
		for iter2_77, iter3_77 in ipairs(arg0_77.phase) do
			if iter3_77.addWeapon then
				for iter4_77, iter5_77 in ipairs(iter3_77.addWeapon) do
					var3_77[#var3_77 + 1] = iter5_77
				end
			end

			if iter3_77.addRandomWeapon then
				for iter6_77, iter7_77 in ipairs(iter3_77.addRandomWeapon) do
					for iter8_77, iter9_77 in ipairs(iter7_77) do
						var3_77[#var3_77 + 1] = iter9_77
					end
				end
			end

			if iter3_77.addBuff then
				for iter10_77, iter11_77 in ipairs(iter3_77.addBuff) do
					var5_77[#var5_77 + 1] = iter11_77
				end
			end
		end
	end

	for iter12_77, iter13_77 in ipairs(var4_77) do
		local var6_77 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter13_77.ID, iter13_77.LV, {})

		for iter14_77, iter15_77 in ipairs(var6_77) do
			var0_77[#var0_77 + 1] = iter15_77
		end
	end

	for iter16_77, iter17_77 in ipairs(var5_77) do
		local var7_77 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter17_77, 1, {})

		for iter18_77, iter19_77 in ipairs(var7_77) do
			var0_77[#var0_77 + 1] = iter19_77
		end

		local var8_77 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(iter17_77, 1)

		for iter20_77, iter21_77 in pairs(var8_77.effect_list) do
			local var9_77 = iter21_77.arg_list.skill_id

			if var9_77 and var0_0.Battle.BattleDataFunction.NeedSkillPainting(var9_77) then
				var0_77[#var0_77 + 1] = var5_0.GetPaintingPath(var1_0.GetMonsterTmpDataFromID(arg0_77.monsterTemplateID).icon)

				break
			end
		end
	end

	for iter22_77, iter23_77 in ipairs(var3_77) do
		local var10_77 = var5_0.GetWeaponResource(iter23_77)

		for iter24_77, iter25_77 in ipairs(var10_77) do
			var0_77[#var0_77 + 1] = iter25_77
		end
	end

	return var0_77
end

function var5_0.GetEquipSkinPreviewRes(arg0_78)
	local var0_78 = {}
	local var1_78 = var1_0.GetEquipSkinDataFromID(arg0_78)

	for iter0_78, iter1_78 in ipairs(var1_78.weapon_ids) do
		local var2_78 = var5_0.GetWeaponResource(iter1_78)

		for iter2_78, iter3_78 in ipairs(var2_78) do
			var0_78[#var0_78 + 1] = iter3_78
		end
	end

	local function var3_78(arg0_79)
		if arg0_79 ~= "" then
			var0_78[#var0_78 + 1] = var5_0.GetBulletPath(arg0_79)
		end
	end

	local var4_78, var5_78, var6_78, var7_78, var8_78, var9_78 = var1_0.GetEquipSkin(arg0_78)

	if _.any(EquipType.AirProtoEquipTypes, function(arg0_80)
		return table.contains(var1_78.equip_type, arg0_80)
	end) then
		var0_78[#var0_78 + 1] = var5_0.GetCharacterGoPath(var4_78)
	else
		var0_78[#var0_78 + 1] = var5_0.GetBulletPath(var4_78)
	end

	var3_78(var5_78)
	var3_78(var6_78)
	var3_78(var7_78)

	if var8_78 and var8_78 ~= "" then
		var0_78[#var0_78 + 1] = var5_0.GetFXPath(var8_78)
	end

	if var9_78 and var9_78 ~= "" then
		var0_78[#var0_78 + 1] = var5_0.GetFXPath(var9_78)
	end

	return var0_78
end

function var5_0.GetEquipSkinBulletRes(arg0_81)
	local var0_81 = {}
	local var1_81, var2_81, var3_81, var4_81 = var1_0.GetEquipSkin(arg0_81)

	local function var5_81(arg0_82)
		if arg0_82 ~= "" then
			var0_81[#var0_81 + 1] = var5_0.GetBulletPath(arg0_82)
		end
	end

	local var6_81 = var1_0.GetEquipSkinDataFromID(arg0_81)
	local var7_81 = false

	for iter0_81, iter1_81 in ipairs(var6_81.equip_type) do
		if table.contains(EquipType.AircraftSkinType, iter1_81) then
			var7_81 = true
		end
	end

	if var7_81 then
		if var1_81 ~= "" then
			var0_81[#var0_81 + 1] = var5_0.GetCharacterGoPath(var1_81)
		end
	else
		var5_81(var1_81)

		if var1_0.GetEquipSkinDataFromID(arg0_81).mirror == 1 then
			var0_81[#var0_81 + 1] = var5_0.GetBulletPath(var1_81 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	var5_81(var2_81)
	var5_81(var3_81)
	var5_81(var4_81)

	return var0_81
end

function var5_0.GetAidUnitsRes(arg0_83)
	local var0_83 = {}

	for iter0_83, iter1_83 in ipairs(arg0_83) do
		local var1_83 = var5_0.GetShipResource(iter1_83.tmpID, nil, true)

		for iter2_83, iter3_83 in ipairs(iter1_83.equipment) do
			if iter3_83 ~= 0 then
				if iter2_83 <= Ship.WEAPON_COUNT then
					local var2_83 = var1_0.GetWeaponDataFromID(iter3_83).weapon_id

					for iter4_83, iter5_83 in ipairs(var2_83) do
						local var3_83 = var5_0.GetWeaponResource(iter5_83)

						for iter6_83, iter7_83 in ipairs(var3_83) do
							table.insert(var1_83, iter7_83)
						end
					end
				else
					local var4_83 = var5_0.GetEquipResource(iter3_83)

					for iter8_83, iter9_83 in ipairs(var4_83) do
						table.insert(var1_83, iter9_83)
					end
				end
			end
		end

		for iter10_83, iter11_83 in ipairs(var1_83) do
			table.insert(var0_83, iter11_83)
		end
	end

	return var0_83
end

function var5_0.GetSpWeaponResource(arg0_84, arg1_84)
	local var0_84 = {}
	local var1_84 = var0_0.Battle.BattleDataFunction.GetSpWeaponDataFromID(arg0_84).effect_id

	if var1_84 ~= 0 then
		var1_84 = arg1_84 and var0_0.Battle.BattleDataFunction.SkillTranform(arg1_84, var1_84) or var1_84

		local var2_84 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var1_84, 1, {})

		for iter0_84, iter1_84 in ipairs(var2_84) do
			var0_84[#var0_84 + 1] = iter1_84
		end
	end

	return var0_84
end
