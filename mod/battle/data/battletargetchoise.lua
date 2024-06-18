ys = ys or {}

local var0_0 = ys.Battle.BattleConfig
local var1_0 = ys.Battle.BattleAttr
local var2_0 = ys.Battle.BattleFormulas
local var3_0 = {}

ys.Battle.BattleTargetChoise = var3_0

function var3_0.TargetNil()
	return nil
end

function var3_0.TargetNull()
	return {}
end

function var3_0.TargetAll()
	return ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
end

function var3_0.TargetEntityUnit()
	local var0_4 = {}
	local var1_4 = ys.Battle.BattleDataProxy.GetInstance():GetUnitList()

	for iter0_4, iter1_4 in pairs(var1_4) do
		if not iter1_4:IsSpectre() then
			var0_4[#var0_4 + 1] = iter1_4
		end
	end

	return var0_4
end

function var3_0.TargetSpectreUnit(arg0_5, arg1_5, arg2_5)
	local var0_5 = {}
	local var1_5 = ys.Battle.BattleDataProxy.GetInstance():GetSpectreShipList()

	for iter0_5, iter1_5 in pairs(var1_5) do
		var0_5[#var0_5 + 1] = iter1_5
	end

	return var0_5
end

function var3_0.TargetTemplate(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6.targetTemplateIDList or {
		arg1_6.targetTemplateID
	}
	local var1_6 = arg2_6 or var3_0.TargetEntityUnit()
	local var2_6 = {}
	local var3_6 = arg0_6:GetIFF()

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var4_6 = iter1_6:GetTemplateID()
		local var5_6 = iter1_6:GetIFF()

		if table.contains(var0_6, var4_6) and var3_6 == var5_6 then
			var2_6[#var2_6 + 1] = iter1_6
		end
	end

	return var2_6
end

function var3_0.TargetNationality(arg0_7, arg1_7, arg2_7)
	if not arg1_7.targetTemplateIDList then
		({})[1] = arg1_7.targetTemplateID
	end

	local var0_7 = arg2_7 or ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
	local var1_7 = {}
	local var2_7 = arg1_7.nationality
	local var3_7 = type(var2_7)

	for iter0_7, iter1_7 in pairs(var0_7) do
		if var3_7 == "number" then
			if iter1_7:GetTemplate().nationality == var2_7 then
				var1_7[#var1_7 + 1] = iter1_7
			end
		elseif var3_7 == "table" and table.contains(var2_7, iter1_7:GetTemplate().nationality) then
			var1_7[#var1_7 + 1] = iter1_7
		end
	end

	return var1_7
end

function var3_0.TargetShipType(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg2_8 or var3_0.TargetEntityUnit()
	local var1_8 = {}
	local var2_8 = arg1_8.ship_type_list

	for iter0_8, iter1_8 in pairs(var0_8) do
		local var3_8 = iter1_8:GetTemplate().type

		if table.contains(var2_8, var3_8) then
			var1_8[#var1_8 + 1] = iter1_8
		end
	end

	return var1_8
end

function var3_0.TargetShipTag(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg2_9 or var3_0.TargetEntityUnit()
	local var1_9 = {}
	local var2_9 = arg1_9.ship_tag_list

	for iter0_9, iter1_9 in pairs(var0_9) do
		if iter1_9:ContainsLabelTag(var2_9) then
			var1_9[#var1_9 + 1] = iter1_9
		end
	end

	return var1_9
end

function var3_0.TargetShipArmor(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg2_10 or var3_0.TargetEntityUnit()
	local var1_10 = {}
	local var2_10 = arg1_10.armor_type

	for iter0_10, iter1_10 in ipairs(var0_10) do
		if iter1_10:GetAttrByName("armorType") == var2_10 then
			var1_10[#var1_10 + 1] = iter1_10
		end
	end

	return var1_10
end

function var3_0.getShipListByIFF(arg0_11)
	local var0_11 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_11

	if arg0_11 == var0_0.FRIENDLY_CODE then
		var1_11 = var0_11:GetFriendlyShipList()
	elseif arg0_11 == var0_0.FOE_CODE then
		var1_11 = var0_11:GetFoeShipList()
	end

	return var1_11
end

function var3_0.TargetAllHelp(arg0_12, arg1_12, arg2_12)
	local var0_12 = {}

	if arg0_12 then
		arg1_12 = arg1_12 or {}

		local var1_12 = arg1_12.exceptCaster
		local var2_12 = arg0_12:GetUniqueID()
		local var3_12 = arg0_12:GetIFF()
		local var4_12 = arg2_12 or var3_0.getShipListByIFF(var3_12)

		for iter0_12, iter1_12 in pairs(var4_12) do
			local var5_12 = iter1_12:GetUniqueID()

			if iter1_12:IsAlive() and iter1_12:GetIFF() == var3_12 and (not var1_12 or var5_12 ~= var2_12) then
				var0_12[#var0_12 + 1] = iter1_12
			end
		end
	end

	return var0_12
end

function var3_0.TargetHelpLeastHP(arg0_13, arg1_13, arg2_13)
	arg1_13 = arg1_13 or {}

	local var0_13
	local var1_13 = arg1_13.targetMaxHPRatio

	if arg0_13 then
		local var2_13 = arg2_13 or var3_0.getShipListByIFF(arg0_13:GetIFF())
		local var3_13 = 9999999999

		for iter0_13, iter1_13 in pairs(var2_13) do
			if iter1_13:IsAlive() and var3_13 > iter1_13:GetCurrentHP() and (not var1_13 or var1_13 >= iter1_13:GetHPRate()) then
				var0_13 = iter1_13
				var3_13 = iter1_13:GetCurrentHP()
			end
		end
	end

	return {
		var0_13
	}
end

function var3_0.TargetHelpLeastHPRatio(arg0_14, arg1_14, arg2_14)
	arg1_14 = arg1_14 or {}

	local var0_14

	if arg0_14 then
		local var1_14 = 100
		local var2_14 = arg2_14 or var3_0.getShipListByIFF(arg0_14:GetIFF())

		for iter0_14, iter1_14 in pairs(var2_14) do
			if iter1_14:IsAlive() and var1_14 > iter1_14:GetHPRate() then
				var0_14 = iter1_14
				var1_14 = iter1_14:GetHPRate()
			end
		end
	end

	return {
		var0_14
	}
end

function var3_0.TargetHighestHP(arg0_15, arg1_15, arg2_15)
	arg1_15 = arg1_15 or {}

	local var0_15

	if arg0_15 then
		local var1_15 = arg2_15 or var3_0.TargetEntityUnit()
		local var2_15 = 1

		for iter0_15, iter1_15 in pairs(var1_15) do
			if iter1_15:IsAlive() and var2_15 < iter1_15:GetCurrentHP() then
				var0_15 = iter1_15
				var2_15 = iter1_15:GetCurrentHP()
			end
		end
	end

	return {
		var0_15
	}
end

function var3_0.TargetLowestHPRatio(arg0_16, arg1_16, arg2_16)
	arg1_16 = arg1_16 or {}

	local var0_16
	local var1_16 = arg2_16 or var3_0.TargetEntityUnit()
	local var2_16 = 1

	for iter0_16, iter1_16 in pairs(var1_16) do
		local var3_16 = iter1_16:GetHPRate()

		if iter1_16:IsAlive() and var3_16 < var2_16 and var3_16 > 0 then
			var0_16 = iter1_16
			var2_16 = var3_16
		end
	end

	return {
		var0_16
	}
end

function var3_0.TargetLowestHP(arg0_17, arg1_17, arg2_17)
	arg1_17 = arg1_17 or {}

	local var0_17
	local var1_17 = arg2_17 or var3_0.TargetEntityUnit()
	local var2_17 = 9999999999

	for iter0_17, iter1_17 in pairs(var1_17) do
		local var3_17 = iter1_17:GetCurrentHP()

		if iter1_17:IsAlive() and var3_17 < var2_17 and var3_17 > 0 then
			var0_17 = iter1_17
			var2_17 = var3_17
		end
	end

	return {
		var0_17
	}
end

function var3_0.TargetHighestHPRatio(arg0_18, arg1_18, arg2_18)
	arg1_18 = arg1_18 or {}

	local var0_18
	local var1_18 = arg2_18 or var3_0.TargetEntityUnit()
	local var2_18 = 0

	for iter0_18, iter1_18 in pairs(var1_18) do
		if iter1_18:IsAlive() and var2_18 < iter1_18:GetHPRate() then
			var0_18 = iter1_18
			var2_18 = iter1_18:GetHPRate()
		end
	end

	return {
		var0_18
	}
end

function var3_0.TargetAttrCompare(arg0_19, arg1_19, arg2_19)
	local var0_19 = {}
	local var1_19 = arg2_19 or var3_0.TargetEntityUnit()

	for iter0_19, iter1_19 in pairs(var1_19) do
		if iter1_19:IsAlive() and var2_0.parseCompareUnitAttr(arg1_19.attrCompare, iter1_19, arg0_19) then
			table.insert(var0_19, iter1_19)
		end
	end

	return var0_19
end

function var3_0.TargetTempCompare(arg0_20, arg1_20, arg2_20)
	local var0_20 = {}
	local var1_20 = arg2_20 or var3_0.TargetEntityUnit()

	for iter0_20, iter1_20 in pairs(var1_20) do
		if iter1_20:IsAlive() and var2_0.parseCompareUnitTemplate(arg1_20.tempCompare, iter1_20, arg0_20) then
			table.insert(var0_20, iter1_20)
		end
	end

	return var0_20
end

function var3_0.TargetHPCompare(arg0_21, arg1_21, arg2_21)
	local var0_21 = {}
	local var1_21 = arg2_21 or var3_0.TargetEntityUnit()

	if arg0_21 then
		local var2_21 = arg0_21:GetHP()

		for iter0_21, iter1_21 in ipairs(var1_21) do
			if var2_21 > iter1_21:GetHP() then
				var0_21[#var0_21 + 1] = iter1_21
			end
		end
	end

	return var0_21
end

function var3_0.TargetHPRatioLowerThan(arg0_22, arg1_22, arg2_22)
	local var0_22 = {}
	local var1_22 = arg1_22.hpRatioList[1]
	local var2_22 = arg2_22 or var3_0.TargetEntityUnit()

	for iter0_22, iter1_22 in ipairs(var2_22) do
		if var1_22 > iter1_22:GetHP() then
			var0_22[#var0_22 + 1] = iter1_22
		end
	end

	return var0_22
end

function var3_0.TargetNationalityFriendly(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}

	if arg0_23 then
		local var1_23 = arg1_23.nationality
		local var2_23 = arg2_23 or var3_0.TargetAllHelp(arg0_23, arg1_23)

		for iter0_23, iter1_23 in pairs(var2_23) do
			if iter1_23:GetTemplate().nationality == var1_23 then
				var0_23[#var0_23 + 1] = iter1_23
			end
		end
	end

	return var0_23
end

function var3_0.TargetNationalityFoe(arg0_24, arg1_24, arg2_24)
	local var0_24 = {}

	if arg0_24 then
		local var1_24 = arg1_24.nationality
		local var2_24 = arg2_24 or var3_0.TargetAllHarm(arg0_24, arg1_24)

		for iter0_24, iter1_24 in pairs(var2_24) do
			if iter1_24:GetTemplate().nationality == var1_24 then
				var0_24[#var0_24 + 1] = iter1_24
			end
		end
	end

	return var0_24
end

function var3_0.TargetShipTypeFriendly(arg0_25, arg1_25, arg2_25)
	local var0_25 = {}

	if arg0_25 then
		local var1_25 = arg1_25.ship_type_list
		local var2_25 = arg2_25 or var3_0.TargetAllHelp(arg0_25, arg1_25)

		for iter0_25, iter1_25 in pairs(var2_25) do
			local var3_25 = iter1_25:GetTemplate().type

			if table.contains(var1_25, var3_25) then
				var0_25[#var0_25 + 1] = iter1_25
			end
		end
	end

	return var0_25
end

function var3_0.TargetSelf(arg0_26)
	return {
		arg0_26
	}
end

function var3_0.TargetAllHarm(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}
	local var1_27
	local var2_27 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_27 then
		var1_27 = arg2_27
	else
		local var3_27 = arg0_27:GetIFF()

		if var3_27 == var0_0.FRIENDLY_CODE then
			var1_27 = var2_27:GetFoeShipList()
		elseif var3_27 == var0_0.FOE_CODE then
			var1_27 = var2_27:GetFriendlyShipList()
		end
	end

	local var4_27, var5_27, var6_27, var7_27 = var2_27:GetFieldBound()

	if var1_27 then
		for iter0_27, iter1_27 in pairs(var1_27) do
			if iter1_27:IsAlive() and var7_27 > iter1_27:GetPosition().x and iter1_27:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0_27[#var0_27 + 1] = iter1_27
			end
		end
	end

	return var0_27
end

function var3_0.TargetAllFoe(arg0_28, arg1_28, arg2_28)
	local var0_28 = {}
	local var1_28
	local var2_28 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_28 then
		var1_28 = arg2_28
	else
		local var3_28 = arg0_28:GetIFF()

		if var3_28 == var0_0.FRIENDLY_CODE then
			var1_28 = var2_28:GetFoeShipList()
		elseif var3_28 == var0_0.FOE_CODE then
			var1_28 = var2_28:GetFriendlyShipList()
		end
	end

	local var4_28, var5_28, var6_28, var7_28 = var2_28:GetFieldBound()

	if var1_28 then
		for iter0_28, iter1_28 in pairs(var1_28) do
			if iter1_28:IsAlive() and var7_28 > iter1_28:GetPosition().x then
				var0_28[#var0_28 + 1] = iter1_28
			end
		end
	end

	return var0_28
end

function var3_0.TargetFoeUncloak(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}
	local var1_29
	local var2_29 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_29 then
		var1_29 = arg2_29
	else
		local var3_29 = arg0_29:GetIFF()

		if var3_29 == var0_0.FRIENDLY_CODE then
			var1_29 = var2_29:GetFoeShipList()
		elseif var3_29 == var0_0.FOE_CODE then
			var1_29 = var2_29:GetFriendlyShipList()
		end
	end

	local var4_29, var5_29, var6_29, var7_29 = var2_29:GetFieldBound()

	if var1_29 then
		for iter0_29, iter1_29 in pairs(var1_29) do
			if iter1_29:IsAlive() and var7_29 > iter1_29:GetPosition().x and not var1_0.IsCloak(iter1_29) and iter1_29:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0_29[#var0_29 + 1] = iter1_29
			end
		end
	end

	return var0_29
end

function var3_0.TargetCloakState(arg0_30, arg1_30, arg2_30)
	local var0_30 = {}
	local var1_30 = arg1_30.cloak or 1
	local var2_30 = arg2_30 or var3_0.TargetEntityUnit()

	for iter0_30, iter1_30 in ipairs(var2_30) do
		if var1_0.GetCurrent(iter1_30, "isCloak") == var1_30 then
			var0_30[#var0_30 + 1] = iter1_30
		end
	end

	return var0_30
end

function var3_0.TargetFaintState(arg0_31, arg1_31, arg2_31)
	local var0_31 = {}
	local var1_31 = arg1_31.faint or 1
	local var2_31 = arg2_31 or var3_0.TargetEntityUnit()

	for iter0_31, iter1_31 in ipairs(var2_31) do
		local var3_31 = iter1_31:GetAimBias()

		if var1_31 == 1 then
			if var3_31 and var3_31:IsFaint() then
				var0_31[#var0_31 + 1] = iter1_31
			end
		elseif var1_31 == 0 and (not var3_31 or not var3_31:IsFaint()) then
			var0_31[#var0_31 + 1] = iter1_31
		end
	end

	return var0_31
end

function var3_0.TargetHarmNearest(arg0_32, arg1_32, arg2_32)
	arg1_32 = arg1_32 or {}

	local var0_32 = arg1_32.range or 9999999999
	local var1_32
	local var2_32 = arg2_32 or var3_0.TargetFoeUncloak(arg0_32)

	for iter0_32, iter1_32 in ipairs(var2_32) do
		local var3_32 = arg0_32:GetDistance(iter1_32)

		if var3_32 < var0_32 then
			var0_32 = var3_32
			var1_32 = iter1_32
		end
	end

	return {
		var1_32
	}
end

function var3_0.TargetHarmFarthest(arg0_33, arg1_33, arg2_33)
	local var0_33 = 0
	local var1_33
	local var2_33 = arg2_33 or var3_0.TargetFoeUncloak(arg0_33)

	for iter0_33, iter1_33 in ipairs(var2_33) do
		local var3_33 = arg0_33:GetDistance(iter1_33)

		if var0_33 < var3_33 then
			var0_33 = var3_33
			var1_33 = iter1_33
		end
	end

	return {
		var1_33
	}
end

function var3_0.TargetHarmRandom(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg2_34 or var3_0.TargetFoeUncloak(arg0_34)

	if #var0_34 > 0 then
		local var1_34 = math.random(#var0_34)

		return {
			var0_34[var1_34]
		}
	else
		return {}
	end
end

function var3_0.TargetHarmRandomByWeight(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg2_35 or var3_0.TargetFoeUncloak(arg0_35)
	local var1_35 = {}
	local var2_35 = -9999

	for iter0_35, iter1_35 in ipairs(var0_35) do
		local var3_35 = iter1_35:GetTargetedPriority() or 0

		if var3_35 == var2_35 then
			var1_35[#var1_35 + 1] = iter1_35
		elseif var2_35 < var3_35 then
			var1_35 = {
				iter1_35
			}
			var2_35 = var3_35
		end
	end

	if #var1_35 > 0 then
		local var4_35 = math.random(#var1_35)

		return {
			var1_35[var4_35]
		}
	else
		return {}
	end
end

function var3_0.TargetWeightiest(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg2_36 or var3_0.TargetEntityUnit()
	local var1_36 = {}
	local var2_36 = -9999

	for iter0_36, iter1_36 in ipairs(var0_36) do
		local var3_36 = iter1_36:GetTargetedPriority() or 0

		if var3_36 == var2_36 then
			var1_36[#var1_36 + 1] = iter1_36
		elseif var2_36 < var3_36 then
			var1_36 = {
				iter1_36
			}
			var2_36 = var3_36
		end
	end

	return var1_36
end

function var3_0.TargetRandom(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg2_37 or var3_0.TargetEntityUnit()
	local var1_37 = arg1_37.randomCount or 1

	return (Mathf.MultiRandom(var0_37, var1_37))
end

function var3_0.TargetInsideArea(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg2_38 or var3_0.TargetAllHarm(arg0_38)
	local var1_38 = arg1_38.dir or ys.Battle.BattleConst.UnitDir.RIGHT
	local var2_38 = arg1_38.lineX
	local var3_38 = {}

	if var1_38 == ys.Battle.BattleConst.UnitDir.RIGHT then
		for iter0_38, iter1_38 in ipairs(var0_38) do
			if var2_38 <= iter1_38:GetPosition().x then
				table.insert(var3_38, iter1_38)
			end
		end
	elseif var1_38 == ys.Battle.BattleConst.UnitDir.LEFT then
		for iter2_38, iter3_38 in ipairs(var0_38) do
			if var2_38 >= iter3_38:GetPosition().x then
				table.insert(var3_38, iter3_38)
			end
		end
	end

	return var3_38
end

function var3_0.TargetAircraftHelp(arg0_39)
	local var0_39 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_39 = {}
	local var2_39 = arg0_39:GetIFF()

	for iter0_39, iter1_39 in pairs(var0_39:GetAircraftList()) do
		if var2_39 == iter1_39:GetIFF() then
			var1_39[#var1_39 + 1] = iter1_39
		end
	end

	return var1_39
end

function var3_0.TargetAircraftHarm(arg0_40)
	local var0_40 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_40 = {}
	local var2_40 = arg0_40:GetIFF()

	for iter0_40, iter1_40 in pairs(var0_40:GetAircraftList()) do
		if var2_40 ~= iter1_40:GetIFF() and iter1_40:IsVisitable() then
			var1_40[#var1_40 + 1] = iter1_40
		end
	end

	return var1_40
end

function var3_0.TargetAircraftGB(arg0_41)
	local var0_41 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_41 = {}
	local var2_41 = arg0_41:GetIFF()

	for iter0_41, iter1_41 in pairs(var0_41:GetAircraftList()) do
		if var2_41 ~= iter1_41:GetIFF() and iter1_41:IsVisitable() and iter1_41:GetMotherUnit() == nil then
			var1_41[#var1_41 + 1] = iter1_41
		end
	end

	return var1_41
end

function var3_0.TargetDiveState(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42 and arg1_42.diveState or ys.Battle.BattleConst.OXY_STATE.DIVE
	local var1_42 = arg2_42 or var3_0.TargetEntityUnit()
	local var2_42 = {}

	for iter0_42, iter1_42 in pairs(var1_42) do
		if var0_42 == iter1_42:GetCurrentOxyState() then
			var2_42[#var2_42 + 1] = iter1_42
		end
	end

	return var2_42
end

function var3_0.TargetDetectedUnit(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg2_43 or var3_0.TargetEntityUnit()
	local var1_43 = {}

	for iter0_43, iter1_43 in pairs(var0_43) do
		if iter1_43:GetDiveDetected() then
			var1_43[#var1_43 + 1] = iter1_43
		end
	end

	return var1_43
end

function var3_0.TargetAllHarmBullet(arg0_44)
	local var0_44 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_44 = {}
	local var2_44 = arg0_44:GetIFF()

	for iter0_44, iter1_44 in pairs(var0_44:GetBulletList()) do
		if var2_44 ~= iter1_44:GetIFF() then
			var1_44[#var1_44 + 1] = iter1_44
		end
	end

	return var1_44
end

function var3_0.TargetAllHarmBulletByType(arg0_45, arg1_45)
	local var0_45 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_45 = {}
	local var2_45 = arg0_45:GetIFF()

	for iter0_45, iter1_45 in pairs(var0_45:GetBulletList()) do
		if var2_45 ~= iter1_45:GetIFF() and iter1_45:GetType() == arg1_45 then
			var1_45[#var1_45 + 1] = iter1_45
		end
	end

	return var1_45
end

function var3_0.TargetAllHarmTorpedoBullet(arg0_46)
	return var3_0.TargetAllHarmBulletByType(arg0_46, ys.Battle.BattleConst.BulletType.TORPEDO)
end

function var3_0.TargetFleetIndex(arg0_47, arg1_47)
	local var0_47

	if arg0_47 then
		var0_47 = arg0_47:GetIFF()
	else
		var0_47 = var0_0.FRIENDLY_CODE
	end

	local var1_47 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0_47)
	local var2_47 = TeamType.TeamPos
	local var3_47 = arg1_47.fleetPos
	local var4_47 = {}
	local var5_47 = var1_47:GetUnitList()
	local var6_47 = var1_47:GetScoutList()
	local var7_47 = arg1_47.exceptCaster

	if var7_47 then
		local var8_47 = arg0_47:GetUniqueID()
	end

	for iter0_47, iter1_47 in ipairs(var5_47) do
		local var9_47 = iter1_47:GetUniqueID()

		if var7_47 and var9_47 == casterID then
			-- block empty
		elseif iter1_47 == var1_47:GetFlagShip() then
			if var3_47 == var2_47.FLAG_SHIP then
				table.insert(var4_47, iter1_47)
			end
		elseif iter1_47 == var6_47[1] then
			if var3_47 == var2_47.LEADER then
				table.insert(var4_47, iter1_47)
			end
		elseif #var6_47 == 3 and iter1_47 == var6_47[2] then
			if var3_47 == var2_47.CENTER then
				table.insert(var4_47, iter1_47)
			end
		elseif iter1_47 == var6_47[#var6_47] then
			if var3_47 == var2_47.REAR then
				table.insert(var4_47, iter1_47)
			end
		elseif iter1_47:IsMainFleetUnit() and iter1_47:GetMainUnitIndex() == 2 then
			if var3_47 == var2_47.UPPER_CONSORT then
				table.insert(var4_47, iter1_47)
			end
		elseif iter1_47:IsMainFleetUnit() and iter1_47:GetMainUnitIndex() == 3 and var3_47 == var2_47.LOWER_CONSORT then
			table.insert(var4_47, iter1_47)
		end
	end

	local var10_47 = var1_47:GetSubList()

	for iter2_47, iter3_47 in ipairs(var5_47) do
		if iter2_47 == 1 then
			if var3_47 == var2_47.SUB_LEADER then
				table.insert(var4_47, iter3_47)
			end
		elseif var3_47 == var2_47.SUB_CONSORT then
			table.insert(var4_47, iter3_47)
		end
	end

	return var4_47
end

function var3_0.TargetPlayerVanguardFleet(arg0_48, arg1_48, arg2_48)
	local var0_48 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_48:GetIFF()):GetScoutList()

	if not arg2_48 then
		return var0_48
	else
		local var1_48 = #arg2_48

		while var1_48 > 0 do
			if not table.contains(var0_48, arg2_48[var1_48]) then
				table.remove(arg2_48, var1_48)
			end

			var1_48 = var1_48 - 1
		end

		return arg2_48
	end
end

function var3_0.TargetPlayerMainFleet(arg0_49, arg1_49, arg2_49)
	local var0_49 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_49:GetIFF()):GetMainList()

	if not arg2_49 then
		return var0_49
	else
		local var1_49 = #arg2_49

		while var1_49 > 0 do
			if not table.contains(var0_49, arg2_49[var1_49]) then
				table.remove(arg2_49, var1_49)
			end

			var1_49 = var1_49 - 1
		end

		return arg2_49
	end
end

function var3_0.TargetPlayerFlagShip(arg0_50, arg1_50, arg2_50)
	local var0_50 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_50:GetIFF())

	return {
		var0_50:GetFlagShip()
	}
end

function var3_0.TargetPlayerLeaderShip(arg0_51, arg1_51, arg2_51)
	local var0_51 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_51:GetIFF())

	return {
		var0_51:GetLeaderShip()
	}
end

function var3_0.TargetPlayerByType(arg0_52, arg1_52)
	local var0_52 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_52:GetIFF()):GetUnitList()
	local var1_52 = {}
	local var2_52 = arg1_52.shipType

	for iter0_52, iter1_52 in ipairs(var0_52) do
		if iter1_52:GetTemplate().type == var2_52 then
			var1_52[#var1_52 + 1] = iter1_52
		end
	end

	return var1_52
end

function var3_0.TargetPlayerAidUnit(arg0_53, arg1_53)
	local var0_53 = ys.Battle.BattleDataProxy.GetInstance():GetAidUnit()
	local var1_53 = {}

	for iter0_53, iter1_53 in pairs(var0_53) do
		table.insert(var1_53, iter1_53)
	end

	return var1_53
end

function var3_0.TargetDamageSource(arg0_54, arg1_54, arg2_54)
	local var0_54 = arg2_54 or var3_0.TargetAllFoe(arg0_54)
	local var1_54 = {}

	for iter0_54, iter1_54 in pairs(var0_54) do
		if iter1_54:GetUniqueID() == arg1_54.damageSourceID then
			table.insert(var1_54, iter1_54)

			break
		end
	end

	return var1_54
end

function var3_0.TargetRarity(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg2_55 or var3_0.TargetAllHelp(arg0_55)
	local var1_55 = {}

	for iter0_55, iter1_55 in ipairs(var0_55) do
		if iter1_55:GetRarity() == arg1_55.rarity then
			table.insert(var1_55, iter1_55)
		end
	end

	return var1_55
end

function var3_0.TargetIllustrator(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg2_56 or var3_0.TargetAllHelp(arg0_56)
	local var1_56 = {}

	for iter0_56, iter1_56 in ipairs(var0_56) do
		if ys.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(iter1_56:GetSkinID()).illustrator == arg1_56.illustrator then
			table.insert(var1_56, iter1_56)
		end
	end

	return var1_56
end

function var3_0.TargetTeam(arg0_57, arg1_57, arg2_57)
	local var0_57 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_57:GetIFF())
	local var1_57 = {}
	local var2_57 = TeamType.TeamTypeIndex[arg1_57.teamIndex]

	if var2_57 == TeamType.Vanguard then
		var1_57 = var0_57:GetScoutList()
	elseif var2_57 == TeamType.Main then
		var1_57 = var0_57:GetMainList()
	elseif var2_57 == TeamType.Submarine then
		var1_57 = var0_57:GetSubList()
	end

	local var3_57 = {}

	for iter0_57, iter1_57 in ipairs(var1_57) do
		if not arg2_57 or table.contains(arg2_57, iter1_57) then
			table.insert(var3_57, iter1_57)
		end
	end

	return var3_57
end

function var3_0.TargetGroup(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg1_58.groupIDList
	local var1_58 = arg2_58 or var3_0.TargetAllHelp(arg0_58)
	local var2_58 = {}
	local var3_58 = arg0_58:GetIFF()

	for iter0_58, iter1_58 in ipairs(var1_58) do
		local var4_58 = iter1_58:GetTemplateID()
		local var5_58 = ys.Battle.BattleDataFunction.GetPlayerShipModelFromID(var4_58).group_type
		local var6_58 = iter1_58:GetIFF()

		if table.contains(var0_58, var5_58) and var3_58 == var6_58 then
			var2_58[#var2_58 + 1] = iter1_58
		end
	end

	return var2_58
end

function var3_0.LegalTarget(arg0_59)
	local var0_59 = {}
	local var1_59
	local var2_59 = ys.Battle.BattleDataProxy.GetInstance()
	local var3_59, var4_59, var5_59, var6_59 = var2_59:GetFieldBound()
	local var7_59 = var2_59:GetUnitList()
	local var8_59 = arg0_59:GetIFF()

	for iter0_59, iter1_59 in pairs(var7_59) do
		if iter1_59:IsAlive() and iter1_59:GetIFF() ~= var8_59 and var6_59 > iter1_59:GetPosition().x and not iter1_59:IsSpectre() then
			var0_59[#var0_59 + 1] = iter1_59
		end
	end

	return var0_59
end

function var3_0.LegalWeaponTarget(arg0_60)
	local var0_60 = {}
	local var1_60
	local var2_60 = ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
	local var3_60 = arg0_60:GetIFF()

	for iter0_60, iter1_60 in pairs(var2_60) do
		if iter1_60:GetIFF() ~= var3_60 and not iter1_60:IsSpectre() then
			var0_60[#var0_60 + 1] = iter1_60
		end
	end

	return var0_60
end
