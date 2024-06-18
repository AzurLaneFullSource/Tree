local var0_0 = class("TaskGoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().taskVO
	local var1_1 = getProxy(ChapterProxy)
	local var2_1 = var0_1:getConfig("scene")

	if var2_1 and #var2_1 > 0 then
		if var2_1[1] == "ACTIVITY_MAP" then
			local var3_1 = {}

			if var2_1[2] then
				table.insert(var3_1, function(arg0_2)
					local var0_2 = getProxy(ActivityProxy)

					if underscore.any(var2_1[2], function(arg0_3)
						local var0_3 = var0_2:getActivityById(arg0_3)

						return var0_3 and not var0_3:isEnd()
					end) then
						arg0_2()
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
					end
				end)
			end

			table.insert(var3_1, function(arg0_4)
				local var0_4, var1_4 = var1_1:getLastMapForActivity()

				if var0_4 and var1_1:getMapById(var0_4):isUnlock() then
					arg0_4(var0_4, var1_4)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
				end
			end)
			seriesAsync(var3_1, function(arg0_5, arg1_5)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
					chapterId = arg1_5,
					mapIdx = arg0_5
				})
			end)
		elseif var2_1[1] == "HARD_MAP" then
			local var4_1 = var1_1:getUseableMaxEliteMap()

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				mapIdx = var4_1 and var4_1.id
			})
		elseif SCENE[var2_1[1]] == SCENE.LEVEL and var2_1[2] then
			local var5_1 = {}

			if var2_1[2].mapIdx then
				table.insert(var5_1, function(arg0_6)
					local var0_6, var1_6 = var1_1:getMapById(var2_1[2].mapIdx):isUnlock()

					if var0_6 then
						arg0_6()
					else
						pg.TipsMgr.GetInstance():ShowTips(var1_6)
					end
				end)
			end

			if var2_1[2].chapterId then
				table.insert(var5_1, function(arg0_7)
					if var1_1:getChapterById(var2_1[2].chapterId):isUnlock() then
						arg0_7()
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))
					end
				end)
			end

			seriesAsync(var5_1, function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE[var2_1[1]], var2_1[2])
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE[var2_1[1]], var2_1[2])
		end

		return
	end

	if isa(var0_1, AvatarFrameTask) then
		return
	end

	local var6_1 = var0_1:getConfig("sub_type")
	local var7_1 = var1_1:getActiveChapter()
	local var8_1 = {
		chapterId = var7_1 and var7_1.id,
		mapIdx = var7_1 and var7_1:getConfig("map")
	}
	local var9_1 = math.modf(var6_1 / 10)
	local var10_1 = math.fmod(var6_1, 10)

	if var9_1 == 0 then
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
	elseif var9_1 == 1 then
		if var10_1 == 9 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		end
	elseif var9_1 == 2 then
		if var10_1 == 6 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		elseif var10_1 == 7 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MILITARYEXERCISE)
		elseif var10_1 == 8 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		elseif var10_1 == 9 then
			local var11_1 = tonumber(var0_1:getConfig("target_id"))

			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_PERFORM,
				stageId = tonumber(var11_1)
			})
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		end
	elseif var9_1 == 3 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT)
		elseif var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				blockLock = true,
				mode = DockyardScene.MODE_DESTROY,
				onShip = ShipStatus.canDestroyShip,
				selectedMax = getGameset("ship_select_limit")[1],
				leftTopInfo = i18n("word_destroy"),
				ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
					isActivityNpc = true
				})
			})
		elseif var10_1 == 7 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
				warp = NavalAcademyScene.WARP_TO_TACTIC
			})
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		end
	elseif var9_1 == 4 then
		if var10_1 == 2 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_DESIGN
			})
		elseif var10_1 == 3 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_WEAPON
			})
		end
	elseif var9_1 == 5 then
		if var10_1 == 0 or var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_MATERIAL
			})
		end
	elseif var9_1 == 6 then
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	elseif var9_1 == 7 then
		local var12_1

		if var10_1 == 1 then
			var12_1 = NavalAcademyScene.WARP_TO_TACTIC
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
			warp = var12_1
		})
	elseif var9_1 == 8 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	elseif var9_1 == 9 then
		if var10_1 == 2 then
			arg0_1:sendNotification(TaskMediator.TASK_FILTER, "weekly")
		end
	elseif var9_1 == 10 then
		if var10_1 == 4 or var10_1 == 5 then
			local var13_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

			if var13_1 and not var13_1:isEnd() then
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
					subContext = Context.New({
						viewComponent = InstagramLayer,
						mediator = InstagramMediator,
						data = {
							id = var13_1.id
						}
					})
				})
			end
		end
	elseif var9_1 == 11 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
		end
	elseif var9_1 == 12 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_SHAM_SHOP
			})
		elseif var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		elseif var10_1 == 2 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_SHOP_STREET
			})
		end
	elseif var9_1 == 13 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		end
	elseif var9_1 == 14 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		end
	elseif var9_1 == 15 then
		if var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_GUILD
			})
		elseif var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP)
		end
	elseif var9_1 == 17 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
				fleetType = CommanderCatScene.FLEET_TYPE_COMMON
			})
		end
	elseif var9_1 == 18 then
		if var10_1 == 2 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		end
	elseif var9_1 == 30 then
		if var10_1 == 4 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
		end
	elseif var9_1 == 40 then
		if var10_1 == 2 then
			if getProxy(GuildProxy):getData() then
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
					page = "office"
				})
			else
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.PUBLIC_GUILD)
			end
		end
	elseif var9_1 == 41 then
		if var10_1 == 7 then
			pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
		end
	elseif var9_1 == 43 then
		if var10_1 == 0 or var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.FEAST)
		elseif var10_1 == 2 or var10_1 == 3 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.FEAST, {
				page = 1
			})
		elseif var10_1 == 4 then
			pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
		end
	elseif var9_1 == 100 then
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
	elseif var9_1 == 101 then
		if var10_1 == 3 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
		elseif var10_1 == 5 or var10_1 == 8 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		end
	elseif var9_1 == 102 then
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8_1)
	elseif var9_1 == 200 then
		if var10_1 == 1 or var10_1 == 2 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BIANDUI)
		end
	elseif var9_1 == 201 then
		if var10_1 == 0 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
		elseif var10_1 == 1 then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
		end
	end
end

return var0_0
