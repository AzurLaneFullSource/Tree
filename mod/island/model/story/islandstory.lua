local var0_0 = class("IslandStory")

var0_0.MODE_BUBBLE = 9
var0_0.MODE_DIALOGUE = 10

function var0_0.GetStoryStepCls(arg0_1)
	return ({
		[var0_0.MODE_BUBBLE] = BubbleStep,
		[var0_0.MODE_DIALOGUE] = Dialogue3DStep
	})[arg0_1]
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.id = arg1_2.id
	arg0_2.unitList = arg2_2 or {}
	arg0_2.lockOp = defaultValue(arg1_2.lockOp, false)
	arg0_2.unitMap = arg1_2.map or {}

	assert(arg1_2.map, "请确保配置文件存在map字段" .. arg1_2.id)

	arg0_2.useUISpace = defaultValue(arg1_2.useUISpace, true)
	arg0_2.steps = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.scripts or {}) do
		local var0_2 = var0_0.GetStoryStepCls(arg3_2).New(iter1_2)

		table.insert(arg0_2.steps, var0_2)
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.steps) do
		iter3_2.unitId = arg0_2:GetUnitIdFromCharaId(iter3_2.characterId)
	end

	arg0_2.speedData = arg1_2.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	arg0_2.branchCode = nil
	arg0_2.isAuto = false
	arg0_2.speed = 0
	arg0_2.skipFlag = false
end

function var0_0.SetAutoPlay(arg0_3)
	arg0_3.isAuto = true

	arg0_3:SetPlaySpeed(arg0_3.speedData)
end

function var0_0.StopAutoPlay(arg0_4)
	arg0_4.isAuto = false

	arg0_4:ResetSpeed()
end

function var0_0.GetAutoPlayFlag(arg0_5)
	return arg0_5.isAuto
end

function var0_0.UpdatePlaySpeed(arg0_6)
	local var0_6 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0_6:SetPlaySpeed(var0_6)
end

function var0_0.GetPlaySpeed(arg0_7)
	return arg0_7.speed
end

function var0_0.SetPlaySpeed(arg0_8, arg1_8)
	arg0_8.speed = arg1_8
end

function var0_0.ResetSpeed(arg0_9)
	arg0_9.speed = 0
end

function var0_0.GetTriggerDelayTime(arg0_10)
	local var0_10 = table.indexof(Story.STORY_AUTO_SPEED, arg0_10.speed)

	if var0_10 then
		return Story.TRIGGER_DELAY_TIME[var0_10] or 0
	end

	return 0
end

function var0_0.IsSkipAll(arg0_11)
	return arg0_11.skipFlag == true
end

function var0_0.MarkSkipAll(arg0_12)
	arg0_12.skipFlag = true
end

function var0_0.GetStepByIndex(arg0_13, arg1_13)
	local var0_13 = arg0_13.steps[arg1_13]

	if not var0_13 or arg0_13.branchCode and not var0_13:IsSameBranch(arg0_13.branchCode) then
		return nil
	end

	return var0_13
end

function var0_0.SetBranchCode(arg0_14, arg1_14)
	arg0_14.branchCode = arg1_14
end

function var0_0.IsUseUISpace(arg0_15)
	return arg0_15.useUISpace
end

function var0_0.GetUnitIdFromCharaId(arg0_16, arg1_16)
	if not arg1_16 then
		return 0
	end

	for iter0_16, iter1_16 in ipairs(arg0_16.unitMap) do
		local var0_16 = iter1_16[1]
		local var1_16 = iter1_16[2]

		if var0_16 == arg1_16 then
			return var1_16
		end
	end

	return 0
end

function var0_0.GetLookGroup(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.unitMap) do
		local var1_17 = arg0_17:GetRole(iter1_17[2])

		if var1_17 then
			table.insert(var0_17, var1_17)
		end
	end

	local var2_17 = arg0_17:GetPlayerRole()

	if not table.contains(var0_17, var2_17) then
		table.insert(var0_17, var2_17)
	end

	return var0_17
end

function var0_0.GetPlayerRole(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.unitList) do
		if isa(iter1_18, IslandPlayerUnit) then
			return iter1_18._go
		end
	end

	return nil
end

function var0_0.GetRole(arg0_19, arg1_19)
	if not arg1_19 or arg1_19 == 0 then
		return arg0_19:GetPlayerRole()
	end

	for iter0_19, iter1_19 in ipairs(arg0_19.unitList) do
		if arg1_19 and iter1_19.id == arg1_19 then
			return iter1_19._go
		end
	end

	return nil
end

function var0_0.GetUnitList(arg0_20)
	return arg0_20.unitList
end

function var0_0.IsFreeOp(arg0_21)
	return not arg0_21.lockOp
end

return var0_0
