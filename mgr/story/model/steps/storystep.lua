local var0_0 = class("StoryStep")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.flashout = arg1_1.flashout
	arg0_1.flashin = arg1_1.flashin
	arg0_1.bgName = arg1_1.bgName
	arg0_1.bgShadow = arg1_1.bgShadow
	arg0_1.blackBg = arg1_1.blackBg
	arg0_1.blackFg = arg1_1.blackFg or 0
	arg0_1.bgGlitchArt = arg1_1.bgNoise
	arg0_1.oldPhoto = arg1_1.oldPhoto
	arg0_1.bgm = arg1_1.bgm
	arg0_1.bgmDelay = arg1_1.bgmDelay or 0
	arg0_1.bgmVolume = arg1_1.bgmVolume or -1
	arg0_1.stopbgm = arg1_1.stopbgm
	arg0_1.effects = arg1_1.effects or {}
	arg0_1.blink = arg1_1.flash
	arg0_1.blinkWithColor = arg1_1.flashN
	arg0_1.soundeffect = arg1_1.soundeffect
	arg0_1.seDelay = arg1_1.seDelay or 0
	arg0_1.voice = arg1_1.voice
	arg0_1.voiceDelay = arg1_1.voiceDelay or 0
	arg0_1.stopVoice = defaultValue(arg1_1.stopVoice, false)
	arg0_1.movableNode = arg1_1.movableNode
	arg0_1.options = arg1_1.options
	arg0_1.important = arg1_1.important
	arg0_1.branchCode = arg1_1.optionFlag
	arg0_1.recallOption = arg1_1.recallOption
	arg0_1.nextScriptName = arg1_1.jumpto
	arg0_1.eventDelay = arg1_1.eventDelay or 0
	arg0_1.bgColor = arg1_1.bgColor or {
		0,
		0,
		0
	}
	arg0_1.location = arg1_1.location
	arg0_1.icon = arg1_1.icon
	arg0_1.autoShowOption = defaultValue(arg1_1.autoShowOption, false)
	arg0_1.dispatcher = arg1_1.dispatcher
	arg0_1.shakeTime = defaultValue(arg1_1.shakeTime, 0)
	arg0_1.selectedBranchCode = 0
	arg0_1.id = 0
	arg0_1.placeholderType = 0
	arg0_1.defaultTb = arg1_1.defaultTb
end

function var0_0.ShouldShake(arg0_2)
	return arg0_2.shakeTime > 0
end

function var0_0.GetShakeTime(arg0_3)
	return arg0_3.shakeTime
end

function var0_0.SetDefaultTb(arg0_4, arg1_4)
	if not arg0_4.defaultTb or arg0_4.defaultTb <= 0 then
		arg0_4.defaultTb = arg1_4
	end
end

function var0_0.SetPlaceholderType(arg0_5, arg1_5)
	arg0_5.placeholderType = arg1_5
end

function var0_0.ShouldReplacePlayer(arg0_6)
	return bit.band(arg0_6.placeholderType, Story.PLAYER) > 0
end

function var0_0.ShouldReplaceTb(arg0_7)
	return bit.band(arg0_7.placeholderType, Story.TB) > 0
end

function var0_0.ReplacePlayerName(arg0_8, arg1_8)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return arg1_8
	end

	local var0_8 = getProxy(PlayerProxy):getRawData():GetName()

	arg1_8 = string.gsub(arg1_8, "{playername}", var0_8)

	return arg1_8
end

function var0_0.ReplaceTbName(arg0_9, arg1_9)
	if pg.NewStoryMgr.GetInstance():IsReView() then
		return string.gsub(arg1_9, "{tb}", i18n("child_story_name"))
	end

	if not getProxy(EducateProxy) then
		return arg1_9
	end

	local var0_9, var1_9 = getProxy(EducateProxy):GetStoryInfo()

	arg1_9 = string.gsub(arg1_9, "{tb}", var1_9)

	return arg1_9
end

function var0_0.ExistDispatcher(arg0_10)
	return arg0_10.dispatcher ~= nil
end

function var0_0.GetDispatcher(arg0_11)
	return arg0_11.dispatcher
end

function var0_0.IsRecallDispatcher(arg0_12)
	if not arg0_12:ExistDispatcher() then
		return false
	end

	local var0_12 = arg0_12:GetDispatcher()

	return var0_12.callbackData ~= nil and var0_12.callbackData.name ~= nil
end

function var0_0.GetDispatcherRecallName(arg0_13)
	if not arg0_13:IsRecallDispatcher() then
		return nil
	end

	return arg0_13:GetDispatcher().callbackData.name
end

function var0_0.ShouldHideUI(arg0_14)
	if not arg0_14:IsRecallDispatcher() then
		return false
	end

	return arg0_14:GetDispatcher().callbackData.hideUI == true
end

function var0_0.ExistIcon(arg0_15)
	return arg0_15.icon ~= nil
end

function var0_0.GetIconData(arg0_16)
	return arg0_16.icon
end

function var0_0.SetId(arg0_17, arg1_17)
	arg0_17.id = arg1_17
end

function var0_0.GetId(arg0_18)
	return arg0_18.id
end

function var0_0.AutoShowOption(arg0_19)
	arg0_19.autoShowOption = true
end

function var0_0.SkipEventForOption(arg0_20)
	return arg0_20:ExistOption() and arg0_20.autoShowOption
end

function var0_0.IsRecallOption(arg0_21)
	if arg0_21:ExistOption() and arg0_21:GetOptionCnt() > 1 and arg0_21.recallOption then
		return true
	end

	return false
end

function var0_0.SetBranchCode(arg0_22, arg1_22)
	arg0_22.selectedBranchCode = arg1_22
end

function var0_0.GetSelectedBranchCode(arg0_23)
	return arg0_23.selectedBranchCode
end

function var0_0.ExistLocation(arg0_24)
	return arg0_24.location ~= nil
end

function var0_0.GetLocation(arg0_25)
	return {
		text = arg0_25.location[1] or "",
		time = arg0_25.location[2] or 999
	}
end

function var0_0.ExistMovableNode(arg0_26)
	return arg0_26.movableNode ~= nil and type(arg0_26.movableNode) == "table" and #arg0_26.movableNode > 0
end

function var0_0.GetPathByString(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}
	local var1_27 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2_27 = Vector3(-var1_27.x * 0.5, var1_27.y * 0.5, 0)
	local var3_27 = Vector3(var1_27.x * 0.5, var1_27.y * 0.5, 0)
	local var4_27 = Vector3(-var1_27.x * 0.5, -var1_27.y * 0.5, 0)
	local var5_27 = Vector3(var1_27.x * 0.5, -var1_27.y * 0.5, 0)
	local var6_27 = arg2_27 or 200

	if arg1_27 == "LTLB" then
		local var7_27 = Vector3(var6_27, 0, 0)

		var0_27 = {
			var2_27 + var7_27,
			var4_27 + var7_27
		}
	elseif arg1_27 == "LBLT" then
		local var8_27 = Vector3(var6_27, 0, 0)

		var0_27 = {
			var4_27 + var8_27,
			var2_27 + var8_27
		}
	elseif arg1_27 == "LTRT" then
		local var9_27 = Vector3(0, -var6_27, 0)

		var0_27 = {
			var2_27 + var9_27,
			var3_27 + var9_27
		}
	elseif arg1_27 == "RTLT" then
		local var10_27 = Vector3(0, -var6_27, 0)

		var0_27 = {
			var3_27 + var10_27,
			var2_27 + var10_27
		}
	elseif arg1_27 == "RTRB" then
		local var11_27 = Vector3(var6_27, 0, 0)

		var0_27 = {
			var3_27 + var11_27,
			var5_27 + var11_27
		}
	elseif arg1_27 == "RBRT" then
		local var12_27 = Vector3(var6_27, 0, 0)

		var0_27 = {
			var5_27 + var12_27,
			var3_27 + var12_27
		}
	elseif arg1_27 == "LBRB" then
		local var13_27 = Vector3(0, -(arg2_27 or 0), 0)

		var0_27 = {
			var4_27 + var13_27,
			var5_27 + var13_27
		}
	elseif arg1_27 == "RBLB" then
		local var14_27 = Vector3(0, -(arg2_27 or 0), 0)

		var0_27 = {
			var5_27 + var14_27,
			var4_27 + var14_27
		}
	end

	return var0_27
end

function var0_0.GenMoveNode(arg0_28, arg1_28)
	local var0_28 = {}

	if type(arg1_28.path) == "table" then
		for iter0_28, iter1_28 in ipairs(arg1_28.path) do
			table.insert(var0_28, Vector3(iter1_28[1], iter1_28[2], 0))
		end
	elseif type(arg1_28.path) == "string" then
		var0_28 = arg0_28:GetPathByString(arg1_28.path, arg1_28.offset)
	else
		var0_28 = arg0_28:GetPathByString("LTRT")
	end

	local var1_28 = type(arg1_28.spine) == "table" or arg1_28.spine == true
	local var2_28

	if arg1_28.spine == true then
		var2_28 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1_28 then
		var2_28 = {
			action = arg1_28.spine.action or "walk",
			scale = arg1_28.spine.scale or 0.5
		}
	end

	return {
		name = arg1_28.name,
		isSpine = var1_28,
		spineData = var2_28,
		path = var0_28,
		time = arg1_28.time,
		delay = arg1_28.delay or 0,
		easeType = arg1_28.easeType or LeanTweenType.linear
	}
end

function var0_0.GetMovableNode(arg0_29)
	if not arg0_29:ExistMovableNode() then
		return {}
	end

	local var0_29 = {}

	for iter0_29, iter1_29 in pairs(arg0_29.movableNode or {}) do
		local var1_29 = arg0_29:GenMoveNode(iter1_29)

		table.insert(var0_29, var1_29)
	end

	return var0_29
end

function var0_0.OldPhotoEffect(arg0_30)
	return arg0_30.oldPhoto
end

function var0_0.ShouldBgGlitchArt(arg0_31)
	return arg0_31.bgGlitchArt
end

function var0_0.IsSameBranch(arg0_32, arg1_32)
	return not arg0_32.branchCode or arg0_32.branchCode == arg1_32
end

function var0_0.GetMode(arg0_33)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_34)
	if arg0_34.flashout then
		local var0_34 = arg0_34.flashout.alpha[1]
		local var1_34 = arg0_34.flashout.alpha[2]
		local var2_34 = arg0_34.flashout.dur
		local var3_34 = arg0_34.flashout.black

		return var0_34, var1_34, var2_34, var3_34
	end
end

function var0_0.GetFlashinData(arg0_35)
	if arg0_35.flashin then
		local var0_35 = arg0_35.flashin.alpha[1]
		local var1_35 = arg0_35.flashin.alpha[2]
		local var2_35 = arg0_35.flashin.dur
		local var3_35 = arg0_35.flashin.black
		local var4_35 = arg0_35.flashin.delay

		return var0_35, var1_35, var2_35, var3_35, var4_35
	end
end

function var0_0.GetBgColor(arg0_36)
	return Color.New(arg0_36.bgColor[1] or 0, arg0_36.bgColor[2] or 0, arg0_36.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_37)
	return arg0_37.blackBg
end

function var0_0.GetBgName(arg0_38)
	return arg0_38.bgName
end

function var0_0.GetBgShadow(arg0_39)
	return arg0_39.bgShadow
end

function var0_0.IsDialogueMode(arg0_40)
	return arg0_40:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_41)
	return arg0_41.bgm, arg0_41.bgmDelay, arg0_41.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_42)
	return arg0_42.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_43)
	return arg0_43.stopbgm
end

function var0_0.GetEffects(arg0_44)
	return arg0_44.effects
end

function var0_0.ShouldBlink(arg0_45)
	return arg0_45.blink ~= nil
end

function var0_0.GetBlinkData(arg0_46)
	return arg0_46.blink
end

function var0_0.ShouldBlinkWithColor(arg0_47)
	return arg0_47.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_48)
	return arg0_48.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_49)
	return arg0_49.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_50)
	return arg0_50.soundeffect, arg0_50.seDelay
end

function var0_0.ShouldPlayVoice(arg0_51)
	return arg0_51.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_52)
	return arg0_52.stopVoice
end

function var0_0.GetVoice(arg0_53)
	return arg0_53.voice, arg0_53.voiceDelay
end

function var0_0.ExistOption(arg0_54)
	return arg0_54.options ~= nil and #arg0_54.options > 0
end

function var0_0.GetOptionCnt(arg0_55)
	if arg0_55:ExistOption() then
		return #arg0_55.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_56, arg1_56)
	arg0_56.optionSelCode = arg1_56
end

function var0_0.IsBlackFrontGround(arg0_57)
	return arg0_57.blackFg > 0, Mathf.Clamp01(arg0_57.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_58)
	local var0_58 = 0
	local var1_58 = 0

	for iter0_58, iter1_58 in ipairs(arg0_58.options) do
		if arg0_58.optionSelCode and iter1_58.flag == arg0_58.optionSelCode then
			var0_58 = iter0_58

			break
		end

		if iter1_58.autochoice and iter1_58.autochoice == 1 then
			var1_58 = iter0_58
		end
	end

	if var0_58 > 0 then
		return var0_58
	end

	if var1_58 > 0 then
		return var1_58
	end

	return nil
end

function var0_0.IsImport(arg0_59)
	return arg0_59.important
end

function var0_0.GetOptions(arg0_60)
	return _.map(arg0_60.options or {}, function(arg0_61)
		local var0_61 = arg0_61.content

		if arg0_60:ShouldReplacePlayer() then
			var0_61 = arg0_60:ReplacePlayerName(var0_61)
		end

		if arg0_60:ShouldReplaceTb() then
			var0_61 = arg0_60:ReplaceTbName(var0_61)
		end

		local var1_61 = HXSet.hxLan(var0_61)

		return {
			var1_61,
			arg0_61.flag
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_62)
	return arg0_62.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_63)
	return arg0_63.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_64)
	return arg0_64.eventDelay and arg0_64.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_65)
	return arg0_65.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_66)
	return {}
end

return var0_0
