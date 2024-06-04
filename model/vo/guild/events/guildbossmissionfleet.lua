local var0 = class("GuildBossMissionFleet", import("...BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.fleet_id
	arg0.userShips = {}
	arg0.commanders = {}
	arg0.invaildShips = {}
	arg0.invaildCommanders = {}

	if arg1.ships then
		arg0:Flush(arg1)
	end
end

function var0.Flush(arg0, arg1)
	arg0.userShips = {}
	arg0.invaildShips = {}

	for iter0, iter1 in ipairs(arg1.ships) do
		local var0 = {
			uid = iter1.user_id,
			id = iter1.ship_id
		}

		if arg0:IsVaildShip(var0) then
			table.insert(arg0.userShips, var0)
		else
			table.insert(arg0.invaildShips, var0)
		end
	end

	local var1 = getProxy(CommanderProxy):getData()
	local var2 = {}

	for iter2, iter3 in pairs(arg1.commanders) do
		local var3 = var1[iter3.id]

		if var3 and iter3.pos then
			var2[iter3.pos] = var3
		else
			table.insert(arg0.invaildCommanders, iter3.id)
		end
	end

	arg0:UpdateCommander(var2)
end

function var0.GetName(arg0)
	if arg0:IsMainFleet() then
		return i18n("ship_formationUI_fleetName11")
	else
		return i18n("ship_formationUI_fleetName1")
	end
end

function var0.ExistMember(arg0, arg1)
	local var0 = getProxy(GuildProxy):getRawData()

	return var0 and var0:getMemberById(arg1)
end

function var0.IsVaildShip(arg0, arg1)
	local function var0(arg0)
		local var0 = getProxy(GuildProxy):getRawData()

		if getProxy(PlayerProxy):getRawData().id == arg0.uid then
			return getProxy(BayProxy):getShipById(arg0.id) ~= nil
		end

		local var1 = var0:getMemberById(arg0.uid):GetAssaultFleet()
		local var2 = GuildAssaultFleet.GetVirtualId(arg0.uid, arg0.id)

		return (var1:ExistShip(var2))
	end

	local function var1(arg0)
		return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0.id, "inEvent")
	end

	return arg0:ExistMember(arg1.uid) and var0(arg1) and not var1(arg1)
end

function var0.ExistInvailShips(arg0)
	if #arg0.invaildShips > 0 then
		return true
	end

	if _.any(arg0.userShips, function(arg0)
		return not arg0:IsVaildShip(arg0)
	end) then
		return true
	end

	return false
end

function var0.ClearInvaildShip(arg0)
	arg0.invaildShips = {}

	for iter0 = #arg0.userShips, 1, -1 do
		local var0 = arg0.userShips[iter0]

		if not arg0:IsVaildShip(var0) then
			table.remove(arg0.userShips, iter0)
		end
	end
end

function var0.GetMyShipIds(arg0)
	local var0 = {}
	local var1 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(arg0.userShips) do
		if iter1.uid == var1 then
			table.insert(var0, iter1.id)
		end
	end

	return var0
end

function var0.GetShipIds(arg0)
	return arg0.userShips
end

function var0.GetShips(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(GuildProxy):getData()
	local var2 = getProxy(BayProxy)
	local var3 = {}

	for iter0, iter1 in ipairs(arg0.userShips) do
		if var0.id == iter1.uid then
			local var4 = var2:getShipById(iter1.id)

			if var4 then
				var4.id = GuildAssaultFleet.GetVirtualId(var0.id, var4.id)

				local var5 = GuildBossMissionShip.New(var4)

				table.insert(var3, {
					member = var0,
					ship = var5
				})
			end
		else
			local var6 = var1:getMemberById(iter1.uid)
			local var7 = var6 and var6:GetAssaultFleet()
			local var8 = var7 and var7:GetShipByRealId(iter1.uid, iter1.id)

			if var8 then
				local var9 = GuildBossMissionShip.New(var8)

				table.insert(var3, {
					member = var6,
					ship = var9
				})
			end
		end
	end

	return var3
end

function var0.GetDownloadResShips(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = arg0:GetShips()
	local var2 = {}

	for iter0, iter1 in pairs(var1) do
		if iter1.member.id ~= var0.id then
			table.insert(var2, iter1.ship:getPainting())
		end
	end

	return var2
end

function var0.GetTeamTypeShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:GetShips()) do
		local var1 = iter1.ship

		if var1:getTeamType() == arg1 then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.ExistSubShip(arg0)
	return #arg0:GetTeamTypeShips(TeamType.Submarine) > 0
end

function var0.RemoveAll(arg0)
	arg0.userShips = {}
end

function var0.IsMainFleet(arg0)
	return arg0.id == 1
end

function var0.ExistUserShip(arg0, arg1)
	return _.any(arg0.userShips, function(arg0)
		return arg0.uid == arg1
	end)
end

function var0.ContainShip(arg0, arg1, arg2)
	return _.any(arg0.userShips, function(arg0)
		return arg0.uid == arg1 and arg0.id == arg2
	end)
end

function var0.RemoveUserShip(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.userShips) do
		if iter1.uid == arg1 and iter1.id == arg2 then
			table.remove(arg0.userShips, iter0)

			return iter0
		end
	end
end

function var0.AddUserShip(arg0, arg1, arg2, arg3)
	if arg3 then
		table.insert(arg0.userShips, arg3, {
			uid = arg1,
			id = arg2
		})
	else
		table.insert(arg0.userShips, {
			uid = arg1,
			id = arg2
		})
	end
end

function var0.GetOtherMemberShipCnt(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.userShips) do
		if iter1.uid ~= arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.ExistSameKindShip(arg0, arg1)
	local var0 = arg0:GetShips()

	for iter0, iter1 in pairs(var0) do
		if iter1.ship:isSameKind(arg1) then
			return true
		end
	end

	return false
end

function var0.IsLegal(arg0)
	local var0 = arg0:GetShips()
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = 0
	local var5 = 0
	local var6 = 0
	local var7 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(var0) do
		if iter1 and iter1.ship:getTeamType() == TeamType.Main then
			var1 = var1 + 1

			if iter1.member.id == var7 then
				var4 = var4 + 1
			end
		elseif iter1 and iter1.ship:getTeamType() == TeamType.Vanguard then
			var2 = var2 + 1

			if iter1.member.id == var7 then
				var5 = var5 + 1
			end
		elseif iter1 and iter1.ship:getTeamType() == TeamType.Submarine then
			var3 = var3 + 1

			if iter1.member.id == var7 then
				var6 = var6 + 1
			end
		end

		local var8 = GuildAssaultFleet.GetRealId(iter1.ship.id)

		if pg.ShipFlagMgr.GetInstance():GetShipFlag(var8, "inEvent") then
			return false, i18n("guild_boss_formation_exist_event_ship", iter1.ship:getConfig("name"))
		end
	end

	if var1 > 3 or var2 > 3 or var3 > 3 then
		return false, i18n("guild_boss_fleet_cnt_invaild")
	end

	local var9 = var5 > 0 and var4 > 0
	local var10

	if var1 > 0 and var2 > 0 and not var9 then
		var10 = i18n("guild_boss_formation_not_exist_self_ship")
	else
		var10 = i18n("guild_fleet_is_legal")
	end

	if arg0:IsMainFleet() then
		return var1 > 0 and var2 > 0 and var9, var10
	else
		return true
	end
end

function var0.ResortShips(arg0, arg1)
	local function var0(arg0)
		local var0 = GuildAssaultFleet.GetVirtualId(arg0.uid, arg0.id)

		for iter0, iter1 in ipairs(arg1) do
			if var0 == iter1.shipId then
				return iter0
			end
		end

		return 0
	end

	table.sort(arg0.userShips, function(arg0, arg1)
		return var0(arg0) < var0(arg1)
	end)
end

function var0.UpdateCommander(arg0, arg1)
	arg0.commanders = arg1
	arg0.skills = {}

	arg0:updateCommanderSkills()
end

function var0.ClearCommanders(arg0)
	for iter0, iter1 in pairs(arg0.commanders) do
		arg0:RemoveCommander(iter0)
	end
end

function var0.getCommanders(arg0)
	return arg0.commanders
end

function var0.AddCommander(arg0, arg1, arg2)
	arg0.commanders[arg1] = arg2
	arg0.skills = {}

	arg0:updateCommanderSkills()
end

function var0.RemoveCommander(arg0, arg1)
	arg0.commanders[arg1] = nil
	arg0.skills = {}

	arg0:updateCommanderSkills()
end

function var0.GetCommanderPos(arg0, arg1)
	for iter0, iter1 in pairs(arg0.commanders) do
		if iter1.id == arg1 then
			return iter0
		end
	end

	return false
end

function var0.updateCommanderSkills(arg0)
	local var0 = #arg0.skills

	while var0 > 0 do
		local var1 = arg0.skills[var0]

		if not arg0:findCommanderBySkillId(var1.id) and var1:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0.skills, var0)
		end

		var0 = var0 - 1
	end

	local var2 = arg0:getCommanders()

	for iter0, iter1 in pairs(var2) do
		for iter2, iter3 in ipairs(iter1:getSkills()) do
			for iter4, iter5 in ipairs(iter3:getTacticSkill()) do
				table.insert(arg0.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5))
			end
		end
	end
end

function var0.findSkills(arg0, arg1)
	return _.filter(arg0:getSkills(), function(arg0)
		return arg0:GetType() == arg1
	end)
end

function var0.findCommanderBySkillId(arg0, arg1)
	local var0 = arg0:getCommanders()

	for iter0, iter1 in pairs(var0) do
		if _.any(iter1:getSkills(), function(arg0)
			return _.any(arg0:getTacticSkill(), function(arg0)
				return arg0 == arg1
			end)
		end) then
			return iter1
		end
	end
end

function var0.getSkills(arg0)
	return arg0.skills or {}
end

function var0.getFleetType(arg0)
	if arg0.id == GuildBossMission.MAIN_FLEET_ID then
		return FleetType.Normal
	elseif arg0.id == GuildBossMission.SUB_FLEET_ID then
		return FleetType.Submarine
	end

	assert(false, arg0.id)
end

function var0.BuildBattleBuffList(arg0)
	local var0 = {}
	local var1, var2 = FleetSkill.GuildBossTriggerSkill(arg0, FleetSkill.TypeBattleBuff)

	if var1 and #var1 > 0 then
		local var3 = {}

		for iter0, iter1 in ipairs(var1) do
			local var4 = var2[iter0]
			local var5 = arg0:findCommanderBySkillId(var4.id)

			var3[var5] = var3[var5] or {}

			table.insert(var3[var5], iter1)
		end

		for iter2, iter3 in pairs(var3) do
			table.insert(var0, {
				iter2,
				iter3
			})
		end
	end

	local var6 = arg0:getCommanders()

	for iter4, iter5 in pairs(var6) do
		local var7 = iter5:getTalents()

		for iter6, iter7 in ipairs(var7) do
			local var8 = iter7:getBuffsAddition()

			if #var8 > 0 then
				local var9

				for iter8, iter9 in ipairs(var0) do
					if iter9[1] == iter5 then
						var9 = iter9[2]

						break
					end
				end

				if not var9 then
					var9 = {}

					table.insert(var0, {
						iter5,
						var9
					})
				end

				for iter10, iter11 in ipairs(var8) do
					table.insert(var9, iter11)
				end
			end
		end
	end

	return var0
end

function var0.ExistCommander(arg0, arg1)
	local var0 = arg0:getCommanders()

	for iter0, iter1 in pairs(var0) do
		if iter1.id == arg1 then
			return true
		end
	end

	return false
end

function var0.ExistInvaildCommanders(arg0)
	if #arg0.invaildCommanders > 0 then
		return true
	end

	local var0 = arg0:getCommanders()
	local var1 = getProxy(CommanderProxy)

	for iter0, iter1 in pairs(var0) do
		if not var1:getCommanderById(iter1.id) then
			return true
		end
	end

	return false
end

function var0.RemoveInvaildCommanders(arg0)
	local var0 = arg0:getCommanders()
	local var1 = getProxy(CommanderProxy)

	for iter0, iter1 in pairs(var0) do
		if not var1:getCommanderById(iter1.id) then
			arg0:RemoveCommander(iter0)
		end
	end

	arg0.invaildCommanders = {}
end

function var0.getCommandersAddition(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(CommanderConst.PROPERTIES) do
		local var1 = 0

		for iter2, iter3 in pairs(arg0:getCommanders()) do
			var1 = var1 + iter3:getAbilitysAddition()[iter1]
		end

		if var1 > 0 then
			table.insert(var0, {
				attrName = iter1,
				value = var1
			})
		end
	end

	return var0
end

function var0.getCommandersTalentDesc(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getCommanders()) do
		local var1 = iter1:getTalentsDesc()

		for iter2, iter3 in pairs(var1) do
			if var0[iter2] then
				var0[iter2].value = var0[iter2].value + iter3.value
			else
				var0[iter2] = {
					name = iter2,
					value = iter3.value,
					type = iter3.type
				}
			end
		end
	end

	return var0
end

function var0.ExistAnyCommander(arg0)
	local var0 = arg0:getCommanders()

	return table.getCount(var0) ~= 0
end

return var0
