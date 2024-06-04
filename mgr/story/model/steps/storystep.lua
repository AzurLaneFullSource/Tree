local var0 = class("StoryStep")

function var0.Ctor(arg0, arg1)
	arg0.flashout = arg1.flashout
	arg0.flashin = arg1.flashin
	arg0.bgName = arg1.bgName
	arg0.bgShadow = arg1.bgShadow
	arg0.blackBg = arg1.blackBg
	arg0.blackFg = arg1.blackFg or 0
	arg0.bgGlitchArt = arg1.bgNoise
	arg0.oldPhoto = arg1.oldPhoto
	arg0.bgm = arg1.bgm
	arg0.bgmDelay = arg1.bgmDelay or 0
	arg0.bgmVolume = arg1.bgmVolume or -1
	arg0.stopbgm = arg1.stopbgm
	arg0.effects = arg1.effects or {}
	arg0.blink = arg1.flash
	arg0.blinkWithColor = arg1.flashN
	arg0.soundeffect = arg1.soundeffect
	arg0.seDelay = arg1.seDelay or 0
	arg0.voice = arg1.voice
	arg0.voiceDelay = arg1.voiceDelay or 0
	arg0.stopVoice = defaultValue(arg1.stopVoice, false)
	arg0.movableNode = arg1.movableNode
	arg0.options = arg1.options
	arg0.important = arg1.important
	arg0.branchCode = arg1.optionFlag
	arg0.recallOption = arg1.recallOption
	arg0.nextScriptName = arg1.jumpto
	arg0.eventDelay = arg1.eventDelay or 0
	arg0.bgColor = arg1.bgColor or {
		0,
		0,
		0
	}
	arg0.location = arg1.location
	arg0.icon = arg1.icon
	arg0.autoShowOption = defaultValue(arg1.autoShowOption, false)
	arg0.dispatcher = arg1.dispatcher
	arg0.shakeTime = defaultValue(arg1.shakeTime, 0)
	arg0.selectedBranchCode = 0
	arg0.id = 0
	arg0.placeholderType = 0
	arg0.defaultTb = arg1.defaultTb
end

function var0.ShouldShake(arg0)
	return arg0.shakeTime > 0
end

function var0.GetShakeTime(arg0)
	return arg0.shakeTime
end

function var0.SetDefaultTb(arg0, arg1)
	if not arg0.defaultTb or arg0.defaultTb <= 0 then
		arg0.defaultTb = arg1
	end
end

function var0.SetPlaceholderType(arg0, arg1)
	arg0.placeholderType = arg1
end

function var0.ShouldReplacePlayer(arg0)
	return bit.band(arg0.placeholderType, Story.PLAYER) > 0
end

function var0.ShouldReplaceTb(arg0)
	return bit.band(arg0.placeholderType, Story.TB) > 0
end

function var0.ReplacePlayerName(arg0, arg1)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return arg1
	end

	local var0 = getProxy(PlayerProxy):getRawData():GetName()

	arg1 = string.gsub(arg1, "{playername}", var0)

	return arg1
end

function var0.ReplaceTbName(arg0, arg1)
	if pg.NewStoryMgr.GetInstance():IsReView() then
		return string.gsub(arg1, "{tb}", i18n("child_story_name"))
	end

	if not getProxy(EducateProxy) then
		return arg1
	end

	local var0, var1 = getProxy(EducateProxy):GetStoryInfo()

	arg1 = string.gsub(arg1, "{tb}", var1)

	return arg1
end

function var0.ExistDispatcher(arg0)
	return arg0.dispatcher ~= nil
end

function var0.GetDispatcher(arg0)
	return arg0.dispatcher
end

function var0.IsRecallDispatcher(arg0)
	if not arg0:ExistDispatcher() then
		return false
	end

	local var0 = arg0:GetDispatcher()

	return var0.callbackData ~= nil and var0.callbackData.name ~= nil
end

function var0.GetDispatcherRecallName(arg0)
	if not arg0:IsRecallDispatcher() then
		return nil
	end

	return arg0:GetDispatcher().callbackData.name
end

function var0.ShouldHideUI(arg0)
	if not arg0:IsRecallDispatcher() then
		return false
	end

	return arg0:GetDispatcher().callbackData.hideUI == true
end

function var0.ExistIcon(arg0)
	return arg0.icon ~= nil
end

function var0.GetIconData(arg0)
	return arg0.icon
end

function var0.SetId(arg0, arg1)
	arg0.id = arg1
end

function var0.GetId(arg0)
	return arg0.id
end

function var0.AutoShowOption(arg0)
	arg0.autoShowOption = true
end

function var0.SkipEventForOption(arg0)
	return arg0:ExistOption() and arg0.autoShowOption
end

function var0.IsRecallOption(arg0)
	if arg0:ExistOption() and arg0:GetOptionCnt() > 1 and arg0.recallOption then
		return true
	end

	return false
end

function var0.SetBranchCode(arg0, arg1)
	arg0.selectedBranchCode = arg1
end

function var0.GetSelectedBranchCode(arg0)
	return arg0.selectedBranchCode
end

function var0.ExistLocation(arg0)
	return arg0.location ~= nil
end

function var0.GetLocation(arg0)
	return {
		text = arg0.location[1] or "",
		time = arg0.location[2] or 999
	}
end

function var0.ExistMovableNode(arg0)
	return arg0.movableNode ~= nil and type(arg0.movableNode) == "table" and #arg0.movableNode > 0
end

function var0.GetPathByString(arg0, arg1, arg2)
	local var0 = {}
	local var1 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2 = Vector3(-var1.x * 0.5, var1.y * 0.5, 0)
	local var3 = Vector3(var1.x * 0.5, var1.y * 0.5, 0)
	local var4 = Vector3(-var1.x * 0.5, -var1.y * 0.5, 0)
	local var5 = Vector3(var1.x * 0.5, -var1.y * 0.5, 0)
	local var6 = arg2 or 200

	if arg1 == "LTLB" then
		local var7 = Vector3(var6, 0, 0)

		var0 = {
			var2 + var7,
			var4 + var7
		}
	elseif arg1 == "LBLT" then
		local var8 = Vector3(var6, 0, 0)

		var0 = {
			var4 + var8,
			var2 + var8
		}
	elseif arg1 == "LTRT" then
		local var9 = Vector3(0, -var6, 0)

		var0 = {
			var2 + var9,
			var3 + var9
		}
	elseif arg1 == "RTLT" then
		local var10 = Vector3(0, -var6, 0)

		var0 = {
			var3 + var10,
			var2 + var10
		}
	elseif arg1 == "RTRB" then
		local var11 = Vector3(var6, 0, 0)

		var0 = {
			var3 + var11,
			var5 + var11
		}
	elseif arg1 == "RBRT" then
		local var12 = Vector3(var6, 0, 0)

		var0 = {
			var5 + var12,
			var3 + var12
		}
	elseif arg1 == "LBRB" then
		local var13 = Vector3(0, -(arg2 or 0), 0)

		var0 = {
			var4 + var13,
			var5 + var13
		}
	elseif arg1 == "RBLB" then
		local var14 = Vector3(0, -(arg2 or 0), 0)

		var0 = {
			var5 + var14,
			var4 + var14
		}
	end

	return var0
end

function var0.GenMoveNode(arg0, arg1)
	local var0 = {}

	if type(arg1.path) == "table" then
		for iter0, iter1 in ipairs(arg1.path) do
			table.insert(var0, Vector3(iter1[1], iter1[2], 0))
		end
	elseif type(arg1.path) == "string" then
		var0 = arg0:GetPathByString(arg1.path, arg1.offset)
	else
		var0 = arg0:GetPathByString("LTRT")
	end

	local var1 = type(arg1.spine) == "table" or arg1.spine == true
	local var2

	if arg1.spine == true then
		var2 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1 then
		var2 = {
			action = arg1.spine.action or "walk",
			scale = arg1.spine.scale or 0.5
		}
	end

	return {
		name = arg1.name,
		isSpine = var1,
		spineData = var2,
		path = var0,
		time = arg1.time,
		delay = arg1.delay or 0,
		easeType = arg1.easeType or LeanTweenType.linear
	}
end

function var0.GetMovableNode(arg0)
	if not arg0:ExistMovableNode() then
		return {}
	end

	local var0 = {}

	for iter0, iter1 in pairs(arg0.movableNode or {}) do
		local var1 = arg0:GenMoveNode(iter1)

		table.insert(var0, var1)
	end

	return var0
end

function var0.OldPhotoEffect(arg0)
	return arg0.oldPhoto
end

function var0.ShouldBgGlitchArt(arg0)
	return arg0.bgGlitchArt
end

function var0.IsSameBranch(arg0, arg1)
	return not arg0.branchCode or arg0.branchCode == arg1
end

function var0.GetMode(arg0)
	assert(false, "should override this function")
end

function var0.GetFlashoutData(arg0)
	if arg0.flashout then
		local var0 = arg0.flashout.alpha[1]
		local var1 = arg0.flashout.alpha[2]
		local var2 = arg0.flashout.dur
		local var3 = arg0.flashout.black

		return var0, var1, var2, var3
	end
end

function var0.GetFlashinData(arg0)
	if arg0.flashin then
		local var0 = arg0.flashin.alpha[1]
		local var1 = arg0.flashin.alpha[2]
		local var2 = arg0.flashin.dur
		local var3 = arg0.flashin.black
		local var4 = arg0.flashin.delay

		return var0, var1, var2, var3, var4
	end
end

function var0.GetBgColor(arg0)
	return Color.New(arg0.bgColor[1] or 0, arg0.bgColor[2] or 0, arg0.bgColor[3] or 0)
end

function var0.IsBlackBg(arg0)
	return arg0.blackBg
end

function var0.GetBgName(arg0)
	return arg0.bgName
end

function var0.GetBgShadow(arg0)
	return arg0.bgShadow
end

function var0.IsDialogueMode(arg0)
	return arg0:GetMode() == Story.MODE_DIALOGUE
end

function var0.GetBgmData(arg0)
	return arg0.bgm, arg0.bgmDelay, arg0.bgmVolume
end

function var0.ShoulePlayBgm(arg0)
	return arg0.bgm ~= nil
end

function var0.ShouldStopBgm(arg0)
	return arg0.stopbgm
end

function var0.GetEffects(arg0)
	return arg0.effects
end

function var0.ShouldBlink(arg0)
	return arg0.blink ~= nil
end

function var0.GetBlinkData(arg0)
	return arg0.blink
end

function var0.ShouldBlinkWithColor(arg0)
	return arg0.blinkWithColor ~= nil
end

function var0.GetBlinkWithColorData(arg0)
	return arg0.blinkWithColor
end

function var0.ShouldPlaySoundEffect(arg0)
	return arg0.soundeffect ~= nil
end

function var0.GetSoundeffect(arg0)
	return arg0.soundeffect, arg0.seDelay
end

function var0.ShouldPlayVoice(arg0)
	return arg0.voice ~= nil
end

function var0.ShouldStopVoice(arg0)
	return arg0.stopVoice
end

function var0.GetVoice(arg0)
	return arg0.voice, arg0.voiceDelay
end

function var0.ExistOption(arg0)
	return arg0.options ~= nil and #arg0.options > 0
end

function var0.GetOptionCnt(arg0)
	if arg0:ExistOption() then
		return #arg0.options
	else
		return 0
	end
end

function var0.SetOptionSelCodes(arg0, arg1)
	arg0.optionSelCode = arg1
end

function var0.IsBlackFrontGround(arg0)
	return arg0.blackFg > 0, Mathf.Clamp01(arg0.blackFg)
end

function var0.GetOptionIndexByAutoSel(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.options) do
		if arg0.optionSelCode and iter1.flag == arg0.optionSelCode then
			var0 = iter0

			break
		end

		if iter1.autochoice and iter1.autochoice == 1 then
			var1 = iter0
		end
	end

	if var0 > 0 then
		return var0
	end

	if var1 > 0 then
		return var1
	end

	return nil
end

function var0.IsImport(arg0)
	return arg0.important
end

function var0.GetOptions(arg0)
	return _.map(arg0.options or {}, function(arg0)
		local var0 = arg0.content

		if arg0:ShouldReplacePlayer() then
			var0 = arg0:ReplacePlayerName(var0)
		end

		if arg0:ShouldReplaceTb() then
			var0 = arg0:ReplaceTbName(var0)
		end

		local var1 = HXSet.hxLan(var0)

		return {
			var1,
			arg0.flag
		}
	end)
end

function var0.ShouldJumpToNextScript(arg0)
	return arg0.nextScriptName ~= nil
end

function var0.GetNextScriptName(arg0)
	return arg0.nextScriptName
end

function var0.ShouldDelayEvent(arg0)
	return arg0.eventDelay and arg0.eventDelay > 0
end

function var0.GetEventDelayTime(arg0)
	return arg0.eventDelay
end

function var0.GetUsingPaintingNames(arg0)
	return {}
end

return var0
