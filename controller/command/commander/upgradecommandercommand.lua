local var0_0 = class("UpgradeCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.materialIds
	local var3_1 = var0_1.skillId
	local var4_1 = getProxy(CommanderProxy)
	local var5_1 = var4_1:getCommanderById(var1_1)

	if not var5_1 then
		return
	end

	local var6_1 = var5_1:getSkill(var3_1)

	if not var6_1 then
		return
	end

	if var5_1:isMaxLevel() and var6_1:isMaxLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_be_upgrade"))

		return
	end

	local var7_1 = getProxy(FleetProxy):getCommandersInFleet()

	if _.any(var2_1, function(arg0_2)
		return table.contains(var7_1, arg0_2)
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_anyone_is_in_fleet"))

		return
	end

	local var8_1 = getProxy(ChapterProxy):getActiveChapter()

	if var8_1 then
		_.each(var8_1.fleets, function(arg0_3)
			local var0_3 = arg0_3:getCommanders()

			if _.any(_.values(var0_3), function(arg0_4)
				return arg0_4.id == var1_1
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

				return
			end
		end)
	end

	local var9_1 = 0
	local var10_1 = 0
	local var11_1 = CommanderCatUtil.CalcCommanderConsume(var2_1)

	for iter0_1, iter1_1 in ipairs(var2_1) do
		local var12_1 = var4_1:getCommanderById(iter1_1)

		if not var12_1 or var1_1 == iter1_1 then
			return
		end

		var9_1 = var9_1 + var12_1:getDestoryedSkillExp(var5_1.groupId)
		var10_1 = var10_1 + var12_1:getDestoryedExp(var5_1.groupId)
	end

	local var13_1 = math.floor(var10_1)
	local var14_1 = math.floor(var9_1)
	local var15_1 = getProxy(PlayerProxy)
	local var16_1 = var15_1:getData()

	if var11_1 > var16_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25008, {
		targetid = var1_1,
		materialid = var2_1
	}, 25009, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = Clone(var5_1)

			var5_1:addExp(var13_1)
			var6_1:addExp(var14_1)
			var16_1:consume({
				gold = var11_1
			})
			var15_1:updatePlayer(var16_1)
			var4_1:updateCommander(var5_1)
			arg0_1:sendNotification(GAME.COMMANDER_UPGRADE_DONE, {
				commander = var5_1,
				oldCommander = var0_5
			})

			for iter0_5, iter1_5 in ipairs(var2_1) do
				var4_1:removeCommanderById(iter1_5)
				arg0_1:clearHardChapterCommanders(iter1_5)
				arg0_1:clearActivityCommanders(iter1_5)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_play_erro", arg0_5.result))
		end
	end)
end

function var0_0.clearHardChapterCommanders(arg0_6, arg1_6)
	local var0_6 = getProxy(ChapterProxy)
	local var1_6 = var0_6:getRawData()

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var2_6 = iter1_6:getEliteFleetCommanders()

		for iter2_6, iter3_6 in pairs(var2_6) do
			for iter4_6, iter5_6 in pairs(iter3_6) do
				if iter5_6 == arg1_6 then
					iter1_6:updateCommander(iter2_6, iter4_6, nil)
					var0_6:updateChapter(iter1_6)
				end
			end
		end
	end
end

function var0_0.clearActivityCommanders(arg0_7, arg1_7)
	getProxy(FleetProxy):removeActivityFleetCommander(arg1_7)
end

return var0_0
