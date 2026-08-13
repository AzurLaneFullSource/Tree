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

function var0_0.ShouldReplaceCar2026(arg0_10)
	return bit.band(arg0_10.placeholderType, Story.CAR2026) > 0
end

function var0_0.ReplacePlayerName(arg0_11, arg1_11)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return arg1_11
	end

	local var0_11 = getProxy(PlayerProxy):getRawData():GetName()

	arg1_11 = string.gsub(arg1_11, "{playername}", var0_11)

	return arg1_11
end

function var0_0.ReplaceTbName(arg0_12, arg1_12)
	if pg.NewStoryMgr.GetInstance():IsReView() then
		return string.gsub(arg1_12, "{tb}", i18n("child_story_name"))
	end

	if not getProxy(EducateProxy) or not getProxy(NewEducateProxy) then
		return arg1_12
	end

	if not getProxy(NewEducateProxy):GetCurChar() then
		local var0_12, var1_12 = getProxy(EducateProxy):GetStoryInfo()

		arg1_12 = string.gsub(arg1_12, "{tb}", var1_12)
	else
		local var2_12, var3_12 = getProxy(NewEducateProxy):GetStoryInfo()

		arg1_12 = string.gsub(arg1_12, "{tb}", var3_12)
	end

	return arg1_12
end

function var0_0.ReplaceDormName(arg0_13, arg1_13)
	if not arg0_13.actorName then
		return arg1_13
	end

	local var0_13 = getProxy(ApartmentProxy):getApartment(arg0_13.actorName)
	local var1_13 = var0_13 and var0_13:GetCallName() or arg0_13.actorName

	arg1_13 = string.gsub(arg1_13, "{dorm3d}", var1_13)

	return arg1_13
end

function var0_0.ReplaceCar2026Name(arg0_14, arg1_14)
	local var0_14 = getProxy(ActivityProxy)
	local var1_14 = var0_14:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var2_14 = ""

	if getProxy(PlayerProxy) then
		var2_14 = getProxy(PlayerProxy):getRawData():GetName()
	end

	if var1_14 then
		local var3_14 = var1_14:getConfig("config_client").link_act
		local var4_14 = var0_14:RawGetActivityById(var3_14)

		if var4_14 and not var4_14:isEnd() then
			var2_14 = var4_14.str_data1
		end
	end

	return string.gsub(arg1_14, "{car2026}", var2_14)
end

function var0_0.ExistDispatcher(arg0_15)
	return arg0_15.dispatcher ~= nil
end

function var0_0.GetDispatcher(arg0_16)
	return arg0_16.dispatcher
end

function var0_0.IsRecallDispatcher(arg0_17)
	if not arg0_17:ExistDispatcher() then
		return false
	end

	local var0_17 = arg0_17:GetDispatcher()

	return var0_17.callbackData ~= nil and var0_17.callbackData.name ~= nil
end

function var0_0.GetDispatcherRecallName(arg0_18)
	if not arg0_18:IsRecallDispatcher() then
		return nil
	end

	return arg0_18:GetDispatcher().callbackData.name
end

function var0_0.ShouldHideUI(arg0_19)
	if not arg0_19:IsRecallDispatcher() then
		return false
	end

	return arg0_19:GetDispatcher().callbackData.hideUI == true
end

function var0_0.ExistIcon(arg0_20)
	return arg0_20.icon ~= nil
end

function var0_0.GetIconData(arg0_21)
	return arg0_21.icon
end

function var0_0.SetId(arg0_22, arg1_22)
	arg0_22.id = arg1_22
end

function var0_0.GetId(arg0_23)
	return arg0_23.id
end

function var0_0.AutoShowOption(arg0_24)
	arg0_24.autoShowOption = true
end

function var0_0.SkipEventForOption(arg0_25)
	return arg0_25:ExistOption() and arg0_25.autoShowOption
end

function var0_0.IsRecallOption(arg0_26)
	if arg0_26:ExistOption() and arg0_26:GetOptionCnt() > 1 and arg0_26.recallOption then
		return true
	end

	return false
end

function var0_0.IsOptionForceCenter(arg0_27)
	return arg0_27.optionForceCenter
end

function var0_0.SetBranchCode(arg0_28, arg1_28)
	arg0_28.selectedBranchCode = arg1_28
end

function var0_0.GetSelectedBranchCode(arg0_29)
	return arg0_29.selectedBranchCode
end

function var0_0.ExistLocation(arg0_30)
	return arg0_30.location ~= nil
end

function var0_0.GetLocation(arg0_31)
	return {
		text = arg0_31.location[1] or "",
		time = arg0_31.location[2] or 999
	}
end

function var0_0.ExistMovableNode(arg0_32)
	return arg0_32.movableNode ~= nil and type(arg0_32.movableNode) == "table" and #arg0_32.movableNode > 0
end

function var0_0.GetPathByString(arg0_33, arg1_33, arg2_33)
	local var0_33 = {}
	local var1_33 = pg.NewStoryMgr.GetInstance():GetRectSize()
	local var2_33 = Vector3(-var1_33.x * 0.5, var1_33.y * 0.5, 0)
	local var3_33 = Vector3(var1_33.x * 0.5, var1_33.y * 0.5, 0)
	local var4_33 = Vector3(-var1_33.x * 0.5, -var1_33.y * 0.5, 0)
	local var5_33 = Vector3(var1_33.x * 0.5, -var1_33.y * 0.5, 0)
	local var6_33 = arg2_33 or 200

	if arg1_33 == "LTLB" then
		local var7_33 = Vector3(var6_33, 0, 0)

		var0_33 = {
			var2_33 + var7_33,
			var4_33 + var7_33
		}
	elseif arg1_33 == "LBLT" then
		local var8_33 = Vector3(var6_33, 0, 0)

		var0_33 = {
			var4_33 + var8_33,
			var2_33 + var8_33
		}
	elseif arg1_33 == "LTRT" then
		local var9_33 = Vector3(0, -var6_33, 0)

		var0_33 = {
			var2_33 + var9_33,
			var3_33 + var9_33
		}
	elseif arg1_33 == "RTLT" then
		local var10_33 = Vector3(0, -var6_33, 0)

		var0_33 = {
			var3_33 + var10_33,
			var2_33 + var10_33
		}
	elseif arg1_33 == "RTRB" then
		local var11_33 = Vector3(var6_33, 0, 0)

		var0_33 = {
			var3_33 + var11_33,
			var5_33 + var11_33
		}
	elseif arg1_33 == "RBRT" then
		local var12_33 = Vector3(var6_33, 0, 0)

		var0_33 = {
			var5_33 + var12_33,
			var3_33 + var12_33
		}
	elseif arg1_33 == "LBRB" then
		local var13_33 = Vector3(0, -(arg2_33 or 0), 0)

		var0_33 = {
			var4_33 + var13_33,
			var5_33 + var13_33
		}
	elseif arg1_33 == "RBLB" then
		local var14_33 = Vector3(0, -(arg2_33 or 0), 0)

		var0_33 = {
			var5_33 + var14_33,
			var4_33 + var14_33
		}
	end

	return var0_33
end

function var0_0.GenMoveNode(arg0_34, arg1_34)
	local var0_34 = {}

	if type(arg1_34.path) == "table" then
		for iter0_34, iter1_34 in ipairs(arg1_34.path) do
			table.insert(var0_34, Vector3(iter1_34[1], iter1_34[2], 0))
		end
	elseif type(arg1_34.path) == "string" then
		var0_34 = arg0_34:GetPathByString(arg1_34.path, arg1_34.offset)
	else
		var0_34 = arg0_34:GetPathByString("LTRT")
	end

	local var1_34 = type(arg1_34.spine) == "table" or arg1_34.spine == true
	local var2_34

	if arg1_34.spine == true then
		var2_34 = {
			action = "walk",
			scale = 0.5
		}
	elseif var1_34 then
		var2_34 = {
			action = arg1_34.spine.action or "walk",
			scale = arg1_34.spine.scale or 0.5
		}
	end

	return {
		name = arg1_34.name,
		isSpine = var1_34,
		spineData = var2_34,
		path = var0_34,
		time = arg1_34.time,
		delay = arg1_34.delay or 0,
		easeType = arg1_34.easeType or LeanTweenType.linear
	}
end

function var0_0.GetMovableNode(arg0_35)
	if not arg0_35:ExistMovableNode() then
		return {}
	end

	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.movableNode or {}) do
		local var1_35 = arg0_35:GenMoveNode(iter1_35)

		table.insert(var0_35, var1_35)
	end

	return var0_35
end

function var0_0.OldPhotoEffect(arg0_36)
	return arg0_36.oldPhoto
end

function var0_0.ShouldBgGlitchArt(arg0_37)
	return arg0_37.bgGlitchArt
end

function var0_0.IsSameBranch(arg0_38, arg1_38)
	return not arg0_38.branchCode or arg0_38.branchCode == arg1_38
end

function var0_0.IsGlobalFlagHit(arg0_39)
	local var0_39 = var0_0.GetGlobalFlagKey(arg0_39.globalBranchCode.id)
	local var1_39 = 1
	local var2_39 = 0

	while PlayerPrefs.HasKey(var0_39 .. var1_39) do
		var2_39 = var2_39 + PlayerPrefs.GetInt(var0_39 .. var1_39)
		var1_39 = var1_39 + 1
	end

	local var3_39 = arg0_39.globalBranchCode.section

	for iter0_39, iter1_39 in ipairs(var3_39) do
		if var2_39 >= iter1_39[1] and var2_39 <= iter1_39[2] then
			return true
		end
	end

	return false
end

function var0_0.GetGlobalFlagKey(arg0_40)
	return getProxy(PlayerProxy):getRawData().id .. "GlobalStoryFlag_" .. arg0_40 .. "_"
end

function var0_0.GetMode(arg0_41)
	assert(false, "should override this function")
end

function var0_0.GetFlashoutData(arg0_42)
	if arg0_42.flashout then
		local var0_42 = arg0_42.flashout.alpha[1]
		local var1_42 = arg0_42.flashout.alpha[2]
		local var2_42 = arg0_42.flashout.dur
		local var3_42 = arg0_42.flashout.black

		return var0_42, var1_42, var2_42, var3_42
	end
end

function var0_0.GetFlashinData(arg0_43)
	if arg0_43.flashin then
		local var0_43 = arg0_43.flashin.alpha[1]
		local var1_43 = arg0_43.flashin.alpha[2]
		local var2_43 = arg0_43.flashin.dur
		local var3_43 = arg0_43.flashin.black
		local var4_43 = arg0_43.flashin.delay

		return var0_43, var1_43, var2_43, var3_43, var4_43
	end
end

function var0_0.GetBgColor(arg0_44)
	return Color.New(arg0_44.bgColor[1] or 0, arg0_44.bgColor[2] or 0, arg0_44.bgColor[3] or 0)
end

function var0_0.IsBlackBg(arg0_45)
	return arg0_45.blackBg
end

function var0_0.GetBgName(arg0_46)
	return arg0_46.bgName
end

function var0_0.GetBgShadow(arg0_47)
	return arg0_47.bgShadow
end

function var0_0.IsDialogueMode(arg0_48)
	return arg0_48:GetMode() == Story.MODE_DIALOGUE
end

function var0_0.GetBgmData(arg0_49)
	return arg0_49.bgm, arg0_49.bgmDelay, arg0_49.bgmVolume
end

function var0_0.ShoulePlayBgm(arg0_50)
	return arg0_50.bgm ~= nil
end

function var0_0.ShouldStopBgm(arg0_51)
	return arg0_51.stopbgm
end

function var0_0.GetEffects(arg0_52)
	return arg0_52.effects
end

function var0_0.ShouldBlink(arg0_53)
	return arg0_53.blink ~= nil
end

function var0_0.GetBlinkData(arg0_54)
	return arg0_54.blink
end

function var0_0.ShouldBlinkWithColor(arg0_55)
	return arg0_55.blinkWithColor ~= nil
end

function var0_0.GetBlinkWithColorData(arg0_56)
	return arg0_56.blinkWithColor
end

function var0_0.ShouldPlaySoundEffect(arg0_57)
	return arg0_57.soundeffect ~= nil
end

function var0_0.GetSoundeffect(arg0_58)
	return arg0_58.soundeffect, arg0_58.seDelay
end

function var0_0.ShouldPlayVoice(arg0_59)
	return arg0_59.voice ~= nil
end

function var0_0.ShouldStopVoice(arg0_60)
	return arg0_60.stopVoice
end

function var0_0.GetVoice(arg0_61)
	return arg0_61.voice, arg0_61.voiceDelay
end

function var0_0.ExistOption(arg0_62)
	return arg0_62.options ~= nil and #arg0_62.options > 0
end

function var0_0.GetOptionCnt(arg0_63)
	if arg0_63:ExistOption() then
		return #arg0_63.options
	else
		return 0
	end
end

function var0_0.SetOptionSelCodes(arg0_64, arg1_64)
	arg0_64.optionSelCode = arg1_64
end

function var0_0.IsBlackFrontGround(arg0_65)
	return arg0_65.blackFg > 0, Mathf.Clamp01(arg0_65.blackFg)
end

function var0_0.GetOptionIndexByAutoSel(arg0_66)
	local var0_66 = 0
	local var1_66 = 0

	for iter0_66, iter1_66 in ipairs(arg0_66.options) do
		if arg0_66.optionSelCode and iter1_66.flag == arg0_66.optionSelCode then
			var0_66 = iter0_66

			break
		end

		if iter1_66.autochoice and iter1_66.autochoice == 1 then
			var1_66 = iter0_66
		end
	end

	if var0_66 > 0 then
		return var0_66
	end

	if var1_66 > 0 then
		return var1_66
	end

	return nil
end

function var0_0.IsImport(arg0_67)
	return arg0_67.important
end

function var0_0.SetOptionIndex(arg0_68, arg1_68)
	arg0_68.optionIndex = arg1_68
end

function var0_0.GetOptionIndex(arg0_69)
	return arg0_69.optionIndex
end

function var0_0.GetOptions(arg0_70)
	return _.map(arg0_70.options or {}, function(arg0_71)
		local var0_71 = arg0_71.content

		if arg0_70:ShouldReplacePlayer() then
			var0_71 = arg0_70:ReplacePlayerName(var0_71)
		end

		if arg0_70:ShouldReplaceTb() then
			var0_71 = arg0_70:ReplaceTbName(var0_71)
		end

		if arg0_70:ShouldReplaceDorm() then
			var0_71 = arg0_70:ReplaceDormName(var0_71)
		end

		if arg0_70:ShouldReplaceCar2026() then
			var0_71 = arg0_70:ReplaceCar2026Name(var0_71)
		end

		local var1_71 = HXSet.hxLan(var0_71)

		return {
			var1_71,
			arg0_71.flag,
			arg0_71.type,
			arg0_71.globalFlag
		}
	end)
end

function var0_0.ShouldJumpToNextScript(arg0_72)
	return arg0_72.nextScriptName ~= nil
end

function var0_0.GetNextScriptName(arg0_73)
	return arg0_73.nextScriptName
end

function var0_0.ShouldDelayEvent(arg0_74)
	return arg0_74.eventDelay and arg0_74.eventDelay > 0
end

function var0_0.GetEventDelayTime(arg0_75)
	return arg0_75.eventDelay
end

function var0_0.GetUsingPaintingNames(arg0_76)
	return {}
end

function var0_0.GetResList(arg0_77)
	local var0_77 = {}
	local var1_77 = arg0_77:GetBgName()

	if var1_77 then
		table.insert(var0_77, var1_77)
	end

	if arg0_77.GetSubBg then
		local var2_77 = arg0_77:GetSubBg()

		if var2_77 then
			table.insert(var0_77, var2_77)
		end
	end

	local var3_77 = _.map(var0_77, function(arg0_78)
		return "bg/" .. arg0_78
	end)
	local var4_77 = {}
	local var5_77, var6_77, var7_77 = arg0_77:GetBgmData()

	if var5_77 then
		table.insert(var4_77, var5_77)
	end

	local var8_77 = {}

	_.each(var4_77, function(arg0_79)
		table.insert(var8_77, "cue/" .. arg0_79 .. ".b")
		table.insert(var8_77, "cue/bgm-" .. arg0_79 .. ".b")
	end)

	local var9_77 = {}

	if arg0_77:ShouldPlaySoundEffect() then
		local var10_77, var11_77 = arg0_77:GetSoundeffect()

		if var10_77 then
			table.insert(var9_77, var10_77)
		end
	end

	local var12_77 = {}

	_.each(var9_77, function(arg0_80)
		local var0_80 = pg.CriMgr.GetInstance():CheckFModeEvent(arg0_80, function()
			return
		end, function()
			return
		end)

		if var0_80 then
			table.insert(var12_77, "cue/" .. var0_80 .. ".b")
		end
	end)

	local var13_77 = {}

	if arg0_77:ShouldPlayVoice() then
		local var14_77, var15_77 = arg0_77:GetVoice()

		if var14_77 then
			table.insert(var13_77, var14_77)
		end
	end

	local var16_77 = {}

	_.each(var13_77, function(arg0_83)
		local var0_83 = pg.CriMgr.GetInstance():CheckFModeEvent(arg0_83, function()
			return
		end, function()
			return
		end)

		if var0_83 then
			table.insert(var16_77, "cue/" .. var0_83 .. ".b")
		end
	end)

	local var17_77 = {}
	local var18_77 = arg0_77:GetEffects()

	_.each(var18_77, function(arg0_86)
		local var0_86 = arg0_86.name

		table.insert(var17_77, var0_86)
	end)

	local var19_77 = {}

	_.each(var17_77, function(arg0_87)
		table.insert(var19_77, "ui/" .. arg0_87)
		table.insert(var19_77, "effect/" .. arg0_87)
	end)

	local var20_77 = {}

	if arg0_77:ExistIcon() then
		local var21_77 = arg0_77:GetIconData()

		if var21_77 and var21_77.image then
			table.insert(var20_77, var21_77.image)
		end
	end

	local var22_77 = {}
	local var23_77 = StoryRecorder.New()

	var23_77:Add(arg0_77)

	local var24_77 = var23_77:GetContentList()

	_.each(var24_77, function(arg0_88)
		if arg0_88.icon then
			local var0_88 = "squareicon/" .. arg0_88.icon

			table.insert(var22_77, var0_88)
		end
	end)

	return (SplitPackMediatorResMap.MergeLuaArr(var3_77, var8_77, var12_77, var16_77, var19_77, var20_77, var22_77))
end

return var0_0
