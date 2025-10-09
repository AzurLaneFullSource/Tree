local var0_0 = class("CourtYardFurnitureSpineSlot", import(".CourtYardFurnitureBaseSlot"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.name = arg1_1[1][1]
	arg0_1.defaultAction = arg1_1[1][2]
	arg0_1.mask = arg1_1[2] and arg1_1[2][1]

	if arg0_1.mask then
		arg0_1.maskDefaultAction = arg1_1[2][2]
	end

	arg0_1.bodyMask = arg1_1[4] and #arg1_1[4] > 0 and {
		offset = arg1_1[4][1] and Vector3(arg1_1[4][1][1], arg1_1[4][1][2], 0) or Vector3.zero,
		size = arg1_1[4][2] and Vector3(arg1_1[4][2][1], arg1_1[4][2][2], 0) or Vector3.zero,
		img = arg1_1[4][3]
	}
	arg0_1.offset = arg1_1[5] and Vector3(arg1_1[5][1], arg1_1[5][2], 0) or Vector3.zero
	arg0_1.scale = arg1_1[6] and Vector3(arg1_1[6][1], arg1_1[6][2], 0) or Vector3.one
	arg0_1.substituteActions = {}
	arg0_1.actions = {}
	arg0_1.loop = false
	arg0_1.valid = tobool(arg1_1[3]) and tobool(arg1_1[3][3])

	if arg0_1.valid then
		arg0_1.actions = arg1_1[3][2]

		local var0_1 = arg1_1[3][3][2] or var1_0

		if var0_1 == true then
			var0_1 = var2_0
		end

		if arg1_1[3][5] then
			var0_1 = var4_0
		end

		arg0_1.strategyType = var0_1
		arg0_1.updateStrategy = arg0_1:InitUpdateStrategy(var0_1)
		arg0_1.preheatAction = arg1_1[3][3][3]
		arg0_1.tailAction = arg1_1[3][3][4]
		arg0_1.loop = arg1_1[3][4][1] == 1
		arg0_1.variedActions = arg1_1[3][5]
	end
end

function var0_0.OnInitCombine(arg0_2, arg1_2)
	arg0_2.combineData = arg1_2
end

function var0_0.InitUpdateStrategy(arg0_3, arg1_3)
	local var0_3

	if arg1_3 == var2_0 then
		var0_3 = CourtYardFollowInteraction.New(arg0_3)
	elseif arg1_3 == var3_0 then
		var0_3 = CourtYardMonglineInteraction.New(arg0_3)
	elseif arg1_3 == var4_0 then
		var0_3 = CourtYardVariedInteraction.New(arg0_3)
	else
		var0_3 = CourtYardInteraction.New(arg0_3)
	end

	return var0_3
end

function var0_0.SetAnimators(arg0_4, arg1_4)
	local var0_4 = arg1_4[1]
	local var1_4 = var0_4[arg0_4.id] or var0_4[1] or {}
	local var2_4 = type(var1_4) == "string" and {
		var1_4
	} or var1_4

	for iter0_4, iter1_4 in ipairs(var2_4) do
		table.insert(arg0_4.animators, {
			key = arg0_4.id .. "_" .. iter0_4,
			value = iter1_4
		})
	end
end

function var0_0.SetFollower(arg0_5, arg1_5)
	arg0_5.follower = {
		bone = arg1_5[1],
		scale = Vector3(arg1_5[2], 1, 1)
	}
end

function var0_0.SetSubstitute(arg0_6, arg1_6)
	arg0_6.substituteActions = _.map(arg1_6, function(arg0_7)
		return {
			action = arg0_7[1],
			match = arg0_7[2],
			replace = arg0_7[3],
			replace_mode = arg0_7[4],
			math_mode = arg0_7[5]
		}
	end)
end

function var0_0.GetSubstituteAction(arg0_8, arg1_8, arg2_8)
	local function var0_8(arg0_9)
		local var0_9 = arg0_8:GetUser()
		local var1_9 = arg0_9.math_mode == 1 and var0_9:GetSkinID() or var0_9:GetGroupID()

		return table.contains(arg0_9.match, var1_9) and (arg0_9.replace_mode == 0 or arg0_9.replace_mode == arg2_8)
	end

	local var1_8 = _.detect(arg0_8.substituteActions, function(arg0_10)
		return arg0_10.action == arg1_8 and var0_8(arg0_10)
	end)

	return var1_8 and var1_8.replace or arg1_8
end

function var0_0.GetUserSubstituteAction(arg0_11, arg1_11)
	return arg0_11:GetSubstituteAction(arg1_11, 1)
end

function var0_0.GetOwnerSubstituteAction(arg0_12, arg1_12)
	return arg0_12:GetSubstituteAction(arg1_12, 2)
end

function var0_0.IsEmpty(arg0_13)
	return var0_0.super.IsEmpty(arg0_13) and arg0_13.valid
end

function var0_0.GetScale(arg0_14)
	if arg0_14.follower then
		return arg0_14.follower.scale
	else
		return arg0_14.scale
	end
end

local function var5_0(arg0_15)
	local var0_15 = {}
	local var1_15 = {}
	local var2_15 = {}
	local var3_15 = arg0_15.actions[1][2]
	local var4_15 = arg0_15.actions[1][3]

	for iter0_15, iter1_15 in ipairs(arg0_15.variedActions) do
		local var5_15 = iter1_15[math.random(1, #iter1_15)]

		table.insert(var0_15, var5_15)
		table.insert(var1_15, var4_15)
		table.insert(var2_15, var3_15)
	end

	return var0_15, var1_15, var2_15
end

local function var6_0(arg0_16)
	local var0_16 = arg0_16:GetCombineFurnitureAnimator()
	local var1_16 = {}
	local var2_16 = {}
	local var3_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.actions) do
		local var4_16 = iter1_16[1]
		local var5_16 = iter1_16[3]

		var4_16 = var0_16 and var0_16[3] and var0_16[3][iter0_16] or var4_16

		local var6_16 = type(var4_16) == "table" and var4_16[math.random(1, #var4_16)] or var4_16
		local var7_16 = arg0_16:GetOwnerSubstituteAction(var6_16)

		table.insert(var1_16, var7_16)

		local var8_16 = arg0_16:GetUserSubstituteAction(var5_16 or var6_16)

		table.insert(var2_16, var8_16)
		table.insert(var3_16, tobool(iter1_16[2]))
	end

	return var1_16, var2_16, var3_16
end

function var0_0.GetActions(arg0_17)
	local var0_17
	local var1_17
	local var2_17

	if arg0_17.preheatAction and type(arg0_17.preheatAction) == "string" then
		var0_17, var2_17 = arg0_17.preheatAction, false
	elseif arg0_17.preheatAction and type(arg0_17.preheatAction) == "table" then
		local var3_17 = {}

		if type(arg0_17.preheatAction[1]) == "table" then
			for iter0_17, iter1_17 in ipairs(arg0_17.preheatAction[1]) do
				table.insert(var3_17, iter1_17)
			end
		else
			table.insert(var3_17, arg0_17.preheatAction[1])
		end

		local var4_17 = 1
		local var5_17 = arg0_17:GetOwner()

		if isa(var5_17, CourtYardFurniture) then
			var4_17 = #var5_17:GetUsingSlots()
		end

		var0_17, var1_17, var2_17, preheatOnlyHost = var3_17[var4_17], arg0_17.preheatAction[2], arg0_17.preheatAction[3], arg0_17.preheatAction[4]
	end

	local var6_17
	local var7_17
	local var8_17

	if arg0_17.strategyType == var4_0 then
		var6_17, var7_17, var8_17 = var5_0(arg0_17)
	else
		var6_17, var7_17, var8_17 = var6_0(arg0_17)
	end

	if var2_17 then
		var8_17[0] = true
	end

	return var6_17, var7_17, var8_17, var0_17, var1_17, arg0_17.tailAction, preheatOnlyHost
end

function var0_0.OnAwake(arg0_18)
	if #arg0_18.animators > 0 then
		arg0_18.animatorIndex = math.random(1, #arg0_18.animators)
	end
end

function var0_0.OnStart(arg0_19)
	arg0_19.updateStrategy:Update(arg0_19.loop)
end

function var0_0.OnContinue(arg0_20, arg1_20)
	arg0_20.updateStrategy:StepEnd(arg1_20)
end

function var0_0.Reset(arg0_21)
	arg0_21.updateStrategy:Reset()
end

function var0_0.GetSpineDefaultAction(arg0_22)
	local var0_22 = arg0_22:GetCombineFurnitureAnimator()

	if var0_22 then
		return var0_22[2] or arg0_22.defaultAction
	end

	return arg0_22.defaultAction
end

function var0_0.GetSpineMaskDefaultAcation(arg0_23)
	return arg0_23.maskDefaultAction
end

return var0_0
