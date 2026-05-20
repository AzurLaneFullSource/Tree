local var0_0 = class("CombatLoadUI", import("..base.BaseUI"))

var0_0._loadObs = nil
var0_0.LOADING_ANIMA_DISTANCE = 1820

function var0_0.getUIName(arg0_1)
	return "CombatLoadUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2._preloadPicType = nil
	arg0_2._preloadPicPath = nil
	arg0_2._preloadPicSprite = nil
	arg0_2._preloadBgFitMode = PlayerPrefs.GetInt("bgFitMode", 0)

	local var0_2
	local var1_2

	if arg0_2.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
		var0_2 = AppreciatePicConst.TYPE_GALLERY
		var1_2 = "bg/star_level_bg_211"
	else
		local var2_2 = AppreciatePicConst.getRandomLoadingPic()

		if var2_2 then
			var0_2 = var2_2.type
			var1_2 = var2_2.path
		else
			var0_2 = AppreciatePicConst.TYPE_GALLERY
			var1_2 = "loadingbg/login"
		end
	end

	arg0_2._preloadPicType = var0_2
	arg0_2._preloadPicPath = var1_2

	if var1_2 then
		LoadSpriteAsync(var1_2, function(arg0_3)
			arg0_2._preloadPicSprite = arg0_3

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

	local var1_4 = arg0_4._tf:Find("GalleryEnv")
	local var2_4 = arg0_4._tf:Find("GalleryFit")
	local var3_4 = arg0_4._preloadBgFitMode or PlayerPrefs.GetInt("bgFitMode", 0)

	arg0_4.bg = var3_4 == 1 and var2_4 or var1_4

	local var4_4 = arg0_4._tf:Find("Manga")

	arg0_4.mangaPicImg = arg0_4._tf:Find("Manga/Pic")

	local function var5_4(arg0_6)
		SetActive(var1_4, var3_4 ~= 1)
		SetActive(var2_4, var3_4 == 1)
		SetActive(var4_4, false)
		setImageSprite(arg0_4.bg, arg0_6 or LoadSprite("loadingbg/login"))
	end

	if arg0_4._preloadPicType == AppreciatePicConst.TYPE_MANGA and arg0_4._preloadPicSprite then
		SetActive(var1_4, false)
		SetActive(var2_4, false)
		SetActive(var4_4, true)
		setImageSprite(arg0_4.mangaPicImg, arg0_4._preloadPicSprite)
	else
		var5_4(arg0_4._preloadPicSprite)
	end

	arg0_4._tipsText = var0_4:Find("tipsText"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_7)
	arg0_7:Preload()
end

function var0_0.onBackPressed(arg0_8)
	return
end

function var0_0.Preload(arg0_9)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_9._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_9 = ys.Battle.BattleResourceManager.GetInstance()

	var0_9:Init()

	local var1_9 = getProxy(BayProxy)
	local var2_9, var3_9 = var0_0.GetTotalResourceList(arg0_9.contextData)

	for iter0_9, iter1_9 in ipairs(var2_9) do
		var0_9:AddPreloadResource(iter1_9)
	end

	for iter2_9, iter3_9 in ipairs(var3_9) do
		var0_9:AddPreloadCV(iter3_9)
	end

	if arg0_9.contextData.system == SYSTEM_DEBUG and BATTLE_DEBUG_CUSTOM_WEAPON then
		for iter4_9, iter5_9 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
			local var4_9 = "触发自定义子弹替换>>>" .. iter4_9 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var4_9)

			pg.bullet_template[iter4_9] = iter5_9
		end

		for iter6_9, iter7_9 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
			local var5_9 = "触发自定义弹幕替换>>>" .. iter6_9 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var5_9)

			pg.barrage_template[iter6_9] = iter7_9
		end

		for iter8_9, iter9_9 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
			local var6_9 = "触发自定义飞机替换>>>" .. iter8_9 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var6_9)

			pg.aircraft_template[iter8_9] = iter9_9
		end

		for iter10_9, iter11_9 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
			local var7_9 = "触发自定义武器替换>>>" .. iter10_9 .. "<<<，检查是否测试需要，否则联系程序"

			pg.TipsMgr.GetInstance():ShowTips(var7_9)

			pg.weapon_property[iter10_9] = iter11_9

			local var8_9 = var0_9.GetWeaponResource(iter10_9)

			for iter12_9, iter13_9 in ipairs(var8_9) do
				var0_9:AddPreloadResource(iter13_9)
			end
		end
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var9_9 = {}
		local var10_9 = getProxy(FleetProxy):getFleetById(11)
		local var11_9 = var10_9:getTeamByName(TeamType.Submarine)

		for iter14_9, iter15_9 in ipairs(var11_9) do
			table.insert(var9_9, var1_9:getShipById(iter15_9))
		end

		local var12_9, var13_9 = var0_9.GetPlayerShipResource(var9_9, arg0_9.contextData.system)

		for iter16_9, iter17_9 in ipairs(var12_9) do
			var0_9:AddPreloadResource(iter17_9)
		end

		for iter18_9, iter19_9 in ipairs(var13_9) do
			var0_9:AddPreloadCV(iter19_9)
		end

		var0_0.addCommanderBuffRes(var10_9:buildBattleBuffList())
	end

	local var14_9, var15_9 = var0_0.GetTotalResourceList(arg0_9.contextData)

	for iter20_9, iter21_9 in ipairs(var14_9) do
		var0_9:AddPreloadResource(iter21_9)
	end

	for iter22_9, iter23_9 in ipairs(var15_9) do
		var0_9:AddPreloadCV(iter23_9)
	end

	if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
		local var16_9 = {}
		local var17_9 = getProxy(FleetProxy):getFleetById(11)
		local var18_9 = var17_9:getTeamByName(TeamType.Submarine)

		for iter24_9, iter25_9 in ipairs(var18_9) do
			table.insert(var16_9, var1_9:getShipById(iter25_9))
		end

		local var19_9, var20_9 = var0_9.GetPlayerShipResource(var16_9, arg0_9.contextData.system)

		for iter26_9, iter27_9 in ipairs(var19_9) do
			var0_9:AddPreloadResource(iter27_9)
		end

		for iter28_9, iter29_9 in ipairs(var20_9) do
			var0_9:AddPreloadCV(iter29_9)
		end

		var0_0.addCommanderBuffRes(var17_9:buildBattleBuffList())
	end

	local function var21_9()
		SetActive(arg0_9._loadingAnima, false)
		SetActive(arg0_9._finishAnima, true)

		arg0_9._finishAnima:GetComponent("Animator").enabled = true
	end

	local var22_9 = 0

	local function var23_9(arg0_11)
		local var0_11
		local var1_11 = var22_9 == 0 and 0 or arg0_11 / var22_9

		arg0_9._loadingProgress.value = var1_11
		arg0_9._loadingText.text = string.format("%.2f", var1_11 * 100) .. "%"
		arg0_9._loadingAnima.anchoredPosition = Vector2(var1_11 * var0_0.LOADING_ANIMA_DISTANCE, arg0_9._loadingAnimaPosY)
	end

	local var24_9 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var24_9, true)

	var22_9 = var0_9:StartPreload(var21_9, var23_9)
	arg0_9._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

function var0_0.GetTotalResourceList(arg0_12)
	local var0_12 = {}
	local var1_12 = {}
	local var2_12 = {}
	local var3_12 = ys.Battle.BattleGate.Gates[arg0_12.system]

	if var3_12.GetPreloadList then
		local var4_12, var5_12 = var3_12.GetPreloadList(arg0_12)

		for iter0_12, iter1_12 in ipairs(var4_12) do
			table.insert(var0_12, iter1_12)
		end

		for iter2_12, iter3_12 in ipairs(var5_12) do
			table.insert(var1_12, iter3_12)
		end
	elseif arg0_12.mainFleetId then
		local var6_12 = getProxy(FleetProxy):getFleetById(arg0_12.mainFleetId)
		local var7_12 = getProxy(BayProxy):getShipsByFleet(var6_12)

		for iter4_12, iter5_12 in ipairs(var7_12) do
			table.insert(var2_12, iter5_12)
		end
	end

	if arg0_12.prefabFleet then
		local var8_12 = arg0_12.prefabFleet.main_unitList or {}
		local var9_12 = arg0_12.prefabFleet.vanguard_unitList or {}
		local var10_12 = arg0_12.prefabFleet.submarine_unitList or {}

		for iter6_12, iter7_12 in ipairs(var8_12) do
			table.insert(var2_12, var0_0.generatePrefabShipData(iter7_12))
		end

		for iter8_12, iter9_12 in ipairs(var9_12) do
			table.insert(var2_12, var0_0.generatePrefabShipData(iter9_12))
		end

		for iter10_12, iter11_12 in ipairs(var10_12) do
			table.insert(var2_12, var0_0.generatePrefabShipData(iter11_12))
		end
	end

	local var11_12 = ys.Battle.BattleResourceManager.GetInstance()
	local var12_12, var13_12 = var11_12.GetPlayerShipResource(var2_12, arg0_12.system)

	for iter12_12, iter13_12 in ipairs(var12_12) do
		table.insert(var0_12, iter13_12)
	end

	for iter14_12, iter15_12 in ipairs(var13_12) do
		table.insert(var1_12, iter15_12)
	end

	local var14_12 = pg.expedition_data_template[arg0_12.stageId].dungeon_id
	local var15_12, var16_12 = var11_12.GetStageResource(var14_12)

	for iter16_12, iter17_12 in ipairs(var15_12) do
		table.insert(var0_12, iter17_12)
	end

	for iter18_12, iter19_12 in ipairs(var11_12.GetCommonResource()) do
		table.insert(var0_12, iter19_12)
	end

	for iter20_12, iter21_12 in ipairs(var11_12.GetBuffResource()) do
		table.insert(var0_12, iter21_12)
	end

	for iter22_12, iter23_12 in ipairs(var16_12) do
		table.insert(var1_12, iter23_12)
	end

	local var17_12 = pg.expedition_data_template[arg0_12.stageId]

	if arg0_12.system == SYSTEM_WORLD and var17_12.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var18_12 = nowWorld():GetActiveMap()

		for iter24_12, iter25_12 in ipairs(var11_12.GetMapResource(var18_12.config.expedition_map_id)) do
			table.insert(var0_12, iter25_12)
		end
	else
		for iter26_12, iter27_12 in ipairs(var17_12.map_id) do
			for iter28_12, iter29_12 in ipairs(var11_12.GetMapResource(iter27_12[1])) do
				table.insert(var0_12, iter29_12)
			end
		end
	end

	if pg.battle_cost_template[arg0_12.system].global_buff_effected > 0 then
		local var19_12 = BuffHelper.GetBattleBuffs()
		local var20_12 = _.map(var19_12, function(arg0_13)
			return arg0_13:getConfig("benefit_effect")
		end)

		for iter30_12, iter31_12 in ipairs(var20_12) do
			iter31_12 = tonumber(iter31_12)

			local var21_12 = ys.Battle.BattleDataFunction.GetResFromBuff(iter31_12, 1, {})

			for iter32_12, iter33_12 in ipairs(var21_12) do
				table.insert(var0_12, iter33_12)
			end
		end
	end

	local var22_12 = var11_12.GetStageBGM(var14_12)

	return var0_12, var1_12, var22_12
end

function var0_0.generatePrefabShipData(arg0_14)
	local var0_14 = {
		configId = arg0_14.configId,
		equipments = {},
		skinId = arg0_14.skinId,
		buffs = arg0_14.skills
	}
	local var1_14 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(arg0_14.configId)
	local var2_14 = math.max(#arg0_14.equipment, #var1_14.default_equip_list)

	for iter0_14 = 1, var2_14 do
		var0_14.equipments[iter0_14] = arg0_14.equipment[iter0_14] and {
			configId = arg0_14.equipment[iter0_14]
		} or false
	end

	function var0_14.getActiveEquipments(arg0_15)
		return arg0_15.equipments
	end

	return var0_14
end

function var0_0.addCommanderBuffRes(arg0_16)
	local var0_16 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		local var1_16 = var0_16.GetCommanderResource(iter1_16)

		for iter2_16, iter3_16 in ipairs(var1_16) do
			var0_16:AddPreloadResource(iter3_16)
		end
	end
end

function var0_0.GetExistBGList()
	local var0_17 = LOADING_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOADING_HX_LV.key_value and "loadingbg_hx/bg_" or "loadingbg/bg_"
	local var1_17 = {}

	for iter0_17 = 1, BG_RANDOM_RANGE do
		local var2_17 = var0_17 .. iter0_17

		if checkABExist(var2_17) then
			table.insert(var1_17, var2_17)
		end
	end

	return var1_17
end

function var0_0.GetRandomBGPath()
	local var0_18 = var0_0.GetExistBGList()

	return var0_18[math.random(1, #var0_18)]
end

function var0_0.EnsureBaseBGList()
	local var0_19 = {}

	if #var0_0.GetExistBGList() <= 0 then
		table.insert(var0_19, "loadingbg_hx/bg_1")
		table.insert(var0_19, "loadingbg/bg_1")
	end

	return var0_19
end

return var0_0
