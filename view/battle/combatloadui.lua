local var0 = class("CombatLoadUI", import("..base.BaseUI"))

var0._loadObs = nil
var0.LOADING_ANIMA_DISTANCE = 1820

function var0.getUIName(arg0)
	return "CombatLoadUI"
end

function var0.init(arg0)
	local var0 = arg0:findTF("loading")

	arg0._loadingProgress = var0:Find("loading_bar"):GetComponent(typeof(Slider))
	arg0._loadingProgress.value = 0
	arg0._loadingText = var0:Find("loading_label/percent"):GetComponent(typeof(Text))
	arg0._loadingAnima = var0:Find("loading_anima")
	arg0._loadingAnimaPosY = arg0._loadingAnima.anchoredPosition.y
	arg0._finishAnima = var0:Find("done_anima")

	SetActive(arg0._loadingAnima, true)
	SetActive(arg0._finishAnima, false)
	arg0._finishAnima:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		arg0:emit(CombatLoadMediator.FINISH, arg0._loadObs)
	end)

	local var1 = arg0._tf:Find("bg")
	local var2 = arg0._tf:Find("bg2")
	local var3 = PlayerPrefs.GetInt("bgFitMode", 0)
	local var4 = var3 == 1 and var2 or var1

	SetActive(var1, var3 ~= 1)
	SetActive(var2, var3 == 1)

	local var5 = "loadingbg/bg_" .. math.random(1, BG_RANDOM_RANGE)

	setImageSprite(var4, LoadSprite(var5))

	arg0._tipsText = var0:Find("tipsText"):GetComponent(typeof(Text))
end

function var0.didEnter(arg0)
	arg0:Preload()
end

function var0.onBackPressed(arg0)
	return
end

function var0.Preload(arg0)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0._loadObs = {}
	arg0._toLoad = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	var0:Init()

	local var1 = getProxy(BayProxy)

	if arg0.contextData.system == SYSTEM_DEBUG then
		local var2 = {}
		local var3 = getProxy(FleetProxy)
		local var4 = var3:getFleetById(arg0.contextData.mainFleetId)

		assert(var4)

		local var5 = var1:getShipsByFleet(var4)

		for iter0, iter1 in ipairs(var5) do
			var2[iter1.configId] = iter1
		end

		local var6 = var3:getFleetById(11)

		assert(var6)

		local var7 = var6:getTeamByName(TeamType.Submarine)

		for iter2, iter3 in ipairs(var7) do
			local var8 = var1:getShipById(iter3)

			var2[var8.configId] = var8
		end

		var0.addCommanderBuffRes(var6:buildBattleBuffList())

		for iter4, iter5 in pairs(var2) do
			if type(iter4) == "number" then
				var0:AddPreloadCV(iter5.skinId)
				var0:AddPreloadResource(var0.GetShipResource(iter4, iter5.skinId, true))

				local var9 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter4)

				for iter6, iter7 in ipairs(iter5:getActiveEquipments()) do
					local var10
					local var11
					local var12 = 0

					if not iter7 then
						var10 = var9.default_equip_list[iter6]
					else
						var10 = iter7.configId
						var12 = iter7.skinId
					end

					if var10 then
						local var13 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(var10).weapon_id

						if #var13 > 0 then
							for iter8, iter9 in ipairs(var13) do
								var0:AddPreloadResource(var0.GetWeaponResource(iter9, var12))
							end
						else
							var0:AddPreloadResource(var0.GetEquipResource(var10, var12, arg0.contextData.system))
						end
					end
				end

				for iter10, iter11 in ipairs(var9.depth_charge_list) do
					local var14 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter11).weapon_id

					for iter12, iter13 in ipairs(var14) do
						var0:AddPreloadResource(var0.GetWeaponResource(iter13))
					end
				end

				for iter14, iter15 in ipairs(var9.fix_equip_list) do
					local var15 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter15).weapon_id

					for iter16, iter17 in ipairs(var15) do
						var0:AddPreloadResource(var0.GetWeaponResource(iter17))
					end
				end

				local var16 = iter5.GetSpWeapon and iter5:GetSpWeapon()

				if var16 then
					var0:AddPreloadResource(var0.GetSpWeaponResource(var16:GetConfigID(), arg0.contextData.system))
				end

				local var17 = ys.Battle.BattleDataFunction.GetBuffBulletRes(iter4, iter5.skills, arg0.contextData.system, iter5.skinId)

				for iter18, iter19 in pairs(var17) do
					var0:AddPreloadResource(iter19)
				end
			end
		end

		if BATTLE_DEBUG_CUSTOM_WEAPON then
			for iter20, iter21 in pairs(ys.Battle.BattleUnitDetailView.BulletForger) do
				local var18 = "触发自定义子弹替换>>>" .. iter20 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var18)

				pg.bullet_template[iter20] = iter21
			end

			for iter22, iter23 in pairs(ys.Battle.BattleUnitDetailView.BarrageForger) do
				local var19 = "触发自定义弹幕替换>>>" .. iter22 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var19)

				pg.barrage_template[iter22] = iter23
			end

			for iter24, iter25 in pairs(ys.Battle.BattleUnitDetailView.AircraftForger) do
				local var20 = "触发自定义飞机替换>>>" .. iter24 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var20)

				pg.aircraft_template[iter24] = iter25
			end

			for iter26, iter27 in pairs(ys.Battle.BattleUnitDetailView.WeaponForger) do
				local var21 = "触发自定义武器替换>>>" .. iter26 .. "<<<，检查是否测试需要，否则联系程序"

				pg.TipsMgr.GetInstance():ShowTips(var21)

				pg.weapon_property[iter26] = iter27

				local var22 = var0.GetWeaponResource(iter26)

				for iter28, iter29 in ipairs(var22) do
					var0:AddPreloadResource(iter29)
				end
			end
		end

		var0:AddPreloadResource(var0.GetAircraftResource(30001, {}))
	else
		local var23 = {}
		local var24 = {}

		if arg0.contextData.system == SYSTEM_SCENARIO then
			local var25 = getProxy(ChapterProxy)
			local var26 = var25:getActiveChapter()
			local var27 = var26.fleet
			local var28 = var27:getShips(false)

			for iter30, iter31 in ipairs(var28) do
				table.insert(var23, iter31)
			end

			local var29, var30 = var26:getFleetBattleBuffs(var27)

			var0.addCommanderBuffRes(var30)
			var0.addChapterBuffRes(var29)

			local var31 = var25.GetChapterAuraBuffs(var26)

			var0.addChapterAuraRes(var31)

			local var32 = var25.GetChapterAidBuffs(var26)
			local var33 = {}

			for iter32, iter33 in pairs(var32) do
				for iter34, iter35 in ipairs(iter33) do
					table.insert(var33, iter35)
				end
			end

			var0.addChapterAuraRes(var33)

			local var34, var35 = var25.getSubAidFlag(var26, arg0.contextData.stageId)

			if var34 == true or var34 > 0 then
				local var36 = var35:getShipsByTeam(TeamType.Submarine, false)

				for iter36, iter37 in ipairs(var36) do
					table.insert(var23, iter37)
				end

				local var37, var38 = var26:getFleetBattleBuffs(var35)

				var0.addCommanderBuffRes(var38)
				var0.addChapterBuffRes(var37)
			end
		elseif arg0.contextData.system == SYSTEM_HP_SHARE_ACT_BOSS or arg0.contextData.system == SYSTEM_ACT_BOSS or arg0.contextData.system == SYSTEM_ACT_BOSS_SP or arg0.contextData.system == SYSTEM_BOSS_EXPERIMENT or arg0.contextData.system == SYSTEM_BOSS_SINGLE then
			local var39 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
			local var40 = var39[arg0.contextData.mainFleetId]

			if var40 then
				local var41 = var40.ships

				for iter38, iter39 in ipairs(var41) do
					table.insert(var23, var1:getShipById(iter39))
				end

				var0.addCommanderBuffRes(var40:buildBattleBuffList())
			end

			local var42 = var39[arg0.contextData.mainFleetId + 10]

			if var42 then
				local var43 = var42:getTeamByName(TeamType.Submarine)

				for iter40, iter41 in ipairs(var43) do
					table.insert(var23, var1:getShipById(iter41))
				end

				var0.addCommanderBuffRes(var42:buildBattleBuffList())
			end

			if arg0.contextData.system == SYSTEM_ACT_BOSS_SP then
				local var44 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0.contextData.actId).buffIds
				local var45 = _.map(var44, function(arg0)
					return ActivityBossBuff.New({
						configId = arg0
					}):GetBuffID()
				end)

				var0.addChapterBuffRes(var45)
			end

			if arg0.contextData.system == SYSTEM_BOSS_SINGLE then
				local var46 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)

				var0.addChapterBuffRes(var46:GetBuffIdsByStageId(arg0.contextData.stageId))
			end
		elseif arg0.contextData.system == SYSTEM_BOSS_RUSH or arg0.contextData.system == SYSTEM_BOSS_RUSH_EX then
			local var47 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId):GetSeriesData()

			assert(var47)

			local var48 = var47:GetStaegLevel() + 1
			local var49 = var47:GetFleetIds()
			local var50 = var49[var48]
			local var51 = var49[#var49]

			if var47:GetMode() == BossRushSeriesData.MODE.SINGLE then
				var50 = var49[1]
			end

			local var52 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
			local var53 = var52[var50]
			local var54 = var52[var51]

			if var53 then
				local var55 = var53:GetRawShipIds()

				for iter42, iter43 in ipairs(var55) do
					table.insert(var23, var1:getShipById(iter43))
				end

				var0.addCommanderBuffRes(var53:buildBattleBuffList())
			end

			if var54 then
				local var56 = var54:GetRawShipIds()

				for iter44, iter45 in ipairs(var56) do
					table.insert(var23, var1:getShipById(iter45))
				end

				var0.addCommanderBuffRes(var54:buildBattleBuffList())
			end
		elseif arg0.contextData.system == SYSTEM_LIMIT_CHALLENGE then
			local var57 = FleetProxy.CHALLENGE_FLEET_ID
			local var58 = FleetProxy.CHALLENGE_SUB_FLEET_ID
			local var59 = getProxy(FleetProxy)
			local var60 = var59:getFleetById(var57)
			local var61 = var59:getFleetById(var58)

			if var60 then
				local var62 = var60:GetRawShipIds()

				for iter46, iter47 in ipairs(var62) do
					table.insert(var23, var1:getShipById(iter47))
				end

				var0.addCommanderBuffRes(var60:buildBattleBuffList())
			end

			if var61 then
				local var63 = var61:GetRawShipIds()

				for iter48, iter49 in ipairs(var63) do
					table.insert(var23, var1:getShipById(iter49))
				end

				var0.addCommanderBuffRes(var61:buildBattleBuffList())
			end

			local var64 = LimitChallengeConst.GetChallengeIDByStageID(arg0.contextData.stageId)
			local var65 = AcessWithinNull(pg.expedition_constellation_challenge_template[var64], "buff_id")

			if var65 then
				var0.addEnemyBuffRes(var65)
			end
		elseif arg0.contextData.system == SYSTEM_GUILD then
			local var66 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
			local var67 = var66:GetMainFleet()
			local var68 = var67:GetShips()

			for iter50, iter51 in ipairs(var68) do
				if iter51 and iter51.ship then
					table.insert(var23, iter51.ship)
				end
			end

			var0.addCommanderBuffRes(var67:BuildBattleBuffList())

			local var69 = var66:GetSubFleet()
			local var70 = var69:GetShips()

			for iter52, iter53 in ipairs(var70) do
				if iter53 and iter53.ship then
					table.insert(var23, iter53.ship)
				end
			end

			var0.addCommanderBuffRes(var69:BuildBattleBuffList())
		elseif arg0.contextData.system == SYSTEM_CHALLENGE then
			local var71 = getProxy(ChallengeProxy):getUserChallengeInfo(arg0.contextData.mode)
			local var72 = var71:getRegularFleet()

			ships = var72:getShips(false)

			for iter54, iter55 in ipairs(ships) do
				table.insert(var23, iter55)
			end

			var0.addCommanderBuffRes(var72:buildBattleBuffList())

			local var73 = var71:getSubmarineFleet()

			ships = var73:getShips(false)

			for iter56, iter57 in ipairs(ships) do
				table.insert(var23, iter57)
			end

			var0.addCommanderBuffRes(var73:buildBattleBuffList())
		elseif arg0.contextData.system == SYSTEM_WORLD_BOSS then
			local var74 = nowWorld():GetBossProxy()
			local var75 = var74:GetFleet(arg0.contextData.bossId)
			local var76 = var1:getSortShipsByFleet(var75)

			for iter58, iter59 in ipairs(var76) do
				table.insert(var23, iter59)
			end

			local var77 = var74:GetBossById(arg0.contextData.bossId)

			if var77 and var77:IsSelf() then
				local var78, var79, var80 = var74.GetSupportValue()

				if var78 then
					var0.addChapterAuraRes({
						{
							level = 1,
							id = var80
						}
					})
				end
			end
		elseif arg0.contextData.system == SYSTEM_WORLD then
			local var81 = nowWorld()
			local var82 = var81:GetActiveMap()
			local var83 = var82:GetFleet()

			for iter60, iter61 in ipairs(var83:GetShipVOs(true)) do
				table.insert(var23, iter61)
			end

			local var84, var85 = var82:getFleetBattleBuffs(var83)

			var0.addCommanderBuffRes(var85)
			var0.addChapterBuffRes(var84)

			local var86 = var82:GetChapterAuraBuffs()

			var0.addChapterAuraRes(var86)

			local var87 = var82:GetChapterAidBuffs()
			local var88 = {}

			for iter62, iter63 in pairs(var87) do
				for iter64, iter65 in ipairs(iter63) do
					table.insert(var88, iter65)
				end
			end

			var0.addChapterAuraRes(var88)

			if var81:GetSubAidFlag() == true then
				local var89 = var82:GetSubmarineFleet()
				local var90 = var89:GetTeamShipVOs(TeamType.Submarine, false)

				for iter66, iter67 in ipairs(var90) do
					table.insert(var23, iter67)
				end

				local var91, var92 = var82:getFleetBattleBuffs(var89)

				var0.addCommanderBuffRes(var92)
				var0.addChapterBuffRes(var91)
			end

			local var93 = var82:GetCell(var83.row, var83.column):GetStageEnemy()

			var0.addChapterBuffRes(table.mergeArray(var93:GetBattleLuaBuffs(), var82:GetBattleLuaBuffs(WorldMap.FactionEnemy, var93)))
		elseif arg0.contextData.mainFleetId then
			local var94 = getProxy(FleetProxy):getFleetById(arg0.contextData.mainFleetId)

			assert(var94)

			local var95 = var1:getShipsByFleet(var94)

			for iter68, iter69 in ipairs(var95) do
				table.insert(var23, iter69)
			end
		end

		local var96 = {}

		if arg0.contextData.rivalId then
			local var97 = getProxy(MilitaryExerciseProxy):getRivalById(arg0.contextData.rivalId)

			assert(var97, "rival id >>>> " .. arg0.contextData.rivalId)

			local var98 = var97:getShips()

			for iter70, iter71 in ipairs(var98) do
				table.insert(var23, iter71)

				var96[iter71] = true
			end
		end

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var99 = getProxy(FleetProxy):getFleetById(11)
			local var100 = var99:getTeamByName(TeamType.Submarine)

			for iter72, iter73 in ipairs(var100) do
				table.insert(var23, var1:getShipById(iter73))
			end

			var0.addCommanderBuffRes(var99:buildBattleBuffList())
		end

		if arg0.contextData.system == SYSTEM_CARDPUZZLE then
			local var101 = arg0.contextData.cards

			for iter74, iter75 in ipairs(var101) do
				local var102 = ys.Battle.BattleDataFunction.GetPuzzleCardDataTemplate(iter75).effect[1]
				local var103 = ys.Battle.BattleDataFunction.GetCardRes(var102)

				for iter76, iter77 in ipairs(var103) do
					var0:AddPreloadResource(iter77)
				end
			end

			for iter78, iter79 in ipairs(arg0.contextData.cardPuzzleFleet) do
				local var104 = iter79:getConfig("id")
				local var105 = ys.Battle.BattleDataFunction.GetPuzzleShipDataTemplate(var104)

				var0:AddPreloadCV(var105.skin_id)
				var0:AddPreloadResource(var0.GetShipResource(var105.id, var105.skin_id, true))
			end

			var0:AddPreloadResource(var0.GetUIPath("CardTowerCardCombat"))
			var0:AddPreloadResource(var0.GetFXPath("kapai_weizhi"))
		end

		if arg0.contextData.prefabFleet then
			local var106 = arg0.contextData.prefabFleet.main_unitList
			local var107 = arg0.contextData.prefabFleet.vanguard_unitList
			local var108 = arg0.contextData.prefabFleet.submarine_unitList

			if var106 then
				for iter80, iter81 in ipairs(var106) do
					local var109 = {
						configId = iter81.configId,
						equipments = {},
						skinId = iter81.skinId,
						buffs = iter81.skills
					}
					local var110 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter81.configId)
					local var111 = math.max(#iter81.equipment, #var110.default_equip_list)

					for iter82 = 1, var111 do
						var109.equipments[iter82] = iter81.equipment[iter82] or false
					end

					function var109.getActiveEquipments(arg0)
						return arg0.equipments
					end

					table.insert(var23, var109)
				end
			end

			if var107 then
				for iter83, iter84 in ipairs(var107) do
					local var112 = {
						configId = iter84.configId,
						equipments = {},
						skinId = iter84.skinId,
						buffs = iter84.skills
					}
					local var113 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter84.configId)
					local var114 = math.max(#iter84.equipment, #var113.default_equip_list)

					for iter85 = 1, var114 do
						var112.equipments[iter85] = iter84.equipment[iter85] or false
					end

					function var112.getActiveEquipments(arg0)
						return arg0.equipments
					end

					table.insert(var23, var112)
				end
			end

			if var108 then
				for iter86, iter87 in ipairs(var108) do
					local var115 = {
						configId = iter87.configId,
						equipments = {},
						skinId = iter87.skinId,
						buffs = iter87.skills
					}
					local var116 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter87.configId)
					local var117 = math.max(#iter87.equipment, #var116.default_equip_list)

					for iter88 = 1, var117 do
						var115.equipments[iter88] = iter87.equipment[iter88] or false
					end

					function var115.getActiveEquipments(arg0)
						return arg0.equipments
					end

					table.insert(var23, var115)
				end
			end
		end

		for iter89, iter90 in ipairs(var23) do
			var0:AddPreloadCV(iter90.skinId)

			local var118 = true

			if var96[iter90] == true then
				var118 = false
			end

			var0:AddPreloadResource(var0.GetShipResource(iter90.configId, iter90.skinId, var118))

			local var119 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter90.configId)

			for iter91, iter92 in ipairs(iter90:getActiveEquipments()) do
				local var120
				local var121
				local var122 = 0

				if not iter92 then
					var120 = var119.default_equip_list[iter91]
				else
					var120 = iter92.configId
					var122 = iter92.skinId
				end

				if var120 then
					local var123 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(var120).weapon_id

					if #var123 > 0 then
						for iter93, iter94 in ipairs(var123) do
							var0:AddPreloadResource(var0.GetWeaponResource(iter94, var122))
						end
					else
						var0:AddPreloadResource(var0.GetEquipResource(var120, var122, arg0.contextData.system))
					end
				end
			end

			for iter95, iter96 in ipairs(var119.depth_charge_list) do
				local var124 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter96).weapon_id

				for iter97, iter98 in ipairs(var124) do
					var0:AddPreloadResource(var0.GetWeaponResource(iter98))
				end
			end

			for iter99, iter100 in ipairs(var119.fix_equip_list) do
				local var125 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter100).weapon_id

				for iter101, iter102 in ipairs(var125) do
					var0:AddPreloadResource(var0.GetWeaponResource(iter102))
				end
			end

			local var126 = iter90.GetSpWeapon and iter90:GetSpWeapon()

			if var126 then
				var0:AddPreloadResource(var0.GetSpWeaponResource(var126:GetConfigID(), arg0.contextData.system))
			end

			local var127 = ys.Battle.BattleDataFunction.GetBuffBulletRes(iter90.configId, iter90.skills, arg0.contextData.system, iter90.skinId, var126)

			for iter103, iter104 in pairs(var127) do
				var0:AddPreloadResource(iter104)
			end

			if iter90.buffs then
				var0:AddPreloadResource(ys.Battle.BattleDataFunction.GetBuffListRes(iter90.buffs, arg0.contextData.system, iter90.skinId))
			end
		end
	end

	local var128 = pg.expedition_data_template[arg0.contextData.stageId]
	local var129

	if arg0.contextData.system == SYSTEM_WORLD and var128.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var130 = nowWorld():GetActiveMap().config.expedition_map_id

		var0:AddPreloadResource(var0.GetMapResource(var130))
	else
		for iter105, iter106 in ipairs(var128.map_id) do
			var0:AddPreloadResource(var0.GetMapResource(iter106[1]))
		end
	end

	local var131 = pg.expedition_data_template[arg0.contextData.stageId].dungeon_id
	local var132, var133 = var0.GetStageResource(var131)

	var0:AddPreloadResource(var132)
	var0:AddPreloadResource(var0.GetCommonResource())
	var0:AddPreloadResource(var0.GetBuffResource())

	if pg.battle_cost_template[arg0.contextData.system].global_buff_effected > 0 then
		var0.addGlobalBuffRes()
	end

	for iter107, iter108 in ipairs(var133) do
		var0:AddPreloadCV(iter108)
	end

	local function var134()
		SetActive(arg0._loadingAnima, false)
		SetActive(arg0._finishAnima, true)

		arg0._finishAnima:GetComponent("Animator").enabled = true
	end

	local var135 = 0

	local function var136(arg0)
		local var0
		local var1 = var135 == 0 and 0 or arg0 / var135

		arg0._loadingProgress.value = var1
		arg0._loadingText.text = string.format("%.2f", var1 * 100) .. "%"
		arg0._loadingAnima.anchoredPosition = Vector2(var1 * var0.LOADING_ANIMA_DISTANCE, arg0._loadingAnimaPosY)
	end

	local var137 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var137, true)

	var135 = var0:StartPreload(var134, var136)
	arg0._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

function var0.addCommanderBuffRes(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0, iter1 in ipairs(arg0) do
		local var1 = var0.GetCommanderResource(iter1)

		for iter2, iter3 in ipairs(var1) do
			var0:AddPreloadResource(iter3)
		end
	end
end

function var0.addGlobalBuffRes()
	local var0 = BuffHelper.GetBattleBuffs()
	local var1 = _.map(var0, function(arg0)
		return arg0:getConfig("benefit_effect")
	end)
	local var2 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0, iter1 in ipairs(var1) do
		iter1 = tonumber(iter1)

		local var3 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1, 1, {})

		for iter2, iter3 in ipairs(var3) do
			var2:AddPreloadResource(iter3)
		end
	end
end

function var0.addChapterBuffRes(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0, iter1 in ipairs(arg0) do
		local var1 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1, 1, {})

		for iter2, iter3 in ipairs(var1) do
			var0:AddPreloadResource(iter3)
		end
	end
end

function var0.addChapterAuraRes(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0, iter1 in ipairs(arg0) do
		local var1 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1.id, iter1.level, {})

		for iter2, iter3 in ipairs(var1) do
			var0:AddPreloadResource(iter3)
		end
	end
end

function var0.addEnemyBuffRes(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	for iter0, iter1 in ipairs(arg0) do
		local var1 = ys.Battle.BattleDataFunction.GetResFromBuff(iter1.ID, iter1.LV, {})

		for iter2, iter3 in ipairs(var1) do
			var0:AddPreloadResource(iter3)
		end
	end
end

function var0.StartLoad(arg0, arg1, arg2, arg3)
	arg0._toLoad[arg3] = 1

	LoadAndInstantiateAsync(arg1, arg2, function(arg0)
		arg0:LoadFinish(arg0, arg3)
	end)
end

function var0.LoadFinish(arg0, arg1, arg2)
	arg0._loadObs.map = arg1
	arg0._toLoad.map = nil

	if table.getCount(arg0._toLoad) <= 0 then
		arg0._go:GetComponent("Animator"):Play("start")
	end
end

return var0
