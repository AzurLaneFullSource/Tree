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
	arg0_1.vaild = tobool(arg1_1[3]) and tobool(arg1_1[3][3])

	if arg0_1.vaild then
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

function var0_0.InitUpdateStrategy(arg0_2, arg1_2)
	local var0_2

	if arg1_2 == var2_0 then
		var0_2 = CourtYardFollowInteraction.New(arg0_2)
	elseif arg1_2 == var3_0 then
		var0_2 = CourtYardMonglineInteraction.New(arg0_2)
	elseif arg1_2 == var4_0 then
		var0_2 = CourtYardVariedInteraction.New(arg0_2)
	else
		var0_2 = CourtYardInteraction.New(arg0_2)
	end

	return var0_2
end

function var0_0.SetAnimators(arg0_3, arg1_3)
	local var0_3 = arg1_3[1]
	local var1_3 = var0_3[arg0_3.id] or var0_3[1] or {}
	local var2_3 = type(var1_3) == "string" and {
		var1_3
	} or var1_3

	for iter0_3, iter1_3 in ipairs(var2_3) do
		table.insert(arg0_3.animators, {
			key = arg0_3.id .. "_" .. iter0_3,
			value = iter1_3
		})
	end
end

function var0_0.SetFollower(arg0_4, arg1_4)
	arg0_4.follower = {
		bone = arg1_4[1],
		scale = Vector3(arg1_4[2], 1, 1)
	}
end

function var0_0.SetSubstitute(arg0_5, arg1_5)
	arg0_5.substituteActions = _.map(arg1_5, function(arg0_6)
		return {
			action = arg0_6[1],
			match = arg0_6[2],
			replace = arg0_6[3],
			replace_mode = arg0_6[4],
			math_mode = arg0_6[5]
		}
	end)
end

function var0_0.GetSubstituteAction(arg0_7, arg1_7, arg2_7)
	local function var0_7(arg0_8)
		local var0_8 = arg0_7:GetUser()
		local var1_8 = arg0_8.math_mode == 1 and var0_8:GetSkinID() or var0_8:GetGroupID()

		return table.contains(arg0_8.match, var1_8) and (arg0_8.replace_mode == 0 or arg0_8.replace_mode == arg2_7)
	end

	local var1_7 = _.detect(arg0_7.substituteActions, function(arg0_9)
		return arg0_9.action == arg1_7 and var0_7(arg0_9)
	end)

	return var1_7 and var1_7.replace or arg1_7
end

function var0_0.GetUserSubstituteAction(arg0_10, arg1_10)
	return arg0_10:GetSubstituteAction(arg1_10, 1)
end

function var0_0.GetOwnerSubstituteAction(arg0_11, arg1_11)
	return arg0_11:GetSubstituteAction(arg1_11, 2)
end

function var0_0.IsEmpty(arg0_12)
	return var0_0.super.IsEmpty(arg0_12) and arg0_12.vaild
end

function var0_0.GetScale(arg0_13)
	if arg0_13.follower then
		return arg0_13.follower.scale
	else
		return arg0_13.scale
	end
end

local function var5_0(arg0_14)
	local var0_14 = {}
	local var1_14 = {}
	local var2_14 = {}
	local var3_14 = arg0_14.actions[1][2]
	local var4_14 = arg0_14.actions[1][3]

	for iter0_14, iter1_14 in ipairs(arg0_14.variedActions) do
		local var5_14 = iter1_14[math.random(1, #iter1_14)]

		table.insert(var0_14, var5_14)
		table.insert(var1_14, var4_14)
		table.insert(var2_14, var3_14)
	end

	return var0_14, var1_14, var2_14
end

local function var6_0(arg0_15)
	local var0_15 = {}
	local var1_15 = {}
	local var2_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.actions) do
		local var3_15 = iter1_15[1]
		local var4_15 = iter1_15[3]
		local var5_15 = type(var3_15) == "table" and var3_15[math.random(1, #var3_15)] or var3_15
		local var6_15 = arg0_15:GetOwnerSubstituteAction(var5_15)

		table.insert(var0_15, var6_15)

		local var7_15 = arg0_15:GetUserSubstituteAction(var4_15 or var5_15)

		table.insert(var1_15, var7_15)
		table.insert(var2_15, tobool(iter1_15[2]))
	end

	return var0_15, var1_15, var2_15
end

function var0_0.GetActions(arg0_16)
	local var0_16
	local var1_16
	local var2_16

	if arg0_16.preheatAction and type(arg0_16.preheatAction) == "string" then
		var0_16, var2_16 = arg0_16.preheatAction, false
	elseif arg0_16.preheatAction and type(arg0_16.preheatAction) == "table" then
		local var3_16 = {}

		if type(arg0_16.preheatAction[1]) == "table" then
			for iter0_16, iter1_16 in ipairs(arg0_16.preheatAction[1]) do
				table.insert(var3_16, iter1_16)
			end
		else
			table.insert(var3_16, arg0_16.preheatAction[1])
		end

		local var4_16 = 1
		local var5_16 = arg0_16:GetOwner()

		if isa(var5_16, CourtYardFurniture) then
			var4_16 = #var5_16:GetUsingSlots()
		end

		var0_16, var1_16, var2_16 = var3_16[var4_16], arg0_16.preheatAction[2], arg0_16.preheatAction[3]
	end

	local var6_16
	local var7_16
	local var8_16

	if arg0_16.strategyType == var4_0 then
		var6_16, var7_16, var8_16 = var5_0(arg0_16)
	else
		var6_16, var7_16, var8_16 = var6_0(arg0_16)
	end

	if var2_16 then
		var8_16[0] = true
	end

	return var6_16, var7_16, var8_16, var0_16, var1_16, arg0_16.tailAction
end

function var0_0.OnAwake(arg0_17)
	if #arg0_17.animators > 0 then
		arg0_17.animatorIndex = math.random(1, #arg0_17.animators)
	end
end

function var0_0.OnStart(arg0_18)
	arg0_18.updateStrategy:Update(arg0_18.loop)
end

function var0_0.OnContinue(arg0_19, arg1_19)
	arg0_19.updateStrategy:StepEnd(arg1_19)
end

function var0_0.Reset(arg0_20)
	arg0_20.updateStrategy:Reset()
end

function var0_0.GetSpineDefaultAction(arg0_21)
	return arg0_21.defaultAction
end

function var0_0.GetSpineMaskDefaultAcation(arg0_22)
	return arg0_22.maskDefaultAction
end

return var0_0
