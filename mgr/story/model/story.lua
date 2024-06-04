local var0 = class("Story")

var0.MODE_ASIDE = 1
var0.MODE_DIALOGUE = 2
var0.MODE_BG = 3
var0.MODE_CAROUSE = 4
var0.MODE_VEDIO = 5
var0.MODE_CAST = 6
var0.STORY_AUTO_SPEED = {
	-9,
	0,
	5,
	9
}
var0.TRIGGER_DELAY_TIME = {
	4,
	3,
	1.5,
	0
}

function var0.GetStoryStepCls(arg0)
	return ({
		AsideStep,
		DialogueStep,
		BgStep,
		CarouselStep,
		VedioStep,
		CastStep
	})[arg0]
end

var0.PLAYER = 2
var0.TB = 4
var0.PlaceholderMap = {
	playername = var0.PLAYER,
	tb = var0.TB
}

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.name = arg1.id
	arg0.mode = arg1.mode
	arg0.once = arg1.once
	arg0.fadeOut = arg1.fadeOut
	arg0.hideSkip = defaultValue(arg1.hideSkip, false)
	arg0.skipTip = defaultValue(arg1.skipTip, true)
	arg0.noWaitFade = defaultValue(arg1.noWaitFade, false)
	arg0.dialogueBox = arg1.dialogbox or 1
	arg0.defaultTb = arg1.defaultTb
	arg0.placeholder = 0

	for iter0, iter1 in ipairs(arg1.placeholder or {}) do
		local var0 = var0.PlaceholderMap[iter1] or 0

		assert(var0 > 0, iter1)

		arg0.placeholder = bit.bor(arg0.placeholder, var0)
	end

	arg0.hideRecord = defaultValue(arg1.hideRecord, false)
	arg0.hideAutoBtn = defaultValue(arg1.hideAuto, false)
	arg0.storyAlpha = defaultValue(arg1.alpha, 0.568)

	if UnGamePlayState then
		arg0.speedData = arg1.speed or 0
	else
		arg0.speedData = arg1.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	end

	arg0.steps = {}

	local var1 = 0
	local var2 = arg3 or {}
	local var3 = {}

	for iter2, iter3 in ipairs(arg1.scripts or {}) do
		local var4 = iter3.mode or arg0.mode
		local var5 = var0.GetStoryStepCls(var4).New(iter3)

		var5:SetId(iter2)
		var5:SetPlaceholderType(arg0:GetPlaceholder())
		var5:SetDefaultTb(arg0.defaultTb)

		if var5:ExistOption() then
			var1 = var1 + 1

			if var2[var1] then
				var5:SetOptionSelCodes(var2[var1])
			end

			if arg4 then
				var5.important = true
			end

			table.insert(var3, iter2)

			if arg5 then
				var5:AutoShowOption()
			end
		end

		table.insert(arg0.steps, var5)
	end

	if #arg0.steps > 0 then
		table.insert(var3, #arg0.steps)
	end

	arg0:HandleRecallOptions(var3)

	arg0.branchCode = nil
	arg0.force = arg2

	if UnGamePlayState then
		arg0.isPlayed = false
	else
		arg0.isPlayed = pg.NewStoryMgr:GetInstance():IsPlayed(arg0.name)
	end

	arg0.nextScriptName = nil
	arg0.skipAll = false
	arg0.isAuto = false
	arg0.speed = 0
end

function var0.HandleRecallOptions(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = arg0.steps[arg0]
		local var1 = {}

		for iter0 = arg0, arg1 do
			local var2 = arg0.steps[iter0]

			table.insert(var1, var2)
		end

		local var3 = var0:GetOptionCnt()

		return {
			var1,
			var3,
			arg1,
			arg0
		}
	end

	local function var1(arg0)
		for iter0 = arg0, 1, -1 do
			local var0 = arg0.steps[iter0]

			if var0 and var0.branchCode ~= nil then
				return iter0
			end
		end

		assert(false)
	end

	local var2 = {}

	for iter0, iter1 in ipairs(arg1) do
		if arg0.steps[iter1]:IsRecallOption() then
			local var3 = iter1
			local var4 = arg1[iter0 + 1]

			if var3 and var4 then
				local var5 = var1(var4)

				table.insert(var2, var0(var3, var5))
			end
		end
	end

	local var6 = 0

	for iter2, iter3 in ipairs(var2) do
		local var7 = iter3[1]
		local var8 = iter3[2]
		local var9 = iter3[3]
		local var10 = iter3[4]

		for iter4 = 1, var8 - 1 do
			local var11 = var9 + var6

			for iter5, iter6 in ipairs(var7) do
				local var12 = Clone(iter6)

				var12:SetId(var10)
				table.insert(arg0.steps, var11 + iter5, var12)
			end
		end

		var6 = var6 + (var8 - 1) * #var7
	end
end

function var0.GetPlaceholder(arg0)
	return arg0.placeholder
end

function var0.ShouldReplaceContent(arg0)
	return arg0.placeholder > 0
end

function var0.GetStoryAlpha(arg0)
	return arg0.storyAlpha
end

function var0.ShouldHideAutoBtn(arg0)
	return arg0.hideAutoBtn
end

function var0.ShouldHideRecord(arg0)
	return arg0.hideRecord
end

function var0.GetDialogueStyleName(arg0)
	return arg0.dialogueBox
end

function var0.IsDialogueStyle2(arg0)
	return arg0:GetDialogueStyleName() == 2
end

function var0.GetTriggerDelayTime(arg0)
	local var0 = table.indexof(var0.STORY_AUTO_SPEED, arg0.speed)

	if var0 then
		return var0.TRIGGER_DELAY_TIME[var0] or 0
	end

	return 0
end

function var0.SetAutoPlay(arg0)
	arg0.isAuto = true

	arg0:SetPlaySpeed(arg0.speedData)
end

function var0.UpdatePlaySpeed(arg0)
	local var0 = getProxy(SettingsProxy):GetStorySpeed() or 0

	arg0:SetPlaySpeed(var0)
end

function var0.GetPlaySpeed(arg0)
	return arg0.speed
end

function var0.StopAutoPlay(arg0)
	arg0.isAuto = false

	arg0:ResetSpeed()
end

function var0.SetPlaySpeed(arg0, arg1)
	arg0.speed = arg1
end

function var0.ResetSpeed(arg0)
	arg0.speed = 0
end

function var0.GetPlaySpeed(arg0)
	return arg0.speed
end

function var0.GetAutoPlayFlag(arg0)
	return arg0.isAuto
end

function var0.ShowSkipTip(arg0)
	return arg0.skipTip
end

function var0.ShouldWaitFadeout(arg0)
	return not arg0.noWaitFade
end

function var0.ShouldHideSkip(arg0)
	return arg0.hideSkip
end

function var0.CanPlay(arg0)
	return arg0.force or not arg0.isPlayed
end

function var0.GetId(arg0)
	return arg0.name
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.GetStepByIndex(arg0, arg1)
	local var0 = arg0.steps[arg1]

	if not var0 or arg0.branchCode and not var0:IsSameBranch(arg0.branchCode) then
		return nil
	end

	return var0
end

function var0.GetNextStep(arg0, arg1)
	if arg1 >= #arg0.steps then
		return nil
	end

	local var0 = arg1 + 1
	local var1 = arg0:GetStepByIndex(var0)

	if not var1 and var0 < #arg0.steps then
		return arg0:GetNextStep(var0)
	else
		return var1
	end
end

function var0.GetPrevStep(arg0, arg1)
	if arg1 <= 1 then
		return nil
	end

	local var0 = arg1 - 1
	local var1 = arg0:GetStepByIndex(var0)

	if not var1 and var0 > 1 then
		return arg0:GetPrevStep(var0)
	else
		return var1
	end
end

function var0.ShouldFadeout(arg0)
	return arg0.fadeOut ~= nil
end

function var0.GetFadeoutTime(arg0)
	return arg0.fadeOut
end

function var0.IsPlayed(arg0)
	return arg0.isPlayed
end

function var0.SetBranchCode(arg0, arg1)
	arg0.branchCode = arg1
end

function var0.GetBranchCode(arg0)
	return arg0.branchCode
end

function var0.GetNextScriptName(arg0)
	return arg0.nextScriptName
end

function var0.SetNextScriptName(arg0, arg1)
	arg0.nextScriptName = arg1
end

function var0.SkipAll(arg0)
	arg0.skipAll = true
end

function var0.StopSkip(arg0)
	arg0.skipAll = false
end

function var0.ShouldSkipAll(arg0)
	return arg0.skipAll
end

function var0.GetUsingPaintingNames(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.steps) do
		local var1 = iter1:GetUsingPaintingNames()

		for iter2, iter3 in ipairs(var1) do
			var0[iter3] = true
		end
	end

	local var2 = {}

	for iter4, iter5 in pairs(var0) do
		table.insert(var2, iter4)
	end

	return var2
end

function var0.GetAllStepDispatcherRecallName(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.steps) do
		local var1 = iter1:GetDispatcherRecallName()

		if var1 then
			var0[var1] = true
		end
	end

	local var2 = {}

	for iter2, iter3 in pairs(var0) do
		table.insert(var2, iter2)
	end

	return var2
end

return var0
