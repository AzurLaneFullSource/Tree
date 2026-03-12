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

function var3_0.TargetAttrCeil(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg2_20 or var3_0.TargetEntityUnit()
	local var1_20 = arg1_20.ceilAttr
	local var2_20 = 0
	local var3_20

	for iter0_20, iter1_20 in ipairs(var0_20) do
		local var4_20 = iter1_20:GetAttrByName(var1_20)

		if var2_20 <= var4_20 then
			var2_20 = var4_20
			var3_20 = iter1_20
		end
	end

	return {
		var3_20
	}
end

function var3_0.TargetAttrFloor(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg2_21 or var3_0.TargetEntityUnit()
	local var1_21 = arg1_21.floorAttr
	local var2_21 = Mathf.Infinity
	local var3_21

	for iter0_21, iter1_21 in ipairs(var0_21) do
		local var4_21 = iter1_21:GetAttrByName(var1_21)

		if var4_21 <= var2_21 then
			var2_21 = var4_21
			var3_21 = iter1_21
		end
	end

	return {
		var3_21
	}
end

function var3_0.TargetTempCompare(arg0_22, arg1_22, arg2_22)
	local var0_22 = {}
	local var1_22 = arg2_22 or var3_0.TargetEntityUnit()

	for iter0_22, iter1_22 in pairs(var1_22) do
		if iter1_22:IsAlive() and var2_0.parseCompareUnitTemplate(arg1_22.tempCompare, iter1_22, arg0_22) then
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22
end

function var3_0.TargetHPCompare(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}
	local var1_23 = arg2_23 or var3_0.TargetEntityUnit()

	if arg0_23 then
		local var2_23 = arg0_23:GetHP()

		for iter0_23, iter1_23 in ipairs(var1_23) do
			if var2_23 > iter1_23:GetHP() then
				var0_23[#var0_23 + 1] = iter1_23
			end
		end
	end

	return var0_23
end

function var3_0.TargetHPRatioLowerThan(arg0_24, arg1_24, arg2_24)
	local var0_24 = {}
	local var1_24 = arg1_24.hpRatioList[1]
	local var2_24 = arg2_24 or var3_0.TargetEntityUnit()

	for iter0_24, iter1_24 in ipairs(var2_24) do
		if var1_24 > iter1_24:GetHP() then
			var0_24[#var0_24 + 1] = iter1_24
		end
	end

	return var0_24
end

function var3_0.TargetNationalityFriendly(arg0_25, arg1_25, arg2_25)
	local var0_25 = {}

	if arg0_25 then
		local var1_25 = arg1_25.nationality
		local var2_25 = arg2_25 or var3_0.TargetAllHelp(arg0_25, arg1_25)

		for iter0_25, iter1_25 in pairs(var2_25) do
			if iter1_25:GetTemplate().nationality == var1_25 then
				var0_25[#var0_25 + 1] = iter1_25
			end
		end
	end

	return var0_25
end

function var3_0.TargetNationalityFoe(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}

	if arg0_26 then
		local var1_26 = arg1_26.nationality
		local var2_26 = arg2_26 or var3_0.TargetAllHarm(arg0_26, arg1_26)

		for iter0_26, iter1_26 in pairs(var2_26) do
			if iter1_26:GetTemplate().nationality == var1_26 then
				var0_26[#var0_26 + 1] = iter1_26
			end
		end
	end

	return var0_26
end

function var3_0.TargetShipTypeFriendly(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}

	if arg0_27 then
		local var1_27 = arg1_27.ship_type_list
		local var2_27 = arg2_27 or var3_0.TargetAllHelp(arg0_27, arg1_27)

		for iter0_27, iter1_27 in pairs(var2_27) do
			local var3_27 = iter1_27:GetTemplate().type

			if table.contains(var1_27, var3_27) then
				var0_27[#var0_27 + 1] = iter1_27
			end
		end
	end

	return var0_27
end

function var3_0.TargetSelf(arg0_28)
	return {
		arg0_28
	}
end

function var3_0.TargetAllHarm(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}
	local var1_29
	local var2_29 = arg0_29:GetIFF()
	local var3_29 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_29 then
		var1_29 = {}

		for iter0_29, iter1_29 in ipairs(arg2_29) do
			if iter1_29:GetIFF() * var2_29 == -1 then
				table.insert(var1_29, iter1_29)
			end
		end
	elseif var2_29 == var0_0.FRIENDLY_CODE then
		var1_29 = var3_29:GetFoeShipList()
	elseif var2_29 == var0_0.FOE_CODE then
		var1_29 = var3_29:GetFriendlyShipList()
	end

	local var4_29, var5_29, var6_29, var7_29 = var3_29:GetFieldBound()

	if var1_29 then
		for iter2_29, iter3_29 in pairs(var1_29) do
			if iter3_29:IsAlive() and var7_29 > iter3_29:GetPosition().x and iter3_29:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0_29[#var0_29 + 1] = iter3_29
			end
		end
	end

	return var0_29
end

function var3_0.TargetAllFoe(arg0_30, arg1_30, arg2_30)
	local var0_30 = {}
	local var1_30
	local var2_30 = arg0_30:GetIFF()
	local var3_30 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_30 then
		var1_30 = {}

		for iter0_30, iter1_30 in ipairs(arg2_30) do
			if iter1_30:GetIFF() * var2_30 == -1 then
				table.insert(var1_30, iter1_30)
			end
		end
	elseif var2_30 == var0_0.FRIENDLY_CODE then
		var1_30 = var3_30:GetFoeShipList()
	elseif var2_30 == var0_0.FOE_CODE then
		var1_30 = var3_30:GetFriendlyShipList()
	end

	local var4_30, var5_30, var6_30, var7_30 = var3_30:GetFieldBound()

	if var1_30 then
		for iter2_30, iter3_30 in pairs(var1_30) do
			if iter3_30:IsAlive() and var7_30 > iter3_30:GetPosition().x then
				var0_30[#var0_30 + 1] = iter3_30
			end
		end
	end

	return var0_30
end

function var3_0.TargetFoeUncloak(arg0_31, arg1_31, arg2_31)
	local var0_31 = {}
	local var1_31
	local var2_31 = arg0_31:GetIFF()
	local var3_31 = ys.Battle.BattleDataProxy.GetInstance()

	if arg2_31 then
		var1_31 = {}

		for iter0_31, iter1_31 in ipairs(arg2_31) do
			if iter1_31:GetIFF() * var2_31 == -1 then
				table.insert(var1_31, iter1_31)
			end
		end
	elseif var2_31 == var0_0.FRIENDLY_CODE then
		var1_31 = var3_31:GetFoeShipList()
	elseif var2_31 == var0_0.FOE_CODE then
		var1_31 = var3_31:GetFriendlyShipList()
	end

	local var4_31, var5_31, var6_31, var7_31 = var3_31:GetFieldBound()

	if var1_31 then
		for iter2_31, iter3_31 in pairs(var1_31) do
			if iter3_31:IsAlive() and var7_31 > iter3_31:GetPosition().x and not var1_0.IsCloak(iter3_31) and iter3_31:GetCurrentOxyState() ~= ys.Battle.BattleConst.OXY_STATE.DIVE then
				var0_31[#var0_31 + 1] = iter3_31
			end
		end
	end

	return var0_31
end

function var3_0.TargetCloakState(arg0_32, arg1_32, arg2_32)
	local var0_32 = {}
	local var1_32 = arg1_32.cloak or 1
	local var2_32 = arg2_32 or var3_0.TargetEntityUnit()

	for iter0_32, iter1_32 in ipairs(var2_32) do
		if var1_0.GetCurrent(iter1_32, "isCloak") == var1_32 then
			var0_32[#var0_32 + 1] = iter1_32
		end
	end

	return var0_32
end

function var3_0.TargetFaintState(arg0_33, arg1_33, arg2_33)
	local var0_33 = {}
	local var1_33 = arg1_33.faint or 1
	local var2_33 = arg2_33 or var3_0.TargetEntityUnit()

	for iter0_33, iter1_33 in ipairs(var2_33) do
		local var3_33 = iter1_33:GetAimBias()

		if var1_33 == 1 then
			if var3_33 and var3_33:IsFaint() then
				var0_33[#var0_33 + 1] = iter1_33
			end
		elseif var1_33 == 0 and (not var3_33 or not var3_33:IsFaint()) then
			var0_33[#var0_33 + 1] = iter1_33
		end
	end

	return var0_33
end

function var3_0.TargetNearest(arg0_34, arg1_34, arg2_34)
	arg1_34 = arg1_34 or {}

	local var0_34 = arg1_34.range or 9999999999
	local var1_34
	local var2_34 = arg2_34

	for iter0_34, iter1_34 in ipairs(var2_34) do
		local var3_34 = arg0_34:GetDistance(iter1_34)

		if var3_34 < var0_34 then
			var0_34 = var3_34
			var1_34 = iter1_34
		end
	end

	return {
		var1_34
	}
end

function var3_0.TargetHarmNearest(arg0_35, arg1_35, arg2_35)
	arg1_35 = arg1_35 or {}

	local var0_35 = arg1_35.range or 9999999999
	local var1_35
	local var2_35 = arg2_35 and var3_0.TargetFoeUncloak(arg0_35, arg1_35, arg2_35) or var3_0.TargetFoeUncloak(arg0_35)

	for iter0_35, iter1_35 in ipairs(var2_35) do
		local var3_35 = arg0_35:GetDistance(iter1_35)

		if var3_35 < var0_35 then
			var0_35 = var3_35
			var1_35 = iter1_35
		end
	end

	return {
		var1_35
	}
end

function var3_0.TargetHarmFarthest(arg0_36, arg1_36, arg2_36)
	local var0_36 = 0
	local var1_36

	arg1_36 = arg1_36 or {}

	local var2_36 = arg2_36 and var3_0.TargetFoeUncloak(arg0_36, arg1_36, arg2_36) or var3_0.TargetFoeUncloak(arg0_36)

	for iter0_36, iter1_36 in ipairs(var2_36) do
		local var3_36 = arg0_36:GetDistance(iter1_36)

		if var0_36 < var3_36 then
			var0_36 = var3_36
			var1_36 = iter1_36
		end
	end

	return {
		var1_36
	}
end

function var3_0.TargetHarmRandom(arg0_37, arg1_37, arg2_37)
	arg1_37 = arg1_37 or {}

	local var0_37 = arg2_37 and var3_0.TargetFoeUncloak(arg0_37, arg1_37, arg2_37) or var3_0.TargetFoeUncloak(arg0_37)

	if #var0_37 > 0 then
		local var1_37 = math.random(#var0_37)

		return {
			var0_37[var1_37]
		}
	else
		return {}
	end
end

function var3_0.TargetHarmRandomByWeight(arg0_38, arg1_38, arg2_38)
	arg1_38 = arg1_38 or {}

	local var0_38 = arg2_38 and var3_0.TargetFoeUncloak(arg0_38, arg1_38, arg2_38) or var3_0.TargetFoeUncloak(arg0_38)
	local var1_38 = {}
	local var2_38 = -9999

	for iter0_38, iter1_38 in ipairs(var0_38) do
		local var3_38 = iter1_38:GetTargetedPriority() or 0

		if var3_38 == var2_38 then
			var1_38[#var1_38 + 1] = iter1_38
		elseif var2_38 < var3_38 then
			var1_38 = {
				iter1_38
			}
			var2_38 = var3_38
		end
	end

	if #var1_38 > 0 then
		local var4_38 = math.random(#var1_38)

		return {
			var1_38[var4_38]
		}
	else
		return {}
	end
end

function var3_0.TargetWeightiest(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg2_39 or var3_0.TargetEntityUnit()
	local var1_39 = {}
	local var2_39 = -9999

	for iter0_39, iter1_39 in ipairs(var0_39) do
		local var3_39 = iter1_39:GetTargetedPriority() or 0

		if var3_39 == var2_39 then
			var1_39[#var1_39 + 1] = iter1_39
		elseif var2_39 < var3_39 then
			var1_39 = {
				iter1_39
			}
			var2_39 = var3_39
		end
	end

	return var1_39
end

function var3_0.TargetRandom(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg2_40 or var3_0.TargetEntityUnit()
	local var1_40 = arg1_40.randomCount or 1

	return (Mathf.MultiRandom(var0_40, var1_40))
end

function var3_0.TargetInsideArea(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg2_41 or var3_0.TargetAllHarm(arg0_41)
	local var1_41 = arg1_41.dir or ys.Battle.BattleConst.UnitDir.RIGHT
	local var2_41 = arg1_41.lineX
	local var3_41 = {}

	if var1_41 == ys.Battle.BattleConst.UnitDir.RIGHT then
		for iter0_41, iter1_41 in ipairs(var0_41) do
			if var2_41 <= iter1_41:GetPosition().x then
				table.insert(var3_41, iter1_41)
			end
		end
	elseif var1_41 == ys.Battle.BattleConst.UnitDir.LEFT then
		for iter2_41, iter3_41 in ipairs(var0_41) do
			if var2_41 >= iter3_41:GetPosition().x then
				table.insert(var3_41, iter3_41)
			end
		end
	end

	return var3_41
end

function var3_0.TargetAircraftHelp(arg0_42)
	local var0_42 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_42 = {}
	local var2_42 = arg0_42:GetIFF()

	for iter0_42, iter1_42 in pairs(var0_42:GetAircraftList()) do
		if var2_42 == iter1_42:GetIFF() then
			var1_42[#var1_42 + 1] = iter1_42
		end
	end

	return var1_42
end

function var3_0.TargetAircraftHarm(arg0_43)
	local var0_43 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_43 = {}
	local var2_43 = arg0_43:GetIFF()

	for iter0_43, iter1_43 in pairs(var0_43:GetAircraftList()) do
		if var2_43 ~= iter1_43:GetIFF() and iter1_43:IsVisitable() then
			var1_43[#var1_43 + 1] = iter1_43
		end
	end

	return var1_43
end

function var3_0.TargetAircraftGB(arg0_44)
	local var0_44 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_44 = {}
	local var2_44 = arg0_44:GetIFF()

	for iter0_44, iter1_44 in pairs(var0_44:GetAircraftList()) do
		if var2_44 ~= iter1_44:GetIFF() and iter1_44:IsVisitable() and iter1_44:GetMotherUnit() == nil then
			var1_44[#var1_44 + 1] = iter1_44
		end
	end

	return var1_44
end

function var3_0.TargetDiveState(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg1_45 and arg1_45.diveState or ys.Battle.BattleConst.OXY_STATE.DIVE
	local var1_45 = arg2_45 or var3_0.TargetEntityUnit()
	local var2_45 = {}

	for iter0_45, iter1_45 in pairs(var1_45) do
		if var0_45 == iter1_45:GetCurrentOxyState() then
			var2_45[#var2_45 + 1] = iter1_45
		end
	end

	return var2_45
end

function var3_0.TargetDetectedUnit(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg2_46 or var3_0.TargetEntityUnit()
	local var1_46 = {}

	for iter0_46, iter1_46 in pairs(var0_46) do
		if iter1_46:GetDiveDetected() then
			var1_46[#var1_46 + 1] = iter1_46
		end
	end

	return var1_46
end

function var3_0.TargetFatalDamageSrc(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg2_47 or var3_0.TargetEntityUnit()
	local var1_47 = arg0_47:GetDeathSrcID()
	local var2_47 = {}

	if var1_47 then
		for iter0_47, iter1_47 in pairs(var0_47) do
			if var1_47 == iter1_47:GetUniqueID() and iter1_47:IsAlive() then
				var2_47[#var2_47 + 1] = iter1_47
			end
		end
	end

	return var2_47
end

function var3_0.TargetAllHarmBullet(arg0_48)
	local var0_48 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_48 = {}
	local var2_48 = arg0_48:GetIFF()

	for iter0_48, iter1_48 in pairs(var0_48:GetBulletList()) do
		if var2_48 ~= iter1_48:GetIFF() then
			var1_48[#var1_48 + 1] = iter1_48
		end
	end

	return var1_48
end

function var3_0.TargetAllHarmBulletByType(arg0_49, arg1_49)
	local var0_49 = ys.Battle.BattleDataProxy.GetInstance()
	local var1_49 = {}
	local var2_49 = arg0_49:GetIFF()

	for iter0_49, iter1_49 in pairs(var0_49:GetBulletList()) do
		if var2_49 ~= iter1_49:GetIFF() and iter1_49:GetType() == arg1_49 then
			var1_49[#var1_49 + 1] = iter1_49
		end
	end

	return var1_49
end

function var3_0.TargetAllHarmTorpedoBullet(arg0_50)
	return var3_0.TargetAllHarmBulletByType(arg0_50, ys.Battle.BattleConst.BulletType.TORPEDO)
end

function var3_0.TargetFleetIndex(arg0_51, arg1_51)
	local var0_51

	if arg0_51 then
		var0_51 = arg0_51:GetIFF()
	else
		var0_51 = var0_0.FRIENDLY_CODE
	end

	local var1_51 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0_51)
	local var2_51 = TeamType.TeamPos
	local var3_51 = arg1_51.fleetPos
	local var4_51 = {}
	local var5_51 = var1_51:GetUnitList()
	local var6_51 = var1_51:GetScoutList()
	local var7_51 = arg1_51.exceptCaster

	if var7_51 then
		local var8_51 = arg0_51:GetUniqueID()
	end

	for iter0_51, iter1_51 in ipairs(var5_51) do
		local var9_51 = iter1_51:GetUniqueID()

		if var7_51 and var9_51 == casterID then
			-- block empty
		elseif iter1_51 == var1_51:GetFlagShip() then
			if var3_51 == var2_51.FLAG_SHIP then
				table.insert(var4_51, iter1_51)
			end
		elseif iter1_51 == var6_51[1] then
			if var3_51 == var2_51.LEADER then
				table.insert(var4_51, iter1_51)
			end
		elseif #var6_51 == 3 and iter1_51 == var6_51[2] then
			if var3_51 == var2_51.CENTER then
				table.insert(var4_51, iter1_51)
			end
		elseif iter1_51 == var6_51[#var6_51] then
			if var3_51 == var2_51.REAR then
				table.insert(var4_51, iter1_51)
			end
		elseif iter1_51:IsMainFleetUnit() and iter1_51:GetMainUnitIndex() == 2 then
			if var3_51 == var2_51.UPPER_CONSORT then
				table.insert(var4_51, iter1_51)
			end
		elseif iter1_51:IsMainFleetUnit() and iter1_51:GetMainUnitIndex() == 3 and var3_51 == var2_51.LOWER_CONSORT then
			table.insert(var4_51, iter1_51)
		end
	end

	local var10_51 = var1_51:GetSubList()

	for iter2_51, iter3_51 in ipairs(var5_51) do
		if iter2_51 == 1 then
			if var3_51 == var2_51.SUB_LEADER then
				table.insert(var4_51, iter3_51)
			end
		elseif var3_51 == var2_51.SUB_CONSORT then
			table.insert(var4_51, iter3_51)
		end
	end

	return var4_51
end

function var3_0.TargetPlayerVanguardFleet(arg0_52, arg1_52, arg2_52)
	local var0_52 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_52:GetIFF()):GetScoutList()

	if not arg2_52 then
		return var0_52
	else
		local var1_52 = #arg2_52

		while var1_52 > 0 do
			if not table.contains(var0_52, arg2_52[var1_52]) then
				table.remove(arg2_52, var1_52)
			end

			var1_52 = var1_52 - 1
		end

		return arg2_52
	end
end

function var3_0.TargetPlayerMainFleet(arg0_53, arg1_53, arg2_53)
	local var0_53 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_53:GetIFF()):GetMainList()

	if not arg2_53 then
		return var0_53
	else
		local var1_53 = #arg2_53

		while var1_53 > 0 do
			if not table.contains(var0_53, arg2_53[var1_53]) then
				table.remove(arg2_53, var1_53)
			end

			var1_53 = var1_53 - 1
		end

		return arg2_53
	end
end

function var3_0.TargetPlayerFlagShip(arg0_54, arg1_54, arg2_54)
	local var0_54 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_54:GetIFF())

	return {
		var0_54:GetFlagShip()
	}
end

function var3_0.TargetPlayerLeaderShip(arg0_55, arg1_55, arg2_55)
	local var0_55 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_55:GetIFF())

	return {
		var0_55:GetLeaderShip()
	}
end

function var3_0.TargetEnemyLeaderShip(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56:GetIFF() * -1
	local var1_56 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0_56)

	return {
		var1_56:GetLeaderShip()
	}
end

function var3_0.TargetPlayerByType(arg0_57, arg1_57)
	local var0_57 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_57:GetIFF()):GetUnitList()
	local var1_57 = {}
	local var2_57 = arg1_57.shipType

	for iter0_57, iter1_57 in ipairs(var0_57) do
		if iter1_57:GetTemplate().type == var2_57 then
			var1_57[#var1_57 + 1] = iter1_57
		end
	end

	return var1_57
end

function var3_0.TargetPlayerAidUnit(arg0_58, arg1_58)
	local var0_58 = ys.Battle.BattleDataProxy.GetInstance():GetAidUnit()
	local var1_58 = {}

	for iter0_58, iter1_58 in pairs(var0_58) do
		table.insert(var1_58, iter1_58)
	end

	return var1_58
end

function var3_0.TargetDamageSource(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg2_59 or var3_0.TargetAllFoe(arg0_59)
	local var1_59 = {}

	for iter0_59, iter1_59 in pairs(var0_59) do
		if iter1_59:GetUniqueID() == arg1_59.damageSourceID then
			table.insert(var1_59, iter1_59)

			break
		end
	end

	return var1_59
end

function var3_0.TargetRarity(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg2_60 or var3_0.TargetAllHelp(arg0_60)
	local var1_60 = {}

	for iter0_60, iter1_60 in ipairs(var0_60) do
		if iter1_60:GetRarity() == arg1_60.rarity then
			table.insert(var1_60, iter1_60)
		end
	end

	return var1_60
end

function var3_0.TargetIllustrator(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg2_61 or var3_0.TargetAllHelp(arg0_61)
	local var1_61 = {}

	for iter0_61, iter1_61 in ipairs(var0_61) do
		if ys.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(iter1_61:GetSkinID()).illustrator == arg1_61.illustrator then
			table.insert(var1_61, iter1_61)
		end
	end

	return var1_61
end

function var3_0.TargetTeam(arg0_62, arg1_62, arg2_62)
	local var0_62 = ys.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(arg0_62:GetIFF())
	local var1_62 = {}
	local var2_62 = TeamType.TeamTypeIndex[arg1_62.teamIndex]

	if var2_62 == TeamType.Vanguard then
		var1_62 = var0_62:GetScoutList()
	elseif var2_62 == TeamType.Main then
		var1_62 = var0_62:GetMainList()
	elseif var2_62 == TeamType.Submarine then
		var1_62 = var0_62:GetSubList()
	end

	local var3_62 = {}

	for iter0_62, iter1_62 in ipairs(var1_62) do
		if not arg2_62 or table.contains(arg2_62, iter1_62) then
			table.insert(var3_62, iter1_62)
		end
	end

	return var3_62
end

function var3_0.TargetGroup(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg1_63.groupIDList
	local var1_63 = arg2_63 or var3_0.TargetAllHelp(arg0_63)
	local var2_63 = {}
	local var3_63 = arg0_63:GetIFF()

	for iter0_63, iter1_63 in ipairs(var1_63) do
		local var4_63 = iter1_63:GetTemplateID()
		local var5_63 = ys.Battle.BattleDataFunction.GetPlayerShipModelFromID(var4_63).group_type
		local var6_63 = iter1_63:GetIFF()

		if table.contains(var0_63, var5_63) and var3_63 == var6_63 then
			var2_63[#var2_63 + 1] = iter1_63
		end
	end

	return var2_63
end

function var3_0.LegalTarget(arg0_64)
	local var0_64 = {}
	local var1_64
	local var2_64 = ys.Battle.BattleDataProxy.GetInstance()
	local var3_64, var4_64, var5_64, var6_64 = var2_64:GetFieldBound()
	local var7_64 = var2_64:GetUnitList()
	local var8_64 = arg0_64:GetIFF()

	for iter0_64, iter1_64 in pairs(var7_64) do
		if iter1_64:IsAlive() and iter1_64:GetIFF() ~= var8_64 and var6_64 > iter1_64:GetPosition().x and not iter1_64:IsSpectre() then
			var0_64[#var0_64 + 1] = iter1_64
		end
	end

	return var0_64
end

function var3_0.LegalWeaponTarget(arg0_65)
	local var0_65 = {}
	local var1_65
	local var2_65 = ys.Battle.BattleDataProxy.GetInstance():GetUnitList()
	local var3_65 = arg0_65:GetIFF()

	for iter0_65, iter1_65 in pairs(var2_65) do
		if iter1_65:GetIFF() ~= var3_65 and not iter1_65:IsSpectre() then
			var0_65[#var0_65 + 1] = iter1_65
		end
	end

	return var0_65
end
