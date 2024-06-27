local var0_0 = class("Story")

var0_0.MODE_ASIDE = 1
var0_0.MODE_DIALOGUE = 2
var0_0.MODE_BG = 3
var0_0.MODE_CAROUSE = 4
var0_0.MODE_VEDIO = 5
var0_0.MODE_CAST = 6
var0_0.STORY_AUTO_SPEED = {
	-9,
	0,
	5,
	9
}
var0_0.TRIGGER_DELAY_TIME = {
	4,
	3,
	1.5,
	0
}

function var0_0.GetStoryStepCls(arg0_1)
	return ({
		AsideStep,
		DialogueStep,
		BgStep,
		CarouselStep,
		VedioStep,
		CastStep
	})[arg0_1]
end

var0_0.PLAYER = 2
var0_0.TB = 4
var0_0.PlaceholderMap = {
	playername = var0_0.PLAYER,
	tb = var0_0.TB
}

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	arg0_2.name = arg1_2.id
	arg0_2.mode = arg1_2.mode
	arg0_2.once = arg1_2.once
	arg0_2.fadeOut = arg1_2.fadeOut
	arg0_2.hideSkip = defaultValue(arg1_2.hideSkip, false)
	arg0_2.skipTip = defaultValue(arg1_2.skipTip, true)
	arg0_2.noWaitFade = defaultValue(arg1_2.noWaitFade, false)
	arg0_2.dialogueBox = arg1_2.dialogbox or 1
	arg0_2.defaultTb = arg1_2.defaultTb
	arg0_2.placeholder = 0

	for iter0_2, iter1_2 in ipairs(arg1_2.placeholder or {}) do
		local var0_2 = var0_0.PlaceholderMap[iter1_2] or 0

		assert(var0_2 > 0, iter1_2)

		arg0_2.placeholder = bit.bor(arg0_2.placeholder, var0_2)
	end

	arg0_2.hideRecord = defaultValue(arg1_2.hideRecord, false)
	arg0_2.hideAutoBtn = defaultValue(arg1_2.hideAuto, false)
	arg0_2.storyAlpha = defaultValue(arg1_2.alpha, 0.568)

	if UnGamePlayState then
		arg0_2.speedData = arg1_2.speed or 0
	else
		arg0_2.speedData = arg1_2.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	end

	arg0_2.steps = {}

	local var1_2 = 0
	local var2_2 = arg3_2 or {}
	local var3_2 = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.scripts or {}) do
		local var4_2 = iter3_2.mode or arg0_2.mode
		local var5_2 = var0_0.GetStoryStepCls(var4_2).New(iter3_2)

		var5_2:SetId(iter2_2)
		var5_2:SetPlaceholderType(arg0_2:GetPlaceholder())
		var5_2:SetDefaultTb(arg0_2.defaultTb)

		if var5_2:ExistOption() then
			var1_2 = var1_2 + 1

			var5_2:SetOptionIndex(var1_2)

			if var2_2[var1_2] then
				var5_2:SetOptionSelCodes(var2_2[var1_2])
			end

			if arg4_2 then
				var5_2.important = true
			end

			table.insert(var3_2, iter2_2)

			if arg5_2 then
				var5_2:AutoShowOption()
			end
		end

		table.insert(arg0_2.steps, var5_2)
	end

	if #arg0_2.steps > 0 then
		table.insert(var3_2, #arg0_2.steps)
	end

	arg0_2:HandleRecallOptions(var3_2)

	arg0_2.branchCode = nil
	arg0_2.force = arg2_2

	if UnGamePlayState then
		arg0_2.isPlayed = false
	else
		arg0_2.isPlayed = pg.NewStoryMgr:GetInstance():IsPlayed(arg0_2.name)
	end

	arg0_2.nextScriptName = nil
	arg0_2.skipAll = false
	arg0_2.isAuto = false
	arg0_2.speed = 0
end

function var0_0.HandleRecallOptions(arg0_3, arg1_3)
	local function var0_3(arg0_4, arg1_4)
		local var0_4 = arg0_3.steps[arg0_4]
		local var1_4 = {}

		for iter0_4 = arg0_4, arg1_4 do
			local var2_4 = arg0_3.steps[iter0_4]

			table.insert(var1_4, var2_4)
		end

		local var3_4 = var0_4:GetOptionCnt()

		return {
			var1_4,
			var3_4,
			arg1_4,
			arg0_4
		}
	end

	local function var1_3(arg0_5)
		for iter0_5 = arg0_5, 1, -1 do
			local var0_5 = arg0_3.steps[iter0_5]

			if var0_5 and var0_5.branchCode ~= nil then
				return iter0_5
			end
		end

		assert(false)
	end

	local var2_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		if arg0_3.steps[iter1_3]:IsRecallOption() then
			local var3_3 = iter1_3
			local var4_3 = arg1_3[iter0_3 + 1]

			if var3_3 and var4_3 then
				local var5_3 = var1_3(var4_3)

				table.insert(var2_3, var0_3(var3_3, var5_3))
			end
		end
	end

	local var6_3 = 0

	for iter2_3, iter3_3 in ipairs(var2_3) do
		local var7_3 = iter3_3[1]
		local var8_3 = iter3_3[2]
		local var9_3 = iter3_3[3]
		local var10_3 = iter3_3[4]

		for iter4_3 = 1, var8_3 - 1 do
			local var11_3 = var9_3 + var6_3

			for iter5_3, iter6_3 in ipairs(var7_3) do
				local var12_3 = Clone(iter6_3)

				var12_3:SetId(var10_3)
				table.insert(arg0_3.steps, var11_3 + iter5_3, var12_3)
			end
		end

		var6_3 = var6_3 + (var8_3 - 1) * #var7_3
	end
end

function var0_0.GetPlaceholder(arg0_6)
	return arg0_6.placeholder
end

function var0_0.ShouldReplaceContent(arg0_7)
	return arg0_7.placeholder > 0
end

function var0_0.GetStoryAlpha(arg0_8)
	return arg0_8.storyAlpha
end

function var0_0.ShouldHideAutoBtn(arg0_9)
	return arg0_9.hideAutoBtn
end

function var0_0.ShouldHideRecord(arg0_10)
	return arg0_10.hideRecord
end

function var0_0.GetDialogueStyleName(arg0_11)
	return arg0_11.dialogueBox
end

function var0_0.IsDialogueStyle2(arg0_12)
	return arg0_12:GetDialogueStyleName() == 2
end

function var0_0.GetTriggerDelayTime(arg0_13)
	local var0_13 = table.indexof(var0_0.STORY_AUTO_SPEED, arg0_13.speed)

	if var0_13 then
		return var0_0.TRIGGER_DELAY_TIME[var0_13] or 0
	end

	return 0
end

function var0_0.SetAutoPlay(arg0_14)
	arg0_14.isAuto = true

	arg0_14:SetPlaySpeed(arg0_14.speedData)
end

function var0_0.UpdatePlaySpeed(arg0_15)
	local var0_15 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0_15:SetPlaySpeed(var0_15)
end

function var0_0.GetPlaySpeed(arg0_16)
	return arg0_16.speed
end

function var0_0.StopAutoPlay(arg0_17)
	arg0_17.isAuto = false

	arg0_17:ResetSpeed()
end

function var0_0.SetPlaySpeed(arg0_18, arg1_18)
	arg0_18.speed = arg1_18
end

function var0_0.ResetSpeed(arg0_19)
	arg0_19.speed = 0
end

function var0_0.GetPlaySpeed(arg0_20)
	return arg0_20.speed
end

function var0_0.GetAutoPlayFlag(arg0_21)
	return arg0_21.isAuto
end

function var0_0.ShowSkipTip(arg0_22)
	return arg0_22.skipTip
end

function var0_0.ShouldWaitFadeout(arg0_23)
	return not arg0_23.noWaitFade
end

function var0_0.ShouldHideSkip(arg0_24)
	return arg0_24.hideSkip
end

function var0_0.CanPlay(arg0_25)
	return arg0_25.force or not arg0_25.isPlayed
end

function var0_0.GetId(arg0_26)
	return arg0_26.name
end

function var0_0.GetName(arg0_27)
	return arg0_27.name
end

function var0_0.GetStepByIndex(arg0_28, arg1_28)
	local var0_28 = arg0_28.steps[arg1_28]

	if not var0_28 or arg0_28.branchCode and not var0_28:IsSameBranch(arg0_28.branchCode) then
		return nil
	end

	return var0_28
end

function var0_0.GetNextStep(arg0_29, arg1_29)
	if arg1_29 >= #arg0_29.steps then
		return nil
	end

	local var0_29 = arg1_29 + 1
	local var1_29 = arg0_29:GetStepByIndex(var0_29)

	if not var1_29 and var0_29 < #arg0_29.steps then
		return arg0_29:GetNextStep(var0_29)
	else
		return var1_29
	end
end

function var0_0.GetPrevStep(arg0_30, arg1_30)
	if arg1_30 <= 1 then
		return nil
	end

	local var0_30 = arg1_30 - 1
	local var1_30 = arg0_30:GetStepByIndex(var0_30)

	if not var1_30 and var0_30 > 1 then
		return arg0_30:GetPrevStep(var0_30)
	else
		return var1_30
	end
end

function var0_0.ShouldFadeout(arg0_31)
	return arg0_31.fadeOut ~= nil
end

function var0_0.GetFadeoutTime(arg0_32)
	return arg0_32.fadeOut
end

function var0_0.IsPlayed(arg0_33)
	return arg0_33.isPlayed
end

function var0_0.SetBranchCode(arg0_34, arg1_34)
	arg0_34.branchCode = arg1_34
end

function var0_0.GetBranchCode(arg0_35)
	return arg0_35.branchCode
end

function var0_0.GetNextScriptName(arg0_36)
	return arg0_36.nextScriptName
end

function var0_0.SetNextScriptName(arg0_37, arg1_37)
	arg0_37.nextScriptName = arg1_37
end

function var0_0.SkipAll(arg0_38)
	arg0_38.skipAll = true
end

function var0_0.StopSkip(arg0_39)
	arg0_39.skipAll = false
end

function var0_0.ShouldSkipAll(arg0_40)
	return arg0_40.skipAll
end

function var0_0.GetUsingPaintingNames(arg0_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg0_41.steps) do
		local var1_41 = iter1_41:GetUsingPaintingNames()

		for iter2_41, iter3_41 in ipairs(var1_41) do
			var0_41[iter3_41] = true
		end
	end

	local var2_41 = {}

	for iter4_41, iter5_41 in pairs(var0_41) do
		table.insert(var2_41, iter4_41)
	end

	return var2_41
end

function var0_0.GetAllStepDispatcherRecallName(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg0_42.steps) do
		local var1_42 = iter1_42:GetDispatcherRecallName()

		if var1_42 then
			var0_42[var1_42] = true
		end
	end

	local var2_42 = {}

	for iter2_42, iter3_42 in pairs(var0_42) do
		table.insert(var2_42, iter2_42)
	end

	return var2_42
end

return var0_0
