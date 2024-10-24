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
	arg0_1.dispatcher = arg1_1.dispatcher
	arg0_1.shakeTime = defaultValue(arg1_1.shakeTime, 0)
	arg0_1.autoShowOption = defaultValue(arg1_1.autoShowOption, false)
	arg0_1.selectedBranchCode = 0
	arg0_1.id = 0
	arg0_1.placeholderType = 0
	arg0_1.defaultTb = arg1_1.defaultTb
	arg0_1.optionIndex = 0
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

function var0_0.ShouldReplaceDorm(arg0_8)
	return bit.band(arg0_8.placeholderType, Story.DORM) > 0
end

function var0_0.ReplacePlayerName(arg0_9, arg1_9)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return arg1_9
	end

	local var0_9 = getProxy(PlayerProxy):getRawData():GetName()

	arg1_9 = string.gsub(arg1_9, "{playername}", var0_9)

	return arg1_9
end

function var0_0.ReplaceTbName(arg0_10, arg1_10)
	if pg.NewStoryMgr.GetInstance():IsReView() then
		return string.gsub(arg1_10, "{tb}", i18n("child_story_name"))
	end

	if not getProxy(EducateProxy) then
		return arg1_10
	end

	local var0_10, var1_10 = getProxy(EducateProxy):GetStoryInfo()

	arg1_10 = string.gsub(arg1_10, "{tb}", var1_10)

	return arg1_10
end

function var0_0.ReplaceDormName(arg0_11, arg1_11)
	if not arg0_11.actorName then
		return arg1_11
	end

	local var0_11 = getProxy(ApartmentProxy):getApartment(arg0_11.actorName)
	local var1_11 = var0_11 and var0_11:GetCallName() or arg0_11.actorName

	arg1_11 = string.gsub(arg1_11, "{dorm3d}", var1_11)

	return arg1_11
end

function var0_0.ExistDispatcher(arg0_12)
	return arg0_12.dispatcher ~= nil
end

function var0_0.GetDispatcher(arg0_13)
	return arg0_13.dispatcher
end

function var0_0.IsRecallDispatcher(arg0_14)
	if not arg0_14:ExistDispatcher() then
		return false
	end

	local var0_14 = arg0_14:GetDispatcher()

	return var0_14.callbackData ~= nil and var0_14.callbackData.name ~= nil
end

function var0_0.GetDispatcherRecallName(arg0_15)
	if not arg0_15:IsRecallDispatcher() then
		return nil
	end

	return arg0_15:GetDispatcher().callbackData.name
end

function var0_0.ShouldHideUI(arg0_16)
	if not arg0_16:IsRecallDispatcher() then
		return false
	end

	return arg0_16:GetDispatcher().callbackData.hideUI == true
end

function var0_0.ExistIcon(arg0_17)
	return arg0_17.icon ~= nil
end

function var0_0.GetIconData(arg0_18)
	return arg0_18.icon
end

function var0_0.SetId(arg0_19, arg1_19)
	arg0_19.id = arg1_19
end

function var0_0.GetId(arg0_20)
	return arg0_20.id
end

function var0_0.AutoShowOption(arg0_21)
	arg0_21.autoShowOption = true
end

function var0_0.SkipEventForOption(arg0_22)
	return arg0_22:ExistOption() and arg0_22.autoShowOption
end

function var0_0.IsRecallOption(arg0_23)
	if arg0_23:ExistOption() and arg0_23:GetOptionCnt() > 1 and arg0_23.recallOption then
		return true
	end

	return false
end

function var0_0.SetBranchCode(arg0_24, arg1_24)
	arg0_24.selectedBranchCode = arg1_24
end

function var0_0.GetSelectedBranchCode(arg0_25)
	return arg0_25.selectedBranchCode
end

function var0_0.ExistLocation(arg0_26)
	return arg0_26.location ~= nil
end

function var0_0.GetLocation(arg0_27)
	return {
		text = arg0_27.location[1] or "",
		time = arg0_27.location[2] or 999
	}
end

function var0_0.ExistMovableNode(arg0_28)
	return arg0_28.movableNode ~= nil and type(arg0_28.movableNode) == "table" and #arg0_28.movableNode > 0
end

function var0_0.GetPathByString(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}
	local var1_29 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2_29 = Vector3(-var1_29.x * 0.5, var1_29.y * 0.5, 0)
	local var3_29 = Vector3(var1_29.x * 0.5, var1_29.y * 0.5, 0)
	local var4_29 = Vector3(-var1_29.x * 0.5, -var1_29.y * 0.5, 0)
	local var5_29 = Vector3(var1_29.x * 0.5, -var1_29.y * 0.5, 0)
	local var6_29 = arg2_29 or 200

	if arg1_29 == "LTLB" then
		local var7_29 = Vector3(var6_29, 0, 0)

		var0_29 = {
			var2_29 + var7_29,
			var4_29 + var7_29
		}
	elseif arg1_29 == "LBLT" then
		local var8_29 = Vector3(var6_29, 0, 0)

		var0_29 = {
			var4_29 + var8_29,
			var2_29 + var8_29
		}
	elseif arg1_29 == "LTRT" then
		local var9_29 = Vector3(0, -var6_29, 0)

		var0_29 = {
			var2_29 + var9_29,
			var3_29 + var9_29
		}
	elseif arg1_29 == "RTLT" then
		local var10_29 = Vector3(0, -var6_29, 0)

		var0_29 = {
			var3_29 + var10_29,
			var2_29 + var10_29
		}
	elseif arg1_29 == "RTRB" then
		local var11_29 = Vector3(var6_29, 0, 0)

		var0_29 = {
			var3_29 + var11_29,
			var5_29 + var11_29
		}
	elseif arg1_29 == "RBRT" then
		local var12_29 = Vector3(var6_29, 0, 0)

		var0_29 = {
			var5_29 + var12_29,
			var3_29 + var12_29
		}
	elseif arg1_29 == "LBRB" then
		local var13_29 = Vector3(0, -(arg2_29 or 0), 0)

		var0_29 = {
			var4_29 + var13_29,
			var5_29 + var13_29
		}
	elseif arg1_29 == "RBLB" then
		local var14_29 = Vector3(0, -(arg2_29 or 0), 0)

		var0_29 = {
			var5_29 + var14_29,
			var4_29 + var14_29
		}
	end

	return var0_29
end

function var0_0.GenMoveNode(arg0_30, arg1_30)
	local var0_30 = {}

	if type(arg1_30.path) == "table" then
		for iter0_30, iter1_30 in ipairs(arg1_30.path) do
			table.insert(var0_30, Vector3(iter1_30[1], iter1_30[2], 0))
		end
	elseif type(arg1_30.path) == "string" then
		var0_30 = arg0_30:GetPathByString(arg1_30.path, arg1_30.offset)
	else
		var0_30 = arg0_30:GetPathByString("LTRT")
	end

	local var1_30 = type(arg1_30.spine) == "table" or arg1_30.spine == true
	local var2_30

	if arg1_30.spine == true then
		var2_30 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1_30 then
		var2_30 = {
			action = arg1_30.spine.action or "walk",
			scale = arg1_30.spine.scale or 0.5
		}
	end

	return {
		name = arg1_30.name,
		isSpine = var1_30,
		spineData = var2_30,
		path = var0_30,
		time = arg1_30.time,
		delay = arg1_30.delay or 0,
		easeType = arg1_30.easeType or LeanTweenType.linear
	}
end

function var0_0.GetMovableNode(arg0_31)
	if not arg0_31:ExistMovableNode() then
		return {}
	end

	local var0_31 = {}

	for iter0_31, iter1_31 in pairs(arg0_31.movableNode or {}) do
		local var1_31 = arg0_31:GenMoveNode(iter1_31)

		table.insert(var0_31, var1_31)
	end

	return var0_31
end

function var0_0.OldPhotoEffect(arg0_32)
	return arg0_32.oldPhoto
end

function var0_0.ShouldBgGlitchArt(arg0_33)
	return arg0_33.bgGlitchArt
end

function var0_0.IsSameBranch(arg0_34, arg1_34)
	return not arg0_34.branchCode or arg0_34.branchCode == arg1_34
end

function var0_0.GetMode(arg0_35)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_36)
	if arg0_36.flashout then
		local var0_36 = arg0_36.flashout.alpha[1]
		local var1_36 = arg0_36.flashout.alpha[2]
		local var2_36 = arg0_36.flashout.dur
		local var3_36 = arg0_36.flashout.black

		return var0_36, var1_36, var2_36, var3_36
	end
end

function var0_0.GetFlashinData(arg0_37)
	if arg0_37.flashin then
		local var0_37 = arg0_37.flashin.alpha[1]
		local var1_37 = arg0_37.flashin.alpha[2]
		local var2_37 = arg0_37.flashin.dur
		local var3_37 = arg0_37.flashin.black
		local var4_37 = arg0_37.flashin.delay

		return var0_37, var1_37, var2_37, var3_37, var4_37
	end
end

function var0_0.GetBgColor(arg0_38)
	return Color.New(arg0_38.bgColor[1] or 0, arg0_38.bgColor[2] or 0, arg0_38.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_39)
	return arg0_39.blackBg
end

function var0_0.GetBgName(arg0_40)
	return arg0_40.bgName
end

function var0_0.GetBgShadow(arg0_41)
	return arg0_41.bgShadow
end

function var0_0.IsDialogueMode(arg0_42)
	return arg0_42:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_43)
	return arg0_43.bgm, arg0_43.bgmDelay, arg0_43.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_44)
	return arg0_44.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_45)
	return arg0_45.stopbgm
end

function var0_0.GetEffects(arg0_46)
	return arg0_46.effects
end

function var0_0.ShouldBlink(arg0_47)
	return arg0_47.blink ~= nil
end

function var0_0.GetBlinkData(arg0_48)
	return arg0_48.blink
end

function var0_0.ShouldBlinkWithColor(arg0_49)
	return arg0_49.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_50)
	return arg0_50.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_51)
	return arg0_51.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_52)
	return arg0_52.soundeffect, arg0_52.seDelay
end

function var0_0.ShouldPlayVoice(arg0_53)
	return arg0_53.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_54)
	return arg0_54.stopVoice
end

function var0_0.GetVoice(arg0_55)
	return arg0_55.voice, arg0_55.voiceDelay
end

function var0_0.ExistOption(arg0_56)
	return arg0_56.options ~= nil and #arg0_56.options > 0
end

function var0_0.GetOptionCnt(arg0_57)
	if arg0_57:ExistOption() then
		return #arg0_57.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_58, arg1_58)
	arg0_58.optionSelCode = arg1_58
end

function var0_0.IsBlackFrontGround(arg0_59)
	return arg0_59.blackFg > 0, Mathf.Clamp01(arg0_59.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_60)
	local var0_60 = 0
	local var1_60 = 0

	for iter0_60, iter1_60 in ipairs(arg0_60.options) do
		if arg0_60.optionSelCode and iter1_60.flag == arg0_60.optionSelCode then
			var0_60 = iter0_60

			break
		end

		if iter1_60.autochoice and iter1_60.autochoice == 1 then
			var1_60 = iter0_60
		end
	end

	if var0_60 > 0 then
		return var0_60
	end

	if var1_60 > 0 then
		return var1_60
	end

	return nil
end

function var0_0.IsImport(arg0_61)
	return arg0_61.important
end

function var0_0.SetOptionIndex(arg0_62, arg1_62)
	arg0_62.optionIndex = arg1_62
end

function var0_0.GetOptionIndex(arg0_63)
	return arg0_63.optionIndex
end

function var0_0.GetOptions(arg0_64)
	return _.map(arg0_64.options or {}, function(arg0_65)
		local var0_65 = arg0_65.content

		if arg0_64:ShouldReplacePlayer() then
			var0_65 = arg0_64:ReplacePlayerName(var0_65)
		end

		if arg0_64:ShouldReplaceTb() then
			var0_65 = arg0_64:ReplaceTbName(var0_65)
		end

		if arg0_64:ShouldReplaceDorm() then
			var0_65 = arg0_64:ReplaceDormName(var0_65)
		end

		local var1_65 = HXSet.hxLan(var0_65)

		return {
			var1_65,
			arg0_65.flag
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_66)
	return arg0_66.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_67)
	return arg0_67.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_68)
	return arg0_68.eventDelay and arg0_68.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_69)
	return arg0_69.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_70)
	return {}
end

return var0_0
