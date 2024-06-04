local var0 = class("CourtYardFurnitureSpineSlot", import(".CourtYardFurnitureBaseSlot"))
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3

function var0.OnInit(arg0, arg1)
	arg0.name = arg1[1][1]
	arg0.defaultAction = arg1[1][2]
	arg0.mask = arg1[2] and arg1[2][1]

	if arg0.mask then
		arg0.maskDefaultAction = arg1[2][2]
	end

	arg0.bodyMask = arg1[4] and #arg1[4] > 0 and {
		offset = arg1[4][1] and Vector3(arg1[4][1][1], arg1[4][1][2], 0) or Vector3.zero,
		size = arg1[4][2] and Vector3(arg1[4][2][1], arg1[4][2][2], 0) or Vector3.zero,
		img = arg1[4][3]
	}
	arg0.offset = arg1[5] and Vector3(arg1[5][1], arg1[5][2], 0) or Vector3.zero
	arg0.scale = arg1[6] and Vector3(arg1[6][1], arg1[6][2], 0) or Vector3.one
	arg0.substituteActions = {}
	arg0.actions = {}
	arg0.loop = false
	arg0.vaild = tobool(arg1[3]) and tobool(arg1[3][3])

	if arg0.vaild then
		arg0.actions = arg1[3][2]

		local var0 = arg1[3][3][2] or var1

		if var0 == true then
			var0 = var2
		end

		if arg1[3][5] then
			var0 = var4
		end

		arg0.strategyType = var0
		arg0.updateStrategy = arg0:InitUpdateStrategy(var0)
		arg0.preheatAction = arg1[3][3][3]
		arg0.tailAction = arg1[3][3][4]
		arg0.loop = arg1[3][4][1] == 1
		arg0.variedActions = arg1[3][5]
	end
end

function var0.InitUpdateStrategy(arg0, arg1)
	local var0

	if arg1 == var2 then
		var0 = CourtYardFollowInteraction.New(arg0)
	elseif arg1 == var3 then
		var0 = CourtYardMonglineInteraction.New(arg0)
	elseif arg1 == var4 then
		var0 = CourtYardVariedInteraction.New(arg0)
	else
		var0 = CourtYardInteraction.New(arg0)
	end

	return var0
end

function var0.SetAnimators(arg0, arg1)
	local var0 = arg1[1]
	local var1 = var0[arg0.id] or var0[1] or {}
	local var2 = type(var1) == "string" and {
		var1
	} or var1

	for iter0, iter1 in ipairs(var2) do
		table.insert(arg0.animators, {
			key = arg0.id .. "_" .. iter0,
			value = iter1
		})
	end
end

function var0.SetFollower(arg0, arg1)
	arg0.follower = {
		bone = arg1[1],
		scale = Vector3(arg1[2], 1, 1)
	}
end

function var0.SetSubstitute(arg0, arg1)
	arg0.substituteActions = _.map(arg1, function(arg0)
		return {
			action = arg0[1],
			match = arg0[2],
			replace = arg0[3],
			replace_mode = arg0[4],
			math_mode = arg0[5]
		}
	end)
end

function var0.GetSubstituteAction(arg0, arg1, arg2)
	local function var0(arg0)
		local var0 = arg0:GetUser()
		local var1 = arg0.math_mode == 1 and var0:GetSkinID() or var0:GetGroupID()

		return table.contains(arg0.match, var1) and (arg0.replace_mode == 0 or arg0.replace_mode == arg2)
	end

	local var1 = _.detect(arg0.substituteActions, function(arg0)
		return arg0.action == arg1 and var0(arg0)
	end)

	return var1 and var1.replace or arg1
end

function var0.GetUserSubstituteAction(arg0, arg1)
	return arg0:GetSubstituteAction(arg1, 1)
end

function var0.GetOwnerSubstituteAction(arg0, arg1)
	return arg0:GetSubstituteAction(arg1, 2)
end

function var0.IsEmpty(arg0)
	return var0.super.IsEmpty(arg0) and arg0.vaild
end

function var0.GetScale(arg0)
	if arg0.follower then
		return arg0.follower.scale
	else
		return arg0.scale
	end
end

local function var5(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = {}
	local var3 = arg0.actions[1][2]
	local var4 = arg0.actions[1][3]

	for iter0, iter1 in ipairs(arg0.variedActions) do
		local var5 = iter1[math.random(1, #iter1)]

		table.insert(var0, var5)
		table.insert(var1, var4)
		table.insert(var2, var3)
	end

	return var0, var1, var2
end

local function var6(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(arg0.actions) do
		local var3 = iter1[1]
		local var4 = iter1[3]
		local var5 = type(var3) == "table" and var3[math.random(1, #var3)] or var3
		local var6 = arg0:GetOwnerSubstituteAction(var5)

		table.insert(var0, var6)

		local var7 = arg0:GetUserSubstituteAction(var4 or var5)

		table.insert(var1, var7)
		table.insert(var2, tobool(iter1[2]))
	end

	return var0, var1, var2
end

function var0.GetActions(arg0)
	local var0
	local var1

	if arg0.preheatAction and type(arg0.preheatAction) == "string" then
		var0 = arg0.preheatAction
	elseif arg0.preheatAction and type(arg0.preheatAction) == "table" then
		var0, var1 = arg0.preheatAction[1], arg0.preheatAction[2]
	end

	local var2
	local var3
	local var4

	if arg0.strategyType == var4 then
		var2, var3, var4 = var5(arg0)
	else
		var2, var3, var4 = var6(arg0)
	end

	return var2, var3, var4, var0, var1, arg0.tailAction
end

function var0.OnAwake(arg0)
	if #arg0.animators > 0 then
		arg0.animatorIndex = math.random(1, #arg0.animators)
	end
end

function var0.OnStart(arg0)
	arg0.updateStrategy:Update(arg0.loop)
end

function var0.OnContinue(arg0, arg1)
	arg0.updateStrategy:StepEnd(arg1)
end

function var0.Reset(arg0)
	arg0.updateStrategy:Reset()
end

function var0.GetSpineDefaultAction(arg0)
	return arg0.defaultAction
end

function var0.GetSpineMaskDefaultAcation(arg0)
	return arg0.maskDefaultAction
end

return var0
