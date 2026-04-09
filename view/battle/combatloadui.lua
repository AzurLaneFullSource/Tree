local var0_0 = class("CombatLoadUI", import("..base.BaseUI"))

var0_0._loadObs = nil
var0_0.LOADING_ANIMA_DISTANCE = 1820

function var0_0.getUIName(arg0_1)
	return "CombatLoadUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("loading")

	arg0_2._loadingProgress = var0_2:Find("loading_bar"):GetComponent(typeof(Slider))
	arg0_2._loadingProgress.value = 0
	arg0_2._loadingText = var0_2:Find("loading_label/percent"):GetComponent(typeof(Text))
	arg0_2._loadingAnima = var0_2:Find("loading_anima")
	arg0_2._loadingAnimaPosY = arg0_2._loadingAnima.anchoredPosition.y
	arg0_2._finishAnima = var0_2:Find("done_anima")

	SetActive(arg0_2._loadingAnima, true)
	SetActive(arg0_2._finishAnima, false)
	arg0_2._finishAnima:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_3)
		arg0_2:emit(CombatLoadMediator.FINISH, arg0_2._loadObs)
	end)

	local var1_2 = arg0_2._tf:Find("bg")
	local var2_2 = arg0_2._tf:Find("bg2")
	local var3_2 = PlayerPrefs.GetInt("bgFitMode", 0)

	arg0_2.bg = var3_2 == 1 and var2_2 or var1_2

	SetActive(var1_2, var3_2 ~= 1)
	SetActive(var2_2, var3_2 == 1)

	local var4_2 = (LOADING_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOADING_HX_LV.key_value and "loadingbg_hx/bg_" or "loadingbg/bg_") .. math.random(1, BG_RANDOM_RANGE)

	setImageSprite(arg0_2.bg, LoadSprite(var4_2))

	arg0_2._tipsText = var0_2:Find("tipsText"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_4)
	arg0_4:Preload()
end

function var0_0.onBackPressed(arg0_5)
	return
end

function var0_0.Preload(arg0_6)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_6._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_6 = ys.Battle.BattleResourceManager.GetInstance()

	var0_6:Init()

	local var1_6 = getProxy(BayProxy)

	if arg0_6.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
		setImageSprite(arg0_6.bg, LoadSprite("bg/star_level_bg_211"))
	end

	local var2_6, var3_6 = var0_0.GetTotalResourceList(arg0_6.contextData)

	for iter0_6, iter1_6 in ipairs(var2_6) do
		var0_6:AddPreloadResource(iter1_6)
	end

	for iter2_6, iter3_6 in ipairs(var3_6) do
		var0_6:AddPreloadCV(iter3_6)
	end

	if arg0_6.contextData.system == SYSTEM_DEBUG and BATTLE_DEBUG_CUSTOM_WEAPON then
		for iter4_6, iter5_6 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
			local var4_6 = "触发自定义子弹替换>>>" .. iter4_6 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var4_6)

			pg.bullet_template[iter4_6] = iter5_6
		end

		for iter6_6, iter7_6 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
			local var5_6 = "触发自定义弹幕替换>>>" .. iter6_6 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var5_6)

			pg.barrage_template[iter6_6] = iter7_6
		end

		for iter8_6, iter9_6 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
			local var6_6 = "触发自定义飞机替换>>>" .. iter8_6 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var6_6)

			pg.aircraft_template[iter8_6] = iter9_6
		end

		for iter10_6, iter11_6 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
			local var7_6 = "触发自定义武器替换>>>" .. iter10_6 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var7_6)

			pg.weapon_property[iter10_6] = iter11_6

			local var8_6 = var0_6.GetWeaponResource(iter10_6)

			for iter12_6, iter13_6 in ipairs(var8_6) do
				var0_6:AddPreloadResource(iter13_6)
			end
		end
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var9_6 = {}
		local var10_6 = getProxy(FleetProxy):getFleetById(11)
		local var11_6 = var10_6:getTeamByName(TeamType.Submarine)

		for iter14_6, iter15_6 in ipairs(var11_6) do
			table.insert(var9_6, var1_6:getShipById(iter15_6))
		end

		local var12_6, var13_6 = var0_6.GetPlayerShipResource(var9_6, arg0_6.contextData.system)

		for iter16_6, iter17_6 in ipairs(var12_6) do
			var0_6:AddPreloadResource(iter17_6)
		end

		for iter18_6, iter19_6 in ipairs(var13_6) do
			var0_6:AddPreloadCV(iter19_6)
		end

		var0_0.addCommanderBuffRes(var10_6:buildBattleBuffList())
	end

	local function var14_6()
		SetActive(arg0_6._loadingAnima, false)
		SetActive(arg0_6._finishAnima, true)

		arg0_6._finishAnima:GetComponent("Animator").enabled = true
	end

	local var15_6 = 0

	local function var16_6(arg0_8)
		local var0_8
		local var1_8 = var15_6 == 0 and 0 or arg0_8 / var15_6

		arg0_6._loadingProgress.value = var1_8
		arg0_6._loadingText.text = string.format("%.2f", var1_8 * 100) .. "%"
		arg0_6._loadingAnima.anchoredPosition = Vector2(var1_8 * var0_0.LOADING_ANIMA_DISTANCE, arg0_6._loadingAnimaPosY)
	end

	local var17_6 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var17_6, true)

	var15_6 = var0_6:StartPreload(var14_6, var16_6)
	arg0_6._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

function var0_0.GetTotalResourceList(arg0_9)
	local var0_9 = {}
	local var1_9 = {}
	local var2_9 = {}
	local var3_9 = ys.Battle.BattleGate.Gates[arg0_9.system]

	if var3_9.GetPreloadList then
		local var4_9, var5_9 = var3_9.GetPreloadList(arg0_9)

		for iter0_9, iter1_9 in ipairs(var4_9) do
			table.insert(var0_9, iter1_9)
		end

		for iter2_9, iter3_9 in ipairs(var5_9) do
			table.insert(var1_9, iter3_9)
		end
	elseif arg0_9.mainFleetId then
		local var6_9 = getProxy(FleetProxy):getFleetById(arg0_9.mainFleetId)
		local var7_9 = getProxy(BayProxy):getShipsByFleet(var6_9)

		for iter4_9, iter5_9 in ipairs(var7_9) do
			table.insert(var2_9, iter5_9)
		end
	end

	if arg0_9.prefabFleet then
		local var8_9 = arg0_9.prefabFleet.main_unitList or {}
		local var9_9 = arg0_9.prefabFleet.vanguard_unitList or {}
		local var10_9 = arg0_9.prefabFleet.submarine_unitList or {}

		for iter6_9, iter7_9 in ipairs(var8_9) do
			table.insert(var2_9, var0_0.generatePrefabShipData(iter7_9))
		end

		for iter8_9, iter9_9 in ipairs(var9_9) do
			table.insert(var2_9, var0_0.generatePrefabShipData(iter9_9))
		end

		for iter10_9, iter11_9 in ipairs(var10_9) do
			table.insert(var2_9, var0_0.generatePrefabShipData(iter11_9))
		end
	end

	local var11_9 = ys.Battle.BattleResourceManager.GetInstance()
	local var12_9, var13_9 = var11_9.GetPlayerShipResource(var2_9, arg0_9.system)

	for iter12_9, iter13_9 in ipairs(var12_9) do
		table.insert(var0_9, iter13_9)
	end

	for iter14_9, iter15_9 in ipairs(var13_9) do
		table.insert(var1_9, iter15_9)
	end

	local var14_9 = pg.expedition_data_template[arg0_9.stageId].dungeon_id
	local var15_9, var16_9 = var11_9.GetStageResource(var14_9)

	for iter16_9, iter17_9 in ipairs(var15_9) do
		table.insert(var0_9, iter17_9)
	end

	for iter18_9, iter19_9 in ipairs(var11_9.GetCommonResource()) do
		table.insert(var0_9, iter19_9)
	end

	for iter20_9, iter21_9 in ipairs(var11_9.GetBuffResource()) do
		table.insert(var0_9, iter21_9)
	end

	for iter22_9, iter23_9 in ipairs(var16_9) do
		table.insert(var1_9, iter23_9)
	end

	local var17_9 = pg.expedition_data_template[arg0_9.stageId]

	if arg0_9.system == SYSTEM_WORLD and var17_9.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var18_9 = nowWorld():GetActiveMap()

		for iter24_9, iter25_9 in ipairs(var11_9.GetMapResource(var18_9.config.expedition_map_id)) do
			table.insert(var0_9, iter25_9)
		end
	else
		for iter26_9, iter27_9 in ipairs(var17_9.map_id) do
			for iter28_9, iter29_9 in ipairs(var11_9.GetMapResource(iter27_9[1])) do
				table.insert(var0_9, iter29_9)
			end
		end
	end

	if pg.battle_cost_template[arg0_9.system].global_buff_effected > 0 then
		local var19_9 = BuffHelper.GetBattleBuffs()
		local var20_9 = _.map(var19_9, function(arg0_10)
			return arg0_10:getConfig("benefit_effect")
		end)

		for iter30_9, iter31_9 in ipairs(var20_9) do
			iter31_9 = tonumber(iter31_9)

			local var21_9 = ys.Battle.BattleDataFunction.GetResFromBuff(iter31_9, 1, {})

			for iter32_9, iter33_9 in ipairs(var21_9) do
				table.insert(var0_9, iter33_9)
			end
		end
	end

	return var0_9, var1_9
end

function var0_0.generatePrefabShipData(arg0_11)
	local var0_11 = {
		configId = arg0_11.configId,
		equipments = {},
		skinId = arg0_11.skinId,
		buffs = arg0_11.skills
	}
	local var1_11 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(arg0_11.configId)
	local var2_11 = math.max(#arg0_11.equipment, #var1_11.default_equip_list)

	for iter0_11 = 1, var2_11 do
		var0_11.equipments[iter0_11] = arg0_11.equipment[iter0_11] and {
			configId = arg0_11.equipment[iter0_11]
		} or false
	end

	function var0_11.getActiveEquipments(arg0_12)
		return arg0_12.equipments
	end

	return var0_11
end

function var0_0.addCommanderBuffRes(arg0_13)
	local var0_13 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_13, iter1_13 in ipairs(arg0_13) do
		local var1_13 = var0_13.GetCommanderResource(iter1_13)

		for iter2_13, iter3_13 in ipairs(var1_13) do
			var0_13:AddPreloadResource(iter3_13)
		end
	end
end

return var0_0
