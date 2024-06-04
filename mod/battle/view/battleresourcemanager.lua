ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = require("Mgr/Pool/PoolUtil")
local var5 = singletonClass("BattleResourceManager")

var0.Battle.BattleResourceManager = var5
var5.__name = "BattleResourceManager"

function var5.Ctor(arg0)
	arg0.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})
end

function var5.Init(arg0)
	arg0._preloadList = {}
	arg0._resCacheList = {}
	arg0._allPool = {}
	arg0._ob2Pool = {}

	local var0 = GameObject()

	var0:SetActive(false)

	var0.name = "PoolRoot"
	var0.transform.position = Vector3(-10000, -10000, 0)
	arg0._poolRoot = var0
	arg0._bulletContainer = GameObject("BulletContainer")
	arg0._battleCVList = {}
end

function var5.Clear(arg0)
	for iter0, iter1 in pairs(arg0._allPool) do
		iter1:Dispose()
	end

	for iter2, iter3 in pairs(arg0._resCacheList) do
		if string.find(iter2, "Char/") then
			var5.ClearCharRes(iter2, iter3)
		elseif string.find(iter2, "painting/") then
			var5.ClearPaintingRes(iter2, iter3)
		else
			var4.Destroy(iter3)
		end
	end

	arg0._resCacheList = {}
	arg0._ob2Pool = {}
	arg0._allPool = {}

	Object.Destroy(arg0._poolRoot)

	arg0._poolRoot = nil

	Object.Destroy(arg0._bulletContainer)

	arg0._bulletContainer = nil
	arg0.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})

	for iter4, iter5 in pairs(arg0._battleCVList) do
		pg.CriMgr.UnloadCVBank(iter5)
	end

	arg0._battleCVList = {}

	var0.Battle.BattleDataFunction.ClearConvertedBarrage()
end

function var5.GetBulletPath(arg0)
	return "Item/" .. arg0
end

function var5.GetOrbitPath(arg0)
	return "orbit/" .. arg0
end

function var5.GetCharacterPath(arg0)
	return "Char/" .. arg0
end

function var5.GetCharacterGoPath(arg0)
	return "chargo/" .. arg0
end

function var5.GetAircraftIconPath(arg0)
	return "AircraftIcon/" .. arg0
end

function var5.GetFXPath(arg0)
	return "Effect/" .. arg0
end

function var5.GetPaintingPath(arg0)
	return "painting/" .. arg0
end

function var5.GetHrzIcon(arg0)
	return "herohrzicon/" .. arg0
end

function var5.GetSquareIcon(arg0)
	return "squareicon/" .. arg0
end

function var5.GetQIcon(arg0)
	return "qicon/" .. arg0
end

function var5.GetCommanderHrzIconPath(arg0)
	return "commanderhrz/" .. arg0
end

function var5.GetShipTypeIconPath(arg0)
	return "shiptype/" .. arg0
end

function var5.GetMapPath(arg0)
	return "Map/" .. arg0
end

function var5.GetUIPath(arg0)
	return "UI/" .. arg0
end

function var5.GetResName(arg0)
	local var0 = arg0
	local var1 = string.find(var0, "%/")

	while var1 do
		var0 = string.sub(var0, var1 + 1)
		var1 = string.find(var0, "%/")
	end

	return var0
end

function var5.ClearCharRes(arg0, arg1)
	local var0 = var5.GetResName(arg0)
	local var1 = arg1:GetComponent("SkeletonRenderer").skeletonDataAsset

	if not PoolMgr.GetInstance():IsSpineSkelCached(var0) then
		UIUtil.ClearSharedMaterial(arg1)
	end

	var4.Destroy(arg1)
end

function var5.ClearPaintingRes(arg0, arg1)
	local var0 = var5.GetResName(arg0)

	PoolMgr.GetInstance():ReturnPainting(var0, arg1)
end

function var5.DestroyOb(arg0, arg1)
	local var0 = arg0._ob2Pool[arg1]

	if var0 then
		var0:Recycle(arg1)
	else
		var4.Destroy(arg1)
	end
end

function var5.popPool(arg0, arg1, arg2)
	local var0 = arg1:GetObject()

	if not arg2 then
		var0.transform.parent = nil
	end

	arg0._ob2Pool[var0] = arg1

	return var0
end

function var5.InstCharacter(arg0, arg1, arg2)
	local var0 = arg0.GetCharacterPath(arg1)
	local var1 = arg0._allPool[var0]

	if var1 then
		local var2 = arg0:popPool(var1)

		arg2(var2)
	elseif arg0._resCacheList[var0] ~= nil then
		arg0:InitPool(var0, arg0._resCacheList[var0])

		var1 = arg0._allPool[var0]

		local var3 = arg0:popPool(var1)

		arg2(var3)
	else
		arg0:LoadSpineAsset(arg1, function(arg0)
			if not arg0._poolRoot then
				var5.ClearCharRes(var0, arg0)

				return
			end

			assert(arg0, "角色资源加载失败：" .. arg1)

			local var0 = SpineAnim.AnimChar(arg1, arg0)

			var0:SetActive(false)
			arg0:InitPool(var0, var0)

			var1 = arg0._allPool[var0]

			local var1 = arg0:popPool(var1)

			arg2(var1)
		end)
	end
end

function var5.LoadSpineAsset(arg0, arg1, arg2)
	local var0 = arg0.GetCharacterPath(arg1)

	if not PoolMgr.GetInstance():IsSpineSkelCached(arg1) then
		ResourceMgr.Inst:getAssetAsync(var0, arg1 .. "_SkeletonData", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			arg2(arg0)
		end), true, true)
	else
		PoolMgr.GetInstance():GetSpineSkel(arg1, true, arg2)
	end
end

function var5.InstAirCharacter(arg0, arg1, arg2)
	local var0 = arg0.GetCharacterGoPath(arg1)
	local var1 = arg0._allPool[var0]

	if var1 then
		local var2 = arg0:popPool(var1)

		arg2(var2)
	elseif arg0._resCacheList[var0] ~= nil then
		arg0:InitPool(var0, arg0._resCacheList[var0])

		var1 = arg0._allPool[var0]

		local var3 = arg0:popPool(var1)

		arg2(var3)
	else
		ResourceMgr.Inst:getAssetAsync(var0, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if not arg0._poolRoot then
				var4.Destroy(arg0)

				return
			else
				assert(arg0, "飞机资源加载失败：" .. arg1)
				arg0:InitPool(var0, arg0)

				var1 = arg0._allPool[var0]

				local var0 = arg0:popPool(var1)

				arg2(var0)
			end
		end), true, true)
	end
end

function var5.InstBullet(arg0, arg1, arg2)
	local var0 = arg0.GetBulletPath(arg1)
	local var1 = arg0._allPool[var0]

	if var1 then
		local var2 = arg0:popPool(var1, true)

		if string.find(arg1, "_trail") then
			local var3 = var2:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var3 then
				var3:Clear()
			end
		end

		arg2(var2)

		return true
	elseif arg0._resCacheList[var0] ~= nil then
		arg0:InitPool(var0, arg0._resCacheList[var0])

		var1 = arg0._allPool[var0]

		local var4 = arg0:popPool(var1, true)

		if string.find(arg1, "_trail") then
			local var5 = var4:GetComponentInChildren(typeof(UnityEngine.TrailRenderer))

			if var5 then
				var5:Clear()
			end
		end

		arg2(var4)

		return true
	else
		ResourceMgr.Inst:getAssetAsync(var0, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0._poolRoot then
				var4.Destroy(arg0)

				return
			else
				assert(arg0, "子弹资源加载失败：" .. arg1)
				arg0:InitPool(var0, arg0)

				var1 = arg0._allPool[var0]

				local var0 = arg0:popPool(var1, true)

				arg2(var0)
			end
		end), true, true)

		return false
	end
end

function var5.InstFX(arg0, arg1, arg2)
	local var0 = arg0.GetFXPath(arg1)
	local var1
	local var2 = arg0._allPool[var0]

	if var2 then
		var1 = arg0:popPool(var2, arg2)
	elseif arg0._resCacheList[var0] ~= nil then
		arg0:InitPool(var0, arg0._resCacheList[var0])

		local var3 = arg0._allPool[var0]

		var1 = arg0:popPool(var3, arg2)
	else
		ResourceMgr.Inst:getAssetAsync(var0, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if not arg0._poolRoot then
				var4.Destroy(arg0)

				return
			else
				assert(arg0, "特效资源加载失败：" .. arg1)
				arg0:InitPool(var0, arg0)
			end
		end), true, true)

		var1 = GameObject(arg1 .. "临时假obj")

		var1:SetActive(false)

		arg0._resCacheList[var0] = var1
	end

	return var1
end

function var5.InstOrbit(arg0, arg1)
	local var0 = arg0.GetOrbitPath(arg1)
	local var1
	local var2 = arg0._allPool[var0]

	if var2 then
		var1 = arg0:popPool(var2)
	elseif arg0._resCacheList[var0] ~= nil then
		arg0:InitPool(var0, arg0._resCacheList[var0])

		local var3 = arg0._allPool[var0]

		var1 = arg0:popPool(var3)
	else
		ResourceMgr.Inst:getAssetAsync(var0, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if not arg0._poolRoot then
				var4.Destroy(arg0)

				return
			else
				assert(arg0, "特效资源加载失败：" .. arg1)
				arg0:InitPool(var0, arg0)
			end
		end), true, true)

		var1 = GameObject(arg1 .. "临时假obj")

		var1:SetActive(false)

		arg0._resCacheList[var0] = var1
	end

	return var1
end

function var5.InstSkillPaintingUI(arg0)
	local var0 = arg0._allPool["UI/SkillPainting"]
	local var1 = var0:GetObject()

	arg0._ob2Pool[var1] = var0

	return var1
end

function var5.InstBossWarningUI(arg0)
	local var0 = arg0._allPool["UI/MonsterAppearUI"]
	local var1 = var0:GetObject()

	arg0._ob2Pool[var1] = var0

	return var1
end

function var5.InstGridmanSkillUI(arg0)
	local var0 = arg0._allPool["UI/combatgridmanskillfloat"]
	local var1 = var0:GetObject()

	arg0._ob2Pool[var1] = var0

	return var1
end

function var5.InstPainting(arg0, arg1)
	local var0 = arg0.GetPaintingPath(arg1)
	local var1
	local var2 = arg0._allPool[var0]

	if var2 then
		var1 = var2:GetObject()
		arg0._ob2Pool[var1] = var2
	elseif arg0._resCacheList[var0] ~= nil then
		var1 = Object.Instantiate(arg0._resCacheList[var0])

		var1:SetActive(true)
	end

	return var1
end

function var5.InstMap(arg0, arg1)
	local var0 = arg0.GetMapPath(arg1)
	local var1
	local var2 = arg0._allPool[var0]

	if var2 then
		var1 = var2:GetObject()
		arg0._ob2Pool[var1] = var2
	elseif arg0._resCacheList[var0] ~= nil then
		var1 = Object.Instantiate(arg0._resCacheList[var0])
	else
		assert(false, "地图资源没有预加载：" .. arg1)
	end

	var1:SetActive(true)

	return var1
end

function var5.InstCardPuzzleCard(arg0)
	local var0 = arg0._allPool["UI/CardTowerCardCombat"]
	local var1 = var0:GetObject()

	arg0._ob2Pool[var1] = var0

	return var1
end

function var5.GetCharacterIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetHrzIcon(arg1)]
end

function var5.GetCharacterSquareIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetSquareIcon(arg1)]
end

function var5.GetCharacterQIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetQIcon(arg1)]
end

function var5.GetAircraftIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetAircraftIconPath(arg1)]
end

function var5.GetShipTypeIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetShipTypeIconPath(arg1)]
end

function var5.GetCommanderHrzIcon(arg0, arg1)
	return arg0._resCacheList[var5.GetCommanderHrzIconPath(arg1)]
end

function var5.GetShader(arg0, arg1)
	return (pg.ShaderMgr.GetInstance():GetShader(var3.BATTLE_SHADER[arg1]))
end

function var5.AddPreloadResource(arg0, arg1)
	if type(arg1) == "string" then
		arg0._preloadList[arg1] = false
	elseif type(arg1) == "table" then
		for iter0, iter1 in ipairs(arg1) do
			arg0._preloadList[iter1] = false
		end
	end
end

function var5.AddPreloadCV(arg0, arg1)
	local var0 = Ship.getCVKeyID(arg1)

	if var0 > 0 then
		arg0._battleCVList[var0] = pg.CriMgr.GetBattleCVBankName(var0)
	end
end

function var5.StartPreload(arg0, arg1, arg2)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0._preloadList) do
		var1 = var1 + 1
	end

	for iter2, iter3 in pairs(arg0._battleCVList) do
		var1 = var1 + 1
	end

	local function var2()
		if not arg0._poolRoot then
			return
		end

		var0 = var0 + 1

		if var0 > var1 then
			return
		end

		if arg2 then
			arg2(var0)
		end

		if var0 == var1 then
			arg0._preloadList = nil

			arg1()
		end
	end

	for iter4, iter5 in pairs(arg0._battleCVList) do
		pg.CriMgr.GetInstance():LoadBattleCV(iter4, var2)
	end

	for iter6, iter7 in pairs(arg0._preloadList) do
		local var3 = arg0.GetResName(iter6)

		if var3 == "" or arg0._resCacheList[iter6] ~= nil then
			var2()
		elseif string.find(iter6, "herohrzicon/") or string.find(iter6, "qicon/") or string.find(iter6, "squareicon/") or string.find(iter6, "commanderhrz/") or string.find(iter6, "AircraftIcon/") then
			local var4, var5 = HXSet.autoHxShiftPath(iter6, var3)

			ResourceMgr.Inst:getAssetAsync(var4, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					if not arg0._poolRoot then
						var4.Destroy(arg0)

						return
					end

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				var2()
			end), true, true)
		elseif string.find(iter6, "shiptype/") then
			local var6 = string.split(iter6, "/")[2]

			ResourceMgr.Inst:getAssetAsync("shiptype", var6, typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					if not arg0._poolRoot then
						var4.Destroy(arg0)

						return
					end

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				var2()
			end), true, true)
		elseif string.find(iter6, "painting/") then
			local var7 = false

			if PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) > 0 then
				var7 = checkABExist("painting/" .. var3 .. "_n")
			else
				var7 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var3, 0) ~= 0
			end

			PoolMgr.GetInstance():GetPainting(var3 .. (var7 and "_n" or ""), true, function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					if not arg0._poolRoot then
						var5.ClearPaintingRes(iter6, arg0)

						return
					end

					ShipExpressionHelper.SetExpression(arg0, var3)
					arg0:SetActive(false)

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				var2()
			end)
		elseif string.find(iter6, "Char/") then
			arg0:LoadSpineAsset(var3, function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					arg0 = SpineAnim.AnimChar(var3, arg0)

					if not arg0._poolRoot then
						var5.ClearCharRes(iter6, arg0)

						return
					end

					arg0:SetActive(false)

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				arg0:InitPool(iter6, arg0)
				var2()
			end)
		elseif string.find(iter6, "UI/") then
			LoadAndInstantiateAsync("UI", var3, function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					if not arg0._poolRoot then
						var4.Destroy(arg0)

						return
					end

					arg0:SetActive(false)

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				arg0:InitPool(iter6, arg0)
				var2()
			end, true, true)
		else
			ResourceMgr.Inst:getAssetAsync(iter6, var3, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0 == nil then
					originalPrint("资源预加载失败，检查以下目录：>>" .. iter6 .. "<<")
				else
					if not arg0._poolRoot then
						var4.Destroy(arg0)

						return
					end

					if arg0._resCacheList then
						arg0._resCacheList[iter6] = arg0
					end
				end

				arg0:InitPool(iter6, arg0)
				var2()
			end), true, true)
		end
	end

	return var1
end

local var6 = Vector3(0, 10000, 0)

function var5.HideBullet(arg0)
	arg0.transform.position = var6
end

function var5.InitParticleSystemCB(arg0)
	pg.EffectMgr.GetInstance():CommonEffectEvent(arg0)
end

function var5.InitPool(arg0, arg1, arg2)
	local var0 = arg0._poolRoot.transform

	if string.find(arg1, "Item/") then
		if arg2:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or arg2:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			arg0._allPool[arg1] = pg.Pool.New(arg0._bulletContainer.transform, arg2, 15, 20, true, false):InitSize()
		else
			local var1 = pg.Pool.New(arg0._bulletContainer.transform, arg2, 20, 20, true, true)

			var1:SetRecycleFuncs(var5.HideBullet)
			var1:InitSize()

			arg0._allPool[arg1] = var1
		end
	elseif string.find(arg1, "Effect/") then
		if arg2:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			local var2 = 5

			if string.find(arg1, "smoke") and not string.find(arg1, "smokeboom") then
				var2 = 30
			elseif string.find(arg1, "feijiyingzi") then
				var2 = 1
			end

			local var3 = pg.Pool.New(var0, arg2, var2, 20, false, false)

			var3:SetInitFuncs(var5.InitParticleSystemCB)
			var3:InitSize()

			arg0._allPool[arg1] = var3
		else
			local var4 = 8

			if string.find(arg1, "AntiAirArea") or string.find(arg1, "AntiSubArea") then
				var4 = 1
			end

			GetOrAddComponent(arg2, typeof(ParticleSystemEvent))

			local var5 = pg.Pool.New(var0, arg2, var4, 20, false, false)

			var5:InitSize()

			arg0._allPool[arg1] = var5
		end
	elseif string.find(arg1, "Char/") then
		local var6 = 1

		if string.find(arg1, "danchuan") then
			var6 = 3
		end

		local var7 = pg.Pool.New(var0, arg2, var6, 20, false, false):InitSize()

		var7:SetRecycleFuncs(var5.ResetSpineAction)

		arg0._allPool[arg1] = var7
	elseif string.find(arg1, "chargo/") then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 3, 20, false, false):InitSize()
	elseif string.find(arg1, "orbit/") then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 2, 20, false, false):InitSize()
	elseif arg1 == "UI/SkillPainting" then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 1, 20, false, false):InitSize()
	elseif arg1 == "UI/MonsterAppearUI" then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 1, 20, false, false):InitSize()
	elseif arg1 == "UI/CardTowerCardCombat" then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 7, 20, false, false):InitSize()
	elseif arg1 == "UI/combatgridmanskillfloat" then
		arg0._allPool[arg1] = pg.Pool.New(var0, arg2, 1, 20, false, false):InitSize()
	elseif arg1 == "UI/CombatHPBar" then
		var0.Battle.BattleHPBarManager.GetInstance():Init(arg2, var0)
	elseif arg1 == "UI/CombatHPPop" then
		var0.Battle.BattlePopNumManager.GetInstance():Init(arg2, var0)
	end
end

function var5.GetRotateScript(arg0, arg1, arg2)
	local var0 = arg0.rotateScriptMap

	if var0[arg1] then
		return var0[arg1]
	end

	local var1 = GetOrAddComponent(arg1, "BulletRotation")

	var0[arg1] = var1

	return var1
end

function var5.GetCommonResource()
	return {
		var5.GetMapPath("visionLine"),
		var5.GetMapPath("exposeLine"),
		var5.GetFXPath(var0.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		var5.GetFXPath(var0.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		var5.GetFXPath(var0.Battle.BattleBossCharacterFactory.BOMB_FX_NAME),
		var5.GetFXPath(var0.Battle.BattleAircraftCharacterFactory.BOMB_FX_NAME),
		var5.GetFXPath("AlertArea"),
		var5.GetFXPath("TorAlert"),
		var5.GetFXPath("SquareAlert"),
		var5.GetFXPath("AntiAirArea"),
		var5.GetFXPath("AntiSubArea"),
		var5.GetFXPath("AimBiasArea"),
		var5.GetFXPath("shock"),
		var5.GetFXPath("qianting_chushui"),
		var5.GetFXPath(var3.PLAYER_SUB_BUBBLE_FX),
		var5.GetFXPath("weaponrange"),
		var5.GetUIPath("SkillPainting"),
		var5.GetUIPath("MonsterAppearUI"),
		var5.GetUIPath("CombatHPBar"),
		var5.GetUIPath("CombatHPPop")
	}
end

function var5.GetDisplayCommonResource()
	return {
		var5.GetFXPath(var0.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		var5.GetFXPath(var0.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		var5.GetFXPath(var0.Battle.BattleCharacterFactory.DANCHUAN_MOVE_WAVE_FX_NAME)
	}
end

function var5.GetMapResource(arg0)
	local var0 = {}
	local var1 = var0.Battle.BattleMap

	for iter0, iter1 in ipairs(var1.LAYERS) do
		local var2 = var1.GetMapResNames(arg0, iter1)

		for iter2, iter3 in ipairs(var2) do
			var0[#var0 + 1] = var5.GetMapPath(iter3)
		end
	end

	return var0
end

function var5.GetBuffResource()
	local var0 = {}
	local var1 = require("buffFXPreloadList")

	for iter0, iter1 in ipairs(var1) do
		var0[#var0 + 1] = var5.GetFXPath(iter1)
	end

	return var0
end

function var5.GetShipResource(arg0, arg1, arg2)
	local var0 = {}
	local var1 = var1.GetPlayerShipTmpDataFromID(arg0)

	if arg1 == nil or arg1 == 0 then
		arg1 = var1.skin_id
	end

	local var2 = var1.GetPlayerShipSkinDataFromID(arg1)

	var0[#var0 + 1] = var5.GetCharacterPath(var2.prefab)
	var0[#var0 + 1] = var5.GetHrzIcon(var2.painting)
	var0[#var0 + 1] = var5.GetQIcon(var2.painting)
	var0[#var0 + 1] = var5.GetSquareIcon(var2.painting)

	if arg2 and var1.GetShipTypeTmp(var1.type).team_type == TeamType.Main then
		var0[#var0 + 1] = var5.GetPaintingPath(var2.painting)
	end

	return var0
end

function var5.GetEnemyResource(arg0)
	local var0 = {}
	local var1 = arg0.monsterTemplateID
	local var2 = arg0.bossData ~= nil
	local var3 = arg0.buffList or {}
	local var4 = arg0.phase or {}
	local var5 = var1.GetMonsterTmpDataFromID(var1)

	var0[#var0 + 1] = var5.GetCharacterPath(var5.prefab)
	var0[#var0 + 1] = var5.GetFXPath(var5.wave_fx)

	if var5.fog_fx then
		var0[#var0 + 1] = var5.GetFXPath(var5.fog_fx)
	end

	for iter0, iter1 in ipairs(var5.appear_fx) do
		var0[#var0 + 1] = var5.GetFXPath(iter1)
	end

	for iter2, iter3 in ipairs(var5.smoke) do
		local var6 = iter3[2]

		for iter4, iter5 in ipairs(var6) do
			var0[#var0 + 1] = var5.GetFXPath(iter5[1])
		end
	end

	if arg0.deadFX then
		var0[#var0 + 1] = var5.GetFXPath(arg0.deadFX)
	end

	if type(var5.bubble_fx) == "table" then
		var0[#var0 + 1] = var5.GetFXPath(var5.bubble_fx[1])
	end

	local function var7(arg0)
		local var0 = var0.Battle.BattleDataFunction.GetBuffTemplate(arg0, 1)

		for iter0, iter1 in pairs(var0.effect_list) do
			local var1 = iter1.arg_list.skill_id

			if var1 then
				local var2 = var0.Battle.BattleDataFunction.GetSkillTemplate(var1).painting

				if var2 == 1 then
					var0[#var0 + 1] = var5.GetHrzIcon(var5.icon)
				elseif type(var2) == "string" then
					var0[#var0 + 1] = var5.GetHrzIcon(var2)
				end
			end

			local var3 = iter1.arg_list.buff_id

			if var3 then
				var7(var3)
			end
		end
	end

	for iter6, iter7 in ipairs(var3) do
		var7(iter7)
	end

	for iter8, iter9 in ipairs(var4) do
		if iter9.addBuff then
			for iter10, iter11 in ipairs(iter9.addBuff) do
				var7(iter11)
			end
		end
	end

	if var2 then
		var0[#var0 + 1] = var5.GetSquareIcon(var5.icon)
	end

	return var0
end

function var5.GetWeaponResource(arg0, arg1)
	local var0 = {}

	if arg0 == -1 then
		return var0
	end

	local var1 = var1.GetWeaponPropertyDataFromID(arg0)

	if var1.type == var2.EquipmentType.MAIN_CANNON or var1.type == var2.EquipmentType.SUB_CANNON or var1.type == var2.EquipmentType.TORPEDO or var1.type == var2.EquipmentType.ANTI_AIR or var1.type == var2.EquipmentType.ANTI_SEA or var1.type == var2.EquipmentType.POINT_HIT_AND_LOCK or var1.type == var2.EquipmentType.MANUAL_METEOR or var1.type == var2.EquipmentType.BOMBER_PRE_CAST_ALERT or var1.type == var2.EquipmentType.DEPTH_CHARGE or var1.type == var2.EquipmentType.MANUAL_TORPEDO or var1.type == var2.EquipmentType.DISPOSABLE_TORPEDO or var1.type == var2.EquipmentType.MANUAL_AAMISSILE or var1.type == var2.EquipmentType.BEAM or var1.type == var2.EquipmentType.SPACE_LASER or var1.type == var2.EquipmentType.FLEET_RANGE_ANTI_AIR or var1.type == var2.EquipmentType.MANUAL_MISSILE or var1.type == var2.EquipmentType.AUTO_MISSILE or var1.type == var2.EquipmentType.MISSILE then
		for iter0, iter1 in ipairs(var1.bullet_ID) do
			local var2 = var5.GetBulletResource(iter1, arg1)

			for iter2, iter3 in ipairs(var2) do
				var0[#var0 + 1] = iter3
			end
		end
	elseif var1.type == var2.EquipmentType.INTERCEPT_AIRCRAFT or var1.type == var2.EquipmentType.STRIKE_AIRCRAFT then
		var0 = var5.GetAircraftResource(arg0, nil, arg1)
	elseif var1.type == var2.EquipmentType.PREVIEW_ARICRAFT then
		for iter4, iter5 in ipairs(var1.bullet_ID) do
			var0 = var5.GetAircraftResource(iter5, nil, arg1)
		end
	end

	if var1.type == var2.EquipmentType.FLEET_RANGE_ANTI_AIR then
		local var3 = var5.GetBulletResource(var3.AntiAirConfig.RangeBulletID)

		for iter6, iter7 in ipairs(var3) do
			var0[#var0 + 1] = iter7
		end
	end

	local var4

	if arg1 and arg1 ~= 0 then
		var4 = var0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1)
	end

	if var4 and var4.fire_fx_name ~= "" then
		var0[#var0 + 1] = var5.GetFXPath(var4.fire_fx_name)
	else
		var0[#var0 + 1] = var5.GetFXPath(var1.fire_fx)
	end

	if var1.precast_param.fx then
		var0[#var0 + 1] = var5.GetFXPath(var1.precast_param.fx)
	end

	if var4 then
		local var5 = var4.orbit_combat

		if var5 ~= "" then
			var0[#var0 + 1] = var5.GetOrbitPath(var5)
		end
	end

	return var0
end

function var5.GetEquipResource(arg0, arg1, arg2)
	local var0 = {}

	if arg1 ~= 0 then
		local var1 = var0.Battle.BattleDataFunction.GetEquipSkinDataFromID(arg1)
		local var2 = var1.ship_skin_id

		if var2 ~= 0 then
			local var3 = var0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(var2)

			var0[#var0 + 1] = var5.GetCharacterPath(var3.prefab)
		end

		local var4 = var1.orbit_combat

		if var4 ~= "" then
			var0[#var0 + 1] = var5.GetOrbitPath(var4)
		end
	end

	local var5 = var0.Battle.BattleDataFunction.GetWeaponDataFromID(arg0)
	local var6 = var5.weapon_id

	for iter0, iter1 in ipairs(var6) do
		local var7 = var5.GetWeaponResource(iter1)

		for iter2, iter3 in ipairs(var7) do
			var0[#var0 + 1] = iter3
		end
	end

	local var8 = var5.skill_id

	for iter4, iter5 in ipairs(var8) do
		iter5 = arg2 and var0.Battle.BattleDataFunction.SkillTranform(arg2, iter5) or iter5

		local var9 = var0.Battle.BattleDataFunction.GetResFromBuff(iter5, 1, {})

		for iter6, iter7 in ipairs(var9) do
			var0[#var0 + 1] = iter7
		end
	end

	return var0
end

function var5.GetBulletResource(arg0, arg1)
	local var0 = {}
	local var1

	if arg1 ~= nil and arg1 ~= 0 then
		var1 = var1.GetEquipSkinDataFromID(arg1)
	end

	local var2 = var1.GetBulletTmpDataFromID(arg0)
	local var3

	if var1 then
		var3 = var1.bullet_name

		if var1.mirror == 1 then
			var0[#var0 + 1] = var5.GetBulletPath(var3 .. var0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		var3 = var2.modle_ID
	end

	if var2.type == var2.BulletType.BEAM or var2.type == var2.BulletType.SPACE_LASER or var2.type == var2.BulletType.MISSILE or var2.type == var2.BulletType.ELECTRIC_ARC then
		var0[#var0 + 1] = var5.GetFXPath(var2.modle_ID)
	else
		var0[#var0 + 1] = var5.GetBulletPath(var3)
	end

	if var2.extra_param.mirror then
		var0[#var0 + 1] = var5.GetBulletPath(var3 .. var0.Battle.BattleBulletUnit.MIRROR_RES)
	end

	local var4

	if var1 and var1.hit_fx_name ~= "" then
		var4 = var1.hit_fx_name
	else
		var4 = var2.hit_fx
	end

	var0[#var0 + 1] = var5.GetFXPath(var4)
	var0[#var0 + 1] = var5.GetFXPath(var2.miss_fx)
	var0[#var0 + 1] = var5.GetFXPath(var2.alert_fx)

	if var2.extra_param.area_FX then
		var0[#var0 + 1] = var5.GetFXPath(var2.extra_param.area_FX)
	end

	if var2.extra_param.shrapnel then
		for iter0, iter1 in ipairs(var2.extra_param.shrapnel) do
			local var5 = var5.GetBulletResource(iter1.bullet_ID)

			for iter2, iter3 in ipairs(var5) do
				var0[#var0 + 1] = iter3
			end
		end
	end

	for iter4, iter5 in ipairs(var2.attach_buff) do
		if iter5.effect_id then
			var0[#var0 + 1] = var5.GetFXPath(iter5.effect_id)
		end

		if iter5.buff_id then
			local var6 = var0.Battle.BattleDataFunction.GetResFromBuff(iter5.buff_id, 1, {})

			for iter6, iter7 in ipairs(var6) do
				var0[#var0 + 1] = iter7
			end
		end
	end

	return var0
end

function var5.GetAircraftResource(arg0, arg1, arg2)
	local var0 = {}

	arg2 = arg2 or 0

	local var1 = var1.GetAircraftTmpDataFromID(arg0)
	local var2
	local var3
	local var4
	local var5

	if arg2 ~= 0 then
		local var6, var7, var8

		var2, var6, var7, var8 = var1.GetEquipSkin(arg2)

		if var6 ~= "" then
			var0[#var0 + 1] = var5.GetBulletPath(var6)
		end

		if var7 ~= "" then
			var0[#var0 + 1] = var5.GetBulletPath(var7)
		end

		if var8 ~= "" then
			var0[#var0 + 1] = var5.GetBulletPath(var8)
		end
	else
		var2 = var1.model_ID
	end

	var0[#var0 + 1] = var5.GetCharacterGoPath(var2)
	var0[#var0 + 1] = var5.GetAircraftIconPath(var1.model_ID)

	local var9 = arg1 or var1.weapon_ID

	if type(var9) == "table" then
		for iter0, iter1 in ipairs(var9) do
			local var10 = var5.GetWeaponResource(iter1)

			for iter2, iter3 in ipairs(var10) do
				var0[#var0 + 1] = iter3
			end
		end
	else
		local var11 = var5.GetWeaponResource(var9)

		for iter4, iter5 in ipairs(var11) do
			var0[#var0 + 1] = iter5
		end
	end

	return var0
end

function var5.GetCommanderResource(arg0)
	local var0 = {}
	local var1 = arg0[1]

	var0[#var0 + 1] = var5.GetCommanderHrzIconPath(var1:getPainting())

	local var2 = var1:getSkills()[1]:getLevel()

	for iter0, iter1 in ipairs(arg0[2]) do
		local var3 = var0.Battle.BattleDataFunction.GetResFromBuff(iter1, var2, {})

		for iter2, iter3 in ipairs(var3) do
			var0[#var0 + 1] = iter3
		end
	end

	return var0
end

function var5.GetStageResource(arg0)
	local var0 = var0.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0)
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0.stages) do
		for iter2, iter3 in ipairs(iter1.waves) do
			if iter3.triggerType == var0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter4, iter5 in ipairs(iter3.spawn) do
					local var3 = var5.GetMonsterRes(iter5)

					for iter6, iter7 in ipairs(var3) do
						table.insert(var1, iter7)
					end
				end

				if iter3.reinforcement then
					for iter8, iter9 in ipairs(iter3.reinforcement) do
						local var4 = var5.GetMonsterRes(iter9)

						for iter10, iter11 in ipairs(var4) do
							table.insert(var1, iter11)
						end
					end
				end
			elseif iter3.triggerType == var0.Battle.BattleConst.WaveTriggerType.AID then
				local var5 = iter3.triggerParams.vanguard_unitList
				local var6 = iter3.triggerParams.main_unitList
				local var7 = iter3.triggerParams.sub_unitList

				local function var8(arg0)
					local var0 = var5.GetAidUnitsRes(arg0)

					for iter0, iter1 in ipairs(var0) do
						table.insert(var1, iter1)
					end

					for iter2, iter3 in ipairs(arg0) do
						var2[#var2 + 1] = iter3.skinId
					end
				end

				if var5 then
					var8(var5)
				end

				if var6 then
					var8(var6)
				end

				if var7 then
					var8(var7)
				end
			elseif iter3.triggerType == var0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for iter12, iter13 in ipairs(iter3.spawn) do
					var5.GetEnvironmentRes(var1, iter13)
				end
			elseif iter3.triggerType == var0.Battle.BattleConst.WaveTriggerType.CARD_PUZZLE then
				local var9 = var0.Battle.BattleDataFunction.GetCardRes(iter3.triggerParams.card_id)

				for iter14, iter15 in ipairs(var9) do
					table.insert(var1, iter15)
				end
			end

			if iter3.airFighter ~= nil then
				for iter16, iter17 in pairs(iter3.airFighter) do
					local var10 = var5.GetAircraftResource(iter17.templateID, iter17.weaponID)

					for iter18, iter19 in ipairs(var10) do
						var1[#var1 + 1] = iter19
					end
				end
			end
		end
	end

	return var1, var2
end

function var5.GetEnvironmentRes(arg0, arg1)
	table.insert(arg0, arg1.prefab and var5.GetFXPath(arg1.prefab))

	local var0 = arg1.behaviours
	local var1 = var0.Battle.BattleDataFunction.GetEnvironmentBehaviour(var0).behaviour_list

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1.type

		if var2 == var0.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			local var3 = var0.Battle.BattleDataFunction.GetResFromBuff(iter1.buff_id, 1, {})

			for iter2, iter3 in ipairs(var3) do
				arg0[#arg0 + 1] = iter3
			end
		elseif var2 == var0.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			local var4 = iter1.content and iter1.content.alert and iter1.content.alert.alert_fx

			table.insert(arg0, var4 and var5.GetFXPath(var4))

			local var5 = iter1.content and iter1.content.child_prefab

			if var5 then
				var5.GetEnvironmentRes(arg0, var5)
			end
		elseif var2 == var0.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			arg0[#arg0 + 1] = var5.GetFXPath(iter1.FX_ID)
		end
	end
end

function var5.GetMonsterRes(arg0)
	local var0 = {}
	local var1 = var5.GetEnemyResource(arg0)

	for iter0, iter1 in ipairs(var1) do
		var0[#var0 + 1] = iter1
	end

	local var2 = var0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0.monsterTemplateID)
	local var3 = Clone(var2.equipment_list)
	local var4 = var2.buff_list
	local var5 = Clone(arg0.buffList) or {}

	if arg0.phase then
		for iter2, iter3 in ipairs(arg0.phase) do
			if iter3.addWeapon then
				for iter4, iter5 in ipairs(iter3.addWeapon) do
					var3[#var3 + 1] = iter5
				end
			end

			if iter3.addRandomWeapon then
				for iter6, iter7 in ipairs(iter3.addRandomWeapon) do
					for iter8, iter9 in ipairs(iter7) do
						var3[#var3 + 1] = iter9
					end
				end
			end

			if iter3.addBuff then
				for iter10, iter11 in ipairs(iter3.addBuff) do
					var5[#var5 + 1] = iter11
				end
			end
		end
	end

	for iter12, iter13 in ipairs(var4) do
		local var6 = var0.Battle.BattleDataFunction.GetResFromBuff(iter13.ID, iter13.LV, {})

		for iter14, iter15 in ipairs(var6) do
			var0[#var0 + 1] = iter15
		end
	end

	for iter16, iter17 in ipairs(var5) do
		local var7 = var0.Battle.BattleDataFunction.GetResFromBuff(iter17, 1, {})

		for iter18, iter19 in ipairs(var7) do
			var0[#var0 + 1] = iter19
		end

		local var8 = var0.Battle.BattleDataFunction.GetBuffTemplate(iter17, 1)

		for iter20, iter21 in pairs(var8.effect_list) do
			local var9 = iter21.arg_list.skill_id

			if var9 and var0.Battle.BattleDataFunction.NeedSkillPainting(var9) then
				var0[#var0 + 1] = var5.GetPaintingPath(var1.GetMonsterTmpDataFromID(arg0.monsterTemplateID).icon)

				break
			end
		end
	end

	for iter22, iter23 in ipairs(var3) do
		local var10 = var5.GetWeaponResource(iter23)

		for iter24, iter25 in ipairs(var10) do
			var0[#var0 + 1] = iter25
		end
	end

	return var0
end

function var5.GetEquipSkinPreviewRes(arg0)
	local var0 = {}
	local var1 = var1.GetEquipSkinDataFromID(arg0)

	for iter0, iter1 in ipairs(var1.weapon_ids) do
		local var2 = var5.GetWeaponResource(iter1)

		for iter2, iter3 in ipairs(var2) do
			var0[#var0 + 1] = iter3
		end
	end

	local function var3(arg0)
		if arg0 ~= "" then
			var0[#var0 + 1] = var5.GetBulletPath(arg0)
		end
	end

	local var4, var5, var6, var7, var8, var9 = var1.GetEquipSkin(arg0)

	if _.any(EquipType.AirProtoEquipTypes, function(arg0)
		return table.contains(var1.equip_type, arg0)
	end) then
		var0[#var0 + 1] = var5.GetCharacterGoPath(var4)
	else
		var0[#var0 + 1] = var5.GetBulletPath(var4)
	end

	var3(var5)
	var3(var6)
	var3(var7)

	if var8 and var8 ~= "" then
		var0[#var0 + 1] = var5.GetFXPath(var8)
	end

	if var9 and var9 ~= "" then
		var0[#var0 + 1] = var5.GetFXPath(var9)
	end

	return var0
end

function var5.GetEquipSkinBulletRes(arg0)
	local var0 = {}
	local var1, var2, var3, var4 = var1.GetEquipSkin(arg0)
	local var5 = function(arg0)
		if arg0 ~= "" then
			var0[#var0 + 1] = var5.GetBulletPath(arg0)
		end
	end
	local var6 = var1.GetEquipSkinDataFromID(arg0)
	local var7 = false

	for iter0, iter1 in ipairs(var6.equip_type) do
		if table.contains(EquipType.AircraftSkinType, iter1) then
			var7 = true
		end
	end

	if var7 then
		if var1 ~= "" then
			var0[#var0 + 1] = var5.GetCharacterGoPath(var1)
		end
	else
		var5(var1)

		if var1.GetEquipSkinDataFromID(arg0).mirror == 1 then
			var0[#var0 + 1] = var5.GetBulletPath(var1 .. var0.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	var5(var2)
	var5(var3)
	var5(var4)

	return var0
end

function var5.GetAidUnitsRes(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var1 = var5.GetShipResource(iter1.tmpID, nil, true)

		for iter2, iter3 in ipairs(iter1.equipment) do
			if iter3 ~= 0 then
				if iter2 <= Ship.WEAPON_COUNT then
					local var2 = var1.GetWeaponDataFromID(iter3).weapon_id

					for iter4, iter5 in ipairs(var2) do
						local var3 = var5.GetWeaponResource(iter5)

						for iter6, iter7 in ipairs(var3) do
							table.insert(var1, iter7)
						end
					end
				else
					local var4 = var5.GetEquipResource(iter3)

					for iter8, iter9 in ipairs(var4) do
						table.insert(var1, iter9)
					end
				end
			end
		end

		for iter10, iter11 in ipairs(var1) do
			table.insert(var0, iter11)
		end
	end

	return var0
end

function var5.GetSpWeaponResource(arg0, arg1)
	local var0 = {}
	local var1 = var0.Battle.BattleDataFunction.GetSpWeaponDataFromID(arg0).effect_id

	if var1 ~= 0 then
		var1 = arg1 and var0.Battle.BattleDataFunction.SkillTranform(arg1, var1) or var1

		local var2 = var0.Battle.BattleDataFunction.GetResFromBuff(var1, 1, {})

		for iter0, iter1 in ipairs(var2) do
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end
