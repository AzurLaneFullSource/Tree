local var0_0 = class("SelectCommanderCatForPlayScene", import(".CommanderCatScene"))

function var0_0.emit(arg0_1, ...)
	if unpack({
		...
	}) == var0_0.ON_BACK then
		var0_0.super.emit(arg0_1, var0_0.ON_CLOSE)
	else
		var0_0.super.emit(arg0_1, ...)
	end
end

function var0_0.didEnter(arg0_2)
	local var0_2 = arg0_2.contextData.activeCommander

	arg0_2.contextData.mode = var0_0.MODE_SELECT
	arg0_2.contextData.maxCount = 10
	arg0_2.contextData.fleetType = CommanderCatScene.FLEET_TYPE_COMMON
	arg0_2.contextData.activeGroupId = var0_2.groupId
	arg0_2.contextData.ignoredIds = {}

	table.insert(arg0_2.contextData.ignoredIds, var0_2.id)
	arg0_2:CollectIgnoredIdsForPlay(arg0_2.contextData.ignoredIds)

	function arg0_2.contextData.onCommander(arg0_3, arg1_3, arg2_3, arg3_3)
		return arg0_2:IsLegalForPlay(var0_2, arg0_3, arg1_3, arg2_3)
	end

	var0_0.super.didEnter(arg0_2)
end

function var0_0.RegisterEvent(arg0_4)
	var0_0.super.RegisterEvent(arg0_4)
	arg0_4:bind(CommanderCatDockPage.ON_SORT, function(arg0_5)
		onNextTick(function()
			local var0_6 = arg0_4.pages[CommanderCatScene.PAGE_DOCK]

			if var0_6 and var0_6:GetLoaded() then
				local var1_6 = Clone(var0_6.sortData)

				if arg0_4.contextData.OnSort then
					arg0_4.contextData.OnSort(var1_6)
				end
			end
		end)
	end)
end

function var0_0.CollectIgnoredIdsForPlay(arg0_7, arg1_7)
	local var0_7 = getProxy(CommanderProxy):getRawData()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if iter1_7:isLocked() then
			table.insert(arg1_7, iter1_7.id)
		end
	end

	local var1_7 = getProxy(ChapterProxy):getActiveChapter()

	if var1_7 then
		_.each(var1_7.fleets, function(arg0_8)
			local var0_8 = arg0_8:getCommanders()

			for iter0_8, iter1_8 in pairs(var0_8) do
				table.insert(arg1_7, iter1_8.id)
			end
		end)
	end
end

function var0_0.IsLegalForPlay(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	if nowWorld():CheckCommanderInFleet(arg2_9.id) then
		return false, i18n("commander_is_in_bigworld")
	end

	if arg1_9:isMaxLevel() and not arg1_9:isSameGroup(arg2_9.groupId) then
		return false, i18n("commander_select_matiral_erro")
	end

	if getProxy(CommanderProxy):IsHome(arg2_9.id) then
		return false, i18n("cat_sleep_notplay")
	end

	if not arg0_9:CheckFormation(arg2_9, arg4_9, arg3_9) then
		return false, nil
	end

	if not arg0_9:CheckGuild(arg2_9, arg4_9, arg3_9) then
		return false, nil
	end

	if not arg0_9:CheckExtra(arg2_9, arg4_9, arg3_9) then
		return false, nil
	end

	return true
end

function var0_0.CheckFormation(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = getProxy(FleetProxy)
	local var1_10 = var0_10:getCommanders()
	local var2_10 = _.detect(var1_10, function(arg0_11)
		return arg1_10.id == arg0_11.commanderId
	end)

	if not var2_10 then
		return true
	end

	arg0_10.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var2_10.fleetId,
				pos = var2_10.pos,
				callback = function()
					var1_10 = var0_10:getCommanders()

					if arg2_10 then
						arg2_10()
					end
				end
			})
		end,
		onNo = arg3_10,
		onClose = arg3_10
	})

	return false
end

function var0_0.CheckGuild(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = getProxy(GuildProxy):getRawData()

	if not var0_14 or not var0_14:ExistCommander(arg1_14.id) then
		return true
	end

	arg0_14.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_is_in_guild"),
		onYes = function()
			local var0_15 = var0_14:GetActiveEvent()

			if not var0_15 then
				return
			end

			local var1_15 = var0_15:GetBossMission()

			if not var1_15 or not var1_15:IsActive() then
				return
			end

			local var2_15 = var1_15:GetFleetCommanderId(arg1_14.id)

			if not var2_15 then
				return
			end

			local var3_15 = Clone(var2_15)
			local var4_15 = var3_15:GetCommanderPos(arg1_14.id)

			if not var4_15 then
				return
			end

			var3_15:RemoveCommander(var4_15)
			pg.m02:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
				force = true,
				editFleet = {
					[var3_15.id] = var3_15
				},
				callback = arg2_14
			})
		end,
		onNo = arg3_14,
		onClose = arg3_14
	})

	return false
end

function var0_0.CheckExtra(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = getProxy(FleetProxy)
	local var1_16 = var0_16:getCommanders()
	local var2_16 = var0_16:GetExtraCommanders()
	local var3_16 = _.detect(var2_16, function(arg0_17)
		return arg1_16.id == arg0_17.commanderId
	end)

	if not var3_16 then
		return true
	end

	arg0_16.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var3_16.fleetId,
				pos = var3_16.pos,
				callback = function()
					var1_16 = var0_16:getCommanders()

					if arg2_16 then
						arg2_16()
					end
				end
			})
		end,
		onNo = arg3_16,
		onClose = arg3_16
	})

	return false
end

return var0_0
