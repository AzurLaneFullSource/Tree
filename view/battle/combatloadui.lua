local var0_0 = class("CombatLoadUI", import("..base.BaseUI"))

var0_0._loadObs = nil
var0_0.LOADING_ANIMA_DISTANCE = 1820

function var0_0.getUIName(arg0_1)
	return "CombatLoadUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2
	local var2_2

	if arg1_2.system == SYSTEM_BOSS_RUSH_COLLABRATE then
		var1_2 = AppreciatePicConst.TYPE_GALLERY
		var2_2 = "bg/star_level_bg_211"
	else
		local var3_2 = AppreciatePicConst.getRandomLoadingPic()

		if var3_2 then
			var1_2 = var3_2.type
			var2_2 = var3_2.path
		else
			var1_2 = AppreciatePicConst.TYPE_GALLERY
			var2_2 = "loadingbg/login"
		end
	end

	if var2_2 then
		table.insert(var0_2, var2_2)
	end

	local var4_2 = HXSet.HxPath(var2_2)

	arg1_2._combatLoadPicData = {
		type = var1_2,
		path = var4_2
	}
	arg0_2._preloadPicType = var1_2
	arg0_2._preloadPicPath = var4_2

	local var5_2, var6_2, var7_2 = CombatLoadUI.GetTotalResourceList(arg1_2)

	if var5_2 and #var5_2 > 0 then
		for iter0_2, iter1_2 in ipairs(var5_2) do
			iter1_2 = string.lower(iter1_2)

			table.insert(var0_2, iter1_2)
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = arg0_3.contextData and arg0_3.contextData._combatLoadPicData

	arg0_3._preloadPicType = var0_3 and var0_3.type or nil
	arg0_3._preloadPicPath = var0_3 and var0_3.path or nil
	arg0_3._preloadPicSprite = nil
	arg0_3._preloadBgFitMode = PlayerPrefs.GetInt("bgFitMode", 0)

	if arg0_3._preloadPicPath then
		LoadSpriteAsync(arg0_3._preloadPicPath, function(arg0_4)
			arg0_3._preloadPicSprite = arg0_4

			arg1_3()
		end)
	else
		arg1_3()
	end
end

function var0_0.init(arg0_5)
	local var0_5 = arg0_5._tf:Find("loading")

	arg0_5._loadingProgress = var0_5:Find("loading_bar"):GetComponent(typeof(Slider))
	arg0_5._loadingProgress.value = 0
	arg0_5._loadingText = var0_5:Find("loading_label/percent"):GetComponent(typeof(Text))
	arg0_5._loadingAnima = var0_5:Find("loading_anima")
	arg0_5._loadingAnimaPosY = arg0_5._loadingAnima.anchoredPosition.y
	arg0_5._finishAnima = var0_5:Find("done_anima")

	SetActive(arg0_5._loadingAnima, true)
	SetActive(arg0_5._finishAnima, false)
	arg0_5._finishAnima:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_6)
		arg0_5:emit(CombatLoadMediator.FINISH, arg0_5._loadObs)
	end)

	local var1_5 = arg0_5._tf:Find("GalleryEnv")
	local var2_5 = arg0_5._tf:Find("GalleryFit")
	local var3_5 = arg0_5._preloadBgFitMode or PlayerPrefs.GetInt("bgFitMode", 0)

	arg0_5.bg = var3_5 == 1 and var2_5 or var1_5

	local var4_5 = arg0_5._tf:Find("Manga")

	arg0_5.mangaPicImg = arg0_5._tf:Find("Manga/Pic")

	local function var5_5(arg0_7)
		SetActive(var1_5, var3_5 ~= 1)
		SetActive(var2_5, var3_5 == 1)
		SetActive(var4_5, false)
		setImageSprite(arg0_5.bg, arg0_7 or LoadSprite("loadingbg/login"))
	end

	if arg0_5._preloadPicType == AppreciatePicConst.TYPE_MANGA and arg0_5._preloadPicSprite then
		SetActive(var1_5, false)
		SetActive(var2_5, false)
		SetActive(var4_5, true)
		setImageSprite(arg0_5.mangaPicImg, arg0_5._preloadPicSprite)
	else
		var5_5(arg0_5._preloadPicSprite)
	end

	arg0_5._tipsText = var0_5:Find("tipsText"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_8)
	arg0_8:Preload()
end

function var0_0.onBackPressed(arg0_9)
	return
end

function var0_0.Preload(arg0_10)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_10._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_10 = ys.Battle.BattleResourceManager.GetInstance()

	var0_10:Init()

	local var1_10 = getProxy(BayProxy)
	local var2_10, var3_10 = var0_0.GetTotalResourceList(arg0_10.contextData)

	for iter0_10, iter1_10 in ipairs(var2_10) do
		var0_10:AddPreloadResource(iter1_10)
	end

	for iter2_10, iter3_10 in ipairs(var3_10) do
		var0_10:AddPreloadCV(iter3_10)
	end

	if arg0_10.contextData.system == SYSTEM_DEBUG and BATTLE_DEBUG_CUSTOM_WEAPON then
		for iter4_10, iter5_10 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
			local var4_10 = "触发自定义子弹替换>>>" .. iter4_10 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var4_10)

			pg.bullet_template[iter4_10] = iter5_10
		end

		for iter6_10, iter7_10 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
			local var5_10 = "触发自定义弹幕替换>>>" .. iter6_10 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var5_10)

			pg.barrage_template[iter6_10] = iter7_10
		end

		for iter8_10, iter9_10 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
			local var6_10 = "触发自定义飞机替换>>>" .. iter8_10 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var6_10)

			pg.aircraft_template[iter8_10] = iter9_10
		end

		for iter10_10, iter11_10 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
			local var7_10 = "触发自定义武器替换>>>" .. iter10_10 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var7_10)

			pg.weapon_property[iter10_10] = iter11_10

			local var8_10 = var0_10.GetWeaponResource(iter10_10)

			for iter12_10, iter13_10 in ipairs(var8_10) do
				var0_10:AddPreloadResource(iter13_10)
			end
		end
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var9_10 = {}
		local var10_10 = getProxy(FleetProxy):getFleetById(11)
		local var11_10 = var10_10:getTeamByName(TeamType.Submarine)

		for iter14_10, iter15_10 in ipairs(var11_10) do
			table.insert(var9_10, var1_10:getShipById(iter15_10))
		end

		local var12_10, var13_10 = var0_10.GetPlayerShipResource(var9_10, arg0_10.contextData.system)

		for iter16_10, iter17_10 in ipairs(var12_10) do
			var0_10:AddPreloadResource(iter17_10)
		end

		for iter18_10, iter19_10 in ipairs(var13_10) do
			var0_10:AddPreloadCV(iter19_10)
		end

		var0_0.addCommanderBuffRes(var10_10:buildBattleBuffList())
	end

	local function var14_10()
		SetActive(arg0_10._loadingAnima, false)
		SetActive(arg0_10._finishAnima, true)

		arg0_10._finishAnima:GetComponent("Animator").enabled = true
	end

	local var15_10 = 0

	local function var16_10(arg0_12)
		local var0_12
		local var1_12 = var15_10 == 0 and 0 or arg0_12 / var15_10

		arg0_10._loadingProgress.value = var1_12
		arg0_10._loadingText.text = string.format("%.2f", var1_12 * 100) .. "%"
		arg0_10._loadingAnima.anchoredPosition = Vector2(var1_12 * var0_0.LOADING_ANIMA_DISTANCE, arg0_10._loadingAnimaPosY)
	end

	local var17_10 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var17_10, true)

	var15_10 = var0_10:StartPreload(var14_10, var16_10)
	arg0_10._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

function var0_0.GetTotalResourceList(arg0_13)
	local var0_13 = {}
	local var1_13 = {}
	local var2_13 = {}
	local var3_13 = ys.Battle.BattleGate.Gates[arg0_13.system]

	if var3_13.GetPreloadList then
		local var4_13, var5_13 = var3_13.GetPreloadList(arg0_13)

		for iter0_13, iter1_13 in ipairs(var4_13) do
			table.insert(var0_13, iter1_13)
		end

		for iter2_13, iter3_13 in ipairs(var5_13) do
			table.insert(var1_13, iter3_13)
		end
	elseif arg0_13.mainFleetId then
		local var6_13 = getProxy(FleetProxy):getFleetById(arg0_13.mainFleetId)
		local var7_13 = getProxy(BayProxy):getShipsByFleet(var6_13)

		for iter4_13, iter5_13 in ipairs(var7_13) do
			table.insert(var2_13, iter5_13)
		end
	end

	if arg0_13.prefabFleet then
		local var8_13 = arg0_13.prefabFleet.main_unitList or {}
		local var9_13 = arg0_13.prefabFleet.vanguard_unitList or {}
		local var10_13 = arg0_13.prefabFleet.submarine_unitList or {}

		for iter6_13, iter7_13 in ipairs(var8_13) do
			table.insert(var2_13, var0_0.generatePrefabShipData(iter7_13))
		end

		for iter8_13, iter9_13 in ipairs(var9_13) do
			table.insert(var2_13, var0_0.generatePrefabShipData(iter9_13))
		end

		for iter10_13, iter11_13 in ipairs(var10_13) do
			table.insert(var2_13, var0_0.generatePrefabShipData(iter11_13))
		end
	end

	local var11_13 = ys.Battle.BattleResourceManager.GetInstance()
	local var12_13, var13_13 = var11_13.GetPlayerShipResource(var2_13, arg0_13.system)

	for iter12_13, iter13_13 in ipairs(var12_13) do
		table.insert(var0_13, iter13_13)
	end

	for iter14_13, iter15_13 in ipairs(var13_13) do
		table.insert(var1_13, iter15_13)
	end

	local var14_13 = pg.expedition_data_template[arg0_13.stageId].dungeon_id
	local var15_13, var16_13 = var11_13.GetStageResource(var14_13)

	for iter16_13, iter17_13 in ipairs(var15_13) do
		table.insert(var0_13, iter17_13)
	end

	for iter18_13, iter19_13 in ipairs(var11_13.GetCommonResource()) do
		table.insert(var0_13, iter19_13)
	end

	for iter20_13, iter21_13 in ipairs(var11_13.GetBuffResource()) do
		table.insert(var0_13, iter21_13)
	end

	for iter22_13, iter23_13 in ipairs(var16_13) do
		table.insert(var1_13, iter23_13)
	end

	local var17_13 = pg.expedition_data_template[arg0_13.stageId]

	if arg0_13.system == SYSTEM_WORLD and var17_13.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var18_13 = nowWorld():GetActiveMap()

		for iter24_13, iter25_13 in ipairs(var11_13.GetMapResource(var18_13.config.expedition_map_id)) do
			table.insert(var0_13, iter25_13)
		end
	else
		for iter26_13, iter27_13 in ipairs(var17_13.map_id) do
			for iter28_13, iter29_13 in ipairs(var11_13.GetMapResource(iter27_13[1])) do
				table.insert(var0_13, iter29_13)
			end
		end
	end

	if pg.battle_cost_template[arg0_13.system].global_buff_effected > 0 then
		local var19_13 = BuffHelper.GetBattleBuffs()
		local var20_13 = _.map(var19_13, function(arg0_14)
			return arg0_14:getConfig("benefit_effect")
		end)

		for iter30_13, iter31_13 in ipairs(var20_13) do
			iter31_13 = tonumber(iter31_13)

			local var21_13 = ys.Battle.BattleDataFunction.GetResFromBuff(iter31_13, 1, {})

			for iter32_13, iter33_13 in ipairs(var21_13) do
				table.insert(var0_13, iter33_13)
			end
		end
	end

	local var22_13 = var11_13.GetStageBGM(var14_13)

	return var0_13, var1_13, var22_13
end

function var0_0.generatePrefabShipData(arg0_15)
	local var0_15 = {
		configId = arg0_15.configId,
		equipments = {},
		skinId = arg0_15.skinId,
		buffs = arg0_15.skills
	}
	local var1_15 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(arg0_15.configId)
	local var2_15 = math.max(#arg0_15.equipment, #var1_15.default_equip_list)

	for iter0_15 = 1, var2_15 do
		var0_15.equipments[iter0_15] = arg0_15.equipment[iter0_15] and {
			configId = arg0_15.equipment[iter0_15]
		} or false
	end

	function var0_15.getActiveEquipments(arg0_16)
		return arg0_16.equipments
	end

	return var0_15
end

function var0_0.addCommanderBuffRes(arg0_17)
	local var0_17 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_17, iter1_17 in ipairs(arg0_17) do
		local var1_17 = var0_17.GetCommanderResource(iter1_17)

		for iter2_17, iter3_17 in ipairs(var1_17) do
			var0_17:AddPreloadResource(iter3_17)
		end
	end
end

return var0_0
