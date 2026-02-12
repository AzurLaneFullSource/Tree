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
		local var5_32 = var4_32:GetComponent(typeof(SpineAnim))
		local var6_32 = var4_32:GetComponent("SkeletonAnimation")
		local var7_32 = "normal"

		if var6_32 then
			var7_32 = SpineAnimUtil.GetCharAnimDirect(var6_32, math.sign(var4_32.localScale.x), "normal")
		end

		var5_32:SetAction(var7_32, 0, false)
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

function var5_0.InstSkillPaintingDALUI(arg0_37)
	local var0_37 = arg0_37._allPool["UI/SkillPaintingDAL"]
	local var1_37 = var0_37:GetObject()

	arg0_37._ob2Pool[var1_37] = var0_37

	return var1_37
end

function var5_0.InstBossWarningUI(arg0_38)
	local var0_38 = arg0_38._allPool["UI/MonsterAppearUI"]
	local var1_38 = var0_38:GetObject()

	arg0_38._ob2Pool[var1_38] = var0_38

	return var1_38
end

function var5_0.InstGridmanSkillUI(arg0_39)
	local var0_39 = arg0_39._allPool["UI/combatgridmanskillfloat"]
	local var1_39 = var0_39:GetObject()

	arg0_39._ob2Pool[var1_39] = var0_39

	return var1_39
end

function var5_0.InstReisalinAPUI(arg0_40)
	local var0_40 = arg0_40._allPool["UI/combatreisalinapui"]
	local var1_40 = var0_40:GetObject()

	arg0_40._ob2Pool[var1_40] = var0_40

	return var1_40
end

function var5_0.InstYumiaManaUI(arg0_41)
	local var0_41 = arg0_41._allPool["UI/combatyumiamanaui"]
	local var1_41 = var0_41:GetObject()

	arg0_41._ob2Pool[var1_41] = var0_41

	return var1_41
end

function var5_0.InstPainting(arg0_42, arg1_42)
	local var0_42 = arg0_42.GetPaintingPath(arg1_42)
	local var1_42
	local var2_42 = arg0_42._allPool[var0_42]

	if var2_42 then
		var1_42 = var2_42:GetObject()
		arg0_42._ob2Pool[var1_42] = var2_42
	elseif arg0_42._resCacheList[var0_42] ~= nil then
		var1_42 = Object.Instantiate(arg0_42._resCacheList[var0_42])

		var1_42:SetActive(true)
	end

	return var1_42
end

function var5_0.InstMap(arg0_43, arg1_43)
	local var0_43 = arg0_43.GetMapPath(arg1_43)
	local var1_43
	local var2_43 = arg0_43._allPool[var0_43]

	if var2_43 then
		var1_43 = var2_43:GetObject()
		arg0_43._ob2Pool[var1_43] = var2_43
	elseif arg0_43._resCacheList[var0_43] ~= nil then
		var1_43 = Object.Instantiate(arg0_43._resCacheList[var0_43])
	else
		assert(false, "地图资源没有预加载：" .. arg1_43)
	end

	var1_43:SetActive(true)

	return var1_43
end

function var5_0.InstCardPuzzleCard(arg0_44)
	local var0_44 = arg0_44._allPool["UI/CardTowerCardCombat"]
	local var1_44 = var0_44:GetObject()

	arg0_44._ob2Pool[var1_44] = var0_44

	return var1_44
end

function var5_0.GetCharacterIcon(arg0_45, arg1_45)
	return arg0_45._resCacheList[var5_0.GetHrzIcon(arg1_45)]
end

function var5_0.GetCharacterSquareIcon(arg0_46, arg1_46)
	return arg0_46._resCacheList[var5_0.GetSquareIcon(arg1_46)]
end

function var5_0.GetCharacterQIcon(arg0_47, arg1_47)
	return arg0_47._resCacheList[var5_0.GetQIcon(arg1_47)]
end

function var5_0.GetAircraftIcon(arg0_48, arg1_48)
	return arg0_48._resCacheList[var5_0.GetAircraftIconPath(arg1_48)]
end

function var5_0.GetShipTypeIcon(arg0_49, arg1_49)
	return arg0_49._resCacheList[var5_0.GetShipTypeIconPath(arg1_49)]
end

function var5_0.GetCommanderHrzIcon(arg0_50, arg1_50)
	return arg0_50._resCacheList[var5_0.GetCommanderHrzIconPath(arg1_50)]
end

function var5_0.GetCommanderIcon(arg0_51, arg1_51)
	return arg0_51._resCacheList[var5_0.GetCommanderIconPath(arg1_51)]
end

function var5_0.GetShader(arg0_52, arg1_52)
	return (pg.ShaderMgr.GetInstance():GetShader(var3_0.BATTLE_SHADER[arg1_52]))
end

function var5_0.AddPreloadResource(arg0_53, arg1_53)
	if type(arg1_53) == "string" then
		arg0_53._preloadList[arg1_53] = false
	elseif type(arg1_53) == "table" then
		for iter0_53, iter1_53 in ipairs(arg1_53) do
			arg0_53._preloadList[iter1_53] = false
		end
	end
end

function var5_0.AddPreloadCV(arg0_54, arg1_54)
	local var0_54 = Ship.getCVKeyID(arg1_54)

	if var0_54 > 0 then
		arg0_54._battleCVList[var0_54] = pg.CriMgr.GetBattleCVBankName(var0_54)
	end
end

function var5_0.StartPreload(arg0_55, arg1_55, arg2_55)
	local var0_55 = 0
	local var1_55 = 0

	for iter0_55, iter1_55 in pairs(arg0_55._preloadList) do
		var1_55 = var1_55 + 1
	end

	for iter2_55, iter3_55 in pairs(arg0_55._battleCVList) do
		var1_55 = var1_55 + 1
	end

	local function var2_55()
		if not arg0_55._poolRoot then
			return
		end

		var0_55 = var0_55 + 1

		if var0_55 > var1_55 then
			return
		end

		if arg2_55 then
			arg2_55(var0_55)
		end

		if var0_55 == var1_55 then
			arg0_55._preloadList = nil

			arg1_55()
		end
	end

	for iter4_55, iter5_55 in pairs(arg0_55._battleCVList) do
		pg.CriMgr.GetInstance():LoadBattleCV(iter4_55, var2_55)
	end

	for iter6_55, iter7_55 in pairs(arg0_55._preloadList) do
		local var3_55 = arg0_55.GetResName(iter6_55)

		if var3_55 == "" or arg0_55._resCacheList[iter6_55] ~= nil then
			var2_55()
		elseif string.find(iter6_55, "herohrzicon/") or string.find(iter6_55, "qicon/") or string.find(iter6_55, "squareicon/") or string.find(iter6_55, "commanderhrz/") or string.find(iter6_55, "commandericon/") or string.find(iter6_55, "AircraftIcon/") then
			local var4_55, var5_55 = HXSet.autoHxShiftPath(iter6_55, var3_55)

			ResourceMgr.Inst:getAssetAsync(var4_55, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_57)
				if arg0_57 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					if not arg0_55._poolRoot then
						var4_0.Destroy(arg0_57)

						return
					end

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_57
					end
				end

				var2_55()
			end), true, true)
		elseif string.find(iter6_55, "shiptype/") then
			local var6_55 = string.split(iter6_55, "/")[2]

			GetSpriteFromAtlasAsync("shiptype", var6_55, function(arg0_58)
				if arg0_58 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					if not arg0_55._poolRoot then
						var4_0.Destroy(arg0_58)

						return
					end

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_58
					end
				end

				var2_55()
			end)
		elseif string.find(iter6_55, "painting/") then
			PoolMgr.GetInstance():GetPainting(var5_0.GetPaintingName(var3_55), true, function(arg0_59)
				if arg0_59 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					if not arg0_55._poolRoot then
						var5_0.ClearPaintingRes(iter6_55, arg0_59)

						return
					end

					ShipExpressionHelper.SetExpression(arg0_59, var3_55)
					arg0_59:SetActive(false)

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_59
					end
				end

				var2_55()
			end)
		elseif string.find(iter6_55, "Char/") then
			arg0_55:LoadSpineAsset(var3_55, function(arg0_60)
				if arg0_60 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					arg0_60 = SpineAnim.AnimChar(var3_55, arg0_60)

					if not arg0_55._poolRoot then
						var5_0.ClearCharRes(iter6_55, arg0_60)

						return
					end

					arg0_60:SetActive(false)

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_60
					end
				end

				arg0_55:InitPool(iter6_55, arg0_60)
				var2_55()
			end)
		elseif string.find(iter6_55, "UI/") then
			LoadAndInstantiateAsync("UI", var3_55, function(arg0_61)
				if arg0_61 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					if not arg0_55._poolRoot then
						var4_0.Destroy(arg0_61)

						return
					end

					arg0_61:SetActive(false)

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_61
					end
				end

				arg0_55:InitPool(iter6_55, arg0_61)
				var2_55()
			end, true, true)
		else
			ResourceMgr.Inst:getAssetAsync(iter6_55, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_62)
				if arg0_62 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6_55 .. "<<")
				else
					if not arg0_55._poolRoot then
						var4_0.Destroy(arg0_62)

						return
					end

					if arg0_55._resCacheList then
						arg0_55._resCacheList[iter6_55] = arg0_62
					end
				end

				arg0_55:InitPool(iter6_55, arg0_62)
				var2_55()
			end), true, true)
		end
	end

	return var1_55
end

function var5_0.GetPaintingName(arg0_63)
	local var0_63 = false

	if PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) > 0 then
		var0_63 = checkABExist("painting/" .. arg0_63 .. "_n")
	else
		var0_63 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_63, 0) ~= 0 and checkABExist("painting/" .. arg0_63 .. "_n")
	end

	return arg0_63 .. (var0_63 and "_n" or "")
end

local var6_0 = Vector3(0, 10000, 0)

function var5_0.HideBullet(arg0_64)
	arg0_64.transform.position = var6_0
end

function var5_0.InitParticleSystemCB(arg0_65)
	pg.EffectMgr.GetInstance():CommonEffectEvent(arg0_65)
end

function var5_0.InitPool(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg0_66._poolRoot.transform

	if string.find(arg1_66, "Item/") then
		if arg2_66:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or arg2_66:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			arg0_66._allPool[arg1_66] = pg.Pool.New(arg0_66._bulletContainer.transform, arg2_66, 15, 20, true, false):InitSize()
		else
			local var1_66 = pg.Pool.New(arg0_66._bulletContainer.transform, arg2_66, 20, 20, true, true)

			var1_66:SetRecycleFuncs(var5_0.HideBullet)
			var1_66:InitSize()

			arg0_66._allPool[arg1_66] = var1_66
		end
	elseif string.find(arg1_66, "Effect/") then
		if arg2_66:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			local var2_66 = 5

			if string.find(arg1_66, "smoke") and not string.find(arg1_66, "smokeboom") then
				var2_66 = 30
			elseif string.find(arg1_66, "feijiyingzi") then
				var2_66 = 1
			end

			local var3_66 = pg.Pool.New(var0_66, arg2_66, var2_66, 20, false, false)

			var3_66:SetInitFuncs(var5_0.InitParticleSystemCB)
			var3_66:InitSize()

			arg0_66._allPool[arg1_66] = var3_66
		else
			local var4_66 = 8

			if string.find(arg1_66, "AntiAirArea") or string.find(arg1_66, "AntiSubArea") then
				var4_66 = 1
			end

			GetOrAddComponent(arg2_66, typeof(ParticleSystemEvent))

			local var5_66 = pg.Pool.New(var0_66, arg2_66, var4_66, 20, false, false)

			var5_66:InitSize()

			arg0_66._allPool[arg1_66] = var5_66
		end
	elseif string.find(arg1_66, "Char/") then
		local var6_66 = 1

		if string.find(arg1_66, "danchuan") then
			var6_66 = 3
		end

		local var7_66 = pg.Pool.New(var0_66, arg2_66, var6_66, 20, false, false):InitSize()

		var7_66:SetRecycleFuncs(var5_0.ResetSpineAction)

		arg0_66._allPool[arg1_66] = var7_66
	elseif string.find(arg1_66, "chargo/") then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 3, 20, false, false):InitSize()
	elseif string.find(arg1_66, "orbit/") then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 2, 20, false, false):InitSize()
	elseif arg1_66 == "UI/SkillPainting" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/SkillPaintingDAL" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/MonsterAppearUI" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/CardTowerCardCombat" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 7, 20, false, false):InitSize()
	elseif arg1_66 == "UI/combatgridmanskillfloat" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/combatreisalinapui" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/combatyumiamanaui" then
		arg0_66._allPool[arg1_66] = pg.Pool.New(var0_66, arg2_66, 1, 20, false, false):InitSize()
	elseif arg1_66 == "UI/CombatHPBar" .. var0_0.Battle.BattleState.GetCombatSkinKey() then
		var0_0.Battle.BattleHPBarManager.GetInstance():Init(arg2_66, var0_66)
	elseif string.find(arg1_66, "UI/CombatHPPop") then
		var0_0.Battle.BattlePopNumManager.GetInstance():Init(arg2_66, var0_66)
	end
end

function var5_0.GetRotateScript(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg0_67.rotateScriptMap

	if var0_67[arg1_67] then
		return var0_67[arg1_67]
	end

	local var1_67 = GetOrAddComponent(arg1_67, "BulletRotation")

	var0_67[arg1_67] = var1_67

	return var1_67
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

function var5_0.GetMapResource(arg0_70)
	local var0_70 = {}
	local var1_70 = var0_0.Battle.BattleMap

	for iter0_70, iter1_70 in ipairs(var1_70.LAYERS) do
		local var2_70 = var1_70.GetMapResNames(arg0_70, iter1_70)

		for iter2_70, iter3_70 in ipairs(var2_70) do
			var0_70[#var0_70 + 1] = var5_0.GetMapPath(iter3_70)
		end
	end

	return var0_70
end

function var5_0.GetBuffResource()
	local var0_71 = {}
	local var1_71 = require("buffFXPreloadList")

	for iter0_71, iter1_71 in ipairs(var1_71) do
		var0_71[#var0_71 + 1] = var5_0.GetFXPath(iter1_71)
	end

	return var0_71
end

function var5_0.GetShipResource(arg0_72, arg1_72, arg2_72)
	local var0_72 = {}
	local var1_72 = var1_0.GetPlayerShipTmpDataFromID(arg0_72)

	if arg1_72 == nil or arg1_72 == 0 then
		arg1_72 = var1_72.skin_id
	end

	local var2_72 = var1_0.GetPlayerShipSkinDataFromID(arg1_72)

	var0_72[#var0_72 + 1] = var5_0.GetCharacterPath(var2_72.prefab)
	var0_72[#var0_72 + 1] = var5_0.GetHrzIcon(var2_72.painting)
	var0_72[#var0_72 + 1] = var5_0.GetQIcon(var2_72.painting)

	if table.contains(var3_0.MIRROR_QICON_SHIP_GROUP, var2_72.ship_group) then
		var0_72[#var0_72 + 1] = var5_0.GetQIcon(var2_72.painting .. var3_0.MIRROR_QICON_KEY)
	end

	var0_72[#var0_72 + 1] = var5_0.GetSquareIcon(var2_72.painting)

	if arg2_72 and var1_0.GetShipTypeTmp(var1_72.type).team_type == TeamType.Main then
		var0_72[#var0_72 + 1] = var5_0.GetPaintingPath(var2_72.painting)
	end

	return var0_72
end

function var5_0.GetPlayerShipResource(arg0_73, arg1_73)
	local var0_73 = {}
	local var1_73 = {}
	local var2_73

	for iter0_73, iter1_73 in ipairs(arg0_73) do
		local var3_73 = iter1_73.configId

		table.insert(var1_73, iter1_73.skinId)

		local var4_73 = var5_0.GetShipResource(var3_73, iter1_73.skinId, true)

		for iter2_73, iter3_73 in pairs(var4_73) do
			table.insert(var0_73, iter3_73)
		end

		local var5_73 = var1_0.GetPlayerShipTmpDataFromID(var3_73)

		for iter4_73, iter5_73 in ipairs(iter1_73:getActiveEquipments()) do
			local var6_73
			local var7_73
			local var8_73 = 0

			if not iter5_73 then
				var6_73 = var5_73.default_equip_list[iter4_73]
			else
				var6_73 = iter5_73.configId
				var8_73 = iter5_73.skinId
			end

			if var6_73 then
				local var9_73 = var1_0.GetWeaponDataFromID(var6_73).weapon_id

				if #var9_73 > 0 then
					for iter6_73, iter7_73 in ipairs(var9_73) do
						local var10_73 = var5_0.GetWeaponResource(iter7_73, var8_73)

						for iter8_73, iter9_73 in pairs(var10_73) do
							table.insert(var0_73, iter9_73)
						end
					end
				else
					local var11_73 = var5_0.GetEquipResource(var6_73, var8_73, arg1_73)

					for iter10_73, iter11_73 in pairs(var11_73) do
						table.insert(var0_73, iter11_73)
					end
				end
			end
		end

		local var12_73 = {}

		for iter12_73, iter13_73 in ipairs(var5_73.depth_charge_list) do
			local var13_73 = var1_0.GetWeaponDataFromID(iter13_73).weapon_id

			for iter14_73, iter15_73 in ipairs(var13_73) do
				table.insert(var12_73, iter15_73)
			end
		end

		for iter16_73, iter17_73 in ipairs(var5_73.fix_equip_list) do
			local var14_73 = var1_0.GetWeaponDataFromID(iter17_73).weapon_id

			for iter18_73, iter19_73 in ipairs(var14_73) do
				table.insert(var12_73, iter19_73)
			end
		end

		for iter20_73, iter21_73 in ipairs(var12_73) do
			local var15_73 = var5_0.GetWeaponResource(iter21_73)

			for iter22_73, iter23_73 in pairs(var15_73) do
				table.insert(var0_73, iter23_73)
			end
		end

		local var16_73 = iter1_73.GetSpWeapon and iter1_73:GetSpWeapon()

		if var16_73 then
			local var17_73 = var5_0.GetSpWeaponResource(var16_73:GetConfigID(), arg1_73)

			for iter24_73, iter25_73 in pairs(var17_73) do
				table.insert(var0_73, iter25_73)
			end
		end

		local var18_73 = var1_0.GetBuffBulletRes(var3_73, iter1_73.skills, arg1_73, iter1_73.skinId)

		for iter26_73, iter27_73 in pairs(var18_73) do
			table.insert(var0_73, iter27_73)
		end

		if iter1_73.buffs then
			local var19_73 = var1_0.GetBuffListRes(iter1_73.buffs, arg1_73, iter1_73.skinId)

			for iter28_73, iter29_73 in pairs(var19_73) do
				table.insert(var0_73, iter29_73)
			end
		end
	end

	return var0_73, var1_73
end

function var5_0.GetEnemyResource(arg0_74)
	local var0_74 = {}
	local var1_74 = arg0_74.monsterTemplateID
	local var2_74 = arg0_74.bossData ~= nil
	local var3_74 = arg0_74.buffList or {}
	local var4_74 = arg0_74.phase or {}
	local var5_74 = var1_0.GetMonsterTmpDataFromID(var1_74)

	var0_74[#var0_74 + 1] = var5_0.GetCharacterPath(var5_74.prefab)
	var0_74[#var0_74 + 1] = var5_0.GetFXPath(var5_74.wave_fx)

	if var5_74.fog_fx then
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(var5_74.fog_fx)
	end

	for iter0_74, iter1_74 in ipairs(var5_74.appear_fx) do
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(iter1_74)
	end

	for iter2_74, iter3_74 in ipairs(var5_74.smoke) do
		local var6_74 = iter3_74[2]

		for iter4_74, iter5_74 in ipairs(var6_74) do
			var0_74[#var0_74 + 1] = var5_0.GetFXPath(iter5_74[1])
		end
	end

	if arg0_74.deadFX then
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(arg0_74.deadFX)
	end

	if type(var5_74.bubble_fx) == "table" then
		var0_74[#var0_74 + 1] = var5_0.GetFXPath(var5_74.bubble_fx[1])
	end

	local function var7_74(arg0_75)
		local var0_75 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg0_75, 1)

		for iter0_75, iter1_75 in pairs(var0_75.effect_list) do
			local var1_75 = iter1_75.arg_list.skill_id

			if var1_75 then
				local var2_75 = var0_0.Battle.BattleDataFunction.GetSkillTemplate(var1_75).painting

				if var2_75 == 1 then
					var0_74[#var0_74 + 1] = var5_0.GetHrzIcon(var5_74.icon)
					var0_74[#var0_74 + 1] = var5_0.GetSquareIcon(var5_74.icon)
				elseif type(var2_75) == "string" then
					var0_74[#var0_74 + 1] = var5_0.GetHrzIcon(var2_75)
					var0_74[#var0_74 + 1] = var5_0.GetSquareIcon(var2_75)
				end
			end

			local var3_75 = iter1_75.arg_list.buff_id

			if var3_75 then
				var7_74(var3_75)
			end
		end
	end

	for iter6_74, iter7_74 in ipairs(var3_74) do
		var7_74(iter7_74)
	end

	for iter8_74, iter9_74 in ipairs(var4_74) do
		if iter9_74.addBuff then
			for iter10_74, iter11_74 in ipairs(iter9_74.addBuff) do
				var7_74(iter11_74)
			end
		end
	end

	if var2_74 then
		var0_74[#var0_74 + 1] = var5_0.GetSquareIcon(var5_74.icon)
	end

	return var0_74
end

function var5_0.GetWeaponResource(arg0_76, arg1_76)
	local var0_76 = {}

	if arg0_76 == -1 then
		return var0_76
	end

	local var1_76 = var1_0.GetWeaponPropertyDataFromID(arg0_76)

	if var1_76.type == var2_0.EquipmentType.MAIN_CANNON or var1_76.type == var2_0.EquipmentType.SUB_CANNON or var1_76.type == var2_0.EquipmentType.TORPEDO or var1_76.type == var2_0.EquipmentType.ANTI_AIR or var1_76.type == var2_0.EquipmentType.ANTI_SEA or var1_76.type == var2_0.EquipmentType.POINT_HIT_AND_LOCK or var1_76.type == var2_0.EquipmentType.MANUAL_METEOR or var1_76.type == var2_0.EquipmentType.BOMBER_PRE_CAST_ALERT or var1_76.type == var2_0.EquipmentType.DEPTH_CHARGE or var1_76.type == var2_0.EquipmentType.MANUAL_TORPEDO or var1_76.type == var2_0.EquipmentType.DISPOSABLE_TORPEDO or var1_76.type == var2_0.EquipmentType.MANUAL_AAMISSILE or var1_76.type == var2_0.EquipmentType.BEAM or var1_76.type == var2_0.EquipmentType.SPACE_LASER or var1_76.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR or var1_76.type == var2_0.EquipmentType.MANUAL_MISSILE or var1_76.type == var2_0.EquipmentType.AUTO_MISSILE or var1_76.type == var2_0.EquipmentType.MISSILE then
		for iter0_76, iter1_76 in ipairs(var1_76.bullet_ID) do
			local var2_76 = var5_0.GetBulletResource(iter1_76, arg1_76)

			for iter2_76, iter3_76 in ipairs(var2_76) do
				var0_76[#var0_76 + 1] = iter3_76
			end
		end
	elseif var1_76.type == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or var1_76.type == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		var0_76 = var5_0.GetAircraftResource(arg0_76, nil, arg1_76)
	elseif var1_76.type == var2_0.EquipmentType.PREVIEW_ARICRAFT then
		for iter4_76, iter5_76 in ipairs(var1_76.bullet_ID) do
			var0_76 = var5_0.GetAircraftResource(iter5_76, nil, arg1_76)
		end
	end

	if var1_76.type == var2_0.EquipmentType.FLEET_RANGE_ANTI_AIR then
		local var3_76 = var5_0.GetBulletResource(var3_0.AntiAirConfig.RangeBulletID)

		for iter6_76, iter7_76 in ipairs(var3_76) do
			var0_76[#var0_76 + 1] = iter7_76
		end
	end

	local var4_76

	if arg1_76 and arg1_76 ~= 0 then
		var4_76 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_76)
	end

	if var4_76 and var4_76.fire_fx_name ~= "" then
		var0_76[#var0_76 + 1] = var5_0.GetFXPath(var4_76.fire_fx_name)
	else
		var0_76[#var0_76 + 1] = var5_0.GetFXPath(var1_76.fire_fx)
	end

	if var1_76.precast_param.fx then
		var0_76[#var0_76 + 1] = var5_0.GetFXPath(var1_76.precast_param.fx)
	end

	if var4_76 then
		local var5_76 = var4_76.orbit_combat

		if var5_76 ~= "" then
			var0_76[#var0_76 + 1] = var5_0.GetOrbitPath(var5_76)
		end
	end

	return var0_76
end

function var5_0.GetEquipResource(arg0_77, arg1_77, arg2_77)
	local var0_77 = {}

	if arg1_77 ~= 0 then
		local var1_77 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1_77)
		local var2_77 = var1_77.ship_skin_id

		if var2_77 ~= 0 then
			local var3_77 = var0_0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(var2_77)

			var0_77[#var0_77 + 1] = var5_0.GetCharacterPath(var3_77.prefab)
		end

		local var4_77 = var1_77.orbit_combat

		if var4_77 ~= "" then
			var0_77[#var0_77 + 1] = var5_0.GetOrbitPath(var4_77)
		end
	end

	local var5_77 = var0_0.Battle.BattleDataFunction.GetWeaponDataFromID(arg0_77)
	local var6_77 = var5_77.weapon_id

	for iter0_77, iter1_77 in ipairs(var6_77) do
		local var7_77 = var5_0.GetWeaponResource(iter1_77)

		for iter2_77, iter3_77 in ipairs(var7_77) do
			var0_77[#var0_77 + 1] = iter3_77
		end
	end

	local var8_77 = var5_77.skill_id

	for iter4_77, iter5_77 in ipairs(var8_77) do
		local var9_77 = arg2_77 and var0_0.Battle.BattleDataFunction.SkillTranform(arg2_77, iter5_77[1]) or iter5_77[1]
		local var10_77 = iter5_77[2] or 1
		local var11_77 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var9_77, var10_77, {})

		for iter6_77, iter7_77 in ipairs(var11_77) do
			var0_77[#var0_77 + 1] = iter7_77
		end
	end

	return var0_77
end

function var5_0.GetBulletResource(arg0_78, arg1_78)
	local var0_78 = {}
	local var1_78

	if arg1_78 ~= nil and arg1_78 ~= 0 then
		var1_78 = var1_0.GetEquipSkinDataFromID(arg1_78)
	end

	local var2_78 = var1_0.GetBulletTmpDataFromID(arg0_78)
	local var3_78

	if var1_78 then
		var3_78 = var1_78.bullet_name

		if var1_78.mirror == 1 then
			var0_78[#var0_78 + 1] = var5_0.GetBulletPath(var3_78 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		var3_78 = var2_78.modle_ID
	end

	if var2_78.type == var2_0.BulletType.BEAM or var2_78.type == var2_0.BulletType.SPACE_LASER or var2_78.type == var2_0.BulletType.MISSILE or var2_78.type == var2_0.BulletType.ELECTRIC_ARC then
		var0_78[#var0_78 + 1] = var5_0.GetFXPath(var2_78.modle_ID)
	else
		var0_78[#var0_78 + 1] = var5_0.GetBulletPath(var3_78)
	end

	if var2_78.extra_param.mirror then
		var0_78[#var0_78 + 1] = var5_0.GetBulletPath(var3_78 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
	end

	local var4_78

	if var1_78 and var1_78.hit_fx_name ~= "" then
		var4_78 = var1_78.hit_fx_name
	else
		var4_78 = var2_78.hit_fx
	end

	var0_78[#var0_78 + 1] = var5_0.GetFXPath(var4_78)
	var0_78[#var0_78 + 1] = var5_0.GetFXPath(var2_78.miss_fx)
	var0_78[#var0_78 + 1] = var5_0.GetFXPath(var2_78.alert_fx)

	if var2_78.extra_param.area_FX then
		var0_78[#var0_78 + 1] = var5_0.GetFXPath(var2_78.extra_param.area_FX)
	end

	if var2_78.extra_param.shrapnel then
		for iter0_78, iter1_78 in ipairs(var2_78.extra_param.shrapnel) do
			local var5_78 = var5_0.GetBulletResource(iter1_78.bullet_ID)

			for iter2_78, iter3_78 in ipairs(var5_78) do
				var0_78[#var0_78 + 1] = iter3_78
			end
		end
	end

	for iter4_78, iter5_78 in ipairs(var2_78.attach_buff) do
		if iter5_78.effect_id then
			var0_78[#var0_78 + 1] = var5_0.GetFXPath(iter5_78.effect_id)
		end

		if iter5_78.buff_id then
			local var6_78 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter5_78.buff_id, 1, {})

			for iter6_78, iter7_78 in ipairs(var6_78) do
				var0_78[#var0_78 + 1] = iter7_78
			end
		end
	end

	return var0_78
end

function var5_0.GetAircraftResource(arg0_79, arg1_79, arg2_79, arg3_79)
	local var0_79 = {}

	arg2_79 = arg2_79 or 0

	local var1_79 = var1_0.GetAircraftTmpDataFromID(arg0_79)
	local var2_79
	local var3_79
	local var4_79
	local var5_79

	if arg2_79 ~= 0 then
		local var6_79, var7_79, var8_79

		var2_79, var6_79, var7_79, var8_79 = var1_0.GetEquipSkin(arg2_79)

		if var6_79 ~= "" then
			var0_79[#var0_79 + 1] = var5_0.GetBulletPath(var6_79)
		end

		if var7_79 ~= "" then
			var0_79[#var0_79 + 1] = var5_0.GetBulletPath(var7_79)
		end

		if var8_79 ~= "" then
			var0_79[#var0_79 + 1] = var5_0.GetBulletPath(var8_79)
		end
	else
		var2_79 = var1_79.model_ID
	end

	var0_79[#var0_79 + 1] = var5_0.GetCharacterGoPath(var2_79)

	if arg3_79 then
		var0_79[#var0_79 + 1] = var5_0.GetAircraftIconPath(var1_79.model_ID)
	end

	local var9_79 = arg1_79 or var1_79.weapon_ID

	if type(var9_79) == "table" then
		for iter0_79, iter1_79 in ipairs(var9_79) do
			local var10_79 = var5_0.GetWeaponResource(iter1_79)

			for iter2_79, iter3_79 in ipairs(var10_79) do
				var0_79[#var0_79 + 1] = iter3_79
			end
		end
	else
		local var11_79 = var5_0.GetWeaponResource(var9_79)

		for iter4_79, iter5_79 in ipairs(var11_79) do
			var0_79[#var0_79 + 1] = iter5_79
		end
	end

	return var0_79
end

function var5_0.GetCommanderBuffRes(arg0_80)
	local var0_80 = {}

	for iter0_80, iter1_80 in ipairs(arg0_80) do
		local var1_80 = var5_0.GetCommanderResource(iter1_80)

		for iter2_80, iter3_80 in ipairs(var1_80) do
			table.insert(var0_80, iter3_80)
		end
	end

	return var0_80
end

function var5_0.GetCommanderResource(arg0_81)
	local var0_81 = {}
	local var1_81 = arg0_81[1]

	var0_81[#var0_81 + 1] = var5_0.GetCommanderHrzIconPath(var1_81:getPainting())
	var0_81[#var0_81 + 1] = var5_0.GetCommanderIconPath(var1_81:getPainting())

	local var2_81 = var1_81:getSkills()[1]:getLevel()

	for iter0_81, iter1_81 in ipairs(arg0_81[2]) do
		local var3_81 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_81, var2_81, {})

		for iter2_81, iter3_81 in ipairs(var3_81) do
			var0_81[#var0_81 + 1] = iter3_81
		end
	end

	return var0_81
end

function var5_0.GetResFromBuffIDList(arg0_82)
	local var0_82 = {}

	for iter0_82, iter1_82 in ipairs(arg0_82) do
		local var1_82 = var1_0.GetResFromBuff(iter1_82, 1, {})

		for iter2_82, iter3_82 in ipairs(var1_82) do
			table.insert(var0_82, iter3_82)
		end
	end

	return var0_82
end

function var5_0.GetResFromBuffList(arg0_83)
	local var0_83 = {}

	for iter0_83, iter1_83 in ipairs(arg0_83) do
		local var1_83 = var1_0.GetResFromBuff(iter1_83.id, iter1_83.level, {})

		for iter2_83, iter3_83 in ipairs(var1_83) do
			table.insert(var0_83, iter3_83)
		end
	end

	return var0_83
end

function var5_0.GetStageResource(arg0_84)
	local var0_84 = var0_0.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0_84)
	local var1_84 = {}
	local var2_84 = {}

	for iter0_84, iter1_84 in ipairs(var0_84.stages) do
		if iter1_84.stageBuff then
			for iter2_84, iter3_84 in ipairs(iter1_84.stageBuff) do
				local var3_84 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter3_84.id, iter3_84.level, {})

				for iter4_84, iter5_84 in ipairs(var3_84) do
					var1_84[#var1_84 + 1] = iter5_84
				end
			end
		end

		for iter6_84, iter7_84 in ipairs(iter1_84.waves) do
			if iter7_84.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter8_84, iter9_84 in ipairs(iter7_84.spawn) do
					local var4_84 = var5_0.GetMonsterRes(iter9_84)

					for iter10_84, iter11_84 in ipairs(var4_84) do
						table.insert(var1_84, iter11_84)
					end
				end

				if iter7_84.reinforcement then
					for iter12_84, iter13_84 in ipairs(iter7_84.reinforcement) do
						local var5_84 = var5_0.GetMonsterRes(iter13_84)

						for iter14_84, iter15_84 in ipairs(var5_84) do
							table.insert(var1_84, iter15_84)
						end
					end
				end
			elseif iter7_84.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.AID then
				local var6_84 = iter7_84.triggerParams.vanguard_unitList
				local var7_84 = iter7_84.triggerParams.main_unitList
				local var8_84 = iter7_84.triggerParams.sub_unitList

				local function var9_84(arg0_85)
					local var0_85 = var5_0.GetAidUnitsRes(arg0_85)

					for iter0_85, iter1_85 in ipairs(var0_85) do
						table.insert(var1_84, iter1_85)
					end

					for iter2_85, iter3_85 in ipairs(arg0_85) do
						var2_84[#var2_84 + 1] = iter3_85.skinId
					end
				end

				if var6_84 then
					var9_84(var6_84)
				end

				if var7_84 then
					var9_84(var7_84)
				end

				if var8_84 then
					var9_84(var8_84)
				end
			elseif iter7_84.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for iter16_84, iter17_84 in ipairs(iter7_84.spawn) do
					var5_0.GetEnvironmentRes(var1_84, iter17_84)
				end
			elseif iter7_84.triggerType == var0_0.Battle.BattleConst.WaveTriggerType.CARD_PUZZLE then
				local var10_84 = var0_0.Battle.BattleDataFunction.GetCardRes(iter7_84.triggerParams.card_id)

				for iter18_84, iter19_84 in ipairs(var10_84) do
					table.insert(var1_84, iter19_84)
				end
			end

			if iter7_84.airFighter ~= nil then
				for iter20_84, iter21_84 in pairs(iter7_84.airFighter) do
					local var11_84 = var5_0.GetAircraftResource(iter21_84.templateID, iter21_84.weaponID, nil, true)

					for iter22_84, iter23_84 in ipairs(var11_84) do
						var1_84[#var1_84 + 1] = iter23_84
					end
				end
			end
		end
	end

	return var1_84, var2_84
end

function var5_0.GetEnvironmentRes(arg0_86, arg1_86)
	table.insert(arg0_86, arg1_86.prefab and var5_0.GetFXPath(arg1_86.prefab))

	local var0_86 = arg1_86.behaviours
	local var1_86 = var0_0.Battle.BattleDataFunction.GetEnvironmentBehaviour(var0_86).behaviour_list

	for iter0_86, iter1_86 in ipairs(var1_86) do
		local var2_86 = iter1_86.type

		if var2_86 == var0_0.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			local var3_86 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter1_86.buff_id, 1, {})

			for iter2_86, iter3_86 in ipairs(var3_86) do
				arg0_86[#arg0_86 + 1] = iter3_86
			end
		elseif var2_86 == var0_0.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			local var4_86 = iter1_86.content and iter1_86.content.alert and iter1_86.content.alert.alert_fx

			table.insert(arg0_86, var4_86 and var5_0.GetFXPath(var4_86))

			local var5_86 = iter1_86.content and iter1_86.content.child_prefab

			if var5_86 then
				var5_0.GetEnvironmentRes(arg0_86, var5_86)
			end
		elseif var2_86 == var0_0.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			arg0_86[#arg0_86 + 1] = var5_0.GetFXPath(iter1_86.FX_ID)
		end
	end
end

function var5_0.GetMonsterRes(arg0_87)
	local var0_87 = {}
	local var1_87 = var5_0.GetEnemyResource(arg0_87)

	for iter0_87, iter1_87 in ipairs(var1_87) do
		var0_87[#var0_87 + 1] = iter1_87
	end

	local var2_87 = var0_0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0_87.monsterTemplateID)
	local var3_87 = Clone(var2_87.equipment_list)
	local var4_87 = var2_87.buff_list
	local var5_87 = Clone(arg0_87.buffList) or {}

	if arg0_87.phase then
		for iter2_87, iter3_87 in ipairs(arg0_87.phase) do
			if iter3_87.addWeapon then
				for iter4_87, iter5_87 in ipairs(iter3_87.addWeapon) do
					var3_87[#var3_87 + 1] = iter5_87
				end
			end

			if iter3_87.addRandomWeapon then
				for iter6_87, iter7_87 in ipairs(iter3_87.addRandomWeapon) do
					for iter8_87, iter9_87 in ipairs(iter7_87) do
						var3_87[#var3_87 + 1] = iter9_87
					end
				end
			end

			if iter3_87.addBuff then
				for iter10_87, iter11_87 in ipairs(iter3_87.addBuff) do
					var5_87[#var5_87 + 1] = iter11_87
				end
			end
		end
	end

	for iter12_87, iter13_87 in ipairs(var4_87) do
		local var6_87 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter13_87.ID, iter13_87.LV, {})

		for iter14_87, iter15_87 in ipairs(var6_87) do
			var0_87[#var0_87 + 1] = iter15_87
		end
	end

	for iter16_87, iter17_87 in ipairs(var5_87) do
		local var7_87 = var0_0.Battle.BattleDataFunction.GetResFromBuff(iter17_87, 1, {})

		for iter18_87, iter19_87 in ipairs(var7_87) do
			var0_87[#var0_87 + 1] = iter19_87
		end

		local var8_87 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(iter17_87, 1)

		for iter20_87, iter21_87 in pairs(var8_87.effect_list) do
			local var9_87 = iter21_87.arg_list.skill_id

			if var9_87 and var0_0.Battle.BattleDataFunction.NeedSkillPainting(var9_87) then
				var0_87[#var0_87 + 1] = var5_0.GetPaintingPath(var1_0.GetMonsterTmpDataFromID(arg0_87.monsterTemplateID).icon)

				break
			end
		end
	end

	for iter22_87, iter23_87 in ipairs(var3_87) do
		local var10_87 = var5_0.GetWeaponResource(iter23_87)

		for iter24_87, iter25_87 in ipairs(var10_87) do
			var0_87[#var0_87 + 1] = iter25_87
		end
	end

	return var0_87
end

function var5_0.GetEquipSkinPreviewRes(arg0_88)
	local var0_88 = {}
	local var1_88 = var1_0.GetEquipSkinDataFromID(arg0_88)

	for iter0_88, iter1_88 in ipairs(var1_88.weapon_ids) do
		local var2_88 = var5_0.GetWeaponResource(iter1_88)

		for iter2_88, iter3_88 in ipairs(var2_88) do
			var0_88[#var0_88 + 1] = iter3_88
		end
	end

	local function var3_88(arg0_89)
		if arg0_89 ~= "" then
			var0_88[#var0_88 + 1] = var5_0.GetBulletPath(arg0_89)
		end
	end

	local var4_88, var5_88, var6_88, var7_88, var8_88, var9_88 = var1_0.GetEquipSkin(arg0_88)

	if _.any(EquipType.AirProtoEquipTypes, function(arg0_90)
		return table.contains(var1_88.equip_type, arg0_90)
	end) then
		var0_88[#var0_88 + 1] = var5_0.GetCharacterGoPath(var4_88)
	else
		var0_88[#var0_88 + 1] = var5_0.GetBulletPath(var4_88)
	end

	var3_88(var5_88)
	var3_88(var6_88)
	var3_88(var7_88)

	if var8_88 and var8_88 ~= "" then
		var0_88[#var0_88 + 1] = var5_0.GetFXPath(var8_88)
	end

	if var9_88 and var9_88 ~= "" then
		var0_88[#var0_88 + 1] = var5_0.GetFXPath(var9_88)
	end

	return var0_88
end

function var5_0.GetEquipSkinBulletRes(arg0_91)
	local var0_91 = {}
	local var1_91, var2_91, var3_91, var4_91 = var1_0.GetEquipSkin(arg0_91)

	local function var5_91(arg0_92)
		if arg0_92 ~= "" then
			var0_91[#var0_91 + 1] = var5_0.GetBulletPath(arg0_92)
		end
	end

	local var6_91 = var1_0.GetEquipSkinDataFromID(arg0_91)
	local var7_91 = false

	for iter0_91, iter1_91 in ipairs(var6_91.equip_type) do
		if table.contains(EquipType.AircraftSkinType, iter1_91) then
			var7_91 = true
		end
	end

	if var7_91 then
		if var1_91 ~= "" then
			var0_91[#var0_91 + 1] = var5_0.GetCharacterGoPath(var1_91)
		end
	else
		var5_91(var1_91)

		if var1_0.GetEquipSkinDataFromID(arg0_91).mirror == 1 then
			var0_91[#var0_91 + 1] = var5_0.GetBulletPath(var1_91 .. var0_0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	var5_91(var2_91)
	var5_91(var3_91)
	var5_91(var4_91)

	return var0_91
end

function var5_0.GetAidUnitsRes(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in ipairs(arg0_93) do
		local var1_93 = var5_0.GetShipResource(iter1_93.tmpID, nil, true)

		for iter2_93, iter3_93 in ipairs(iter1_93.equipment) do
			if iter3_93 ~= 0 then
				if iter2_93 <= Ship.WEAPON_COUNT then
					local var2_93 = var1_0.GetWeaponDataFromID(iter3_93).weapon_id

					for iter4_93, iter5_93 in ipairs(var2_93) do
						local var3_93 = var5_0.GetWeaponResource(iter5_93)

						for iter6_93, iter7_93 in ipairs(var3_93) do
							table.insert(var1_93, iter7_93)
						end
					end
				else
					local var4_93 = var5_0.GetEquipResource(iter3_93)

					for iter8_93, iter9_93 in ipairs(var4_93) do
						table.insert(var1_93, iter9_93)
					end
				end
			end
		end

		for iter10_93, iter11_93 in ipairs(var1_93) do
			table.insert(var0_93, iter11_93)
		end
	end

	return var0_93
end

function var5_0.GetSpWeaponResource(arg0_94, arg1_94)
	local var0_94 = {}
	local var1_94 = var0_0.Battle.BattleDataFunction.GetSpWeaponDataFromID(arg0_94).effect_id

	if var1_94 ~= 0 then
		var1_94 = arg1_94 and var0_0.Battle.BattleDataFunction.SkillTranform(arg1_94, var1_94) or var1_94

		local var2_94 = var0_0.Battle.BattleDataFunction.GetResFromBuff(var1_94, 1, {})

		for iter0_94, iter1_94 in ipairs(var2_94) do
			var0_94[#var0_94 + 1] = iter1_94
		end
	end

	return var0_94
end
