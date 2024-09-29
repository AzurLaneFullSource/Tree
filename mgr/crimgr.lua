pg = pg or {}

local var0_0 = pg

var0_0.CriMgr = singletonClass("CriMgr")

local var1_0 = var0_0.CriMgr

var1_0.Category_CV = "Category_CV"
var1_0.Category_BGM = "Category_BGM"
var1_0.Category_SE = "Category_SE"
var1_0.C_BGM = "C_BGM"
var1_0.C_VOICE = "cv"
var1_0.C_SE = "C_SE"
var1_0.C_BATTLE_SE = "C_BATTLE_SE"
var1_0.C_GALLERY_MUSIC = "C_GALLERY_MUSIC"
var1_0.C_BATTLE_CV_EXTRA = "C_BATTLE_CV_EXTRA"
var1_0.C_TIMELINE = "C_TIMELINE"
var1_0.NEXT_VER = 40

function var1_0.Init(arg0_1, arg1_1)
	print("initializing cri manager...")
	seriesAsync({
		function(arg0_2)
			arg0_1:InitCri(arg0_2)
		end,
		function(arg0_3)
			local var0_3 = CueData.GetCueData()

			var0_3.cueSheetName = "se-ui"
			var0_3.channelName = var1_0.C_SE

			arg0_1.criInst:LoadCueSheet(var0_3, function(arg0_4)
				arg0_3()
			end, true)
		end,
		function(arg0_5)
			local var0_5 = CueData.GetCueData()

			var0_5.cueSheetName = "se-battle"
			var0_5.channelName = var1_0.C_BATTLE_SE

			arg0_1.criInst:LoadCueSheet(var0_5, function(arg0_6)
				arg0_5()
			end, true)
		end,
		function(arg0_7)
			arg0_1:InitBgmCfg(arg0_7)
		end
	}, arg1_1)
end

function var1_0.InitCri(arg0_8, arg1_8)
	arg0_8.criInitializer = GameObject.Find("CRIWARE"):GetComponent(typeof(CriWareInitializer))
	arg0_8.criInitializer.fileSystemConfig.numberOfLoaders = 128
	arg0_8.criInitializer.manaConfig.numberOfDecoders = 128
	arg0_8.criInitializer.atomConfig.useRandomSeedWithTime = true

	arg0_8.criInitializer:Initialize()

	arg0_8.criInst = CriWareMgr.Inst

	arg0_8.criInst:Init(function()
		CriAtom.SetCategoryVolume(var1_0.Category_CV, arg0_8:getCVVolume())
		CriAtom.SetCategoryVolume(var1_0.Category_SE, arg0_8:getSEVolume())
		CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg0_8:getBGMVolume())
		arg0_8.criInst:RemoveChannel("C_VOICE")
		Object.Destroy(GameObject.Find("CRIWARE/C_VOICE"))
		arg0_8.criInst:CreateChannel(var1_0.C_VOICE, CriWareMgr.CRI_CHANNEL_TYPE.MULTI_NOT_REPEAT)

		CriWareMgr.C_VOICE = var1_0.C_VOICE

		arg0_8.criInst:RemoveChannel("C_TIMELINE")
		Object.Destroy(GameObject.Find("CRIWARE/C_TIMELINE"))
		arg0_8.criInst:CreateChannel(var1_0.C_TIMELINE, CriWareMgr.CRI_CHANNEL_TYPE.WITHOUT_LIMIT)

		local var0_9 = arg0_8.criInst:GetChannelData(var1_0.C_VOICE)

		arg0_8.criInst:CreateChannel(var1_0.C_GALLERY_MUSIC, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0_8.criInst:GetChannelData(var1_0.C_BGM).channelPlayer.loop = true

		arg0_8.criInst:CreateChannel(var1_0.C_BATTLE_CV_EXTRA, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0_8.criInst:GetChannelData(var1_0.C_BATTLE_CV_EXTRA).channelPlayer.volume = 0.6

		arg1_8()
	end)
end

function var1_0.PlayBGM(arg0_10, arg1_10, arg2_10)
	local var0_10 = "bgm-" .. arg1_10

	if arg0_10.bgmName == var0_10 then
		return
	end

	arg0_10.bgmName = var0_10

	arg0_10.criInst:PlayBGM(var0_10, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_11)
		if arg0_11 == nil then
			warning("Missing BGM :" .. (arg1_10 or "NIL"))
		end
	end)
end

function var1_0.StopBGM(arg0_12)
	arg0_12.criInst:StopBGM(CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)

	arg0_12.bgmName = nil
end

function var1_0.StopPlaybackInfoForce(arg0_13, arg1_13)
	arg1_13.playback:Stop(true)
end

function var1_0.LoadCV(arg0_14, arg1_14, arg2_14)
	local var0_14 = var1_0.GetCVBankName(arg1_14)

	arg0_14:LoadCueSheet(var0_14, arg2_14)
end

function var1_0.LoadBattleCV(arg0_15, arg1_15, arg2_15)
	local var0_15 = var1_0.GetBattleCVBankName(arg1_15)

	arg0_15:LoadCueSheet(var0_15, arg2_15)
end

function var1_0.UnloadCVBank(arg0_16)
	var1_0.GetInstance():UnloadCueSheet(arg0_16)
end

function var1_0.GetCVBankName(arg0_17)
	return "cv-" .. arg0_17
end

function var1_0.GetBattleCVBankName(arg0_18)
	return "cv-" .. arg0_18 .. "-battle"
end

function var1_0.CheckFModeEvent(arg0_19, arg1_19, arg2_19, arg3_19)
	if not arg1_19 then
		return
	end

	local var0_19
	local var1_19

	string.gsub(arg1_19, "event:/cv/(.+)/(.+)", function(arg0_20, arg1_20)
		local var0_20 = string.gsub(arg1_20, "_%w+", "")
		local var1_20 = tobool(ShipWordHelper.CVBattleKey[var0_20])

		var0_19 = "cv-" .. arg0_20 .. (var1_20 and "-battle" or "")
		var1_19 = arg1_20
	end)
	string.gsub(arg1_19, "event:/tb/(.+)/(.+)", function(arg0_21, arg1_21)
		var0_19 = "tb-" .. arg0_21
		var1_19 = arg1_21
	end)
	string.gsub(arg1_19, "event:/educate/(.+)/(.+)", function(arg0_22, arg1_22)
		var0_19 = "educate-" .. arg0_22
		var1_19 = arg1_22
	end)
	string.gsub(arg1_19, "event:/dorm/(.+)/(.+)", function(arg0_23, arg1_23)
		var0_19 = arg0_23
		var1_19 = arg1_23
	end)

	if string.find(arg1_19, "event:/educate%-cv/") then
		local var2_19 = string.split(arg1_19, "/")

		var1_19 = var2_19[#var2_19]
		var0_19 = var2_19[#var2_19 - 1]
	end

	if var0_19 and var1_19 then
		arg2_19(var0_19, var1_19)
	else
		var1_19 = arg1_19
		var1_19 = string.gsub(var1_19, "event:/(battle)/(.+)", "%1-%2")
		var1_19 = string.gsub(var1_19, "event:/(ui)/(.+)", "%1-%2")

		arg3_19(var1_19)
	end
end

function var1_0.CheckHasCue(arg0_24, arg1_24, arg2_24)
	local var0_24 = CriAtom.GetCueSheet(arg1_24)

	return var0_24 ~= nil and var0_24.acb:Exists(arg2_24)
end

function var1_0.PlaySoundEffect_V3(arg0_25, arg1_25, arg2_25)
	arg0_25:CheckFModeEvent(arg1_25, function(arg0_26, arg1_26)
		arg0_25:PlayCV_V3(arg0_26, arg1_26, arg2_25)
	end, function(arg0_27)
		arg0_25:PlaySE_V3(arg0_27, arg2_25)
	end)
end

function var1_0.PlayMultipleSound_V3(arg0_28, arg1_28, arg2_28)
	arg0_28:CheckFModeEvent(arg1_28, function(arg0_29, arg1_29)
		arg0_28:CreateCvMultipleHandler(arg0_29, arg1_29, arg2_28)
	end, function(arg0_30)
		arg0_28:PlaySE_V3(arg0_30, arg2_28)
	end)
end

function var1_0.StopSoundEffect_V3(arg0_31, arg1_31)
	arg0_31:CheckFModeEvent(arg1_31, function(arg0_32, arg1_32)
		arg0_31:StopCV_V3()
	end, function(arg0_33)
		arg0_31:StopSE_V3()
	end)
end

function var1_0.UnloadSoundEffect_V3(arg0_34, arg1_34)
	arg0_34:CheckFModeEvent(arg1_34, function(arg0_35, arg1_35)
		arg0_34:UnloadCueSheet(arg0_35)
	end, function(arg0_36)
		arg0_34:StopSE_V3()
	end)
end

function var1_0.PlayCV_V3(arg0_37, arg1_37, arg2_37, arg3_37)
	assert(arg1_37, "cueSheetName can not be nil.")
	assert(arg2_37, "cueName can not be nil.")
	arg0_37.criInst:PlayVoice(arg2_37, CriWareMgr.CRI_FADE_TYPE.NONE, arg1_37, function(arg0_38)
		if arg3_37 ~= nil then
			arg3_37(arg0_38)
		end
	end)
end

function var1_0.CreateCvMultipleHandler(arg0_39, arg1_39, arg2_39, arg3_39)
	if not arg0_39.luHandle then
		arg0_39.luHandle = LateUpdateBeat:CreateListener(arg0_39.LateCvHandler, arg0_39)

		LateUpdateBeat:AddListener(arg0_39.luHandle)
	end

	arg0_39.cvCacheDataList = arg0_39.cvCacheDataList or {}

	local var0_39 = true

	for iter0_39, iter1_39 in ipairs(arg0_39.cvCacheDataList) do
		if iter1_39[1] == arg1_39 and iter1_39[2] == arg2_39 then
			var0_39 = false

			break
		end
	end

	if var0_39 then
		arg0_39.cvCacheDataList[#arg0_39.cvCacheDataList + 1] = {
			arg1_39,
			arg2_39,
			arg3_39
		}
	end
end

function var1_0.LateCvHandler(arg0_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.cvCacheDataList) do
		local var0_40 = iter1_40[1]
		local var1_40 = iter1_40[2]
		local var2_40 = iter1_40[3]

		if iter0_40 == 1 then
			arg0_40.criInst:PlayVoice(var1_40, CriWareMgr.CRI_FADE_TYPE.NONE, var0_40, function(arg0_41)
				if var2_40 ~= nil then
					var2_40(arg0_41)
				end
			end)
		else
			local var3_40 = CueData.GetCueData()

			var3_40.cueSheetName = var0_40
			var3_40.channelName = var1_0.C_BATTLE_CV_EXTRA
			var3_40.cueName = var1_40

			onDelayTick(function()
				arg0_40.criInst:PlaySound(var3_40, CriWareMgr.CRI_FADE_TYPE.FADE_CROSS, function(arg0_43)
					if var2_40 ~= nil then
						var2_40(arg0_43)
					end
				end)
			end, iter0_40 * 0.4)
		end
	end

	arg0_40.cvCacheDataList = nil

	if arg0_40.luHandle then
		LateUpdateBeat:RemoveListener(arg0_40.luHandle)

		arg0_40.luHandle = nil
	end
end

function var1_0.StopCV_V3(arg0_44)
	arg0_44.criInst:GetChannelData(var1_0.C_VOICE).channelPlayer:Stop()
end

function var1_0.PlaySE_V3(arg0_45, arg1_45, arg2_45)
	assert(arg1_45, "cueName can not be nil.")
	arg0_45.criInst:PlayAnySE(arg1_45, nil, function(arg0_46)
		if arg2_45 ~= nil then
			arg2_45(arg0_46)
		end
	end)
end

function var1_0.StopSE_V3(arg0_47)
	arg0_47.criInst:GetChannelData(var1_0.C_SE).channelPlayer:Stop()
	arg0_47.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.StopSEBattle_V3(arg0_48)
	arg0_48.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.LoadCueSheet(arg0_49, arg1_49, arg2_49)
	local var0_49 = CueData.GetCueData()

	var0_49.cueSheetName = arg1_49

	arg0_49.criInst:LoadCueSheet(var0_49, function(arg0_50)
		existCall(arg2_49, arg0_50)
	end, true)
end

function var1_0.UnloadCueSheet(arg0_51, arg1_51)
	arg0_51.criInst:UnloadCueSheet(arg1_51)
end

function var1_0.getCVVolume(arg0_52)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

function var1_0.setCVVolume(arg0_53, arg1_53)
	PlayerPrefs.SetFloat("cv_vol", arg1_53)
	CriAtom.SetCategoryVolume(var1_0.Category_CV, arg1_53)
end

function var1_0.getBGMVolume(arg0_54)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

function var1_0.setBGMVolume(arg0_55, arg1_55)
	PlayerPrefs.SetFloat("bgm_vol", arg1_55)
	CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg1_55)
end

function var1_0.getSEVolume(arg0_56)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

function var1_0.setSEVolume(arg0_57, arg1_57)
	PlayerPrefs.SetFloat("se_vol", arg1_57)
	CriAtom.SetCategoryVolume(var1_0.Category_SE, arg1_57)
end

function var1_0.InitBgmCfg(arg0_58, arg1_58)
	arg0_58.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if Application.isEditor then
			if arg1_58 then
				arg1_58()
			end

			return
		end

		local var0_58 = {
			"Malaysia",
			"Indonesia"
		}
		local var1_58 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2_58 = ""

		local function var3_58(arg0_59)
			local var0_59 = "\"country\":\""
			local var1_59 = "\","
			local var2_59, var3_59 = string.find(arg0_59, var0_59)

			if var3_59 then
				arg0_59 = string.sub(arg0_59, var3_59 + 1)
			end

			local var4_59 = string.find(arg0_59, var1_59)

			if var4_59 then
				arg0_59 = string.sub(arg0_59, 1, var4_59 - 1)
			end

			return arg0_59
		end

		local function var4_58(arg0_60)
			local var0_60 = false

			for iter0_60, iter1_60 in ipairs(var0_58) do
				if iter1_60 == arg0_60 then
					var0_60 = true
				end
			end

			return var0_60
		end

		VersionMgr.Inst:WebRequest(var1_58, function(arg0_61, arg1_61)
			local var0_61 = var3_58(arg1_61)

			originalPrint("content: " .. arg1_61)
			originalPrint("country is: " .. var0_61)

			arg0_58.isDefaultBGM = var4_58(var0_61)

			originalPrint("IP limit: " .. tostring(arg0_58.isDefaultBGM))

			if arg1_58 then
				arg1_58()
			end
		end)
	elseif arg1_58 then
		arg1_58()
	end
end

function var1_0.IsDefaultBGM(arg0_62)
	return arg0_62.isDefaultBGM
end

function var1_0.getAtomSource(arg0_63, arg1_63)
	return GetComponent(GameObject.Find("CRIWARE/" .. arg1_63), "CriAtomSource")
end

function var1_0.GetCueInfo(arg0_64, arg1_64, arg2_64, arg3_64, arg4_64)
	arg0_64:LoadCueSheet(arg1_64, function(arg0_65)
		if not arg0_65 then
			warning("加载CueSheet失败")

			return
		end

		local var0_65 = arg0_64.criInst:GetCueInfo(arg1_64, arg2_64)

		arg3_64(var0_65)

		if not arg4_64 then
			arg0_64:UnloadCueSheet(arg1_64)
		end
	end)
end
