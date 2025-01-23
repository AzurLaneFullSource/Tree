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
	arg0_1.code = arg1_1.code or -1
	arg0_1.autoShowOption = defaultValue(arg1_1.autoShowOption, false)
	arg0_1.selectedBranchCode = 0
	arg0_1.id = 0
	arg0_1.placeholderType = 0
	arg0_1.defaultTb = arg1_1.defaultTb
	arg0_1.optionIndex = 0
end

function var0_0.IsVaild(arg0_2, arg1_2)
	if arg0_2.code == -1 then
		return true
	end

	if type(arg0_2.code) == "string" or type(arg0_2.code) == "number" then
		return arg0_2.code == arg1_2
	elseif type(arg0_2.code) == "table" then
		return table.contains(arg0_2.code, arg1_2)
	end

	return false
end

function var0_0.ShouldShake(arg0_3)
	return arg0_3.shakeTime > 0
end

function var0_0.GetShakeTime(arg0_4)
	return arg0_4.shakeTime
end

function var0_0.SetDefaultTb(arg0_5, arg1_5)
	if not arg0_5.defaultTb or arg0_5.defaultTb <= 0 then
		arg0_5.defaultTb = arg1_5
	end
end

function var0_0.SetPlaceholderType(arg0_6, arg1_6)
	arg0_6.placeholderType = arg1_6
end

function var0_0.ShouldReplacePlayer(arg0_7)
	return bit.band(arg0_7.placeholderType, Story.PLAYER) > 0
end

function var0_0.ShouldReplaceTb(arg0_8)
	return bit.band(arg0_8.placeholderType, Story.TB) > 0
end

function var0_0.ShouldReplaceDorm(arg0_9)
	return bit.band(arg0_9.placeholderType, Story.DORM) > 0
end

function var0_0.ReplacePlayerName(arg0_10, arg1_10)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return arg1_10
	end

	local var0_10 = getProxy(PlayerProxy):getRawData():GetName()

	arg1_10 = string.gsub(arg1_10, "{playername}", var0_10)

	return arg1_10
end

function var0_0.ReplaceTbName(arg0_11, arg1_11)
	if pg.NewStoryMgr.GetInstance():IsReView() then
		return string.gsub(arg1_11, "{tb}", i18n("child_story_name"))
	end

	if not getProxy(EducateProxy) or not getProxy(NewEducateProxy) then
		return arg1_11
	end

	if not getProxy(NewEducateProxy):GetCurChar() then
		local var0_11, var1_11 = getProxy(EducateProxy):GetStoryInfo()

		arg1_11 = string.gsub(arg1_11, "{tb}", var1_11)
	else
		local var2_11, var3_11 = getProxy(NewEducateProxy):GetStoryInfo()

		arg1_11 = string.gsub(arg1_11, "{tb}", var3_11)
	end

	return arg1_11
end

function var0_0.ReplaceDormName(arg0_12, arg1_12)
	if not arg0_12.actorName then
		return arg1_12
	end

	local var0_12 = getProxy(ApartmentProxy):getApartment(arg0_12.actorName)
	local var1_12 = var0_12 and var0_12:GetCallName() or arg0_12.actorName

	arg1_12 = string.gsub(arg1_12, "{dorm3d}", var1_12)

	return arg1_12
end

function var0_0.ExistDispatcher(arg0_13)
	return arg0_13.dispatcher ~= nil
end

function var0_0.GetDispatcher(arg0_14)
	return arg0_14.dispatcher
end

function var0_0.IsRecallDispatcher(arg0_15)
	if not arg0_15:ExistDispatcher() then
		return false
	end

	local var0_15 = arg0_15:GetDispatcher()

	return var0_15.callbackData ~= nil and var0_15.callbackData.name ~= nil
end

function var0_0.GetDispatcherRecallName(arg0_16)
	if not arg0_16:IsRecallDispatcher() then
		return nil
	end

	return arg0_16:GetDispatcher().callbackData.name
end

function var0_0.ShouldHideUI(arg0_17)
	if not arg0_17:IsRecallDispatcher() then
		return false
	end

	return arg0_17:GetDispatcher().callbackData.hideUI == true
end

function var0_0.ExistIcon(arg0_18)
	return arg0_18.icon ~= nil
end

function var0_0.GetIconData(arg0_19)
	return arg0_19.icon
end

function var0_0.SetId(arg0_20, arg1_20)
	arg0_20.id = arg1_20
end

function var0_0.GetId(arg0_21)
	return arg0_21.id
end

function var0_0.AutoShowOption(arg0_22)
	arg0_22.autoShowOption = true
end

function var0_0.SkipEventForOption(arg0_23)
	return arg0_23:ExistOption() and arg0_23.autoShowOption
end

function var0_0.IsRecallOption(arg0_24)
	if arg0_24:ExistOption() and arg0_24:GetOptionCnt() > 1 and arg0_24.recallOption then
		return true
	end

	return false
end

function var0_0.SetBranchCode(arg0_25, arg1_25)
	arg0_25.selectedBranchCode = arg1_25
end

function var0_0.GetSelectedBranchCode(arg0_26)
	return arg0_26.selectedBranchCode
end

function var0_0.ExistLocation(arg0_27)
	return arg0_27.location ~= nil
end

function var0_0.GetLocation(arg0_28)
	return {
		text = arg0_28.location[1] or "",
		time = arg0_28.location[2] or 999
	}
end

function var0_0.ExistMovableNode(arg0_29)
	return arg0_29.movableNode ~= nil and type(arg0_29.movableNode) == "table" and #arg0_29.movableNode > 0
end

function var0_0.GetPathByString(arg0_30, arg1_30, arg2_30)
	local var0_30 = {}
	local var1_30 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2_30 = Vector3(-var1_30.x * 0.5, var1_30.y * 0.5, 0)
	local var3_30 = Vector3(var1_30.x * 0.5, var1_30.y * 0.5, 0)
	local var4_30 = Vector3(-var1_30.x * 0.5, -var1_30.y * 0.5, 0)
	local var5_30 = Vector3(var1_30.x * 0.5, -var1_30.y * 0.5, 0)
	local var6_30 = arg2_30 or 200

	if arg1_30 == "LTLB" then
		local var7_30 = Vector3(var6_30, 0, 0)

		var0_30 = {
			var2_30 + var7_30,
			var4_30 + var7_30
		}
	elseif arg1_30 == "LBLT" then
		local var8_30 = Vector3(var6_30, 0, 0)

		var0_30 = {
			var4_30 + var8_30,
			var2_30 + var8_30
		}
	elseif arg1_30 == "LTRT" then
		local var9_30 = Vector3(0, -var6_30, 0)

		var0_30 = {
			var2_30 + var9_30,
			var3_30 + var9_30
		}
	elseif arg1_30 == "RTLT" then
		local var10_30 = Vector3(0, -var6_30, 0)

		var0_30 = {
			var3_30 + var10_30,
			var2_30 + var10_30
		}
	elseif arg1_30 == "RTRB" then
		local var11_30 = Vector3(var6_30, 0, 0)

		var0_30 = {
			var3_30 + var11_30,
			var5_30 + var11_30
		}
	elseif arg1_30 == "RBRT" then
		local var12_30 = Vector3(var6_30, 0, 0)

		var0_30 = {
			var5_30 + var12_30,
			var3_30 + var12_30
		}
	elseif arg1_30 == "LBRB" then
		local var13_30 = Vector3(0, -(arg2_30 or 0), 0)

		var0_30 = {
			var4_30 + var13_30,
			var5_30 + var13_30
		}
	elseif arg1_30 == "RBLB" then
		local var14_30 = Vector3(0, -(arg2_30 or 0), 0)

		var0_30 = {
			var5_30 + var14_30,
			var4_30 + var14_30
		}
	end

	return var0_30
end

function var0_0.GenMoveNode(arg0_31, arg1_31)
	local var0_31 = {}

	if type(arg1_31.path) == "table" then
		for iter0_31, iter1_31 in ipairs(arg1_31.path) do
			table.insert(var0_31, Vector3(iter1_31[1], iter1_31[2], 0))
		end
	elseif type(arg1_31.path) == "string" then
		var0_31 = arg0_31:GetPathByString(arg1_31.path, arg1_31.offset)
	else
		var0_31 = arg0_31:GetPathByString("LTRT")
	end

	local var1_31 = type(arg1_31.spine) == "table" or arg1_31.spine == true
	local var2_31

	if arg1_31.spine == true then
		var2_31 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1_31 then
		var2_31 = {
			action = arg1_31.spine.action or "walk",
			scale = arg1_31.spine.scale or 0.5
		}
	end

	return {
		name = arg1_31.name,
		isSpine = var1_31,
		spineData = var2_31,
		path = var0_31,
		time = arg1_31.time,
		delay = arg1_31.delay or 0,
		easeType = arg1_31.easeType or LeanTweenType.linear
	}
end

function var0_0.GetMovableNode(arg0_32)
	if not arg0_32:ExistMovableNode() then
		return {}
	end

	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.movableNode or {}) do
		local var1_32 = arg0_32:GenMoveNode(iter1_32)

		table.insert(var0_32, var1_32)
	end

	return var0_32
end

function var0_0.OldPhotoEffect(arg0_33)
	return arg0_33.oldPhoto
end

function var0_0.ShouldBgGlitchArt(arg0_34)
	return arg0_34.bgGlitchArt
end

function var0_0.IsSameBranch(arg0_35, arg1_35)
	return not arg0_35.branchCode or arg0_35.branchCode == arg1_35
end

function var0_0.GetMode(arg0_36)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_37)
	if arg0_37.flashout then
		local var0_37 = arg0_37.flashout.alpha[1]
		local var1_37 = arg0_37.flashout.alpha[2]
		local var2_37 = arg0_37.flashout.dur
		local var3_37 = arg0_37.flashout.black

		return var0_37, var1_37, var2_37, var3_37
	end
end

function var0_0.GetFlashinData(arg0_38)
	if arg0_38.flashin then
		local var0_38 = arg0_38.flashin.alpha[1]
		local var1_38 = arg0_38.flashin.alpha[2]
		local var2_38 = arg0_38.flashin.dur
		local var3_38 = arg0_38.flashin.black
		local var4_38 = arg0_38.flashin.delay

		return var0_38, var1_38, var2_38, var3_38, var4_38
	end
end

function var0_0.GetBgColor(arg0_39)
	return Color.New(arg0_39.bgColor[1] or 0, arg0_39.bgColor[2] or 0, arg0_39.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_40)
	return arg0_40.blackBg
end

function var0_0.GetBgName(arg0_41)
	return arg0_41.bgName
end

function var0_0.GetBgShadow(arg0_42)
	return arg0_42.bgShadow
end

function var0_0.IsDialogueMode(arg0_43)
	return arg0_43:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_44)
	return arg0_44.bgm, arg0_44.bgmDelay, arg0_44.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_45)
	return arg0_45.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_46)
	return arg0_46.stopbgm
end

function var0_0.GetEffects(arg0_47)
	return arg0_47.effects
end

function var0_0.ShouldBlink(arg0_48)
	return arg0_48.blink ~= nil
end

function var0_0.GetBlinkData(arg0_49)
	return arg0_49.blink
end

function var0_0.ShouldBlinkWithColor(arg0_50)
	return arg0_50.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_51)
	return arg0_51.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_52)
	return arg0_52.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_53)
	return arg0_53.soundeffect, arg0_53.seDelay
end

function var0_0.ShouldPlayVoice(arg0_54)
	return arg0_54.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_55)
	return arg0_55.stopVoice
end

function var0_0.GetVoice(arg0_56)
	return arg0_56.voice, arg0_56.voiceDelay
end

function var0_0.ExistOption(arg0_57)
	return arg0_57.options ~= nil and #arg0_57.options > 0
end

function var0_0.GetOptionCnt(arg0_58)
	if arg0_58:ExistOption() then
		return #arg0_58.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_59, arg1_59)
	arg0_59.optionSelCode = arg1_59
end

function var0_0.IsBlackFrontGround(arg0_60)
	return arg0_60.blackFg > 0, Mathf.Clamp01(arg0_60.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_61)
	local var0_61 = 0
	local var1_61 = 0

	for iter0_61, iter1_61 in ipairs(arg0_61.options) do
		if arg0_61.optionSelCode and iter1_61.flag == arg0_61.optionSelCode then
			var0_61 = iter0_61

			break
		end

		if iter1_61.autochoice and iter1_61.autochoice == 1 then
			var1_61 = iter0_61
		end
	end

	if var0_61 > 0 then
		return var0_61
	end

	if var1_61 > 0 then
		return var1_61
	end

	return nil
end

function var0_0.IsImport(arg0_62)
	return arg0_62.important
end

function var0_0.SetOptionIndex(arg0_63, arg1_63)
	arg0_63.optionIndex = arg1_63
end

function var0_0.GetOptionIndex(arg0_64)
	return arg0_64.optionIndex
end

function var0_0.GetOptions(arg0_65)
	return _.map(arg0_65.options or {}, function(arg0_66)
		local var0_66 = arg0_66.content

		if arg0_65:ShouldReplacePlayer() then
			var0_66 = arg0_65:ReplacePlayerName(var0_66)
		end

		if arg0_65:ShouldReplaceTb() then
			var0_66 = arg0_65:ReplaceTbName(var0_66)
		end

		if arg0_65:ShouldReplaceDorm() then
			var0_66 = arg0_65:ReplaceDormName(var0_66)
		end

		local var1_66 = HXSet.hxLan(var0_66)

		return {
			var1_66,
			arg0_66.flag,
			arg0_66.type
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_67)
	return arg0_67.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_68)
	return arg0_68.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_69)
	return arg0_69.eventDelay and arg0_69.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_70)
	return arg0_70.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_71)
	return {}
end

return var0_0
