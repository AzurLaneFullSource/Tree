pg = pg or {}

local var0_0 = pg

var0_0.CriMgr = singletonClass("CriMgr")

local var1_0 = var0_0.CriMgr

var1_0.Category_CV = "Category_CV"
var1_0.Category_BGM = "Category_BGM"
var1_0.Category_SE = "Category_SE"
var1_0.Category_Mute_Other_CV = "Mute_Other_CV"
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
	local var0_8 = GameObject.Find("CRIWARE")

	var0_8:AddComponent(typeof(CriWareMgr))

	arg0_8.criInitializer = var0_8:GetComponent(typeof(CriWare.CriWareInitializer))
	arg0_8.criInitializer.fileSystemConfig.numberOfLoaders = 128
	arg0_8.criInitializer.manaConfig.numberOfDecoders = 128
	arg0_8.criInitializer.atomConfig.useRandomSeedWithTime = true
	arg0_8.criInitializer.DecrypterConfig.key = "621561580448882"

	arg0_8.criInitializer:Initialize()

	arg0_8.criInst = CriWareMgr.Inst

	arg0_8.criInst:Init(function()
		arg0_8:ResetAllVolume()

		local var0_9 = arg0_8.criInst:GetChannelData(var1_0.C_VOICE)

		arg0_8.criInst:CreateChannel(var1_0.C_GALLERY_MUSIC, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0_8.criInst:GetChannelData(var1_0.C_BGM).channelPlayer.loop = true

		arg0_8.criInst:CreateChannel(var1_0.C_BATTLE_CV_EXTRA, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0_8.criInst:GetChannelData(var1_0.C_BATTLE_CV_EXTRA).channelPlayer.volume = 0.6

		local var1_9 = GameObject.Find("CRIWARE/C_BGM")

		arg0_8.bgmWaveAnalyzer = GetOrAddComponent(var1_9, typeof(CriAtomWaveAnalyzer))

		arg0_8.bgmWaveAnalyzer:Init()
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

function var1_0.playCueSheetVoice(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	assert(arg1_14, "cueSheetName can not be nil.")
	assert(arg2_14, "cueName can not be nil.")

	if arg3_14 then
		arg0_14.criInst:PlaySE(arg2_14, arg1_14, function(arg0_15)
			if arg4_14 ~= nil then
				arg4_14(arg0_15)
			end
		end)
	else
		arg0_14.criInst:PlayVoice(arg2_14, CriWareMgr.CRI_FADE_TYPE.NONE, arg1_14, function(arg0_16)
			if arg4_14 ~= nil then
				arg4_14(arg0_16)
			end
		end)
	end
end

function var1_0.LoadCV(arg0_17, arg1_17, arg2_17)
	local var0_17 = var1_0.GetCVBankName(arg1_17)

	arg0_17:LoadCueSheet(var0_17, arg2_17)
end

function var1_0.LoadBattleCV(arg0_18, arg1_18, arg2_18)
	local var0_18 = var1_0.GetBattleCVBankName(arg1_18)

	arg0_18:LoadCueSheet(var0_18, arg2_18)
end

function var1_0.UnloadCVBank(arg0_19)
	var1_0.GetInstance():UnloadCueSheet(arg0_19)
end

function var1_0.GetCVBankName(arg0_20)
	return "cv-" .. arg0_20
end

function var1_0.GetBattleCVBankName(arg0_21)
	return "cv-" .. arg0_21 .. "-battle"
end

function var1_0.CheckFModeEvent(arg0_22, arg1_22, arg2_22, arg3_22)
	if not arg1_22 then
		return
	end

	local var0_22
	local var1_22

	string.gsub(arg1_22, "event:/cv/(.+)/(.+)", function(arg0_23, arg1_23)
		local var0_23 = string.gsub(arg1_23, "_%w+", "")
		local var1_23 = tobool(ShipWordHelper.CVBattleKey[var0_23])

		var0_22 = "cv-" .. arg0_23 .. (var1_23 and "-battle" or "")
		var1_22 = arg1_23
	end)
	string.gsub(arg1_22, "event:/tb/(.+)/(.+)", function(arg0_24, arg1_24)
		var0_22 = "tb-" .. arg0_24
		var1_22 = arg1_24
	end)
	string.gsub(arg1_22, "event:/educate/(.+)/(.+)", function(arg0_25, arg1_25)
		var0_22 = "educate-" .. arg0_25
		var1_22 = arg1_25
	end)
	string.gsub(arg1_22, "event:/dorm/(.+)/(.+)", function(arg0_26, arg1_26)
		var0_22 = arg0_26
		var1_22 = arg1_26
	end)

	if string.find(arg1_22, "event:/educate%-cv/") then
		local var2_22 = string.split(arg1_22, "/")

		var1_22 = var2_22[#var2_22]
		var0_22 = var2_22[#var2_22 - 1]
	end

	if var0_22 and var1_22 then
		arg2_22(var0_22, var1_22)
	else
		var1_22 = arg1_22
		var1_22 = string.gsub(var1_22, "event:/(battle)/(.+)", "%1-%2")
		var1_22 = string.gsub(var1_22, "event:/(ui)/(.+)", "%1-%2")

		arg3_22(var1_22)
	end
end

function var1_0.CheckHasCue(arg0_27, arg1_27, arg2_27)
	local var0_27 = CriWare.CriAtom.GetCueSheet(arg1_27)

	return var0_27 ~= nil and var0_27.acb:Exists(arg2_27)
end

function var1_0.PlaySoundEffect_V3(arg0_28, arg1_28, arg2_28)
	arg0_28:CheckFModeEvent(arg1_28, function(arg0_29, arg1_29)
		arg0_28:PlayCV_V3(arg0_29, arg1_29, arg2_28)
	end, function(arg0_30)
		arg0_28:PlaySE_V3(arg0_30, arg2_28)
	end)
end

function var1_0.PlayMultipleSound_V3(arg0_31, arg1_31, arg2_31)
	arg0_31:CheckFModeEvent(arg1_31, function(arg0_32, arg1_32)
		arg0_31:CreateCvMultipleHandler(arg0_32, arg1_32, arg2_31)
	end, function(arg0_33)
		arg0_31:PlaySE_V3(arg0_33, arg2_31)
	end)
end

function var1_0.StopSoundEffect_V3(arg0_34, arg1_34)
	arg0_34:CheckFModeEvent(arg1_34, function(arg0_35, arg1_35)
		arg0_34:StopCV_V3()
	end, function(arg0_36)
		arg0_34:StopSE_V3()
	end)
end

function var1_0.UnloadSoundEffect_V3(arg0_37, arg1_37)
	arg0_37:CheckFModeEvent(arg1_37, function(arg0_38, arg1_38)
		arg0_37:UnloadCueSheet(arg0_38)
	end, function(arg0_39)
		arg0_37:StopSE_V3()
	end)
end

function var1_0.PlayCV_V3(arg0_40, arg1_40, arg2_40, arg3_40)
	assert(arg1_40, "cueSheetName can not be nil.")
	assert(arg2_40, "cueName can not be nil.")
	arg0_40.criInst:PlayVoice(arg2_40, CriWareMgr.CRI_FADE_TYPE.NONE, arg1_40, function(arg0_41)
		if arg3_40 ~= nil then
			arg3_40(arg0_41)
		end
	end)
end

function var1_0.CreateCvMultipleHandler(arg0_42, arg1_42, arg2_42, arg3_42)
	if not arg0_42.luHandle then
		arg0_42.luHandle = LateUpdateBeat:CreateListener(arg0_42.LateCvHandler, arg0_42)

		LateUpdateBeat:AddListener(arg0_42.luHandle)
	end

	arg0_42.cvCacheDataList = arg0_42.cvCacheDataList or {}

	local var0_42 = true

	for iter0_42, iter1_42 in ipairs(arg0_42.cvCacheDataList) do
		if iter1_42[1] == arg1_42 and iter1_42[2] == arg2_42 then
			var0_42 = false

			break
		end
	end

	if var0_42 then
		arg0_42.cvCacheDataList[#arg0_42.cvCacheDataList + 1] = {
			arg1_42,
			arg2_42,
			arg3_42
		}
	end
end

function var1_0.LateCvHandler(arg0_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.cvCacheDataList) do
		local var0_43 = iter1_43[1]
		local var1_43 = iter1_43[2]
		local var2_43 = iter1_43[3]

		if iter0_43 == 1 then
			arg0_43.criInst:PlayVoice(var1_43, CriWareMgr.CRI_FADE_TYPE.NONE, var0_43, function(arg0_44)
				if var2_43 ~= nil then
					var2_43(arg0_44)
				end
			end)
		else
			local var3_43 = CueData.GetCueData()

			var3_43.cueSheetName = var0_43
			var3_43.channelName = var1_0.C_BATTLE_CV_EXTRA
			var3_43.cueName = var1_43

			onDelayTick(function()
				arg0_43.criInst:PlaySound(var3_43, CriWareMgr.CRI_FADE_TYPE.FADE_CROSS, function(arg0_46)
					if var2_43 ~= nil then
						var2_43(arg0_46)
					end
				end)
			end, iter0_43 * 0.4)
		end
	end

	arg0_43.cvCacheDataList = nil

	if arg0_43.luHandle then
		LateUpdateBeat:RemoveListener(arg0_43.luHandle)

		arg0_43.luHandle = nil
	end
end

function var1_0.StopCV_V3(arg0_47)
	arg0_47.criInst:GetChannelData(var1_0.C_VOICE).channelPlayer:Stop()
end

function var1_0.PlaySE_V3(arg0_48, arg1_48, arg2_48)
	assert(arg1_48, "cueName can not be nil.")
	arg0_48.criInst:PlayAnySE(arg1_48, nil, function(arg0_49)
		if arg2_48 ~= nil then
			arg2_48(arg0_49)
		end
	end)
end

function var1_0.StopSE_V3(arg0_50)
	arg0_50.criInst:GetChannelData(var1_0.C_SE).channelPlayer:Stop()
	arg0_50.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.StopSEBattle_V3(arg0_51)
	arg0_51.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.LoadCueSheet(arg0_52, arg1_52, arg2_52)
	local var0_52 = CueData.GetCueData()

	var0_52.cueSheetName = arg1_52

	arg0_52.criInst:LoadCueSheet(var0_52, function(arg0_53)
		existCall(arg2_52, arg0_53)
	end, true)
end

function var1_0.UnloadCueSheet(arg0_54, arg1_54)
	arg0_54.criInst:UnloadCueSheet(arg1_54)
end

function var1_0.getCVVolume(arg0_55)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

function var1_0.setCVVolume(arg0_56, arg1_56)
	PlayerPrefs.SetFloat("cv_vol", arg1_56)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, arg1_56)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, arg1_56)
end

function var1_0.getBGMVolume(arg0_57)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

function var1_0.setBGMVolume(arg0_58, arg1_58)
	PlayerPrefs.SetFloat("bgm_vol", arg1_58)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg1_58)
end

function var1_0.getSEVolume(arg0_59)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

function var1_0.setSEVolume(arg0_60, arg1_60)
	PlayerPrefs.SetFloat("se_vol", arg1_60)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, arg1_60)
end

function var1_0.MuteAllVolume(arg0_61)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, 0)
end

function var1_0.ResetAllVolume(arg0_62)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, arg0_62:getCVVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, arg0_62:getCVVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg0_62:getBGMVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, arg0_62:getSEVolume())
end

function var1_0.InitBgmCfg(arg0_63, arg1_63)
	arg0_63.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if Application.isEditor then
			if arg1_63 then
				arg1_63()
			end

			return
		end

		local var0_63 = {
			"Malaysia",
			"Indonesia"
		}
		local var1_63 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2_63 = ""

		local function var3_63(arg0_64)
			local var0_64 = "\"country\":\""
			local var1_64 = "\","
			local var2_64, var3_64 = string.find(arg0_64, var0_64)

			if var3_64 then
				arg0_64 = string.sub(arg0_64, var3_64 + 1)
			end

			local var4_64 = string.find(arg0_64, var1_64)

			if var4_64 then
				arg0_64 = string.sub(arg0_64, 1, var4_64 - 1)
			end

			return arg0_64
		end

		local function var4_63(arg0_65)
			local var0_65 = false

			for iter0_65, iter1_65 in ipairs(var0_63) do
				if iter1_65 == arg0_65 then
					var0_65 = true
				end
			end

			return var0_65
		end

		VersionMgr.Inst:WebRequest(var1_63, function(arg0_66, arg1_66)
			local var0_66 = var3_63(arg1_66)

			originalPrint("content: " .. arg1_66)
			originalPrint("country is: " .. var0_66)

			arg0_63.isDefaultBGM = var4_63(var0_66)

			originalPrint("IP limit: " .. tostring(arg0_63.isDefaultBGM))

			if arg1_63 then
				arg1_63()
			end
		end)
	elseif arg1_63 then
		arg1_63()
	end
end

function var1_0.IsDefaultBGM(arg0_67)
	return arg0_67.isDefaultBGM
end

function var1_0.getAtomSource(arg0_68, arg1_68)
	return GetComponent(GameObject.Find("CRIWARE/" .. arg1_68), "CriAtomSource")
end

function var1_0.GetCueInfo(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	arg0_69:LoadCueSheet(arg1_69, function(arg0_70)
		if not arg0_70 then
			warning("加载CueSheet失败")

			return
		end

		local var0_70 = arg0_69.criInst:GetCueInfo(arg1_69, arg2_69)

		arg3_69(var0_70)

		if not arg4_69 then
			arg0_69:UnloadCueSheet(arg1_69)
		end
	end)
end

function var1_0.SetBgmWaveAnalyzerOnCapture(arg0_71, arg1_71, arg2_71)
	arg0_71.bgmWaveAnalyzer.OnCaptureL = arg1_71
	arg0_71.bgmWaveAnalyzer.OnCaptureR = arg2_71
end
