local var0_0 = class("CombatLoadUI", import("..base.BaseUI"))

var0_0._loadObs = nil
var0_0.LOADING_ANIMA_DISTANCE = 1820

function var0_0.getUIName(arg0_1)
	return "CombatLoadUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2._preloadBGSprite = nil

	local var0_2 = arg0_2.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE and "bg/star_level_bg_211" or var0_0.GetRandomBGPath()

	if var0_2 then
		LoadSpriteAsync(var0_2, function(arg0_3)
			arg0_2._preloadBGSprite = arg0_3

			arg1_2()
		end)
	else
		arg1_2()
	end
end

function var0_0.init(arg0_4)
	local var0_4 = arg0_4._tf:Find("loading")

	arg0_4._loadingProgress = var0_4:Find("loading_bar"):GetComponent(typeof(Slider))
	arg0_4._loadingProgress.value = 0
	arg0_4._loadingText = var0_4:Find("loading_label/percent"):GetComponent(typeof(Text))
	arg0_4._loadingAnima = var0_4:Find("loading_anima")
	arg0_4._loadingAnimaPosY = arg0_4._loadingAnima.anchoredPosition.y
	arg0_4._finishAnima = var0_4:Find("done_anima")

	SetActive(arg0_4._loadingAnima, true)
	SetActive(arg0_4._finishAnima, false)
	arg0_4._finishAnima:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_5)
		arg0_4:emit(CombatLoadMediator.FINISH, arg0_4._loadObs)
	end)

	local var1_4 = arg0_4._tf:Find("bg")
	local var2_4 = arg0_4._tf:Find("bg2")
	local var3_4 = PlayerPrefs.GetInt("bgFitMode", 0)

	arg0_4.bg = var3_4 == 1 and var2_4 or var1_4

	SetActive(var1_4, var3_4 ~= 1)
	SetActive(var2_4, var3_4 == 1)

	if arg0_4._preloadBGSprite then
		setImageSprite(arg0_4.bg, arg0_4._preloadBGSprite)
	end

	arg0_4._tipsText = var0_4:Find("tipsText"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_6)
	arg0_6:Preload()
end

function var0_0.onBackPressed(arg0_7)
	return
end

function var0_0.Preload(arg0_8)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_8._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_8 = ys.Battle.BattleResourceManager.GetInstance()

	var0_8:Init()

	local var1_8 = getProxy(BayProxy)
	local var2_8, var3_8 = var0_0.GetTotalResourceList(arg0_8.contextData)

	for iter0_8, iter1_8 in ipairs(var2_8) do
		var0_8:AddPreloadResource(iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(var3_8) do
		var0_8:AddPreloadCV(iter3_8)
	end

	if arg0_8.contextData.system == SYSTEM_DEBUG and BATTLE_DEBUG_CUSTOM_WEAPON then
		for iter4_8, iter5_8 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
			local var4_8 = "触发自定义子弹替换>>>" .. iter4_8 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var4_8)

			pg.bullet_template[iter4_8] = iter5_8
		end

		for iter6_8, iter7_8 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
			local var5_8 = "触发自定义弹幕替换>>>" .. iter6_8 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var5_8)

			pg.barrage_template[iter6_8] = iter7_8
		end

		for iter8_8, iter9_8 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
			local var6_8 = "触发自定义飞机替换>>>" .. iter8_8 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var6_8)

			pg.aircraft_template[iter8_8] = iter9_8
		end

		for iter10_8, iter11_8 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
			local var7_8 = "触发自定义武器替换>>>" .. iter10_8 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var7_8)

			pg.weapon_property[iter10_8] = iter11_8

			local var8_8 = var0_8.GetWeaponResource(iter10_8)

			for iter12_8, iter13_8 in ipairs(var8_8) do
				var0_8:AddPreloadResource(iter13_8)
			end
		end
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var9_8 = {}
		local var10_8 = getProxy(FleetProxy):getFleetById(11)
		local var11_8 = var10_8:getTeamByName(TeamType.Submarine)

		for iter14_8, iter15_8 in ipairs(var11_8) do
			table.insert(var9_8, var1_8:getShipById(iter15_8))
		end

		local var12_8, var13_8 = var0_8.GetPlayerShipResource(var9_8, arg0_8.contextData.system)

		for iter16_8, iter17_8 in ipairs(var12_8) do
			var0_8:AddPreloadResource(iter17_8)
		end

		for iter18_8, iter19_8 in ipairs(var13_8) do
			var0_8:AddPreloadCV(iter19_8)
		end

		var0_0.addCommanderBuffRes(var10_8:buildBattleBuffList())
	end

	local var14_8, var15_8 = var0_0.GetTotalResourceList(arg0_8.contextData)

	for iter20_8, iter21_8 in ipairs(var14_8) do
		var0_8:AddPreloadResource(iter21_8)
	end

	for iter22_8, iter23_8 in ipairs(var15_8) do
		var0_8:AddPreloadCV(iter23_8)
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var16_8 = getProxy(FleetProxy):getFleetById(11)
		local var17_8 = var16_8:getTeamByName(TeamType.Submarine)

		for iter24_8, iter25_8 in ipairs(var17_8) do
			table.insert(loadShip, var1_8:getShipById(iter25_8))
		end

		var0_0.addCommanderBuffRes(var16_8:buildBattleBuffList())
	end

	local function var18_8()
		SetActive(arg0_8._loadingAnima, false)
		SetActive(arg0_8._finishAnima, true)

		arg0_8._finishAnima:GetComponent("Animator").enabled = true
	end

	local var19_8 = 0

	local function var20_8(arg0_10)
		local var0_10
		local var1_10 = var19_8 == 0 and 0 or arg0_10 / var19_8

		arg0_8._loadingProgress.value = var1_10
		arg0_8._loadingText.text = string.format("%.2f", var1_10 * 100) .. "%"
		arg0_8._loadingAnima.anchoredPosition = Vector2(var1_10 * var0_0.LOADING_ANIMA_DISTANCE, arg0_8._loadingAnimaPosY)
	end

	local var21_8 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var21_8, true)

	var19_8 = var0_8:StartPreload(var18_8, var20_8)
	arg0_8._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

function var0_0.GetTotalResourceList(arg0_11)
	local var0_11 = {}
	local var1_11 = {}
	local var2_11 = {}
	local var3_11 = ys.Battle.BattleGate.Gates[arg0_11.system]

	if var3_11.GetPreloadList then
		local var4_11, var5_11 = var3_11.GetPreloadList(arg0_11)

		for iter0_11, iter1_11 in ipairs(var4_11) do
			table.insert(var0_11, iter1_11)
		end

		for iter2_11, iter3_11 in ipairs(var5_11) do
			table.insert(var1_11, iter3_11)
		end
	elseif arg0_11.mainFleetId then
		local var6_11 = getProxy(FleetProxy):getFleetById(arg0_11.mainFleetId)
		local var7_11 = getProxy(BayProxy):getShipsByFleet(var6_11)

		for iter4_11, iter5_11 in ipairs(var7_11) do
			table.insert(var2_11, iter5_11)
		end
	end

	if arg0_11.prefabFleet then
		local var8_11 = arg0_11.prefabFleet.main_unitList or {}
		local var9_11 = arg0_11.prefabFleet.vanguard_unitList or {}
		local var10_11 = arg0_11.prefabFleet.submarine_unitList or {}

		for iter6_11, iter7_11 in ipairs(var8_11) do
			table.insert(var2_11, var0_0.generatePrefabShipData(iter7_11))
		end

		for iter8_11, iter9_11 in ipairs(var9_11) do
			table.insert(var2_11, var0_0.generatePrefabShipData(iter9_11))
		end

		for iter10_11, iter11_11 in ipairs(var10_11) do
			table.insert(var2_11, var0_0.generatePrefabShipData(iter11_11))
		end
	end

	local var11_11 = ys.Battle.BattleResourceManager.GetInstance()
	local var12_11, var13_11 = var11_11.GetPlayerShipResource(var2_11, arg0_11.system)

	for iter12_11, iter13_11 in ipairs(var12_11) do
		table.insert(var0_11, iter13_11)
	end

	for iter14_11, iter15_11 in ipairs(var13_11) do
		table.insert(var1_11, iter15_11)
	end

	local var14_11 = pg.expedition_data_template[arg0_11.stageId].dungeon_id
	local var15_11, var16_11 = var11_11.GetStageResource(var14_11)

	for iter16_11, iter17_11 in ipairs(var15_11) do
		table.insert(var0_11, iter17_11)
	end

	for iter18_11, iter19_11 in ipairs(var11_11.GetCommonResource()) do
		table.insert(var0_11, iter19_11)
	end

	for iter20_11, iter21_11 in ipairs(var11_11.GetBuffResource()) do
		table.insert(var0_11, iter21_11)
	end

	for iter22_11, iter23_11 in ipairs(var16_11) do
		table.insert(var1_11, iter23_11)
	end

	local var17_11 = pg.expedition_data_template[arg0_11.stageId]

	if arg0_11.system == SYSTEM_WORLD and var17_11.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var18_11 = nowWorld():GetActiveMap()

		for iter24_11, iter25_11 in ipairs(var11_11.GetMapResource(var18_11.config.expedition_map_id)) do
			table.insert(var0_11, iter25_11)
		end
	else
		for iter26_11, iter27_11 in ipairs(var17_11.map_id) do
			for iter28_11, iter29_11 in ipairs(var11_11.GetMapResource(iter27_11[1])) do
				table.insert(var0_11, iter29_11)
			end
		end
	end

	if pg.battle_cost_template[arg0_11.system].global_buff_effected > 0 then
		local var19_11 = BuffHelper.GetBattleBuffs()
		local var20_11 = _.map(var19_11, function(arg0_12)
			return arg0_12:getConfig("benefit_effect")
		end)

		for iter30_11, iter31_11 in ipairs(var20_11) do
			iter31_11 = tonumber(iter31_11)

			local var21_11 = ys.Battle.BattleDataFunction.GetResFromBuff(iter31_11, 1, {})

			for iter32_11, iter33_11 in ipairs(var21_11) do
				table.insert(var0_11, iter33_11)
			end
		end
	end

	local var22_11 = var11_11.GetStageBGM(var14_11)

	return var0_11, var1_11, var22_11
end

function var0_0.generatePrefabShipData(arg0_13)
	local var0_13 = {
		configId = arg0_13.configId,
		equipments = {},
		skinId = arg0_13.skinId,
		buffs = arg0_13.skills
	}
	local var1_13 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(arg0_13.configId)
	local var2_13 = math.max(#arg0_13.equipment, #var1_13.default_equip_list)

	for iter0_13 = 1, var2_13 do
		var0_13.equipments[iter0_13] = arg0_13.equipment[iter0_13] and {
			configId = arg0_13.equipment[iter0_13]
		} or false
	end

	function var0_13.getActiveEquipments(arg0_14)
		return arg0_14.equipments
	end

	return var0_13
end

function var0_0.addCommanderBuffRes(arg0_15)
	local var0_15 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_15, iter1_15 in ipairs(arg0_15) do
		local var1_15 = var0_15.GetCommanderResource(iter1_15)

		for iter2_15, iter3_15 in ipairs(var1_15) do
			var0_15:AddPreloadResource(iter3_15)
		end
	end
end

function var0_0.GetExistBGList()
	local var0_16 = LOADING_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOADING_HX_LV.key_value and "loadingbg_hx/bg_" or "loadingbg/bg_"
	local var1_16 = {}

	for iter0_16 = 1, BG_RANDOM_RANGE do
		local var2_16 = var0_16 .. iter0_16

		if checkABExist(var2_16) then
			table.insert(var1_16, var2_16)
		end
	end

	return var1_16
end

function var0_0.GetRandomBGPath()
	local var0_17 = var0_0.GetExistBGList()

	return var0_17[math.random(1, #var0_17)]
end

function var0_0.EnsureBaseBGList()
	local var0_18 = {}

	if #var0_0.GetExistBGList() <= 0 then
		table.insert(var0_18, "loadingbg_hx/bg_1")
		table.insert(var0_18, "loadingbg/bg_1")
	end

	return var0_18
end

return var0_0
