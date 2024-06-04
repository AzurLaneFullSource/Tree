local var0 = class("CommanderFormationOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().data
	local var1 = var0.FleetType
	local var2 = getProxy(CommanderProxy)
	local var3 = getProxy(ChapterProxy)
	local var4 = getProxy(FleetProxy)
	local var5 = var0.data

	if var5.type == LevelUIConst.COMMANDER_OP_RENAME then
		local var6 = var5.id
		local var7 = var5.str
		local var8 = var5.onFailed

		arg0:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME, {
			id = var6,
			name = var7,
			onFailed = var8
		})

		return
	end

	if var1 == LevelUIConst.FLEET_TYPE_SELECT then
		local var9 = var5.id
		local var10 = var0.fleetId
		local var11 = var0.chapterId

		if var5.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var12 = var4:getFleetById(var10):getCommanders()

			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var9,
				commanders = var12
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			arg0:sendNotification(GAME.USE_COMMANDER_PREFBA, {
				pid = var9,
				fleetId = var10
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var13 = {
				function(arg0)
					arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 1,
						fleetId = var10,
						callback = arg0
					})
				end,
				function(arg0)
					arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 2,
						fleetId = var10,
						callback = arg0
					})
				end
			}

			seriesAsync(var13)
		end
	elseif var1 == LevelUIConst.FLEET_TYPE_EDIT then
		local var14 = var5.id
		local var15 = var2:getPrefabFleetById(var14)
		local var16 = var0.index
		local var17 = var0.chapterId

		if var5.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var18 = var3:getChapterById(var17)
			local var19 = var18:getEliteFleetCommanders()[var16]

			if table.getCount(var19) == 0 then
				return
			end

			local var20 = {}

			for iter0 = 1, 2 do
				local var21 = var19[iter0]
				local var22 = var2:getCommanderById(var21)

				if var22 then
					var20[iter0] = var22
				end
			end

			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var14,
				commanders = var20
			})
			var3:updateChapter(var18)
			arg0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var18.id,
				index = var16
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var23 = {}

			for iter1 = 1, 2 do
				local var24 = var15:getCommanderByPos(iter1)

				if var24 then
					local var25, var26 = Commander.canEquipToEliteChapter(var17, var16, iter1, var24.id)

					if not var25 then
						pg.TipsMgr.GetInstance():ShowTips(var26)

						return
					end
				end
			end

			local var27 = var3:getChapterById(var17)
			local var28 = var27:getEliteFleetCommanders()[var16]

			if var15:isSameId(var28) then
				return
			end

			for iter2 = 1, 2 do
				local var29 = var15:getCommanderByPos(iter2)

				if var29 then
					arg0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = var17,
						index = var16,
						pos = iter2,
						commanderId = var29.id
					})
				else
					arg0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = var17,
						index = var16,
						pos = iter2
					})
				end
			end

			arg0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var27.id,
				index = var16
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var30 = var3:getChapterById(var17)

			for iter3 = 1, 2 do
				arg0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = var17,
					index = var16,
					pos = iter3
				})
			end

			arg0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = var30.id,
				index = var16
			})
		end
	elseif var1 == LevelUIConst.FLEET_TYPE_ACTIVITY then
		local var31 = var5.id
		local var32 = var2:getPrefabFleetById(var31)
		local var33 = var0.fleetId
		local var34 = var0.actId

		if var5.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var35 = var4:getActivityFleets()[var34][var33]:getCommanders()

			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var31,
				commanders = var35
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var36 = {}
			local var37 = var4:getActivityFleets()[var34]
			local var38 = pg.activity_template[var34]
			local var39 = var38 and var38.type or 0

			local function var40(arg0)
				for iter0, iter1 in pairs(var37) do
					local var0 = var33 ~= iter0

					if var39 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 or var39 == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
						var0 = iter0 == ActivityBossMediatorTemplate.GetPairedFleetIndex(var33)
					end

					if var0 then
						local var1 = iter1:getCommanders()

						for iter2, iter3 in pairs(var1) do
							if arg0 == iter3.id then
								return iter0, iter2
							end
						end
					end
				end

				return nil
			end

			for iter4 = 1, 2 do
				local var41 = var32:getCommanderByPos(iter4)

				if var41 then
					local var42, var43 = var40(var41.id)

					if var42 and var43 then
						table.insert(var36, function(arg0)
							local var0 = var43 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1 = Fleet.DEFAULT_NAME[var42]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var1, var0),
								onYes = function()
									local var0 = var37[var42]

									var0:updateCommanderByPos(var43, nil)
									var4:updateActivityFleet(var34, var42, var0)

									local var1 = var37[var33]

									var1:updateCommanderByPos(iter4, var41)
									var4:updateActivityFleet(var34, var33, var1)
									arg0()
								end,
								onNo = arg0
							})
						end)
					else
						table.insert(var36, function(arg0)
							local var0 = var37[var33]

							var0:updateCommanderByPos(iter4, var41)
							var4:updateActivityFleet(var34, var33, var0)
							arg0()
						end)
					end
				else
					table.insert(var36, function(arg0)
						local var0 = var37[var33]

						var0:updateCommanderByPos(iter4, nil)
						var4:updateActivityFleet(var34, var33, var0)
						arg0()
					end)
				end
			end

			seriesAsync(var36, function()
				arg0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
					actId = var34,
					fleetId = var33
				})
			end)
		elseif var5.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var44 = var4:getActivityFleets()[var34][var33]

			for iter5 = 1, 2 do
				var44:updateCommanderByPos(iter5, nil)
			end

			var4:updateActivityFleet(var34, var33, var44)
			arg0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
				actId = var34,
				fleetId = var33
			})
		end
	elseif var1 == LevelUIConst.FLEET_TYPE_WORLD then
		local var45 = var5.id
		local var46 = var2:getPrefabFleetById(var45)
		local var47 = var0.fleets
		local var48 = var0.fleetType
		local var49 = var0.fleetIndex
		local var50 = var47[var48][var49]
		local var51 = Fleet.New({
			ship_list = {},
			commanders = var50.commanders
		})

		if var5.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var52 = var51:getCommanders()

			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var45,
				commanders = var52
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var53 = {}

			local function var54(arg0)
				for iter0, iter1 in pairs(var47) do
					for iter2, iter3 in pairs(iter1) do
						if var50 ~= iter3 then
							for iter4, iter5 in ipairs(iter3.commanders) do
								if iter5.id == arg0 then
									return iter0, iter2, iter5.pos
								end
							end
						end
					end
				end

				return nil
			end

			for iter6 = 1, 2 do
				local var55 = var46:getCommanderByPos(iter6)

				if var55 then
					local var56, var57, var58 = var54(var55.id)

					if var56 and var57 and var58 then
						table.insert(var53, function(arg0)
							local var0 = var58 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1 = Fleet.DEFAULT_NAME[var57 + (var56 == FleetType.Submarine and 10 or 0)]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var1, var0),
								onYes = function()
									local var0 = var47[var56][var57]
									local var1 = Fleet.New({
										ship_list = {},
										commanders = var0.commanders
									})

									var1:updateCommanderByPos(iter6, nil)

									var0.commanders = var1:outputCommanders()

									var51:updateCommanderByPos(iter6, var55)

									var50.commanders = var51:outputCommanders()

									arg0()
								end,
								onNo = arg0
							})
						end)
					else
						table.insert(var53, function(arg0)
							var51:updateCommanderByPos(iter6, var55)

							var50.commanders = var51:outputCommanders()

							arg0()
						end)
					end
				else
					table.insert(var53, function(arg0)
						var51:updateCommanderByPos(iter6, nil)

						var50.commanders = var51:outputCommanders()

						arg0()
					end)
				end
			end

			seriesAsync(var53, function()
				arg0:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
					fleet = var51
				})
			end)
		elseif var5.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			for iter7 = 1, 2 do
				var51:updateCommanderByPos(iter7, nil)
			end

			var50.commanders = var51:outputCommanders()

			arg0:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
				fleet = var51
			})
		end
	elseif var1 == LevelUIConst.FLEET_TYPE_BOSSRUSH then
		local var59 = var5.id
		local var60 = var2:getPrefabFleetById(var59)
		local var61 = var0.fleetId
		local var62 = var0.actId

		if var5.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			local var63 = var4:getActivityFleets()[var62][var61]:getCommanders()

			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = var59,
				commanders = var63
			})
		elseif var5.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var64 = {}
			local var65 = {}

			_.each(var0.fleets, function(arg0)
				var65[arg0.id] = arg0
			end)

			local function var66(arg0)
				for iter0, iter1 in pairs(var65) do
					if var61 ~= iter0 then
						local var0 = iter1:getCommanders()

						for iter2, iter3 in pairs(var0) do
							if arg0 == iter3.id then
								return iter0, iter2
							end
						end
					end
				end

				return nil
			end

			for iter8 = 1, 2 do
				local var67 = var60:getCommanderByPos(iter8)

				if var67 then
					local var68, var69 = var66(var67.id)

					if var68 and var69 then
						table.insert(var64, function(arg0)
							local var0 = var69 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
							local var1 = table.indexof(var0.fleets, var65[var68])
							local var2 = Fleet.DEFAULT_NAME[var1]

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", var2, var0),
								onYes = function()
									local var0 = var65[var68]

									var0:updateCommanderByPos(var69, nil)
									var4:updateActivityFleet(var62, var68, var0)

									local var1 = var65[var61]

									var1:updateCommanderByPos(iter8, var67)
									var4:updateActivityFleet(var62, var61, var1)
									arg0()
								end,
								onNo = arg0
							})
						end)
					else
						table.insert(var64, function(arg0)
							local var0 = var65[var61]

							var0:updateCommanderByPos(iter8, var67)
							var4:updateActivityFleet(var62, var61, var0)
							arg0()
						end)
					end
				else
					table.insert(var64, function(arg0)
						local var0 = var65[var61]

						var0:updateCommanderByPos(iter8, nil)
						var4:updateActivityFleet(var62, var61, var0)
						arg0()
					end)
				end
			end

			seriesAsync(var64, function()
				arg0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
					actId = var62,
					fleetId = var61
				})
			end)
		elseif var5.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			local var70 = var4:getActivityFleets()[var62][var61]

			for iter9 = 1, 2 do
				var70:updateCommanderByPos(iter9, nil)
			end

			var4:updateActivityFleet(var62, var61, var70)
			arg0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
				actId = var62,
				fleetId = var61
			})
		end
	end
end

return var0
