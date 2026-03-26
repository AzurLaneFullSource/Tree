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
	arg0_1.globalBranchCode = arg1_1.globalOptionFlag
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

function var0_0.IsValid(arg0_2, arg1_2)
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

function var0_0.IsGlobalFlagHit(arg0_36)
	local var0_36 = var0_0.GetGlobalFlagKey(arg0_36.globalBranchCode.id)
	local var1_36 = 1
	local var2_36 = 0

	while PlayerPrefs.HasKey(var0_36 .. var1_36) do
		var2_36 = var2_36 + PlayerPrefs.GetInt(var0_36 .. var1_36)
		var1_36 = var1_36 + 1
	end

	local var3_36 = arg0_36.globalBranchCode.section

	for iter0_36, iter1_36 in ipairs(var3_36) do
		if var2_36 >= iter1_36[1] and var2_36 <= iter1_36[2] then
			return true
		end
	end

	return false
end

function var0_0.GetGlobalFlagKey(arg0_37)
	return getProxy(PlayerProxy):getRawData().id .. "GlobalStoryFlag_" .. arg0_37 .. "_"
end

function var0_0.GetMode(arg0_38)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_39)
	if arg0_39.flashout then
		local var0_39 = arg0_39.flashout.alpha[1]
		local var1_39 = arg0_39.flashout.alpha[2]
		local var2_39 = arg0_39.flashout.dur
		local var3_39 = arg0_39.flashout.black

		return var0_39, var1_39, var2_39, var3_39
	end
end

function var0_0.GetFlashinData(arg0_40)
	if arg0_40.flashin then
		local var0_40 = arg0_40.flashin.alpha[1]
		local var1_40 = arg0_40.flashin.alpha[2]
		local var2_40 = arg0_40.flashin.dur
		local var3_40 = arg0_40.flashin.black
		local var4_40 = arg0_40.flashin.delay

		return var0_40, var1_40, var2_40, var3_40, var4_40
	end
end

function var0_0.GetBgColor(arg0_41)
	return Color.New(arg0_41.bgColor[1] or 0, arg0_41.bgColor[2] or 0, arg0_41.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_42)
	return arg0_42.blackBg
end

function var0_0.GetBgName(arg0_43)
	return arg0_43.bgName
end

function var0_0.GetBgShadow(arg0_44)
	return arg0_44.bgShadow
end

function var0_0.IsDialogueMode(arg0_45)
	return arg0_45:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_46)
	return arg0_46.bgm, arg0_46.bgmDelay, arg0_46.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_47)
	return arg0_47.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_48)
	return arg0_48.stopbgm
end

function var0_0.GetEffects(arg0_49)
	return arg0_49.effects
end

function var0_0.ShouldBlink(arg0_50)
	return arg0_50.blink ~= nil
end

function var0_0.GetBlinkData(arg0_51)
	return arg0_51.blink
end

function var0_0.ShouldBlinkWithColor(arg0_52)
	return arg0_52.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_53)
	return arg0_53.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_54)
	return arg0_54.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_55)
	return arg0_55.soundeffect, arg0_55.seDelay
end

function var0_0.ShouldPlayVoice(arg0_56)
	return arg0_56.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_57)
	return arg0_57.stopVoice
end

function var0_0.GetVoice(arg0_58)
	return arg0_58.voice, arg0_58.voiceDelay
end

function var0_0.ExistOption(arg0_59)
	return arg0_59.options ~= nil and #arg0_59.options > 0
end

function var0_0.GetOptionCnt(arg0_60)
	if arg0_60:ExistOption() then
		return #arg0_60.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_61, arg1_61)
	arg0_61.optionSelCode = arg1_61
end

function var0_0.IsBlackFrontGround(arg0_62)
	return arg0_62.blackFg > 0, Mathf.Clamp01(arg0_62.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_63)
	local var0_63 = 0
	local var1_63 = 0

	for iter0_63, iter1_63 in ipairs(arg0_63.options) do
		if arg0_63.optionSelCode and iter1_63.flag == arg0_63.optionSelCode then
			var0_63 = iter0_63

			break
		end

		if iter1_63.autochoice and iter1_63.autochoice == 1 then
			var1_63 = iter0_63
		end
	end

	if var0_63 > 0 then
		return var0_63
	end

	if var1_63 > 0 then
		return var1_63
	end

	return nil
end

function var0_0.IsImport(arg0_64)
	return arg0_64.important
end

function var0_0.SetOptionIndex(arg0_65, arg1_65)
	arg0_65.optionIndex = arg1_65
end

function var0_0.GetOptionIndex(arg0_66)
	return arg0_66.optionIndex
end

function var0_0.GetOptions(arg0_67)
	return _.map(arg0_67.options or {}, function(arg0_68)
		local var0_68 = arg0_68.content

		if arg0_67:ShouldReplacePlayer() then
			var0_68 = arg0_67:ReplacePlayerName(var0_68)
		end

		if arg0_67:ShouldReplaceTb() then
			var0_68 = arg0_67:ReplaceTbName(var0_68)
		end

		if arg0_67:ShouldReplaceDorm() then
			var0_68 = arg0_67:ReplaceDormName(var0_68)
		end

		local var1_68 = HXSet.hxLan(var0_68)

		return {
			var1_68,
			arg0_68.flag,
			arg0_68.type,
			arg0_68.globalFlag
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_69)
	return arg0_69.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_70)
	return arg0_70.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_71)
	return arg0_71.eventDelay and arg0_71.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_72)
	return arg0_72.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_73)
	return {}
end

return var0_0
