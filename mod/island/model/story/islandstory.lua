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

function var0_0.ContainerPlayer(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.steps) do
		if not iter1_3.characterId or iter1_3.characterId == 0 then
			return true
		end
	end

	return false
end

function var0_0.IsFacingWhenSolo(arg0_4)
	return arg0_4.soloCamDir
end

function var0_0.LastStepIsTimeline(arg0_5)
	local var0_5 = arg0_5.steps[#arg0_5.steps]

	if isa(var0_5, Dialogue3DStep) then
		return var0_5:IsTimeline()
	else
		return false
	end
end

function var0_0.GetFadeInTime(arg0_6)
	return arg0_6.fadeIn
end

function var0_0.GetFadeOutTime(arg0_7)
	return arg0_7.fadeOut
end

function var0_0.GetDefultFollowOffset(arg0_8)
	return arg0_8.defultFollowOffset
end

function var0_0.ShouldSetCamOffset(arg0_9)
	return arg0_9.followOffset ~= nil
end

function var0_0.GetFollowOffset(arg0_10)
	if not arg0_10:ShouldSetCamOffset() then
		return nil
	end

	return BuildVector3(arg0_10.followOffset)
end

function var0_0.SetAutoPlay(arg0_11)
	arg0_11.isAuto = true

	arg0_11:SetPlaySpeed(arg0_11.speedData)
end

function var0_0.StopAutoPlay(arg0_12)
	arg0_12.isAuto = false

	arg0_12:ResetSpeed()
end

function var0_0.GetAutoPlayFlag(arg0_13)
	return arg0_13.isAuto
end

function var0_0.UpdatePlaySpeed(arg0_14)
	local var0_14 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0_14:SetPlaySpeed(var0_14)
end

function var0_0.GetPlaySpeed(arg0_15)
	return arg0_15.speed
end

function var0_0.SetPlaySpeed(arg0_16, arg1_16)
	arg0_16.speed = arg1_16
end

function var0_0.ResetSpeed(arg0_17)
	arg0_17.speed = 0
end

function var0_0.GetTriggerDelayTime(arg0_18)
	local var0_18 = table.indexof(Story.STORY_AUTO_SPEED, arg0_18.speed)

	if var0_18 then
		return Story.TRIGGER_DELAY_TIME[var0_18] or 0
	end

	return 0
end

function var0_0.IsSkipAll(arg0_19)
	return arg0_19.skipFlag == true
end

function var0_0.MarkSkipAll(arg0_20)
	arg0_20.skipFlag = true
end

function var0_0.UnMarkSkipAll(arg0_21)
	arg0_21.skipFlag = false
end

function var0_0.GetStepByIndex(arg0_22, arg1_22)
	local var0_22 = arg0_22.steps[arg1_22]

	if not var0_22 or arg0_22.branchCode and not var0_22:IsSameBranch(arg0_22.branchCode) then
		return nil
	end

	return var0_22
end

function var0_0.SetBranchCode(arg0_23, arg1_23)
	arg0_23.branchCode = arg1_23
end

function var0_0.IsUseUISpace(arg0_24)
	return arg0_24.useUISpace
end

function var0_0.GetUnitIdFromCharaId(arg0_25, arg1_25)
	if not arg1_25 or arg1_25 == 0 then
		return 0, IslandConst.UNIT_LIST_OBJ
	end

	for iter0_25, iter1_25 in ipairs(arg0_25.unitMap) do
		local var0_25 = iter1_25[1]
		local var1_25 = iter1_25[2]
		local var2_25 = iter1_25[3] or IslandConst.UNIT_LIST_OBJ

		if var0_25 == arg1_25 then
			return var1_25, var2_25
		end
	end

	return 0, IslandConst.UNIT_LIST_OBJ
end

function var0_0.GetLookGroup(arg0_26)
	local var0_26 = {}
	local var1_26 = {}
	local var2_26 = {}

	for iter0_26, iter1_26 in ipairs(arg0_26.unitMap) do
		local var3_26 = arg0_26.lookWeight[iter0_26] or {}
		local var4_26 = arg0_26:GetRole({
			id = iter1_26[2],
			type = iter1_26[3] or IslandConst.UNIT_LIST_OBJ
		})

		if var4_26 then
			table.insert(var0_26, var4_26)
			table.insert(var1_26, var3_26[1] or 1)
			table.insert(var2_26, var3_26[2] or 0)
		end
	end

	local var5_26 = arg0_26:GetPlayerRole()

	if not table.contains(var0_26, var5_26) then
		table.insert(var0_26, var5_26)

		local var6_26 = arg0_26.lookWeight[#arg0_26.lookWeight] or {}

		table.insert(var1_26, var6_26[1] or 1)
		table.insert(var2_26, var6_26[2] or 0)
	end

	return var0_26, var1_26, var2_26
end

function var0_0.GetPlayerRole(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.unitList) do
		if isa(iter1_27, IslandPlayerUnit) then
			return iter1_27._go
		end
	end

	return nil
end

function var0_0.GetRole(arg0_28, arg1_28)
	local var0_28 = arg1_28.id
	local var1_28 = arg1_28.type

	if not var0_28 or var0_28 == 0 then
		return arg0_28:GetPlayerRole()
	end

	for iter0_28, iter1_28 in ipairs(arg0_28.unitList) do
		if var0_28 and iter1_28.id == var0_28 and iter1_28.unitType == var1_28 then
			return iter1_28._go
		end
	end

	return nil
end

function var0_0.GetUnitList(arg0_29)
	return arg0_29.unitList
end

function var0_0.IsFreeOp(arg0_30)
	return not arg0_30.lockOp
end

return var0_0
