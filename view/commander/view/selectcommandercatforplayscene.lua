local var0 = class("SelectCommanderCatForPlayScene", import(".CommanderCatScene"))

function var0.emit(arg0, ...)
	if unpack({
		...
	}) == var0.ON_BACK then
		var0.super.emit(arg0, var0.ON_CLOSE)
	else
		var0.super.emit(arg0, ...)
	end
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.activeCommander

	arg0.contextData.mode = var0.MODE_SELECT
	arg0.contextData.maxCount = 10
	arg0.contextData.fleetType = CommanderCatScene.FLEET_TYPE_COMMON
	arg0.contextData.activeGroupId = var0.groupId
	arg0.contextData.ignoredIds = {}

	table.insert(arg0.contextData.ignoredIds, var0.id)
	arg0:CollectIgnoredIdsForPlay(arg0.contextData.ignoredIds)

	function arg0.contextData.onCommander(arg0, arg1, arg2, arg3)
		return arg0:IsLegalForPlay(var0, arg0, arg1, arg2)
	end

	var0.super.didEnter(arg0)
end

function var0.RegisterEvent(arg0)
	var0.super.RegisterEvent(arg0)
	arg0:bind(CommanderCatDockPage.ON_SORT, function(arg0)
		onNextTick(function()
			local var0 = arg0.pages[CommanderCatScene.PAGE_DOCK]

			if var0 and var0:GetLoaded() then
				local var1 = Clone(var0.sortData)

				if arg0.contextData.OnSort then
					arg0.contextData.OnSort(var1)
				end
			end
		end)
	end)
end

function var0.CollectIgnoredIdsForPlay(arg0, arg1)
	local var0 = getProxy(CommanderProxy):getRawData()

	for iter0, iter1 in pairs(var0) do
		if iter1:isLocked() then
			table.insert(arg1, iter1.id)
		end
	end

	local var1 = getProxy(ChapterProxy):getActiveChapter()

	if var1 then
		_.each(var1.fleets, function(arg0)
			local var0 = arg0:getCommanders()

			for iter0, iter1 in pairs(var0) do
				table.insert(arg1, iter1.id)
			end
		end)
	end
end

function var0.IsLegalForPlay(arg0, arg1, arg2, arg3, arg4)
	if nowWorld():CheckCommanderInFleet(arg2.id) then
		return false, i18n("commander_is_in_bigworld")
	end

	if arg1:isMaxLevel() and not arg1:isSameGroup(arg2.groupId) then
		return false, i18n("commander_select_matiral_erro")
	end

	if getProxy(CommanderProxy):IsHome(arg2.id) then
		return false, i18n("cat_sleep_notplay")
	end

	if not arg0:CheckFormation(arg2, arg4, arg3) then
		return false, nil
	end

	if not arg0:CheckGuild(arg2, arg4, arg3) then
		return false, nil
	end

	if not arg0:CheckExtra(arg2, arg4, arg3) then
		return false, nil
	end

	return true
end

function var0.CheckFormation(arg0, arg1, arg2, arg3)
	local var0 = getProxy(FleetProxy)
	local var1 = var0:getCommanders()
	local var2 = _.detect(var1, function(arg0)
		return arg1.id == arg0.commanderId
	end)

	if not var2 then
		return true
	end

	arg0.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var2.fleetId,
				pos = var2.pos,
				callback = function()
					var1 = var0:getCommanders()

					if arg2 then
						arg2()
					end
				end
			})
		end,
		onNo = arg3,
		onClose = arg3
	})

	return false
end

function var0.CheckGuild(arg0, arg1, arg2, arg3)
	local var0 = getProxy(GuildProxy):getRawData()

	if not var0 or not var0:ExistCommander(arg1.id) then
		return true
	end

	arg0.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_is_in_guild"),
		onYes = function()
			local var0 = var0:GetActiveEvent()

			if not var0 then
				return
			end

			local var1 = var0:GetBossMission()

			if not var1 or not var1:IsActive() then
				return
			end

			local var2 = var1:GetFleetCommanderId(arg1.id)

			if not var2 then
				return
			end

			local var3 = Clone(var2)
			local var4 = var3:GetCommanderPos(arg1.id)

			if not var4 then
				return
			end

			var3:RemoveCommander(var4)
			pg.m02:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
				force = true,
				editFleet = {
					[var3.id] = var3
				},
				callback = arg2
			})
		end,
		onNo = arg3,
		onClose = arg3
	})

	return false
end

function var0.CheckExtra(arg0, arg1, arg2, arg3)
	local var0 = getProxy(FleetProxy)
	local var1 = var0:getCommanders()
	local var2 = var0:GetExtraCommanders()
	local var3 = _.detect(var2, function(arg0)
		return arg1.id == arg0.commanderId
	end)

	if not var3 then
		return true
	end

	arg0.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var3.fleetId,
				pos = var3.pos,
				callback = function()
					var1 = var0:getCommanders()

					if arg2 then
						arg2()
					end
				end
			})
		end,
		onNo = arg3,
		onClose = arg3
	})

	return false
end

return var0
