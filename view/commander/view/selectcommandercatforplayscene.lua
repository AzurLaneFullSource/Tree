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

	if not arg0_9:CheckFullExp(arg1_9, arg2_9) and not arg1_9:isSameGroup(arg2_9.groupId) then
		return false, i18n("commander_exp_limit")
	end

	return true
end

function var0_0.SimulateAddCommanderExp(arg0_10, arg1_10, arg2_10)
	local var0_10 = Clone(arg1_10)

	var0_10:addExp(arg2_10)

	return var0_10, arg1_10
end

function var0_0.CheckFullExp(arg0_11, arg1_11, arg2_11)
	local var0_11 = {}
	local var1_11 = arg0_11.pages[CommanderCatScene.PAGE_DOCK]

	if var1_11 and var1_11.selectedList then
		var0_11 = var1_11.selectedList
	end

	local var2_11, var3_11 = CommanderCatUtil.GetSkillExpAndCommanderExp(arg1_11, var0_11)

	if arg0_11:SimulateAddCommanderExp(arg1_11, var2_11):isMaxLevel() then
		return false
	end

	return true
end

function var0_0.CheckFormation(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = getProxy(FleetProxy)
	local var1_12 = var0_12:getCommanders()
	local var2_12 = _.detect(var1_12, function(arg0_13)
		return arg1_12.id == arg0_13.commanderId
	end)

	if not var2_12 then
		return true
	end

	arg0_12.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var2_12.fleetId,
				pos = var2_12.pos,
				callback = function()
					var1_12 = var0_12:getCommanders()

					if arg2_12 then
						arg2_12()
					end
				end
			})
		end,
		onNo = arg3_12,
		onClose = arg3_12
	})

	return false
end

function var0_0.CheckGuild(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = getProxy(GuildProxy):getRawData()

	if not var0_16 or not var0_16:ExistCommander(arg1_16.id) then
		return true
	end

	arg0_16.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_is_in_guild"),
		onYes = function()
			local var0_17 = var0_16:GetActiveEvent()

			if not var0_17 then
				return
			end

			local var1_17 = var0_17:GetBossMission()

			if not var1_17 or not var1_17:IsActive() then
				return
			end

			local var2_17 = var1_17:GetFleetCommanderId(arg1_16.id)

			if not var2_17 then
				return
			end

			local var3_17 = Clone(var2_17)
			local var4_17 = var3_17:GetCommanderPos(arg1_16.id)

			if not var4_17 then
				return
			end

			var3_17:RemoveCommander(var4_17)
			pg.m02:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
				force = true,
				editFleet = {
					[var3_17.id] = var3_17
				},
				callback = arg2_16
			})
		end,
		onNo = arg3_16,
		onClose = arg3_16
	})

	return false
end

function var0_0.CheckExtra(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = getProxy(FleetProxy)
	local var1_18 = var0_18:getCommanders()
	local var2_18 = var0_18:GetExtraCommanders()
	local var3_18 = _.detect(var2_18, function(arg0_19)
		return arg1_18.id == arg0_19.commanderId
	end)

	if not var3_18 then
		return true
	end

	arg0_18.contextData.msgBox:ExecuteAction("Show", {
		content = i18n("commander_material_is_in_fleet_tip"),
		onYes = function()
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var3_18.fleetId,
				pos = var3_18.pos,
				callback = function()
					var1_18 = var0_18:getCommanders()

					if arg2_18 then
						arg2_18()
					end
				end
			})
		end,
		onNo = arg3_18,
		onClose = arg3_18
	})

	return false
end

return var0_0
