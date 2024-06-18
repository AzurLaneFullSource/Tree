local var0_0 = class("CommanderFormationOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().data
	local var1_1 = var0_1.FleetType
	local var2_1 = getProxy(CommanderProxy)
	local var3_1 = getProxy(ChapterProxy)
	local var4_1 = getProxy(FleetProxy)
	local var5_1 = var0_1.data

	if var5_1.type == LevelUIConst.COMMANDER_OP_RENAME then
		local var6_1 = var5_1.id
		local var7_1 = var5_1.str
		local var8_1 = var5_1.onFailed

		arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME, {
			id = var6_1,
			name = var7_1,
			onFailed = var8_1
		})

		return
	end

	if var1_1 == LevelUIConst.FLEET_TYPE_SELECT then
		local var9_1 = var5_1.id
		local var10_1 = var0_1.fleetId
		local var11_1 = var0_1.chapterId

		if var5_1.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var12_1 = var4_1:getFleetById(var10_1):getCommanders()

			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var9_1,
				commanders = var12_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			arg0_1:sendNotification(GAME.USE_COMMANDER_PREFBA, {
				pid = var9_1,
				fleetId = var10_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var13_1 = {
				function(arg0_2)
					arg0_1:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 1,
						fleetId = var10_1,
						callback = arg0_2
					})
				end,
				function(arg0_3)
					arg0_1:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 2,
						fleetId = var10_1,
						callback = arg0_3
					})
				end
			}

			seriesAsync(var13_1)
		end
	elseif var1_1 == LevelUIConst.FLEET_TYPE_EDIT then
		local var14_1 = var5_1.id
		local var15_1 = var2_1:getPrefabFleetById(var14_1)
		local var16_1 = var0_1.index
		local var17_1 = var0_1.chapterId

		if var5_1.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var18_1 = var3_1:getChapterById(var17_1)
			local var19_1 = var18_1:getEliteFleetCommanders()[var16_1]

			if table.getCount(var19_1) == 0 then
				return
			end

			local var20_1 = {}

			for iter0_1 = 1, 2 do
				local var21_1 = var19_1[iter0_1]
				local var22_1 = var2_1:getCommanderById(var21_1)

				if var22_1 then
					var20_1[iter0_1] = var22_1
				end
			end

			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var14_1,
				commanders = var20_1
			})
			var3_1:updateChapter(var18_1)
			arg0_1:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var18_1.id,
				index = var16_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var23_1 = {}

			for iter1_1 = 1, 2 do
				local var24_1 = var15_1:getCommanderByPos(iter1_1)

				if var24_1 then
					local var25_1, var26_1 = Commander.canEquipToEliteChapter(var17_1, var16_1, iter1_1, var24_1.id)

					if not var25_1 then
						pg.TipsMgr.GetInstance():ShowTips(var26_1)

						return
					end
				end
			end

			local var27_1 = var3_1:getChapterById(var17_1)
			local var28_1 = var27_1:getEliteFleetCommanders()[var16_1]

			if var15_1:isSameId(var28_1) then
				return
			end

			for iter2_1 = 1, 2 do
				local var29_1 = var15_1:getCommanderByPos(iter2_1)

				if var29_1 then
					arg0_1:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = var17_1,
						index = var16_1,
						pos = iter2_1,
						commanderId = var29_1.id
					})
				else
					arg0_1:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = var17_1,
						index = var16_1,
						pos = iter2_1
					})
				end
			end

			arg0_1:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var27_1.id,
				index = var16_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var30_1 = var3_1:getChapterById(var17_1)

			for iter3_1 = 1, 2 do
				arg0_1:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = var17_1,
					index = var16_1,
					pos = iter3_1
				})
			end

			arg0_1:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var30_1.id,
				index = var16_1
			})
		end
	elseif var1_1 == LevelUIConst.FLEET_TYPE_ACTIVITY then
		local var31_1 = var5_1.id
		local var32_1 = var2_1:getPrefabFleetById(var31_1)
		local var33_1 = var0_1.fleetId
		local var34_1 = var0_1.actId

		if var5_1.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var35_1 = var4_1:getActivityFleets()[var34_1][var33_1]:getCommanders()

			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var31_1,
				commanders = var35_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var36_1 = {}
			local var37_1 = var4_1:getActivityFleets()[var34_1]
			local var38_1 = pg.activity_template[var34_1]
			local var39_1 = var38_1 and var38_1.type or 0

			local function var40_1(arg0_4)
				for iter0_4, iter1_4 in pairs(var37_1) do
					local var0_4 = var33_1 ~= iter0_4

					if var39_1 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 or var39_1 == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
						var0_4 = iter0_4 == ActivityBossMediatorTemplate.GetPairedFleetIndex(var33_1)
					end

					if var0_4 then
						local var1_4 = iter1_4:getCommanders()

						for iter2_4, iter3_4 in pairs(var1_4) do
							if arg0_4 == iter3_4.id then
								return iter0_4, iter2_4
							end
						end
					end
				end

				return nil
			end

			for iter4_1 = 1, 2 do
				local var41_1 = var32_1:getCommanderByPos(iter4_1)

				if var41_1 then
					local var42_1, var43_1 = var40_1(var41_1.id)

					if var42_1 and var43_1 then
						table.insert(var36_1, function(arg0_5)
							local var0_5 = var43_1 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1_5 = Fleet.DEFAULT_NAME[var42_1]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var1_5, var0_5),
								onYes = function()
									local var0_6 = var37_1[var42_1]

									var0_6:updateCommanderByPos(var43_1, nil)
									var4_1:updateActivityFleet(var34_1, var42_1, var0_6)

									local var1_6 = var37_1[var33_1]

									var1_6:updateCommanderByPos(iter4_1, var41_1)
									var4_1:updateActivityFleet(var34_1, var33_1, var1_6)
									arg0_5()
								end,
								onNo = arg0_5
							})
						end)
					else
						table.insert(var36_1, function(arg0_7)
							local var0_7 = var37_1[var33_1]

							var0_7:updateCommanderByPos(iter4_1, var41_1)
							var4_1:updateActivityFleet(var34_1, var33_1, var0_7)
							arg0_7()
						end)
					end
				else
					table.insert(var36_1, function(arg0_8)
						local var0_8 = var37_1[var33_1]

						var0_8:updateCommanderByPos(iter4_1, nil)
						var4_1:updateActivityFleet(var34_1, var33_1, var0_8)
						arg0_8()
					end)
				end
			end

			seriesAsync(var36_1, function()
				arg0_1:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
					actId = var34_1,
					fleetId = var33_1
				})
			end)
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var44_1 = var4_1:getActivityFleets()[var34_1][var33_1]

			for iter5_1 = 1, 2 do
				var44_1:updateCommanderByPos(iter5_1, nil)
			end

			var4_1:updateActivityFleet(var34_1, var33_1, var44_1)
			arg0_1:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
				actId = var34_1,
				fleetId = var33_1
			})
		end
	elseif var1_1 == LevelUIConst.FLEET_TYPE_WORLD then
		local var45_1 = var5_1.id
		local var46_1 = var2_1:getPrefabFleetById(var45_1)
		local var47_1 = var0_1.fleets
		local var48_1 = var0_1.fleetType
		local var49_1 = var0_1.fleetIndex
		local var50_1 = var47_1[var48_1][var49_1]
		local var51_1 = Fleet.New({
			ship_list = {},
			commanders = var50_1.commanders
		})

		if var5_1.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var52_1 = var51_1:getCommanders()

			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var45_1,
				commanders = var52_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var53_1 = {}

			local function var54_1(arg0_10)
				for iter0_10, iter1_10 in pairs(var47_1) do
					for iter2_10, iter3_10 in pairs(iter1_10) do
						if var50_1 ~= iter3_10 then
							for iter4_10, iter5_10 in ipairs(iter3_10.commanders) do
								if iter5_10.id == arg0_10 then
									return iter0_10, iter2_10, iter5_10.pos
								end
							end
						end
					end
				end

				return nil
			end

			for iter6_1 = 1, 2 do
				local var55_1 = var46_1:getCommanderByPos(iter6_1)

				if var55_1 then
					local var56_1, var57_1, var58_1 = var54_1(var55_1.id)

					if var56_1 and var57_1 and var58_1 then
						table.insert(var53_1, function(arg0_11)
							local var0_11 = var58_1 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1_11 = Fleet.DEFAULT_NAME[var57_1 + (var56_1 == FleetType.Submarine and 10 or 0)]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var1_11, var0_11),
								onYes = function()
									local var0_12 = var47_1[var56_1][var57_1]
									local var1_12 = Fleet.New({
										ship_list = {},
										commanders = var0_12.commanders
									})

									var1_12:updateCommanderByPos(iter6_1, nil)

									var0_12.commanders = var1_12:outputCommanders()

									var51_1:updateCommanderByPos(iter6_1, var55_1)

									var50_1.commanders = var51_1:outputCommanders()

									arg0_11()
								end,
								onNo = arg0_11
							})
						end)
					else
						table.insert(var53_1, function(arg0_13)
							var51_1:updateCommanderByPos(iter6_1, var55_1)

							var50_1.commanders = var51_1:outputCommanders()

							arg0_13()
						end)
					end
				else
					table.insert(var53_1, function(arg0_14)
						var51_1:updateCommanderByPos(iter6_1, nil)

						var50_1.commanders = var51_1:outputCommanders()

						arg0_14()
					end)
				end
			end

			seriesAsync(var53_1, function()
				arg0_1:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
					fleet = var51_1
				})
			end)
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			for iter7_1 = 1, 2 do
				var51_1:updateCommanderByPos(iter7_1, nil)
			end

			var50_1.commanders = var51_1:outputCommanders()

			arg0_1:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
				fleet = var51_1
			})
		end
	elseif var1_1 == LevelUIConst.FLEET_TYPE_BOSSRUSH then
		local var59_1 = var5_1.id
		local var60_1 = var2_1:getPrefabFleetById(var59_1)
		local var61_1 = var0_1.fleetId
		local var62_1 = var0_1.actId

		if var5_1.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var63_1 = var4_1:getActivityFleets()[var62_1][var61_1]:getCommanders()

			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var59_1,
				commanders = var63_1
			})
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var64_1 = {}
			local var65_1 = {}

			_.each(var0_1.fleets, function(arg0_16)
				var65_1[arg0_16.id] = arg0_16
			end)

			local function var66_1(arg0_17)
				for iter0_17, iter1_17 in pairs(var65_1) do
					if var61_1 ~= iter0_17 then
						local var0_17 = iter1_17:getCommanders()

						for iter2_17, iter3_17 in pairs(var0_17) do
							if arg0_17 == iter3_17.id then
								return iter0_17, iter2_17
							end
						end
					end
				end

				return nil
			end

			for iter8_1 = 1, 2 do
				local var67_1 = var60_1:getCommanderByPos(iter8_1)

				if var67_1 then
					local var68_1, var69_1 = var66_1(var67_1.id)

					if var68_1 and var69_1 then
						table.insert(var64_1, function(arg0_18)
							local var0_18 = var69_1 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1_18 = table.indexof(var0_1.fleets, var65_1[var68_1])
							local var2_18 = Fleet.DEFAULT_NAME[var1_18]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var2_18, var0_18),
								onYes = function()
									local var0_19 = var65_1[var68_1]

									var0_19:updateCommanderByPos(var69_1, nil)
									var4_1:updateActivityFleet(var62_1, var68_1, var0_19)

									local var1_19 = var65_1[var61_1]

									var1_19:updateCommanderByPos(iter8_1, var67_1)
									var4_1:updateActivityFleet(var62_1, var61_1, var1_19)
									arg0_18()
								end,
								onNo = arg0_18
							})
						end)
					else
						table.insert(var64_1, function(arg0_20)
							local var0_20 = var65_1[var61_1]

							var0_20:updateCommanderByPos(iter8_1, var67_1)
							var4_1:updateActivityFleet(var62_1, var61_1, var0_20)
							arg0_20()
						end)
					end
				else
					table.insert(var64_1, function(arg0_21)
						local var0_21 = var65_1[var61_1]

						var0_21:updateCommanderByPos(iter8_1, nil)
						var4_1:updateActivityFleet(var62_1, var61_1, var0_21)
						arg0_21()
					end)
				end
			end

			seriesAsync(var64_1, function()
				arg0_1:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
					actId = var62_1,
					fleetId = var61_1
				})
			end)
		elseif var5_1.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var70_1 = var4_1:getActivityFleets()[var62_1][var61_1]

			for iter9_1 = 1, 2 do
				var70_1:updateCommanderByPos(iter9_1, nil)
			end

			var4_1:updateActivityFleet(var62_1, var61_1, var70_1)
			arg0_1:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
				actId = var62_1,
				fleetId = var61_1
			})
		end
	end
end

return var0_0
