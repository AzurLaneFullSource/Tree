local var0_0 = class("GuildBossMissionFleet", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.fleet_id
	arg0_1.userShips = {}
	arg0_1.commanders = {}
	arg0_1.invaildShips = {}
	arg0_1.invaildCommanders = {}

	if arg1_1.ships then
		arg0_1:Flush(arg1_1)
	end
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2.userShips = {}
	arg0_2.invaildShips = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.ships) do
		local var0_2 = {
			uid = iter1_2.user_id,
			id = iter1_2.ship_id
		}

		if arg0_2:IsVaildShip(var0_2) then
			table.insert(arg0_2.userShips, var0_2)
		else
			table.insert(arg0_2.invaildShips, var0_2)
		end
	end

	local var1_2 = getProxy(CommanderProxy):getData()
	local var2_2 = {}

	for iter2_2, iter3_2 in pairs(arg1_2.commanders) do
		local var3_2 = var1_2[iter3_2.id]

		if var3_2 and iter3_2.pos then
			var2_2[iter3_2.pos] = var3_2
		else
			table.insert(arg0_2.invaildCommanders, iter3_2.id)
		end
	end

	arg0_2:UpdateCommander(var2_2)
end

function var0_0.GetName(arg0_3)
	if arg0_3:IsMainFleet() then
		return i18n("ship_formationUI_fleetName11")
	else
		return i18n("ship_formationUI_fleetName1")
	end
end

function var0_0.ExistMember(arg0_4, arg1_4)
	local var0_4 = getProxy(GuildProxy):getRawData()

	return var0_4 and var0_4:getMemberById(arg1_4)
end

function var0_0.IsVaildShip(arg0_5, arg1_5)
	local function var0_5(arg0_6)
		local var0_6 = getProxy(GuildProxy):getRawData()

		if getProxy(PlayerProxy):getRawData().id == arg0_6.uid then
			return getProxy(BayProxy):getShipById(arg0_6.id) ~= nil
		end

		local var1_6 = var0_6:getMemberById(arg0_6.uid):GetAssaultFleet()
		local var2_6 = GuildAssaultFleet.GetVirtualId(arg0_6.uid, arg0_6.id)

		return (var1_6:ExistShip(var2_6))
	end

	local function var1_5(arg0_7)
		return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_7.id, "inEvent")
	end

	return arg0_5:ExistMember(arg1_5.uid) and var0_5(arg1_5) and not var1_5(arg1_5)
end

function var0_0.ExistInvailShips(arg0_8)
	if #arg0_8.invaildShips > 0 then
		return true
	end

	if _.any(arg0_8.userShips, function(arg0_9)
		return not arg0_8:IsVaildShip(arg0_9)
	end) then
		return true
	end

	return false
end

function var0_0.ClearInvaildShip(arg0_10)
	arg0_10.invaildShips = {}

	for iter0_10 = #arg0_10.userShips, 1, -1 do
		local var0_10 = arg0_10.userShips[iter0_10]

		if not arg0_10:IsVaildShip(var0_10) then
			table.remove(arg0_10.userShips, iter0_10)
		end
	end
end

function var0_0.GetMyShipIds(arg0_11)
	local var0_11 = {}
	local var1_11 = getProxy(PlayerProxy):getRawData().id

	for iter0_11, iter1_11 in ipairs(arg0_11.userShips) do
		if iter1_11.uid == var1_11 then
			table.insert(var0_11, iter1_11.id)
		end
	end

	return var0_11
end

function var0_0.GetShipIds(arg0_12)
	return arg0_12.userShips
end

function var0_0.GetShips(arg0_13)
	local var0_13 = getProxy(PlayerProxy):getData()
	local var1_13 = getProxy(GuildProxy):getData()
	local var2_13 = getProxy(BayProxy)
	local var3_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.userShips) do
		if var0_13.id == iter1_13.uid then
			local var4_13 = var2_13:getShipById(iter1_13.id)

			if var4_13 then
				var4_13.id = GuildAssaultFleet.GetVirtualId(var0_13.id, var4_13.id)

				local var5_13 = GuildBossMissionShip.New(var4_13)

				table.insert(var3_13, {
					member = var0_13,
					ship = var5_13
				})
			end
		else
			local var6_13 = var1_13:getMemberById(iter1_13.uid)
			local var7_13 = var6_13 and var6_13:GetAssaultFleet()
			local var8_13 = var7_13 and var7_13:GetShipByRealId(iter1_13.uid, iter1_13.id)

			if var8_13 then
				local var9_13 = GuildBossMissionShip.New(var8_13)

				table.insert(var3_13, {
					member = var6_13,
					ship = var9_13
				})
			end
		end
	end

	return var3_13
end

function var0_0.GetDownloadResShips(arg0_14)
	local var0_14 = getProxy(PlayerProxy):getRawData()
	local var1_14 = arg0_14:GetShips()
	local var2_14 = {}

	for iter0_14, iter1_14 in pairs(var1_14) do
		if iter1_14.member.id ~= var0_14.id then
			table.insert(var2_14, iter1_14.ship:getPainting())
		end
	end

	return var2_14
end

function var0_0.GetTeamTypeShips(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15:GetShips()) do
		local var1_15 = iter1_15.ship

		if var1_15:getTeamType() == arg1_15 then
			table.insert(var0_15, var1_15)
		end
	end

	return var0_15
end

function var0_0.ExistSubShip(arg0_16)
	return #arg0_16:GetTeamTypeShips(TeamType.Submarine) > 0
end

function var0_0.RemoveAll(arg0_17)
	arg0_17.userShips = {}
end

function var0_0.IsMainFleet(arg0_18)
	return arg0_18.id == 1
end

function var0_0.ExistUserShip(arg0_19, arg1_19)
	return _.any(arg0_19.userShips, function(arg0_20)
		return arg0_20.uid == arg1_19
	end)
end

function var0_0.ContainShip(arg0_21, arg1_21, arg2_21)
	return _.any(arg0_21.userShips, function(arg0_22)
		return arg0_22.uid == arg1_21 and arg0_22.id == arg2_21
	end)
end

function var0_0.RemoveUserShip(arg0_23, arg1_23, arg2_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.userShips) do
		if iter1_23.uid == arg1_23 and iter1_23.id == arg2_23 then
			table.remove(arg0_23.userShips, iter0_23)

			return iter0_23
		end
	end
end

function var0_0.AddUserShip(arg0_24, arg1_24, arg2_24, arg3_24)
	if arg3_24 then
		table.insert(arg0_24.userShips, arg3_24, {
			uid = arg1_24,
			id = arg2_24
		})
	else
		table.insert(arg0_24.userShips, {
			uid = arg1_24,
			id = arg2_24
		})
	end
end

function var0_0.GetOtherMemberShipCnt(arg0_25, arg1_25)
	local var0_25 = 0

	for iter0_25, iter1_25 in ipairs(arg0_25.userShips) do
		if iter1_25.uid ~= arg1_25 then
			var0_25 = var0_25 + 1
		end
	end

	return var0_25
end

function var0_0.ExistSameKindShip(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetShips()

	for iter0_26, iter1_26 in pairs(var0_26) do
		if iter1_26.ship:isSameKind(arg1_26) then
			return true
		end
	end

	return false
end

function var0_0.IsLegal(arg0_27)
	local var0_27 = arg0_27:GetShips()
	local var1_27 = 0
	local var2_27 = 0
	local var3_27 = 0
	local var4_27 = 0
	local var5_27 = 0
	local var6_27 = 0
	local var7_27 = getProxy(PlayerProxy):getRawData().id

	for iter0_27, iter1_27 in ipairs(var0_27) do
		if iter1_27 and iter1_27.ship:getTeamType() == TeamType.Main then
			var1_27 = var1_27 + 1

			if iter1_27.member.id == var7_27 then
				var4_27 = var4_27 + 1
			end
		elseif iter1_27 and iter1_27.ship:getTeamType() == TeamType.Vanguard then
			var2_27 = var2_27 + 1

			if iter1_27.member.id == var7_27 then
				var5_27 = var5_27 + 1
			end
		elseif iter1_27 and iter1_27.ship:getTeamType() == TeamType.Submarine then
			var3_27 = var3_27 + 1

			if iter1_27.member.id == var7_27 then
				var6_27 = var6_27 + 1
			end
		end

		local var8_27 = GuildAssaultFleet.GetRealId(iter1_27.ship.id)

		if pg.ShipFlagMgr.GetInstance():GetShipFlag(var8_27, "inEvent") then
			return false, i18n("guild_boss_formation_exist_event_ship", iter1_27.ship:getConfig("name"))
		end
	end

	if var1_27 > 3 or var2_27 > 3 or var3_27 > 3 then
		return false, i18n("guild_boss_fleet_cnt_invaild")
	end

	local var9_27 = var5_27 > 0 and var4_27 > 0
	local var10_27

	if var1_27 > 0 and var2_27 > 0 and not var9_27 then
		var10_27 = i18n("guild_boss_formation_not_exist_self_ship")
	else
		var10_27 = i18n("guild_fleet_is_legal")
	end

	if arg0_27:IsMainFleet() then
		return var1_27 > 0 and var2_27 > 0 and var9_27, var10_27
	else
		return true
	end
end

function var0_0.ResortShips(arg0_28, arg1_28)
	local function var0_28(arg0_29)
		local var0_29 = GuildAssaultFleet.GetVirtualId(arg0_29.uid, arg0_29.id)

		for iter0_29, iter1_29 in ipairs(arg1_28) do
			if var0_29 == iter1_29.shipId then
				return iter0_29
			end
		end

		return 0
	end

	table.sort(arg0_28.userShips, function(arg0_30, arg1_30)
		return var0_28(arg0_30) < var0_28(arg1_30)
	end)
end

function var0_0.UpdateCommander(arg0_31, arg1_31)
	arg0_31.commanders = arg1_31
	arg0_31.skills = {}

	arg0_31:updateCommanderSkills()
end

function var0_0.ClearCommanders(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32.commanders) do
		arg0_32:RemoveCommander(iter0_32)
	end
end

function var0_0.getCommanders(arg0_33)
	return arg0_33.commanders
end

function var0_0.AddCommander(arg0_34, arg1_34, arg2_34)
	arg0_34.commanders[arg1_34] = arg2_34
	arg0_34.skills = {}

	arg0_34:updateCommanderSkills()
end

function var0_0.RemoveCommander(arg0_35, arg1_35)
	arg0_35.commanders[arg1_35] = nil
	arg0_35.skills = {}

	arg0_35:updateCommanderSkills()
end

function var0_0.GetCommanderPos(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36.commanders) do
		if iter1_36.id == arg1_36 then
			return iter0_36
		end
	end

	return false
end

function var0_0.updateCommanderSkills(arg0_37)
	local var0_37 = #arg0_37.skills

	while var0_37 > 0 do
		local var1_37 = arg0_37.skills[var0_37]

		if not arg0_37:findCommanderBySkillId(var1_37.id) and var1_37:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0_37.skills, var0_37)
		end

		var0_37 = var0_37 - 1
	end

	local var2_37 = arg0_37:getCommanders()

	for iter0_37, iter1_37 in pairs(var2_37) do
		for iter2_37, iter3_37 in ipairs(iter1_37:getSkills()) do
			for iter4_37, iter5_37 in ipairs(iter3_37:getTacticSkill()) do
				table.insert(arg0_37.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5_37))
			end
		end
	end
end

function var0_0.findSkills(arg0_38, arg1_38)
	return _.filter(arg0_38:getSkills(), function(arg0_39)
		return arg0_39:GetType() == arg1_38
	end)
end

function var0_0.findCommanderBySkillId(arg0_40, arg1_40)
	local var0_40 = arg0_40:getCommanders()

	for iter0_40, iter1_40 in pairs(var0_40) do
		if _.any(iter1_40:getSkills(), function(arg0_41)
			return _.any(arg0_41:getTacticSkill(), function(arg0_42)
				return arg0_42 == arg1_40
			end)
		end) then
			return iter1_40
		end
	end
end

function var0_0.getSkills(arg0_43)
	return arg0_43.skills or {}
end

function var0_0.getFleetType(arg0_44)
	if arg0_44.id == GuildBossMission.MAIN_FLEET_ID then
		return FleetType.Normal
	elseif arg0_44.id == GuildBossMission.SUB_FLEET_ID then
		return FleetType.Submarine
	end

	assert(false, arg0_44.id)
end

function var0_0.BuildBattleBuffList(arg0_45)
	local var0_45 = {}
	local var1_45, var2_45 = FleetSkill.GuildBossTriggerSkill(arg0_45, FleetSkill.TypeBattleBuff)

	if var1_45 and #var1_45 > 0 then
		local var3_45 = {}

		for iter0_45, iter1_45 in ipairs(var1_45) do
			local var4_45 = var2_45[iter0_45]
			local var5_45 = arg0_45:findCommanderBySkillId(var4_45.id)

			var3_45[var5_45] = var3_45[var5_45] or {}

			table.insert(var3_45[var5_45], iter1_45)
		end

		for iter2_45, iter3_45 in pairs(var3_45) do
			table.insert(var0_45, {
				iter2_45,
				iter3_45
			})
		end
	end

	local var6_45 = arg0_45:getCommanders()

	for iter4_45, iter5_45 in pairs(var6_45) do
		local var7_45 = iter5_45:getTalents()

		for iter6_45, iter7_45 in ipairs(var7_45) do
			local var8_45 = iter7_45:getBuffsAddition()

			if #var8_45 > 0 then
				local var9_45

				for iter8_45, iter9_45 in ipairs(var0_45) do
					if iter9_45[1] == iter5_45 then
						var9_45 = iter9_45[2]

						break
					end
				end

				if not var9_45 then
					var9_45 = {}

					table.insert(var0_45, {
						iter5_45,
						var9_45
					})
				end

				for iter10_45, iter11_45 in ipairs(var8_45) do
					table.insert(var9_45, iter11_45)
				end
			end
		end
	end

	return var0_45
end

function var0_0.ExistCommander(arg0_46, arg1_46)
	local var0_46 = arg0_46:getCommanders()

	for iter0_46, iter1_46 in pairs(var0_46) do
		if iter1_46.id == arg1_46 then
			return true
		end
	end

	return false
end

function var0_0.ExistInvaildCommanders(arg0_47)
	if #arg0_47.invaildCommanders > 0 then
		return true
	end

	local var0_47 = arg0_47:getCommanders()
	local var1_47 = getProxy(CommanderProxy)

	for iter0_47, iter1_47 in pairs(var0_47) do
		if not var1_47:getCommanderById(iter1_47.id) then
			return true
		end
	end

	return false
end

function var0_0.RemoveInvaildCommanders(arg0_48)
	local var0_48 = arg0_48:getCommanders()
	local var1_48 = getProxy(CommanderProxy)

	for iter0_48, iter1_48 in pairs(var0_48) do
		if not var1_48:getCommanderById(iter1_48.id) then
			arg0_48:RemoveCommander(iter0_48)
		end
	end

	arg0_48.invaildCommanders = {}
end

function var0_0.getCommandersAddition(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(CommanderConst.PROPERTIES) do
		local var1_49 = 0

		for iter2_49, iter3_49 in pairs(arg0_49:getCommanders()) do
			var1_49 = var1_49 + iter3_49:getAbilitysAddition()[iter1_49]
		end

		if var1_49 > 0 then
			table.insert(var0_49, {
				attrName = iter1_49,
				value = var1_49
			})
		end
	end

	return var0_49
end

function var0_0.getCommandersTalentDesc(arg0_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in pairs(arg0_50:getCommanders()) do
		local var1_50 = iter1_50:getTalentsDesc()

		for iter2_50, iter3_50 in pairs(var1_50) do
			if var0_50[iter2_50] then
				var0_50[iter2_50].value = var0_50[iter2_50].value + iter3_50.value
			else
				var0_50[iter2_50] = {
					name = iter2_50,
					value = iter3_50.value,
					type = iter3_50.type
				}
			end
		end
	end

	return var0_50
end

function var0_0.ExistAnyCommander(arg0_51)
	local var0_51 = arg0_51:getCommanders()

	return table.getCount(var0_51) ~= 0
end

return var0_0
