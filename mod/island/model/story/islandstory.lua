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
	arg0_2.lookWeight = arg1_2.look_weight or {}

	assert(arg1_2.map, "请确保配置文件存在map字段" .. arg1_2.id)

	arg0_2.useUISpace = defaultValue(arg1_2.useUISpace, true)
	arg0_2.steps = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.scripts or {}) do
		local var0_2 = var0_0.GetStoryStepCls(arg3_2).New(iter1_2, arg0_2)

		table.insert(arg0_2.steps, var0_2)
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.steps) do
		local var1_2, var2_2 = arg0_2:GetUnitIdFromCharaId(iter3_2.characterId)

		iter3_2.unitId = var1_2
		iter3_2.unitType = var2_2
	end

	arg0_2.speedData = arg1_2.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	arg0_2.fadeIn = arg1_2.fadeIn or 0
	arg0_2.fadeOut = arg1_2.fadeOut or 0
	arg0_2.branchCode = nil
	arg0_2.isAuto = false
	arg0_2.speed = 0
	arg0_2.skipFlag = false
	arg0_2.followOffset = arg1_2.followOffset
	arg0_2.defultFollowOffset = Vector3(0, 1, 5)
	arg0_2.soloCamDir = defaultValue(arg1_2.cam_dir, 0) == 0
end

function var0_0.IsFacingWhenSolo(arg0_3)
	return arg0_3.soloCamDir
end

function var0_0.LastStepIsTimeline(arg0_4)
	local var0_4 = arg0_4.steps[#arg0_4.steps]

	if isa(var0_4, Dialogue3DStep) then
		return var0_4:IsTimeline()
	else
		return false
	end
end

function var0_0.GetFadeInTime(arg0_5)
	return arg0_5.fadeIn
end

function var0_0.GetFadeOutTime(arg0_6)
	return arg0_6.fadeOut
end

function var0_0.GetDefultFollowOffset(arg0_7)
	return arg0_7.defultFollowOffset
end

function var0_0.ShouldSetCamOffset(arg0_8)
	return arg0_8.followOffset ~= nil
end

function var0_0.GetFollowOffset(arg0_9)
	if not arg0_9:ShouldSetCamOffset() then
		return nil
	end

	return BuildVector3(arg0_9.followOffset)
end

function var0_0.SetAutoPlay(arg0_10)
	arg0_10.isAuto = true

	arg0_10:SetPlaySpeed(arg0_10.speedData)
end

function var0_0.StopAutoPlay(arg0_11)
	arg0_11.isAuto = false

	arg0_11:ResetSpeed()
end

function var0_0.GetAutoPlayFlag(arg0_12)
	return arg0_12.isAuto
end

function var0_0.UpdatePlaySpeed(arg0_13)
	local var0_13 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0_13:SetPlaySpeed(var0_13)
end

function var0_0.GetPlaySpeed(arg0_14)
	return arg0_14.speed
end

function var0_0.SetPlaySpeed(arg0_15, arg1_15)
	arg0_15.speed = arg1_15
end

function var0_0.ResetSpeed(arg0_16)
	arg0_16.speed = 0
end

function var0_0.GetTriggerDelayTime(arg0_17)
	local var0_17 = table.indexof(Story.STORY_AUTO_SPEED, arg0_17.speed)

	if var0_17 then
		return Story.TRIGGER_DELAY_TIME[var0_17] or 0
	end

	return 0
end

function var0_0.IsSkipAll(arg0_18)
	return arg0_18.skipFlag == true
end

function var0_0.MarkSkipAll(arg0_19)
	arg0_19.skipFlag = true
end

function var0_0.UnMarkSkipAll(arg0_20)
	arg0_20.skipFlag = false
end

function var0_0.GetStepByIndex(arg0_21, arg1_21)
	local var0_21 = arg0_21.steps[arg1_21]

	if not var0_21 or arg0_21.branchCode and not var0_21:IsSameBranch(arg0_21.branchCode) then
		return nil
	end

	return var0_21
end

function var0_0.SetBranchCode(arg0_22, arg1_22)
	arg0_22.branchCode = arg1_22
end

function var0_0.IsUseUISpace(arg0_23)
	return arg0_23.useUISpace
end

function var0_0.GetUnitIdFromCharaId(arg0_24, arg1_24)
	if not arg1_24 or arg1_24 == 0 then
		return 0, IslandConst.UNIT_LIST_OBJ
	end

	for iter0_24, iter1_24 in ipairs(arg0_24.unitMap) do
		local var0_24 = iter1_24[1]
		local var1_24 = iter1_24[2]
		local var2_24 = iter1_24[3] or IslandConst.UNIT_LIST_OBJ

		if var0_24 == arg1_24 then
			return var1_24, var2_24
		end
	end

	return 0, IslandConst.UNIT_LIST_OBJ
end

function var0_0.GetLookGroup(arg0_25)
	local var0_25 = {}
	local var1_25 = {}
	local var2_25 = {}

	for iter0_25, iter1_25 in ipairs(arg0_25.unitMap) do
		local var3_25 = arg0_25.lookWeight[iter0_25] or {}
		local var4_25 = arg0_25:GetRole({
			id = iter1_25[2],
			type = iter1_25[3] or IslandConst.UNIT_LIST_OBJ
		})

		if var4_25 then
			table.insert(var0_25, var4_25)
			table.insert(var1_25, var3_25[1] or 1)
			table.insert(var2_25, var3_25[2] or 0)
		end
	end

	local var5_25 = arg0_25:GetPlayerRole()

	if not table.contains(var0_25, var5_25) then
		table.insert(var0_25, var5_25)

		local var6_25 = arg0_25.lookWeight[#arg0_25.lookWeight] or {}

		table.insert(var1_25, var6_25[1] or 1)
		table.insert(var2_25, var6_25[2] or 0)
	end

	return var0_25, var1_25, var2_25
end

function var0_0.GetPlayerRole(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.unitList) do
		if isa(iter1_26, IslandPlayerUnit) then
			return iter1_26._go
		end
	end

	return nil
end

function var0_0.GetRole(arg0_27, arg1_27)
	local var0_27 = arg1_27.id
	local var1_27 = arg1_27.type

	if not var0_27 or var0_27 == 0 then
		return arg0_27:GetPlayerRole()
	end

	for iter0_27, iter1_27 in ipairs(arg0_27.unitList) do
		if var0_27 and iter1_27.id == var0_27 and iter1_27.unitType == var1_27 then
			return iter1_27._go
		end
	end

	return nil
end

function var0_0.GetUnitList(arg0_28)
	return arg0_28.unitList
end

function var0_0.IsFreeOp(arg0_29)
	return not arg0_29.lockOp
end

return var0_0
