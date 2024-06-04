local var0 = class("UpgradeCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.materialIds
	local var3 = var0.skillId
	local var4 = getProxy(CommanderProxy)
	local var5 = var4:getCommanderById(var1)

	if not var5 then
		return
	end

	local var6 = var5:getSkill(var3)

	if not var6 then
		return
	end

	if var5:isMaxLevel() and var6:isMaxLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_be_upgrade"))

		return
	end

	local var7 = getProxy(FleetProxy):getCommandersInFleet()

	if _.any(var2, function(arg0)
		return table.contains(var7, arg0)
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_anyone_is_in_fleet"))

		return
	end

	local var8 = getProxy(ChapterProxy):getActiveChapter()

	if var8 then
		_.each(var8.fleets, function(arg0)
			local var0 = arg0:getCommanders()

			if _.any(_.values(var0), function(arg0)
				return arg0.id == var1
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

				return
			end
		end)
	end

	local var9 = 0
	local var10 = 0
	local var11 = CommanderCatUtil.CalcCommanderConsume(var2)

	for iter0, iter1 in ipairs(var2) do
		local var12 = var4:getCommanderById(iter1)

		if not var12 or var1 == iter1 then
			return
		end

		var9 = var9 + var12:getDestoryedSkillExp(var5.groupId)
		var10 = var10 + var12:getDestoryedExp(var5.groupId)
	end

	local var13 = math.floor(var10)
	local var14 = math.floor(var9)
	local var15 = getProxy(PlayerProxy)
	local var16 = var15:getData()

	if var11 > var16.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25008, {
		targetid = var1,
		materialid = var2
	}, 25009, function(arg0)
		if arg0.result == 0 then
			local var0 = Clone(var5)

			var5:addExp(var13)
			var6:addExp(var14)
			var16:consume({
				gold = var11
			})
			var15:updatePlayer(var16)
			var4:updateCommander(var5)
			arg0:sendNotification(GAME.COMMANDER_UPGRADE_DONE, {
				commander = var5,
				oldCommander = var0
			})

			for iter0, iter1 in ipairs(var2) do
				var4:removeCommanderById(iter1)
				arg0:clearHardChapterCommanders(iter1)
				arg0:clearActivityCommanders(iter1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_play_erro", arg0.result))
		end
	end)
end

function var0.clearHardChapterCommanders(arg0, arg1)
	local var0 = getProxy(ChapterProxy)
	local var1 = var0:getRawData()

	for iter0, iter1 in pairs(var1) do
		local var2 = iter1:getEliteFleetCommanders()

		for iter2, iter3 in pairs(var2) do
			for iter4, iter5 in pairs(iter3) do
				if iter5 == arg1 then
					iter1:updateCommander(iter2, iter4, nil)
					var0:updateChapter(iter1)
				end
			end
		end
	end
end

function var0.clearActivityCommanders(arg0, arg1)
	getProxy(FleetProxy):removeActivityFleetCommander(arg1)
end

return var0
