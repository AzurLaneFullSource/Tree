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
	arg0_1.optionForceCenter = arg1_1.option_force_center
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

function var0_0.IsOptionForceCenter(arg0_25)
	return arg0_25.optionForceCenter
end

function var0_0.SetBranchCode(arg0_26, arg1_26)
	arg0_26.selectedBranchCode = arg1_26
end

function var0_0.GetSelectedBranchCode(arg0_27)
	return arg0_27.selectedBranchCode
end

function var0_0.ExistLocation(arg0_28)
	return arg0_28.location ~= nil
end

function var0_0.GetLocation(arg0_29)
	return {
		text = arg0_29.location[1] or "",
		time = arg0_29.location[2] or 999
	}
end

function var0_0.ExistMovableNode(arg0_30)
	return arg0_30.movableNode ~= nil and type(arg0_30.movableNode) == "table" and #arg0_30.movableNode > 0
end

function var0_0.GetPathByString(arg0_31, arg1_31, arg2_31)
	local var0_31 = {}
	local var1_31 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2_31 = Vector3(-var1_31.x * 0.5, var1_31.y * 0.5, 0)
	local var3_31 = Vector3(var1_31.x * 0.5, var1_31.y * 0.5, 0)
	local var4_31 = Vector3(-var1_31.x * 0.5, -var1_31.y * 0.5, 0)
	local var5_31 = Vector3(var1_31.x * 0.5, -var1_31.y * 0.5, 0)
	local var6_31 = arg2_31 or 200

	if arg1_31 == "LTLB" then
		local var7_31 = Vector3(var6_31, 0, 0)

		var0_31 = {
			var2_31 + var7_31,
			var4_31 + var7_31
		}
	elseif arg1_31 == "LBLT" then
		local var8_31 = Vector3(var6_31, 0, 0)

		var0_31 = {
			var4_31 + var8_31,
			var2_31 + var8_31
		}
	elseif arg1_31 == "LTRT" then
		local var9_31 = Vector3(0, -var6_31, 0)

		var0_31 = {
			var2_31 + var9_31,
			var3_31 + var9_31
		}
	elseif arg1_31 == "RTLT" then
		local var10_31 = Vector3(0, -var6_31, 0)

		var0_31 = {
			var3_31 + var10_31,
			var2_31 + var10_31
		}
	elseif arg1_31 == "RTRB" then
		local var11_31 = Vector3(var6_31, 0, 0)

		var0_31 = {
			var3_31 + var11_31,
			var5_31 + var11_31
		}
	elseif arg1_31 == "RBRT" then
		local var12_31 = Vector3(var6_31, 0, 0)

		var0_31 = {
			var5_31 + var12_31,
			var3_31 + var12_31
		}
	elseif arg1_31 == "LBRB" then
		local var13_31 = Vector3(0, -(arg2_31 or 0), 0)

		var0_31 = {
			var4_31 + var13_31,
			var5_31 + var13_31
		}
	elseif arg1_31 == "RBLB" then
		local var14_31 = Vector3(0, -(arg2_31 or 0), 0)

		var0_31 = {
			var5_31 + var14_31,
			var4_31 + var14_31
		}
	end

	return var0_31
end

function var0_0.GenMoveNode(arg0_32, arg1_32)
	local var0_32 = {}

	if type(arg1_32.path) == "table" then
		for iter0_32, iter1_32 in ipairs(arg1_32.path) do
			table.insert(var0_32, Vector3(iter1_32[1], iter1_32[2], 0))
		end
	elseif type(arg1_32.path) == "string" then
		var0_32 = arg0_32:GetPathByString(arg1_32.path, arg1_32.offset)
	else
		var0_32 = arg0_32:GetPathByString("LTRT")
	end

	local var1_32 = type(arg1_32.spine) == "table" or arg1_32.spine == true
	local var2_32

	if arg1_32.spine == true then
		var2_32 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1_32 then
		var2_32 = {
			action = arg1_32.spine.action or "walk",
			scale = arg1_32.spine.scale or 0.5
		}
	end

	return {
		name = arg1_32.name,
		isSpine = var1_32,
		spineData = var2_32,
		path = var0_32,
		time = arg1_32.time,
		delay = arg1_32.delay or 0,
		easeType = arg1_32.easeType or LeanTweenType.linear
	}
end

function var0_0.GetMovableNode(arg0_33)
	if not arg0_33:ExistMovableNode() then
		return {}
	end

	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.movableNode or {}) do
		local var1_33 = arg0_33:GenMoveNode(iter1_33)

		table.insert(var0_33, var1_33)
	end

	return var0_33
end

function var0_0.OldPhotoEffect(arg0_34)
	return arg0_34.oldPhoto
end

function var0_0.ShouldBgGlitchArt(arg0_35)
	return arg0_35.bgGlitchArt
end

function var0_0.IsSameBranch(arg0_36, arg1_36)
	return not arg0_36.branchCode or arg0_36.branchCode == arg1_36
end

function var0_0.IsGlobalFlagHit(arg0_37)
	local var0_37 = var0_0.GetGlobalFlagKey(arg0_37.globalBranchCode.id)
	local var1_37 = 1
	local var2_37 = 0

	while PlayerPrefs.HasKey(var0_37 .. var1_37) do
		var2_37 = var2_37 + PlayerPrefs.GetInt(var0_37 .. var1_37)
		var1_37 = var1_37 + 1
	end

	local var3_37 = arg0_37.globalBranchCode.section

	for iter0_37, iter1_37 in ipairs(var3_37) do
		if var2_37 >= iter1_37[1] and var2_37 <= iter1_37[2] then
			return true
		end
	end

	return false
end

function var0_0.GetGlobalFlagKey(arg0_38)
	return getProxy(PlayerProxy):getRawData().id .. "GlobalStoryFlag_" .. arg0_38 .. "_"
end

function var0_0.GetMode(arg0_39)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_40)
	if arg0_40.flashout then
		local var0_40 = arg0_40.flashout.alpha[1]
		local var1_40 = arg0_40.flashout.alpha[2]
		local var2_40 = arg0_40.flashout.dur
		local var3_40 = arg0_40.flashout.black

		return var0_40, var1_40, var2_40, var3_40
	end
end

function var0_0.GetFlashinData(arg0_41)
	if arg0_41.flashin then
		local var0_41 = arg0_41.flashin.alpha[1]
		local var1_41 = arg0_41.flashin.alpha[2]
		local var2_41 = arg0_41.flashin.dur
		local var3_41 = arg0_41.flashin.black
		local var4_41 = arg0_41.flashin.delay

		return var0_41, var1_41, var2_41, var3_41, var4_41
	end
end

function var0_0.GetBgColor(arg0_42)
	return Color.New(arg0_42.bgColor[1] or 0, arg0_42.bgColor[2] or 0, arg0_42.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_43)
	return arg0_43.blackBg
end

function var0_0.GetBgName(arg0_44)
	return arg0_44.bgName
end

function var0_0.GetBgShadow(arg0_45)
	return arg0_45.bgShadow
end

function var0_0.IsDialogueMode(arg0_46)
	return arg0_46:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_47)
	return arg0_47.bgm, arg0_47.bgmDelay, arg0_47.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_48)
	return arg0_48.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_49)
	return arg0_49.stopbgm
end

function var0_0.GetEffects(arg0_50)
	return arg0_50.effects
end

function var0_0.ShouldBlink(arg0_51)
	return arg0_51.blink ~= nil
end

function var0_0.GetBlinkData(arg0_52)
	return arg0_52.blink
end

function var0_0.ShouldBlinkWithColor(arg0_53)
	return arg0_53.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_54)
	return arg0_54.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_55)
	return arg0_55.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_56)
	return arg0_56.soundeffect, arg0_56.seDelay
end

function var0_0.ShouldPlayVoice(arg0_57)
	return arg0_57.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_58)
	return arg0_58.stopVoice
end

function var0_0.GetVoice(arg0_59)
	return arg0_59.voice, arg0_59.voiceDelay
end

function var0_0.ExistOption(arg0_60)
	return arg0_60.options ~= nil and #arg0_60.options > 0
end

function var0_0.GetOptionCnt(arg0_61)
	if arg0_61:ExistOption() then
		return #arg0_61.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_62, arg1_62)
	arg0_62.optionSelCode = arg1_62
end

function var0_0.IsBlackFrontGround(arg0_63)
	return arg0_63.blackFg > 0, Mathf.Clamp01(arg0_63.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_64)
	local var0_64 = 0
	local var1_64 = 0

	for iter0_64, iter1_64 in ipairs(arg0_64.options) do
		if arg0_64.optionSelCode and iter1_64.flag == arg0_64.optionSelCode then
			var0_64 = iter0_64

			break
		end

		if iter1_64.autochoice and iter1_64.autochoice == 1 then
			var1_64 = iter0_64
		end
	end

	if var0_64 > 0 then
		return var0_64
	end

	if var1_64 > 0 then
		return var1_64
	end

	return nil
end

function var0_0.IsImport(arg0_65)
	return arg0_65.important
end

function var0_0.SetOptionIndex(arg0_66, arg1_66)
	arg0_66.optionIndex = arg1_66
end

function var0_0.GetOptionIndex(arg0_67)
	return arg0_67.optionIndex
end

function var0_0.GetOptions(arg0_68)
	return _.map(arg0_68.options or {}, function(arg0_69)
		local var0_69 = arg0_69.content

		if arg0_68:ShouldReplacePlayer() then
			var0_69 = arg0_68:ReplacePlayerName(var0_69)
		end

		if arg0_68:ShouldReplaceTb() then
			var0_69 = arg0_68:ReplaceTbName(var0_69)
		end

		if arg0_68:ShouldReplaceDorm() then
			var0_69 = arg0_68:ReplaceDormName(var0_69)
		end

		local var1_69 = HXSet.hxLan(var0_69)

		return {
			var1_69,
			arg0_69.flag,
			arg0_69.type,
			arg0_69.globalFlag
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_70)
	return arg0_70.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_71)
	return arg0_71.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_72)
	return arg0_72.eventDelay and arg0_72.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_73)
	return arg0_73.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_74)
	return {}
end

function var0_0.GetResList(arg0_75)
	local var0_75 = {}
	local var1_75 = arg0_75:GetBgName()

	if var1_75 then
		table.insert(var0_75, var1_75)
	end

	if arg0_75.GetSubBg then
		local var2_75 = arg0_75:GetSubBg()

		if var2_75 then
			table.insert(var0_75, var2_75)
		end
	end

	local var3_75 = _.map(var0_75, function(arg0_76)
		return "bg/" .. arg0_76
	end)
	local var4_75 = {}
	local var5_75, var6_75, var7_75 = arg0_75:GetBgmData()

	if var5_75 then
		table.insert(var4_75, var5_75)
	end

	local var8_75 = {}

	_.each(var4_75, function(arg0_77)
		table.insert(var8_75, "cue/" .. arg0_77 .. ".b")
		table.insert(var8_75, "cue/bgm-" .. arg0_77 .. ".b")
	end)

	local var9_75 = {}

	if arg0_75:ShouldPlaySoundEffect() then
		local var10_75, var11_75 = arg0_75:GetSoundeffect()

		if var10_75 then
			table.insert(var9_75, var10_75)
		end
	end

	local var12_75 = {}

	_.each(var9_75, function(arg0_78)
		local var0_78 = pg.CriMgr.GetInstance():CheckFModeEvent(arg0_78, function()
			return
		end, function()
			return
		end)

		if var0_78 then
			table.insert(var12_75, "cue/" .. var0_78 .. ".b")
		end
	end)

	local var13_75 = {}

	if arg0_75:ShouldPlayVoice() then
		local var14_75, var15_75 = arg0_75:GetVoice()

		if var14_75 then
			table.insert(var13_75, var14_75)
		end
	end

	local var16_75 = {}

	_.each(var13_75, function(arg0_81)
		local var0_81 = pg.CriMgr.GetInstance():CheckFModeEvent(arg0_81, function()
			return
		end, function()
			return
		end)

		if var0_81 then
			table.insert(var16_75, "cue/" .. var0_81 .. ".b")
		end
	end)

	local var17_75 = {}
	local var18_75 = arg0_75:GetEffects()

	_.each(var18_75, function(arg0_84)
		local var0_84 = arg0_84.name

		table.insert(var17_75, var0_84)
	end)

	local var19_75 = {}

	_.each(var17_75, function(arg0_85)
		table.insert(var19_75, "ui/" .. arg0_85)
		table.insert(var19_75, "effect/" .. arg0_85)
	end)

	local var20_75 = {}

	if arg0_75:ExistIcon() then
		local var21_75 = arg0_75:GetIconData()

		if var21_75 and var21_75.image then
			table.insert(var20_75, var21_75.image)
		end
	end

	local var22_75 = {}
	local var23_75 = StoryRecorder.New()

	var23_75:Add(arg0_75)

	local var24_75 = var23_75:GetContentList()

	_.each(var24_75, function(arg0_86)
		if arg0_86.icon then
			local var0_86 = "squareicon/" .. arg0_86.icon

			table.insert(var22_75, var0_86)
		end
	end)

	return (SplitPackMediatorResMap.MergeLuaArr(var3_75, var8_75, var12_75, var16_75, var19_75, var20_75, var22_75))
end

return var0_0
