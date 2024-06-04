ys = ys or {}

local var0 = ys.Battle.BattleConfig
local var1 = ys.Battle.BattleAttr
local var2 = ys.Battle.BattleFormulas
local var3 = {}

ys.Battle.BattleTargetChoise = var3

function var3.TargetNil()
	return nil
end

function var3.TargetNull()
	return {}
end

function var3.TargetAll()
	return ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
end

function var3.TargetEntityUnit()
	local var0 = {}
	local var1 = ys.Battle.BattleDataProxy.GetInstance():GetUnitList()

	for iter0, iter1 in pairs(var1) do
		if not iter1:IsSpectre() then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var3.TargetSpectreUnit(arg0, arg1, arg2)
	local var0 = {}
	local var1 = ys.Battle.BattleDataProxy.GetInstance():GetSpectreShipList()

	for iter0, iter1 in pairs(var1) do
		var0[#var0 + 1] = iter1
	end

	return var0
end

function var3.TargetTemplate(arg0, arg1, arg2)
	local var0 = arg1.targetTemplateIDList or {
		arg1.targetTemplateID
	}
	local var1 = arg2 or var3.TargetEntityUnit()
	local var2 = {}
	local var3 = arg0:GetIFF()

	for iter0, iter1 in pairs(var1) do
		local var4 = iter1:GetTemplateID()
		local var5 = iter1:GetIFF()

		if table.contains(var0, var4) and var3 == var5 then
			var2[#var2 + 1] = iter1
		end
	end

	return var2
end

function var3.TargetNationality(arg0, arg1, arg2)
	if not arg1.targetTemplateIDList then
		({})[1] = arg1.targetTemplateID
	end

	local var0 = arg2 or ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
	local var1 = {}
	local var2 = arg1.nationality
	local var3 = type(var2)

	for iter0, iter1 in pairs(var0) do
		if var3 == "number" then
			if iter1:GetTemplate().nationality == var2 then
				var1[#var1 + 1] = iter1
			end
		elseif var3 == "table" and table.contains(var2, iter1:GetTemplate().nationality) then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetShipType(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = {}
	local var2 = arg1.ship_type_list

	for iter0, iter1 in pairs(var0) do
		local var3 = iter1:GetTemplate().type

		if table.contains(var2, var3) then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetShipTag(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = {}
	local var2 = arg1.ship_tag_list

	for iter0, iter1 in pairs(var0) do
		if iter1:ContainsLabelTag(var2) then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetShipArmor(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = {}
	local var2 = arg1.armor_type

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetAttrByName("armorType") == var2 then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.getShipListByIFF(arg0)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1

	if arg0 == var0.FRIENDLY_CODE then
		var1 = var0:GetFriendlyShipList()
	elseif arg0 == var0.FOE_CODE then
		var1 = var0:GetFoeShipList()
	end

	return var1
end

function var3.TargetAllHelp(arg0, arg1, arg2)
	local var0 = {}

	if arg0 then
		arg1 = arg1 or {}

		local var1 = arg1.exceptCaster
		local var2 = arg0:GetUniqueID()
		local var3 = arg0:GetIFF()
		local var4 = arg2 or var3.getShipListByIFF(var3)

		for iter0, iter1 in pairs(var4) do
			local var5 = iter1:GetUniqueID()

			if iter1:IsAlive() and iter1:GetIFF() == var3 and (not var1 or var5 ~= var2) then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetHelpLeastHP(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0
	local var1 = arg1.targetMaxHPRatio

	if arg0 then
		local var2 = arg2 or var3.getShipListByIFF(arg0:GetIFF())
		local var3 = 9999999999

		for iter0, iter1 in pairs(var2) do
			if iter1:IsAlive() and var3 > iter1:GetCurrentHP() and (not var1 or var1 >= iter1:GetHPRate()) then
				var0 = iter1
				var3 = iter1:GetCurrentHP()
			end
		end
	end

	return {
		var0
	}
end

function var3.TargetHelpLeastHPRatio(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0

	if arg0 then
		local var1 = 100
		local var2 = arg2 or var3.getShipListByIFF(arg0:GetIFF())

		for iter0, iter1 in pairs(var2) do
			if iter1:IsAlive() and var1 > iter1:GetHPRate() then
				var0 = iter1
				var1 = iter1:GetHPRate()
			end
		end
	end

	return {
		var0
	}
end

function var3.TargetHighestHP(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0

	if arg0 then
		local var1 = arg2 or var3.TargetEntityUnit()
		local var2 = 1

		for iter0, iter1 in pairs(var1) do
			if iter1:IsAlive() and var2 < iter1:GetCurrentHP() then
				var0 = iter1
				var2 = iter1:GetCurrentHP()
			end
		end
	end

	return {
		var0
	}
end

function var3.TargetLowestHPRatio(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0
	local var1 = arg2 or var3.TargetEntityUnit()
	local var2 = 1

	for iter0, iter1 in pairs(var1) do
		local var3 = iter1:GetHPRate()

		if iter1:IsAlive() and var3 < var2 and var3 > 0 then
			var0 = iter1
			var2 = var3
		end
	end

	return {
		var0
	}
end

function var3.TargetLowestHP(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0
	local var1 = arg2 or var3.TargetEntityUnit()
	local var2 = 9999999999

	for iter0, iter1 in pairs(var1) do
		local var3 = iter1:GetCurrentHP()

		if iter1:IsAlive() and var3 < var2 and var3 > 0 then
			var0 = iter1
			var2 = var3
		end
	end

	return {
		var0
	}
end

function var3.TargetHighestHPRatio(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0
	local var1 = arg2 or var3.TargetEntityUnit()
	local var2 = 0

	for iter0, iter1 in pairs(var1) do
		if iter1:IsAlive() and var2 < iter1:GetHPRate() then
			var0 = iter1
			var2 = iter1:GetHPRate()
		end
	end

	return {
		var0
	}
end

function var3.TargetAttrCompare(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg2 or var3.TargetEntityUnit()

	for iter0, iter1 in pairs(var1) do
		if iter1:IsAlive() and var2.parseCompareUnitAttr(arg1.attrCompare, iter1, arg0) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var3.TargetTempCompare(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg2 or var3.TargetEntityUnit()

	for iter0, iter1 in pairs(var1) do
		if iter1:IsAlive() and var2.parseCompareUnitTemplate(arg1.tempCompare, iter1, arg0) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var3.TargetHPCompare(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg2 or var3.TargetEntityUnit()

	if arg0 then
		local var2 = arg0:GetHP()

		for iter0, iter1 in ipairs(var1) do
			if var2 > iter1:GetHP() then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetHPRatioLowerThan(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1.hpRatioList[1]
	local var2 = arg2 or var3.TargetEntityUnit()

	for iter0, iter1 in ipairs(var2) do
		if var1 > iter1:GetHP() then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var3.TargetNationalityFriendly(arg0, arg1, arg2)
	local var0 = {}

	if arg0 then
		local var1 = arg1.nationality
		local var2 = arg2 or var3.TargetAllHelp(arg0, arg1)

		for iter0, iter1 in pairs(var2) do
			if iter1:GetTemplate().nationality == var1 then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetNationalityFoe(arg0, arg1, arg2)
	local var0 = {}

	if arg0 then
		local var1 = arg1.nationality
		local var2 = arg2 or var3.TargetAllHarm(arg0, arg1)

		for iter0, iter1 in pairs(var2) do
			if iter1:GetTemplate().nationality == var1 then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetShipTypeFriendly(arg0, arg1, arg2)
	local var0 = {}

	if arg0 then
		local var1 = arg1.ship_type_list
		local var2 = arg2 or var3.TargetAllHelp(arg0, arg1)

		for iter0, iter1 in pairs(var2) do
			local var3 = iter1:GetTemplate().type

			if table.contains(var1, var3) then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetSelf(arg0)
	return {
		arg0
	}
end

function var3.TargetAllHarm(arg0, arg1, arg2)
	local var0 = {}
	local var1
	local var2 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2 then
		var1 = arg2
	else
		local var3 = arg0:GetIFF()

		if var3 == var0.FRIENDLY_CODE then
			var1 = var2:GetFoeShipList()
		elseif var3 == var0.FOE_CODE then
			var1 = var2:GetFriendlyShipList()
		end
	end

	local var4, var5, var6, var7 = var2:GetFieldBound()

	if var1 then
		for iter0, iter1 in pairs(var1) do
			if iter1:IsAlive() and var7 > iter1:GetPosition().x and iter1:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetAllFoe(arg0, arg1, arg2)
	local var0 = {}
	local var1
	local var2 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2 then
		var1 = arg2
	else
		local var3 = arg0:GetIFF()

		if var3 == var0.FRIENDLY_CODE then
			var1 = var2:GetFoeShipList()
		elseif var3 == var0.FOE_CODE then
			var1 = var2:GetFriendlyShipList()
		end
	end

	local var4, var5, var6, var7 = var2:GetFieldBound()

	if var1 then
		for iter0, iter1 in pairs(var1) do
			if iter1:IsAlive() and var7 > iter1:GetPosition().x then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetFoeUncloak(arg0, arg1, arg2)
	local var0 = {}
	local var1
	local var2 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2 then
		var1 = arg2
	else
		local var3 = arg0:GetIFF()

		if var3 == var0.FRIENDLY_CODE then
			var1 = var2:GetFoeShipList()
		elseif var3 == var0.FOE_CODE then
			var1 = var2:GetFriendlyShipList()
		end
	end

	local var4, var5, var6, var7 = var2:GetFieldBound()

	if var1 then
		for iter0, iter1 in pairs(var1) do
			if iter1:IsAlive() and var7 > iter1:GetPosition().x and not var1.IsCloak(iter1) and iter1:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0[#var0 + 1] = iter1
			end
		end
	end

	return var0
end

function var3.TargetCloakState(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1.cloak or 1
	local var2 = arg2 or var3.TargetEntityUnit()

	for iter0, iter1 in ipairs(var2) do
		if var1.GetCurrent(iter1, "isCloak") == var1 then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var3.TargetFaintState(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1.faint or 1
	local var2 = arg2 or var3.TargetEntityUnit()

	for iter0, iter1 in ipairs(var2) do
		local var3 = iter1:GetAimBias()

		if var1 == 1 then
			if var3 and var3:IsFaint() then
				var0[#var0 + 1] = iter1
			end
		elseif var1 == 0 and (not var3 or not var3:IsFaint()) then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var3.TargetHarmNearest(arg0, arg1, arg2)
	arg1 = arg1 or {}

	local var0 = arg1.range or 9999999999
	local var1
	local var2 = arg2 or var3.TargetFoeUncloak(arg0)

	for iter0, iter1 in ipairs(var2) do
		local var3 = arg0:GetDistance(iter1)

		if var3 < var0 then
			var0 = var3
			var1 = iter1
		end
	end

	return {
		var1
	}
end

function var3.TargetHarmFarthest(arg0, arg1, arg2)
	local var0 = 0
	local var1
	local var2 = arg2 or var3.TargetFoeUncloak(arg0)

	for iter0, iter1 in ipairs(var2) do
		local var3 = arg0:GetDistance(iter1)

		if var0 < var3 then
			var0 = var3
			var1 = iter1
		end
	end

	return {
		var1
	}
end

function var3.TargetHarmRandom(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetFoeUncloak(arg0)

	if #var0 > 0 then
		local var1 = math.random(#var0)

		return {
			var0[var1]
		}
	else
		return {}
	end
end

function var3.TargetHarmRandomByWeight(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetFoeUncloak(arg0)
	local var1 = {}
	local var2 = -9999

	for iter0, iter1 in ipairs(var0) do
		local var3 = iter1:GetTargetedPriority() or 0

		if var3 == var2 then
			var1[#var1 + 1] = iter1
		elseif var2 < var3 then
			var1 = {
				iter1
			}
			var2 = var3
		end
	end

	if #var1 > 0 then
		local var4 = math.random(#var1)

		return {
			var1[var4]
		}
	else
		return {}
	end
end

function var3.TargetWeightiest(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = {}
	local var2 = -9999

	for iter0, iter1 in ipairs(var0) do
		local var3 = iter1:GetTargetedPriority() or 0

		if var3 == var2 then
			var1[#var1 + 1] = iter1
		elseif var2 < var3 then
			var1 = {
				iter1
			}
			var2 = var3
		end
	end

	return var1
end

function var3.TargetRandom(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = arg1.randomCount or 1

	return (Mathf.MultiRandom(var0, var1))
end

function var3.TargetInsideArea(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetAllHarm(arg0)
	local var1 = arg1.dir or ys.Battle.BattleConst.UnitDir.RIGHT
	local var2 = arg1.lineX
	local var3 = {}

	if var1 == ys.Battle.BattleConst.UnitDir.RIGHT then
		for iter0, iter1 in ipairs(var0) do
			if var2 <= iter1:GetPosition().x then
				table.insert(var3, iter1)
			end
		end
	elseif var1 == ys.Battle.BattleConst.UnitDir.LEFT then
		for iter2, iter3 in ipairs(var0) do
			if var2 >= iter3:GetPosition().x then
				table.insert(var3, iter3)
			end
		end
	end

	return var3
end

function var3.TargetAircraftHelp(arg0)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1 = {}
	local var2 = arg0:GetIFF()

	for iter0, iter1 in pairs(var0:GetAircraftList()) do
		if var2 == iter1:GetIFF() then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetAircraftHarm(arg0)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1 = {}
	local var2 = arg0:GetIFF()

	for iter0, iter1 in pairs(var0:GetAircraftList()) do
		if var2 ~= iter1:GetIFF() and iter1:IsVisitable() then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetAircraftGB(arg0)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1 = {}
	local var2 = arg0:GetIFF()

	for iter0, iter1 in pairs(var0:GetAircraftList()) do
		if var2 ~= iter1:GetIFF() and iter1:IsVisitable() and iter1:GetMotherUnit() == nil then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetDiveState(arg0, arg1, arg2)
	local var0 = arg1 and arg1.diveState or ys.Battle.BattleConst.OXY_STATE.DIVE
	local var1 = arg2 or var3.TargetEntityUnit()
	local var2 = {}

	for iter0, iter1 in pairs(var1) do
		if var0 == iter1:GetCurrentOxyState() then
			var2[#var2 + 1] = iter1
		end
	end

	return var2
end

function var3.TargetDetectedUnit(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetEntityUnit()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1:GetDiveDetected() then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetAllHarmBullet(arg0)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1 = {}
	local var2 = arg0:GetIFF()

	for iter0, iter1 in pairs(var0:GetBulletList()) do
		if var2 ~= iter1:GetIFF() then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetAllHarmBulletByType(arg0, arg1)
	local var0 = ys.Battle.BattleDataProxy.GetInstance()
	local var1 = {}
	local var2 = arg0:GetIFF()

	for iter0, iter1 in pairs(var0:GetBulletList()) do
		if var2 ~= iter1:GetIFF() and iter1:GetType() == arg1 then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetAllHarmTorpedoBullet(arg0)
	return var3.TargetAllHarmBulletByType(arg0, ys.Battle.BattleConst.BulletType.TORPEDO)
end

function var3.TargetFleetIndex(arg0, arg1)
	local var0

	if arg0 then
		var0 = arg0:GetIFF()
	else
		var0 = var0.FRIENDLY_CODE
	end

	local var1 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0)
	local var2 = TeamType.TeamPos
	local var3 = arg1.fleetPos
	local var4 = {}
	local var5 = var1:GetUnitList()
	local var6 = var1:GetScoutList()
	local var7 = arg1.exceptCaster

	if var7 then
		local var8 = arg0:GetUniqueID()
	end

	for iter0, iter1 in ipairs(var5) do
		local var9 = iter1:GetUniqueID()

		if var7 and var9 == casterID then
			-- block empty
		elseif iter1 == var1:GetFlagShip() then
			if var3 == var2.FLAG_SHIP then
				table.insert(var4, iter1)
			end
		elseif iter1 == var6[1] then
			if var3 == var2.LEADER then
				table.insert(var4, iter1)
			end
		elseif #var6 == 3 and iter1 == var6[2] then
			if var3 == var2.CENTER then
				table.insert(var4, iter1)
			end
		elseif iter1 == var6[#var6] then
			if var3 == var2.REAR then
				table.insert(var4, iter1)
			end
		elseif iter1:IsMainFleetUnit() and iter1:GetMainUnitIndex() == 2 then
			if var3 == var2.UPPER_CONSORT then
				table.insert(var4, iter1)
			end
		elseif iter1:IsMainFleetUnit() and iter1:GetMainUnitIndex() == 3 and var3 == var2.LOWER_CONSORT then
			table.insert(var4, iter1)
		end
	end

	local var10 = var1:GetSubList()

	for iter2, iter3 in ipairs(var5) do
		if iter2 == 1 then
			if var3 == var2.SUB_LEADER then
				table.insert(var4, iter3)
			end
		elseif var3 == var2.SUB_CONSORT then
			table.insert(var4, iter3)
		end
	end

	return var4
end

function var3.TargetPlayerVanguardFleet(arg0, arg1, arg2)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF()):GetScoutList()

	if not arg2 then
		return var0
	else
		local var1 = #arg2

		while var1 > 0 do
			if not table.contains(var0, arg2[var1]) then
				table.remove(arg2, var1)
			end

			var1 = var1 - 1
		end

		return arg2
	end
end

function var3.TargetPlayerMainFleet(arg0, arg1, arg2)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF()):GetMainList()

	if not arg2 then
		return var0
	else
		local var1 = #arg2

		while var1 > 0 do
			if not table.contains(var0, arg2[var1]) then
				table.remove(arg2, var1)
			end

			var1 = var1 - 1
		end

		return arg2
	end
end

function var3.TargetPlayerFlagShip(arg0, arg1, arg2)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF())

	return {
		var0:GetFlagShip()
	}
end

function var3.TargetPlayerLeaderShip(arg0, arg1, arg2)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF())

	return {
		var0:GetLeaderShip()
	}
end

function var3.TargetPlayerByType(arg0, arg1)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF()):GetUnitList()
	local var1 = {}
	local var2 = arg1.shipType

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetTemplate().type == var2 then
			var1[#var1 + 1] = iter1
		end
	end

	return var1
end

function var3.TargetPlayerAidUnit(arg0, arg1)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetAidUnit()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var1, iter1)
	end

	return var1
end

function var3.TargetDamageSource(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetAllFoe(arg0)
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1:GetUniqueID() == arg1.damageSourceID then
			table.insert(var1, iter1)

			break
		end
	end

	return var1
end

function var3.TargetRarity(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetAllHelp(arg0)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetRarity() == arg1.rarity then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var3.TargetIllustrator(arg0, arg1, arg2)
	local var0 = arg2 or var3.TargetAllHelp(arg0)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if ys.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(iter1:GetSkinID()).illustrator == arg1.illustrator then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var3.TargetTeam(arg0, arg1, arg2)
	local var0 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0:GetIFF())
	local var1 = {}
	local var2 = TeamType.TeamTypeIndex[arg1.teamIndex]

	if var2 == TeamType.Vanguard then
		var1 = var0:GetScoutList()
	elseif var2 == TeamType.Main then
		var1 = var0:GetMainList()
	elseif var2 == TeamType.Submarine then
		var1 = var0:GetSubList()
	end

	local var3 = {}

	for iter0, iter1 in ipairs(var1) do
		if not arg2 or table.contains(arg2, iter1) then
			table.insert(var3, iter1)
		end
	end

	return var3
end

function var3.TargetGroup(arg0, arg1, arg2)
	local var0 = arg1.groupIDList
	local var1 = arg2 or var3.TargetAllHelp(arg0)
	local var2 = {}
	local var3 = arg0:GetIFF()

	for iter0, iter1 in ipairs(var1) do
		local var4 = iter1:GetTemplateID()
		local var5 = ys.Battle.BattleDataFunction.GetPlayerShipModelFromID(var4).group_type
		local var6 = iter1:GetIFF()

		if table.contains(var0, var5) and var3 == var6 then
			var2[#var2 + 1] = iter1
		end
	end

	return var2
end

function var3.LegalTarget(arg0)
	local var0 = {}
	local var1
	local var2 = ys.Battle.BattleDataProxy.GetInstance()
	local var3, var4, var5, var6 = var2:GetFieldBound()
	local var7 = var2:GetUnitList()
	local var8 = arg0:GetIFF()

	for iter0, iter1 in pairs(var7) do
		if iter1:IsAlive() and iter1:GetIFF() ~= var8 and var6 > iter1:GetPosition().x and not iter1:IsSpectre() then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var3.LegalWeaponTarget(arg0)
	local var0 = {}
	local var1
	local var2 = ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
	local var3 = arg0:GetIFF()

	for iter0, iter1 in pairs(var2) do
		if iter1:GetIFF() ~= var3 and not iter1:IsSpectre() then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end
