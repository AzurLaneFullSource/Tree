local var0 = class("TaskGoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().taskVO
	local var1 = getProxy(ChapterProxy)
	local var2 = var0:getConfig("scene")

	if var2 and #var2 > 0 then
		if var2[1] == "ACTIVITY_MAP" then
			local var3 = {}

			if var2[2] then
				table.insert(var3, function(arg0)
					local var0 = getProxy(ActivityProxy)

					if underscore.any(var2[2], function(arg0)
						local var0 = var0:getActivityById(arg0)

						return var0 and not var0:isEnd()
					end) then
						arg0()
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
					end
				end)
			end

			table.insert(var3, function(arg0)
				local var0, var1 = var1:getLastMapForActivity()

				if var0 and var1:getMapById(var0):isUnlock() then
					arg0(var0, var1)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
				end
			end)
			seriesAsync(var3, function(arg0, arg1)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
					chapterId = arg1,
					mapIdx = arg0
				})
			end)
		elseif var2[1] == "HARD_MAP" then
			local var4 = var1:getUseableMaxEliteMap()

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				mapIdx = var4 and var4.id
			})
		elseif SCENE[var2[1]] == SCENE.LEVEL and var2[2] then
			local var5 = {}

			if var2[2].mapIdx then
				table.insert(var5, function(arg0)
					local var0, var1 = var1:getMapById(var2[2].mapIdx):isUnlock()

					if var0 then
						arg0()
					else
						pg.TipsMgr.GetInstance():ShowTips(var1)
					end
				end)
			end

			if var2[2].chapterId then
				table.insert(var5, function(arg0)
					if var1:getChapterById(var2[2].chapterId):isUnlock() then
						arg0()
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))
					end
				end)
			end

			seriesAsync(var5, function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
			end)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
		end

		return
	end

	if isa(var0, AvatarFrameTask) then
		return
	end

	local var6 = var0:getConfig("sub_type")
	local var7 = var1:getActiveChapter()
	local var8 = {
		chapterId = var7 and var7.id,
		mapIdx = var7 and var7:getConfig("map")
	}
	local var9 = math.modf(var6 / 10)
	local var10 = math.fmod(var6, 10)

	if var9 == 0 then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
	elseif var9 == 1 then
		if var10 == 9 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		end
	elseif var9 == 2 then
		if var10 == 6 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		elseif var10 == 7 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.MILITARYEXERCISE)
		elseif var10 == 8 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		elseif var10 == 9 then
			local var11 = tonumber(var0:getConfig("target_id"))

			arg0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_PERFORM,
				stageId = tonumber(var11)
			})
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		end
	elseif var9 == 3 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT)
		elseif var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				blockLock = true,
				mode = DockyardScene.MODE_DESTROY,
				onShip = ShipStatus.canDestroyShip,
				selectedMax = getGameset("ship_select_limit")[1],
				leftTopInfo = i18n("word_destroy"),
				ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
					isActivityNpc = true
				})
			})
		elseif var10 == 7 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
				warp = NavalAcademyScene.WARP_TO_TACTIC
			})
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		end
	elseif var9 == 4 then
		if var10 == 2 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_DESIGN
			})
		elseif var10 == 3 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_WEAPON
			})
		end
	elseif var9 == 5 then
		if var10 == 0 or var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				warp = StoreHouseConst.WARP_TO_MATERIAL
			})
		end
	elseif var9 == 6 then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	elseif var9 == 7 then
		local var12

		if var10 == 1 then
			var12 = NavalAcademyScene.WARP_TO_TACTIC
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
			warp = var12
		})
	elseif var9 == 8 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	elseif var9 == 9 then
		if var10 == 2 then
			arg0:sendNotification(TaskMediator.TASK_FILTER, "weekly")
		end
	elseif var9 == 10 then
		if var10 == 4 or var10 == 5 then
			local var13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

			if var13 and not var13:isEnd() then
				arg0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
					subContext = Context.New({
						viewComponent = InstagramLayer,
						mediator = InstagramMediator,
						data = {
							id = var13.id
						}
					})
				})
			end
		end
	elseif var9 == 11 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
		end
	elseif var9 == 12 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_SHAM_SHOP
			})
		elseif var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		elseif var10 == 2 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_SHOP_STREET
			})
		end
	elseif var9 == 13 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		end
	elseif var9 == 14 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
		end
	elseif var9 == 15 then
		if var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_GUILD
			})
		elseif var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP)
		end
	elseif var9 == 17 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
				fleetType = CommanderCatScene.FLEET_TYPE_COMMON
			})
		end
	elseif var9 == 18 then
		if var10 == 2 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		end
	elseif var9 == 30 then
		if var10 == 4 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
		end
	elseif var9 == 40 then
		if var10 == 2 then
			if getProxy(GuildProxy):getData() then
				arg0:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
					page = "office"
				})
			else
				arg0:sendNotification(GAME.GO_SCENE, SCENE.PUBLIC_GUILD)
			end
		end
	elseif var9 == 41 then
		if var10 == 7 then
			pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
		end
	elseif var9 == 43 then
		if var10 == 0 or var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.FEAST)
		elseif var10 == 2 or var10 == 3 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.FEAST, {
				page = 1
			})
		elseif var10 == 4 then
			pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
		end
	elseif var9 == 100 then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
	elseif var9 == 101 then
		if var10 == 3 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
		elseif var10 == 5 or var10 == 8 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
				mode = DockyardScene.MODE_OVERVIEW
			})
		end
	elseif var9 == 102 then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var8)
	elseif var9 == 200 then
		if var10 == 1 or var10 == 2 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.BIANDUI)
		end
	elseif var9 == 201 then
		if var10 == 0 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
		elseif var10 == 1 then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
		end
	end
end

return var0
