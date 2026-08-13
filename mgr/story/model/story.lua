local var0_0 = class("Story")

var0_0.MODE_ASIDE = 1
var0_0.MODE_DIALOGUE = 2
var0_0.MODE_BG = 3
var0_0.MODE_CAROUSE = 4
var0_0.MODE_VEDIO = 5
var0_0.MODE_CAST = 6
var0_0.MODE_SPANIM = 7
var0_0.MODE_BLINK = 8
var0_0.MODE_TDDIALOGUE = 9
var0_0.MODE_SUBPAGE = 10
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
		CastStep,
		SpAnimStep,
		BlinkStep,
		TDDialogueStep,
		SubPageStep
	})[arg0_1]
end

var0_0.PLAYER = 2
var0_0.TB = 4
var0_0.DORM = 8
var0_0.CAR2026 = 16
var0_0.PlaceholderMap = {
	playername = var0_0.PLAYER,
	tb = var0_0.TB,
	dorm3d = var0_0.DORM,
	car2026 = var0_0.CAR2026
}
var0_0.PLAY_TYPE_STORY = 1
var0_0.PLAY_TYPE_BUBBLE = 2

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2)
	arg0_2.name = arg1_2.id
	arg0_2.mode = arg1_2.mode
	arg0_2.playType = arg1_2.playType or var0_0.PLAY_TYPE_STORY
	arg0_2.once = arg1_2.once
	arg0_2.fadeOut = arg1_2.fadeOut
	arg0_2.hideSkip = defaultValue(arg1_2.hideSkip, false)
	arg0_2.skipTip = defaultValue(arg1_2.skipTip, true)
	arg0_2.noWaitFade = defaultValue(arg1_2.noWaitFade, false)
	arg0_2.dialogueBox = arg1_2.dialogbox or 1
	arg0_2.interaction = defaultValue(arg1_2.interaction, false)
	arg0_2.defaultTb = arg1_2.defaultTb
	arg0_2.placeholder = 0

	for iter0_2, iter1_2 in ipairs(arg1_2.placeholder or {}) do
		local var0_2 = var0_0.PlaceholderMap[iter1_2] or 0

		assert(var0_2 > 0, iter1_2)

		arg0_2.placeholder = bit.bor(arg0_2.placeholder, var0_2)
	end

	arg0_2.hideRecord = defaultValue(arg1_2.hideRecord, false)
	arg0_2.hideAutoBtn = defaultValue(arg1_2.hideAuto, false)

	if arg0_2:IsTDDMode() then
		arg0_2.storyAlpha = defaultValue(arg1_2.alpha, 0)
	else
		arg0_2.storyAlpha = defaultValue(arg1_2.alpha, 0.568)
	end

	if UnGamePlayState then
		arg0_2.speedData = arg1_2.speed or 0
	else
		arg0_2.speedData = arg1_2.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	end

	arg0_2.steps = {}

	local var1_2 = 0
	local var2_2 = arg3_2 or {}
	local var3_2 = {}

	arg0_2.globalOptionBranchJump = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.scripts or {}) do
		local var4_2 = iter3_2.mode or arg0_2.mode
		local var5_2 = var0_0.GetStoryStepCls(var4_2).New(iter3_2)

		if var5_2:IsValid(arg6_2) then
			if var5_2:IsDialogueMode() and arg0_2:IsDialogueStyle2() then
				var5_2:SetDefaultSide()
			end

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

		if iter3_2.globalOptionFlag and iter3_2.jumpto then
			table.insert(arg0_2.globalOptionBranchJump, iter3_2.jumpto)
		end
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
		arg0_2.isPlayed = pg.NewStoryMgr.GetInstance():IsPlayed(arg0_2.name)
	end

	arg0_2.nextScriptName = nil
	arg0_2.skipAll = false
	arg0_2.isAuto = false
	arg0_2.speed = 0
end

function var0_0.IsTDDMode(arg0_3)
	return arg0_3.mode and arg0_3.mode == var0_0.MODE_TDDIALOGUE
end

function var0_0.GetPlayType(arg0_4)
	return arg0_4.playType
end

function var0_0.IsBubbleType(arg0_5)
	return arg0_5.playType == var0_0.PLAY_TYPE_BUBBLE
end

function var0_0.CanInteraction(arg0_6)
	return arg0_6.interaction
end

function var0_0.HandleRecallOptions(arg0_7, arg1_7)
	local function var0_7(arg0_8, arg1_8)
		local var0_8 = arg0_7.steps[arg0_8]
		local var1_8 = {}

		for iter0_8 = arg0_8, arg1_8 do
			local var2_8 = arg0_7.steps[iter0_8]

			table.insert(var1_8, var2_8)
		end

		local var3_8 = var0_8:GetOptionCnt()

		return {
			var1_8,
			var3_8,
			arg1_8,
			arg0_8
		}
	end

	local function var1_7(arg0_9)
		for iter0_9 = arg0_9, 1, -1 do
			local var0_9 = arg0_7.steps[iter0_9]

			if var0_9 and var0_9.branchCode ~= nil then
				return iter0_9
			end
		end

		assert(false)
	end

	local var2_7 = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		if arg0_7.steps[iter1_7]:IsRecallOption() then
			local var3_7 = iter1_7
			local var4_7 = arg1_7[iter0_7 + 1]

			if var3_7 and var4_7 then
				local var5_7 = var1_7(var4_7)

				table.insert(var2_7, var0_7(var3_7, var5_7))
			end
		end
	end

	local var6_7 = 0

	for iter2_7, iter3_7 in ipairs(var2_7) do
		local var7_7 = iter3_7[1]
		local var8_7 = iter3_7[2]
		local var9_7 = iter3_7[3]
		local var10_7 = iter3_7[4]

		for iter4_7 = 1, var8_7 - 1 do
			local var11_7 = var9_7 + var6_7

			for iter5_7, iter6_7 in ipairs(var7_7) do
				local var12_7 = Clone(iter6_7)

				var12_7:SetId(var10_7)
				table.insert(arg0_7.steps, var11_7 + iter5_7, var12_7)
			end
		end

		var6_7 = var6_7 + (var8_7 - 1) * #var7_7
	end
end

function var0_0.GetPlaceholder(arg0_10)
	return arg0_10.placeholder
end

function var0_0.ShouldReplaceContent(arg0_11)
	return arg0_11.placeholder > 0
end

function var0_0.GetStoryAlpha(arg0_12)
	return arg0_12.storyAlpha
end

function var0_0.ShouldHideAutoBtn(arg0_13)
	return arg0_13.hideAutoBtn
end

function var0_0.ShouldHideRecord(arg0_14)
	return arg0_14.hideRecord
end

function var0_0.GetDialogueStyleName(arg0_15)
	return arg0_15.dialogueBox
end

function var0_0.IsDialogueStyle2(arg0_16)
	return arg0_16:GetDialogueStyleName() == 2
end

function var0_0.GetAnimPrefix(arg0_17)
	return switch(arg0_17:GetDialogueStyleName(), {
		function()
			return "anim_storydialogue_optiontpl_"
		end,
		function()
			return "anim_newstory_dialogue2_"
		end
	})
end

function var0_0.GetTriggerDelayTime(arg0_20)
	local var0_20 = table.indexof(var0_0.STORY_AUTO_SPEED, arg0_20.speed)

	if var0_20 then
		return var0_0.TRIGGER_DELAY_TIME[var0_20] or 0
	end

	return 0
end

function var0_0.SetAutoPlay(arg0_21)
	arg0_21.isAuto = true

	arg0_21:SetPlaySpeed(arg0_21.speedData)
end

function var0_0.UpdatePlaySpeed(arg0_22)
	local var0_22 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0_22:SetPlaySpeed(var0_22)
end

function var0_0.GetPlaySpeed(arg0_23)
	return arg0_23.speed
end

function var0_0.StopAutoPlay(arg0_24)
	arg0_24.isAuto = false

	arg0_24:ResetSpeed()
end

function var0_0.SetPlaySpeed(arg0_25, arg1_25)
	arg0_25.speed = arg1_25
end

function var0_0.ResetSpeed(arg0_26)
	arg0_26.speed = 0
end

function var0_0.GetPlaySpeed(arg0_27)
	return arg0_27.speed
end

function var0_0.GetAutoPlayFlag(arg0_28)
	return arg0_28.isAuto
end

function var0_0.ShowSkipTip(arg0_29)
	return arg0_29.skipTip
end

function var0_0.ShouldWaitFadeout(arg0_30)
	return not arg0_30.noWaitFade
end

function var0_0.ShouldHideSkip(arg0_31)
	return arg0_31.hideSkip
end

function var0_0.CanPlay(arg0_32)
	return arg0_32.force or not arg0_32.isPlayed
end

function var0_0.GetId(arg0_33)
	return arg0_33.name
end

function var0_0.GetName(arg0_34)
	return arg0_34.name
end

function var0_0.GetStepByIndex(arg0_35, arg1_35)
	local var0_35 = arg0_35.steps[arg1_35]

	if not var0_35 or arg0_35.branchCode and not var0_35:IsSameBranch(arg0_35.branchCode) or var0_35.globalBranchCode and not var0_35:IsGlobalFlagHit() then
		return nil
	end

	return var0_35
end

function var0_0.GetNextStep(arg0_36, arg1_36)
	if arg1_36 >= #arg0_36.steps then
		return nil
	end

	local var0_36 = arg1_36 + 1
	local var1_36 = arg0_36:GetStepByIndex(var0_36)

	if not var1_36 and var0_36 < #arg0_36.steps then
		return arg0_36:GetNextStep(var0_36)
	else
		return var1_36
	end
end

function var0_0.GetPrevStep(arg0_37, arg1_37)
	if arg1_37 <= 1 then
		return nil
	end

	local var0_37 = arg1_37 - 1
	local var1_37 = arg0_37:GetStepByIndex(var0_37)

	if not var1_37 and var0_37 > 1 then
		return arg0_37:GetPrevStep(var0_37)
	else
		return var1_37
	end
end

function var0_0.ShouldFadeout(arg0_38)
	return arg0_38.fadeOut ~= nil
end

function var0_0.GetFadeoutTime(arg0_39)
	return arg0_39.fadeOut
end

function var0_0.IsPlayed(arg0_40)
	return arg0_40.isPlayed
end

function var0_0.SetBranchCode(arg0_41, arg1_41)
	arg0_41.branchCode = arg1_41
end

function var0_0.GetBranchCode(arg0_42)
	return arg0_42.branchCode
end

function var0_0.GetNextScriptName(arg0_43)
	return arg0_43.nextScriptName
end

function var0_0.SetNextScriptName(arg0_44, arg1_44)
	arg0_44.nextScriptName = arg1_44
end

function var0_0.SkipAll(arg0_45)
	arg0_45.skipAll = true
end

function var0_0.StopSkip(arg0_46)
	arg0_46.skipAll = false
end

function var0_0.ShouldSkipAll(arg0_47)
	return arg0_47.skipAll
end

function var0_0.GetUsingPaintingNames(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs(arg0_48.steps) do
		local var1_48 = iter1_48:GetUsingPaintingNames()

		for iter2_48, iter3_48 in ipairs(var1_48) do
			var0_48[iter3_48] = true
		end
	end

	local var2_48 = {}

	for iter4_48, iter5_48 in pairs(var0_48) do
		table.insert(var2_48, iter4_48)
	end

	return var2_48
end

function var0_0.GetAllStepDispatcherRecallName(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(arg0_49.steps) do
		local var1_49 = iter1_49:GetDispatcherRecallName()

		if var1_49 then
			var0_49[var1_49] = true
		end
	end

	local var2_49 = {}

	for iter2_49, iter3_49 in pairs(var0_49) do
		table.insert(var2_49, iter2_49)
	end

	return var2_49
end

function var0_0.GlobalOptionBranch(arg0_50)
	return arg0_50.globalOptionBranchJump
end

return var0_0
