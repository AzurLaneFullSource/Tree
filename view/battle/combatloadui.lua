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
	arg0_6._toLoad = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_6 = ys.Battle.BattleResourceManager.GetInstance()

	var0_6:Init()

	local var1_6 = getProxy(BayProxy)

	if arg0_6.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
		setImageSprite(arg0_6.bg, LoadSprite("bg/star_level_bg_211"))
	end

	if arg0_6.contextData.system == SYSTEM_DEBUG then
		local var2_6 = {}
		local var3_6 = getProxy(FleetProxy)
		local var4_6 = var3_6:getFleetById(arg0_6.contextData.mainFleetId)

		assert(var4_6)

		local var5_6 = var1_6:getShipsByFleet(var4_6)

		for iter0_6, iter1_6 in ipairs(var5_6) do
			var2_6[iter1_6.configId] = iter1_6
		end

		local var6_6 = var3_6:getFleetById(11)

		assert(var6_6)

		local var7_6 = var6_6:getTeamByName(TeamType.Submarine)

		for iter2_6, iter3_6 in ipairs(var7_6) do
			local var8_6 = var1_6:getShipById(iter3_6)

			var2_6[var8_6.configId] = var8_6
		end

		var0_0.addCommanderBuffRes(var6_6:buildBattleBuffList())

		for iter4_6, iter5_6 in pairs(var2_6) do
			if type(iter4_6) == "number" then
				var0_6:AddPreloadCV(iter5_6.skinId)
				var0_6:AddPreloadResource(var0_6.GetShipResource(iter4_6, iter5_6.skinId, true))

				local var9_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter4_6)

				for iter6_6, iter7_6 in ipairs(iter5_6:getActiveEquipments()) do
					local var10_6
					local var11_6
					local var12_6 = 0

					if not iter7_6 then
						var10_6 = var9_6.default_equip_list[iter6_6]
					else
						var10_6 = iter7_6.configId
						var12_6 = iter7_6.skinId
					end

					if var10_6 then
						local var13_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(var10_6).weapon_id

						if #var13_6 > 0 then
							for iter8_6, iter9_6 in ipairs(var13_6) do
								var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter9_6, var12_6))
							end
						else
							var0_6:AddPreloadResource(var0_6.GetEquipResource(var10_6, var12_6, arg0_6.contextData.system))
						end
					end
				end

				for iter10_6, iter11_6 in ipairs(var9_6.depth_charge_list) do
					local var14_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter11_6).weapon_id

					for iter12_6, iter13_6 in ipairs(var14_6) do
						var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter13_6))
					end
				end

				for iter14_6, iter15_6 in ipairs(var9_6.fix_equip_list) do
					local var15_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter15_6).weapon_id

					for iter16_6, iter17_6 in ipairs(var15_6) do
						var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter17_6))
					end
				end

				local var16_6 = iter5_6.GetSpWeapon and iter5_6:GetSpWeapon()

				if var16_6 then
					var0_6:AddPreloadResource(var0_6.GetSpWeaponResource(var16_6:GetConfigID(), arg0_6.contextData.system))
				end

				local var17_6 = ys.Battle.BattleDataFunction.GetBuffBulletRes(iter4_6, iter5_6.skills, arg0_6.contextData.system, iter5_6.skinId)

				for iter18_6, iter19_6 in pairs(var17_6) do
					var0_6:AddPreloadResource(iter19_6)
				end
			end
		end

		if BATTLE_DEBUG_CUSTOM_WEAPON then
			for iter20_6, iter21_6 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
				local var18_6 = "触发自定义子弹替换>>>" .. iter20_6 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var18_6)

				pg.bullet_template[iter20_6] = iter21_6
			end

			for iter22_6, iter23_6 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
				local var19_6 = "触发自定义弹幕替换>>>" .. iter22_6 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var19_6)

				pg.barrage_template[iter22_6] = iter23_6
			end

			for iter24_6, iter25_6 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
				local var20_6 = "触发自定义飞机替换>>>" .. iter24_6 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var20_6)

				pg.aircraft_template[iter24_6] = iter25_6
			end

			for iter26_6, iter27_6 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
				local var21_6 = "触发自定义武器替换>>>" .. iter26_6 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var21_6)

				pg.weapon_property[iter26_6] = iter27_6

				local var22_6 = var0_6.GetWeaponResource(iter26_6)

				for iter28_6, iter29_6 in ipairs(var22_6) do
					var0_6:AddPreloadResource(iter29_6)
				end
			end
		end

		var0_6:AddPreloadResource(var0_6.GetAircraftResource(30001, {}))
	else
		local var23_6 = {}
		local var24_6 = {}

		if arg0_6.contextData.system == SYSTEM_SCENARIO then
			local var25_6 = getProxy(ChapterProxy)
			local var26_6 = var25_6:getActiveChapter()
			local var27_6 = var26_6.fleet
			local var28_6 = var27_6:getShips(false)

			for iter30_6, iter31_6 in ipairs(var28_6) do
				table.insert(var23_6, iter31_6)
			end

			local var29_6 = var26_6:getChapterSupportFleet()

			if var29_6 then
				local var30_6 = var29_6:getTeamByName(TeamType.Submarine)

				for iter32_6, iter33_6 in ipairs(var30_6) do
					local var31_6 = var1_6:getShipById(iter33_6)

					table.insert(var23_6, var31_6)
				end
			end

			local var32_6, var33_6 = var26_6:getFleetBattleBuffs(var27_6)

			var0_0.addCommanderBuffRes(var33_6)
			var0_0.addChapterBuffRes(var32_6)

			local var34_6 = var25_6.GetChapterAuraBuffs(var26_6)

			var0_0.addChapterAuraRes(var34_6)

			local var35_6 = var25_6.GetChapterAidBuffs(var26_6)
			local var36_6 = {}

			for iter34_6, iter35_6 in pairs(var35_6) do
				for iter36_6, iter37_6 in ipairs(iter35_6) do
					table.insert(var36_6, iter37_6)
				end
			end

			var0_0.addChapterAuraRes(var36_6)

			local var37_6, var38_6 = var25_6.getSubAidFlag(var26_6, arg0_6.contextData.stageId)

			if var37_6 == true or var37_6 > 0 then
				local var39_6 = var38_6:getShipsByTeam(TeamType.Submarine, false)

				for iter38_6, iter39_6 in ipairs(var39_6) do
					table.insert(var23_6, iter39_6)
				end

				local var40_6, var41_6 = var26_6:getFleetBattleBuffs(var38_6)

				var0_0.addCommanderBuffRes(var41_6)
				var0_0.addChapterBuffRes(var40_6)
			end
		elseif arg0_6.contextData.system == SYSTEM_HP_SHARE_ACT_BOSS or arg0_6.contextData.system == SYSTEM_ACT_BOSS or arg0_6.contextData.system == SYSTEM_ACT_BOSS_SP or arg0_6.contextData.system == SYSTEM_BOSS_EXPERIMENT or arg0_6.contextData.system == SYSTEM_BOSS_SINGLE or arg0_6.contextData.system == SYSTEM_BOSS_SINGLE_VARIABLE then
			local var42_6 = getProxy(FleetProxy):getActivityFleets()[arg0_6.contextData.actId]
			local var43_6 = var42_6[arg0_6.contextData.mainFleetId]

			if var43_6 then
				local var44_6 = var43_6.ships

				for iter40_6, iter41_6 in ipairs(var44_6) do
					table.insert(var23_6, var1_6:getShipById(iter41_6))
				end

				var0_0.addCommanderBuffRes(var43_6:buildBattleBuffList())
			end

			local var45_6 = arg0_6.contextData.system == SYSTEM_BOSS_SINGLE_VARIABLE and Fleet.MEGA_SUBMARINE_FLEET_OFFSET or 10
			local var46_6 = var42_6[arg0_6.contextData.mainFleetId + var45_6]

			if var46_6 then
				local var47_6 = var46_6:getTeamByName(TeamType.Submarine)

				for iter42_6, iter43_6 in ipairs(var47_6) do
					table.insert(var23_6, var1_6:getShipById(iter43_6))
				end

				var0_0.addCommanderBuffRes(var46_6:buildBattleBuffList())
			end

			if arg0_6.contextData.system == SYSTEM_ACT_BOSS_SP then
				local var48_6 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_6.contextData.actId).buffIds
				local var49_6 = _.map(var48_6, function(arg0_7)
					return ActivityBossBuff.New({
						configId = arg0_7
					}):GetBuffID()
				end)

				var0_0.addChapterBuffRes(var49_6)
			end

			if arg0_6.contextData.system == SYSTEM_BOSS_SINGLE then
				local var50_6 = getProxy(ActivityProxy):getActivityById(arg0_6.contextData.actId)

				var0_0.addChapterBuffRes(var50_6:GetBuffIdsByStageId(arg0_6.contextData.stageId))
			end

			if arg0_6.contextData.system == SYSTEM_BOSS_SINGLE_VARIABLE then
				local var51_6 = getProxy(ActivityProxy):getActivityById(arg0_6.contextData.actId)

				var0_0.addChapterBuffRes(var51_6:GetBuffIdsByStageId(arg0_6.contextData.stageId))

				local var52_6 = pg.strategy_data_template
				local var53_6 = {}

				for iter44_6, iter45_6 in ipairs(arg0_6.contextData.variableBuffList) do
					table.insert(var53_6, var52_6[iter45_6].buff_id)
				end

				var0_0.addChapterBuffRes(var53_6)
			end
		elseif arg0_6.contextData.system == SYSTEM_BOSS_RUSH or arg0_6.contextData.system == SYSTEM_BOSS_RUSH_EX or arg0_6.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
			local var54_6 = getProxy(ActivityProxy):getActivityById(arg0_6.contextData.actId):GetSeriesData()

			assert(var54_6)

			local var55_6 = var54_6:GetStaegLevel() + 1
			local var56_6 = var54_6:GetMode()
			local var57_6, var58_6 = var54_6:GetStageFleets(var56_6, var55_6)
			local var59_6 = getProxy(FleetProxy):getActivityFleets()[arg0_6.contextData.actId]
			local var60_6 = var59_6[var57_6]
			local var61_6 = var59_6[var58_6]

			if var60_6 then
				local var62_6 = var60_6:GetRawShipIds()

				for iter46_6, iter47_6 in ipairs(var62_6) do
					table.insert(var23_6, var1_6:getShipById(iter47_6))
				end

				var0_0.addCommanderBuffRes(var60_6:buildBattleBuffList())
			end

			if var61_6 then
				local var63_6 = var61_6:GetRawShipIds()

				for iter48_6, iter49_6 in ipairs(var63_6) do
					table.insert(var23_6, var1_6:getShipById(iter49_6))
				end

				var0_0.addCommanderBuffRes(var61_6:buildBattleBuffList())
			end

			if arg0_6.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
				local var64_6 = var54_6:getConfig("aid_buff")

				if var54_6:GetBossHpRate() <= var64_6[1] then
					var0_0.addChapterBuffRes({
						var64_6[2]
					})
				end
			end
		elseif arg0_6.contextData.system == SYSTEM_LIMIT_CHALLENGE then
			local var65_6 = FleetProxy.CHALLENGE_FLEET_ID
			local var66_6 = FleetProxy.CHALLENGE_SUB_FLEET_ID
			local var67_6 = getProxy(FleetProxy)
			local var68_6 = var67_6:getFleetById(var65_6)
			local var69_6 = var67_6:getFleetById(var66_6)

			if var68_6 then
				local var70_6 = var68_6:GetRawShipIds()

				for iter50_6, iter51_6 in ipairs(var70_6) do
					table.insert(var23_6, var1_6:getShipById(iter51_6))
				end

				var0_0.addCommanderBuffRes(var68_6:buildBattleBuffList())
			end

			if var69_6 then
				local var71_6 = var69_6:GetRawShipIds()

				for iter52_6, iter53_6 in ipairs(var71_6) do
					table.insert(var23_6, var1_6:getShipById(iter53_6))
				end

				var0_0.addCommanderBuffRes(var69_6:buildBattleBuffList())
			end

			local var72_6 = LimitChallengeConst.GetChallengeIDByStageID(arg0_6.contextData.stageId)
			local var73_6 = AcessWithinNull(pg.expedition_constellation_challenge_template[var72_6], "buff_id")

			if var73_6 then
				var0_0.addEnemyBuffRes(var73_6)
			end
		elseif arg0_6.contextData.system == SYSTEM_GUILD then
			local var74_6 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
			local var75_6 = var74_6:GetMainFleet()
			local var76_6 = var75_6:GetShips()

			for iter54_6, iter55_6 in ipairs(var76_6) do
				if iter55_6 and iter55_6.ship then
					table.insert(var23_6, iter55_6.ship)
				end
			end

			var0_0.addCommanderBuffRes(var75_6:BuildBattleBuffList())

			local var77_6 = var74_6:GetSubFleet()
			local var78_6 = var77_6:GetShips()

			for iter56_6, iter57_6 in ipairs(var78_6) do
				if iter57_6 and iter57_6.ship then
					table.insert(var23_6, iter57_6.ship)
				end
			end

			var0_0.addCommanderBuffRes(var77_6:BuildBattleBuffList())
		elseif arg0_6.contextData.system == SYSTEM_CHALLENGE then
			local var79_6 = getProxy(ChallengeProxy):getUserChallengeInfo(arg0_6.contextData.mode)
			local var80_6 = var79_6:getRegularFleet()

			ships = var80_6:getShips(false)

			for iter58_6, iter59_6 in ipairs(ships) do
				table.insert(var23_6, iter59_6)
			end

			var0_0.addCommanderBuffRes(var80_6:buildBattleBuffList())

			local var81_6 = var79_6:getSubmarineFleet()

			ships = var81_6:getShips(false)

			for iter60_6, iter61_6 in ipairs(ships) do
				table.insert(var23_6, iter61_6)
			end

			var0_0.addCommanderBuffRes(var81_6:buildBattleBuffList())
		elseif arg0_6.contextData.system == SYSTEM_WORLD_BOSS then
			local var82_6 = nowWorld():GetBossProxy()
			local var83_6 = var82_6:GetFleet(arg0_6.contextData.bossId)
			local var84_6 = var1_6:getSortShipsByFleet(var83_6)

			for iter62_6, iter63_6 in ipairs(var84_6) do
				table.insert(var23_6, iter63_6)
			end

			local var85_6 = var82_6:GetBossById(arg0_6.contextData.bossId)

			if var85_6 and var85_6:IsSelf() then
				local var86_6, var87_6, var88_6 = var82_6.GetSupportValue()

				if var86_6 then
					var0_0.addChapterAuraRes({
						{
							level = 1,
							id = var88_6
						}
					})
				end
			end
		elseif arg0_6.contextData.system == SYSTEM_WORLD then
			local var89_6 = nowWorld()
			local var90_6 = var89_6:GetActiveMap()
			local var91_6 = var90_6:GetFleet()

			for iter64_6, iter65_6 in ipairs(var91_6:GetShipVOs(true)) do
				table.insert(var23_6, iter65_6)
			end

			local var92_6, var93_6 = var90_6:getFleetBattleBuffs(var91_6)

			var0_0.addCommanderBuffRes(var93_6)
			var0_0.addChapterBuffRes(var92_6)

			local var94_6 = var90_6:GetChapterAuraBuffs()

			var0_0.addChapterAuraRes(var94_6)

			local var95_6 = var90_6:GetChapterAidBuffs()
			local var96_6 = {}

			for iter66_6, iter67_6 in pairs(var95_6) do
				for iter68_6, iter69_6 in ipairs(iter67_6) do
					table.insert(var96_6, iter69_6)
				end
			end

			var0_0.addChapterAuraRes(var96_6)

			if var89_6:GetSubAidFlag() == true then
				local var97_6 = var90_6:GetSubmarineFleet()
				local var98_6 = var97_6:GetTeamShipVOs(TeamType.Submarine, false)

				for iter70_6, iter71_6 in ipairs(var98_6) do
					table.insert(var23_6, iter71_6)
				end

				local var99_6, var100_6 = var90_6:getFleetBattleBuffs(var97_6)

				var0_0.addCommanderBuffRes(var100_6)
				var0_0.addChapterBuffRes(var99_6)
			end

			local var101_6 = var90_6:GetCell(var91_6.row, var91_6.column):GetStageEnemy()

			var0_0.addChapterBuffRes(table.mergeArray(var101_6:GetBattleLuaBuffs(), var90_6:GetBattleLuaBuffs(WorldMap.FactionEnemy, var101_6)))
		elseif arg0_6.contextData.system == SYSTEM_SCENARIO_SUB_STRIKE then
			local var102_6 = getProxy(ChapterProxy):getActiveChapter():getChapterSupportFleet():getTeamByName(TeamType.Submarine)

			for iter72_6, iter73_6 in ipairs(var102_6) do
				local var103_6 = var1_6:getShipById(iter73_6)

				table.insert(var23_6, var103_6)
			end
		elseif arg0_6.contextData.mainFleetId then
			local var104_6 = getProxy(FleetProxy):getFleetById(arg0_6.contextData.mainFleetId)

			assert(var104_6)

			local var105_6 = var1_6:getShipsByFleet(var104_6)

			for iter74_6, iter75_6 in ipairs(var105_6) do
				table.insert(var23_6, iter75_6)
			end
		end

		local var106_6 = {}

		if arg0_6.contextData.rivalId then
			local var107_6 = getProxy(MilitaryExerciseProxy):getRivalById(arg0_6.contextData.rivalId)

			assert(var107_6, "rival id >>>> " .. arg0_6.contextData.rivalId)

			local var108_6 = var107_6:getShips()

			for iter76_6, iter77_6 in ipairs(var108_6) do
				table.insert(var23_6, iter77_6)

				var106_6[iter77_6] = true
			end
		end

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var109_6 = getProxy(FleetProxy):getFleetById(11)
			local var110_6 = var109_6:getTeamByName(TeamType.Submarine)

			for iter78_6, iter79_6 in ipairs(var110_6) do
				table.insert(var23_6, var1_6:getShipById(iter79_6))
			end

			var0_0.addCommanderBuffRes(var109_6:buildBattleBuffList())
		end

		if arg0_6.contextData.system == SYSTEM_CARDPUZZLE then
			local var111_6 = arg0_6.contextData.cards

			for iter80_6, iter81_6 in ipairs(var111_6) do
				local var112_6 = ys.Battle.BattleDataFunction.GetPuzzleCardDataTemplate(iter81_6).effect[1]
				local var113_6 = ys.Battle.BattleDataFunction.GetCardRes(var112_6)

				for iter82_6, iter83_6 in ipairs(var113_6) do
					var0_6:AddPreloadResource(iter83_6)
				end
			end

			for iter84_6, iter85_6 in ipairs(arg0_6.contextData.cardPuzzleFleet) do
				local var114_6 = iter85_6:getConfig("id")
				local var115_6 = ys.Battle.BattleDataFunction.GetPuzzleShipDataTemplate(var114_6)

				var0_6:AddPreloadCV(var115_6.skin_id)
				var0_6:AddPreloadResource(var0_6.GetShipResource(var115_6.id, var115_6.skin_id, true))
			end

			var0_6:AddPreloadResource(var0_6.GetUIPath("CardTowerCardCombat"))
			var0_6:AddPreloadResource(var0_6.GetFXPath("kapai_weizhi"))
		end

		if arg0_6.contextData.prefabFleet then
			local var116_6 = arg0_6.contextData.prefabFleet.main_unitList
			local var117_6 = arg0_6.contextData.prefabFleet.vanguard_unitList
			local var118_6 = arg0_6.contextData.prefabFleet.submarine_unitList

			if var116_6 then
				for iter86_6, iter87_6 in ipairs(var116_6) do
					local var119_6 = {
						configId = iter87_6.configId,
						equipments = {},
						skinId = iter87_6.skinId,
						buffs = iter87_6.skills
					}
					local var120_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter87_6.configId)
					local var121_6 = math.max(#iter87_6.equipment, #var120_6.default_equip_list)

					for iter88_6 = 1, var121_6 do
						var119_6.equipments[iter88_6] = iter87_6.equipment[iter88_6] and {
							configId = iter87_6.equipment[iter88_6]
						} or false
					end

					function var119_6.getActiveEquipments(arg0_8)
						return arg0_8.equipments
					end

					table.insert(var23_6, var119_6)
				end
			end

			if var117_6 then
				for iter89_6, iter90_6 in ipairs(var117_6) do
					local var122_6 = {
						configId = iter90_6.configId,
						equipments = {},
						skinId = iter90_6.skinId,
						buffs = iter90_6.skills
					}
					local var123_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter90_6.configId)
					local var124_6 = math.max(#iter90_6.equipment, #var123_6.default_equip_list)

					for iter91_6 = 1, var124_6 do
						var122_6.equipments[iter91_6] = iter90_6.equipment[iter91_6] and {
							configId = iter90_6.equipment[iter91_6]
						} or false
					end

					function var122_6.getActiveEquipments(arg0_9)
						return arg0_9.equipments
					end

					table.insert(var23_6, var122_6)
				end
			end

			if var118_6 then
				for iter92_6, iter93_6 in ipairs(var118_6) do
					local var125_6 = {
						configId = iter93_6.configId,
						equipments = {},
						skinId = iter93_6.skinId,
						buffs = iter93_6.skills
					}
					local var126_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter93_6.configId)
					local var127_6 = math.max(#iter93_6.equipment, #var126_6.default_equip_list)

					for iter94_6 = 1, var127_6 do
						var125_6.equipments[iter94_6] = iter93_6.equipment[iter94_6] and {
							configId = iter93_6.equipment[iter94_6]
						} or false
					end

					function var125_6.getActiveEquipments(arg0_10)
						return arg0_10.equipments
					end

					table.insert(var23_6, var125_6)
				end
			end
		end

		for iter95_6, iter96_6 in ipairs(var23_6) do
			var0_6:AddPreloadCV(iter96_6.skinId)

			local var128_6 = true

			if var106_6[iter96_6] == true then
				var128_6 = false
			end

			var0_6:AddPreloadResource(var0_6.GetShipResource(iter96_6.configId, iter96_6.skinId, var128_6))

			local var129_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter96_6.configId)

			for iter97_6, iter98_6 in ipairs(iter96_6:getActiveEquipments()) do
				local var130_6
				local var131_6
				local var132_6 = 0

				if not iter98_6 then
					var130_6 = var129_6.default_equip_list[iter97_6]
				else
					var130_6 = iter98_6.configId
					var132_6 = iter98_6.skinId
				end

				if var130_6 then
					local var133_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(var130_6).weapon_id

					if #var133_6 > 0 then
						for iter99_6, iter100_6 in ipairs(var133_6) do
							var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter100_6, var132_6))
						end
					else
						var0_6:AddPreloadResource(var0_6.GetEquipResource(var130_6, var132_6, arg0_6.contextData.system))
					end
				end
			end

			for iter101_6, iter102_6 in ipairs(var129_6.depth_charge_list) do
				local var134_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter102_6).weapon_id

				for iter103_6, iter104_6 in ipairs(var134_6) do
					var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter104_6))
				end
			end

			for iter105_6, iter106_6 in ipairs(var129_6.fix_equip_list) do
				local var135_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter106_6).weapon_id

				for iter107_6, iter108_6 in ipairs(var135_6) do
					var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter108_6))
				end
			end

			local var136_6 = iter96_6.GetSpWeapon and iter96_6:GetSpWeapon()

			if var136_6 then
				var0_6:AddPreloadResource(var0_6.GetSpWeaponResource(var136_6:GetConfigID(), arg0_6.contextData.system))
			end

			local var137_6 = ys.Battle.BattleDataFunction.GetBuffBulletRes(iter96_6.configId, iter96_6.skills, arg0_6.contextData.system, iter96_6.skinId, var136_6)

			for iter109_6, iter110_6 in pairs(var137_6) do
				var0_6:AddPreloadResource(iter110_6)
			end

			if iter96_6.buffs then
				var0_6:AddPreloadResource(ys.Battle.BattleDataFunction.GetBuffListRes(iter96_6.buffs, arg0_6.contextData.system, iter96_6.skinId))
			end
		end
	end

	local var138_6 = pg.expedition_data_template[arg0_6.contextData.stageId]
	local var139_6

	if arg0_6.contextData.system == SYSTEM_WORLD and var138_6.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var140_6 = nowWorld():GetActiveMap().config.expedition_map_id

		var0_6:AddPreloadResource(var0_6.GetMapResource(var140_6))
	else
		for iter111_6, iter112_6 in ipairs(var138_6.map_id) do
			var0_6:AddPreloadResource(var0_6.GetMapResource(iter112_6[1]))
		end
	end

	local var141_6 = pg.expedition_data_template[arg0_6.contextData.stageId].dungeon_id
	local var142_6, var143_6 = var0_6.GetStageResource(var141_6)

	var0_6:AddPreloadResource(var142_6)
	var0_6:AddPreloadResource(var0_6.GetCommonResource())
	var0_6:AddPreloadResource(var0_6.GetBuffResource())

	if pg.battle_cost_template[arg0_6.contextData.system].global_buff_effected > 0 then
		var0_0.addGlobalBuffRes()
	end

	for iter113_6, iter114_6 in ipairs(var143_6) do
		var0_6:AddPreloadCV(iter114_6)
	end

	local function var144_6()
		SetActive(arg0_6._loadingAnima, false)
		SetActive(arg0_6._finishAnima, true)

		arg0_6._finishAnima:GetComponent("Animator").enabled = true
	end

	local var145_6 = 0

	local function var146_6(arg0_12)
		local var0_12
		local var1_12 = var145_6 == 0 and 0 or arg0_12 / var145_6

		arg0_6._loadingProgress.value = var1_12
		arg0_6._loadingText.text = string.format("%.2f", var1_12 * 100) .. "%"
		arg0_6._loadingAnima.anchoredPosition = Vector2(var1_12 * var0_0.LOADING_ANIMA_DISTANCE, arg0_6._loadingAnimaPosY)
	end

	local var147_6 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var147_6, true)

	var145_6 = var0_6:StartPreload(var144_6, var146_6)
	arg0_6._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
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

function var0_0.addGlobalBuffRes()
	local var0_14 = BuffHelper.GetBattleBuffs()
	local var1_14 = _.map(var0_14, function(arg0_15)
		return arg0_15:getConfig("benefit_effect")
	end)
	local var2_14 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_14, iter1_14 in ipairs(var1_14) do
		iter1_14 = tonumber(iter1_14)

		local var3_14 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1_14, 1, {})

		for iter2_14, iter3_14 in ipairs(var3_14) do
			var2_14:AddPreloadResource(iter3_14)
		end
	end
end

function var0_0.addChapterBuffRes(arg0_16)
	local var0_16 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		local var1_16 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1_16, 1, {})

		for iter2_16, iter3_16 in ipairs(var1_16) do
			var0_16:AddPreloadResource(iter3_16)
		end
	end
end

function var0_0.addChapterAuraRes(arg0_17)
	local var0_17 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_17, iter1_17 in ipairs(arg0_17) do
		local var1_17 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1_17.id, iter1_17.level, {})

		for iter2_17, iter3_17 in ipairs(var1_17) do
			var0_17:AddPreloadResource(iter3_17)
		end
	end
end

function var0_0.addEnemyBuffRes(arg0_18)
	local var0_18 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0_18, iter1_18 in ipairs(arg0_18) do
		local var1_18 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1_18.ID, iter1_18.LV, {})

		for iter2_18, iter3_18 in ipairs(var1_18) do
			var0_18:AddPreloadResource(iter3_18)
		end
	end
end

function var0_0.StartLoad(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19._toLoad[arg3_19] = 1

	LoadAndInstantiateAsync(arg1_19, arg2_19, function(arg0_20)
		arg0_19:LoadFinish(arg0_20, arg3_19)
	end)
end

function var0_0.LoadFinish(arg0_21, arg1_21, arg2_21)
	arg0_21._loadObs.map = arg1_21
	arg0_21._toLoad.map = nil

	if table.getCount(arg0_21._toLoad) <= 0 then
		arg0_21._go:GetComponent("Animator"):Play("start")
	end
end

return var0_0
