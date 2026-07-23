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
var1_0.C_SE_LOOP = "C_SE_LOOP"
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

		arg0_8.criInst:CreateChannel(var1_0.C_SE_LOOP, CriWareMgr.CRI_CHANNEL_TYPE.MULTI_NOT_REPEAT)

		arg0_8.criInst:GetChannelData(var1_0.C_SE_LOOP).channelPlayer.loop = true

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

function var1_0.PlayPaintingBgm(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	if not arg0_17._paintingBgmSheets then
		arg0_17._paintingBgmSheets = {}
	end

	if not arg0_17._paintingBgmSheetInfo then
		arg0_17._paintingBgmSheetInfo = {}
	end

	if not arg0_17._paintingBgmSheetVolume then
		arg0_17._paintingBgmSheetVolume = {}
	end

	if not table.contains(arg0_17._paintingBgmSheets, arg1_17) then
		table.insert(arg0_17._paintingBgmSheets, arg1_17)
	end

	if arg3_17 and arg0_17._paintingBgmSheetInfo[arg2_17] then
		return
	end

	arg0_17._paintingBgmVolumeRate = arg5_17 or 1

	if arg0_17._paintingBgmSheetInfo[arg2_17] and arg0_17._paintingBgmSheetInfo[arg2_17].channelPlayer then
		arg0_17._paintingBgmSheetInfo[arg2_17].channelPlayer.volume = arg4_17 * arg5_17

		print("设置 painting bgm = " .. arg2_17 .. " 音量 = " .. arg4_17 .. " 当前音量 = " .. arg0_17._paintingBgmSheetInfo[arg2_17].channelPlayer.volume)
	else
		var0_0.CriMgr.GetInstance():PlaySE_Loop(arg1_17, arg2_17, function(arg0_18)
			if arg0_18 then
				arg0_18.channelPlayer.volume = arg4_17 * arg5_17

				print("播放 painting bgm = " .. arg2_17 .. " volume = " .. arg0_18.channelPlayer.volume)

				arg0_17._paintingBgmSheetInfo[arg2_17] = arg0_18
				arg0_17._paintingBgmSheetVolume[arg2_17] = arg4_17
			end
		end)
	end
end

function var1_0.ChangePaintingBgmVolume(arg0_19, arg1_19)
	if arg0_19._paintingBgmVolumeRate and arg0_19._paintingBgmVolumeRate == arg1_19 then
		return
	end

	arg0_19._paintingBgmVolumeRate = arg1_19 or 1

	if arg0_19._paintingBgmSheetInfo then
		for iter0_19, iter1_19 in pairs(arg0_19._paintingBgmSheetInfo) do
			if iter1_19 and iter1_19.channelPlayer then
				iter1_19.channelPlayer.volume = arg0_19._paintingBgmSheetVolume[iter0_19] * arg1_19

				print("设置 painting bgm = " .. iter0_19 .. " 音量 = " .. arg1_19 .. " 当前音量 = " .. iter1_19.channelPlayer.volume)
			end
		end
	end
end

function var1_0.StopPaintingBgm(arg0_20, arg1_20)
	if arg0_20._paintingBgmSheetInfo and arg0_20._paintingBgmSheetInfo[arg1_20] then
		arg0_20.criInst:StopSound(arg0_20._paintingBgmSheetInfo[arg1_20], CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)

		arg0_20._paintingBgmSheetInfo[arg1_20] = nil
	end
end

function var1_0.DisposePaintingBgm(arg0_21)
	arg0_21._paintingBgmSheetInfo = {}
	arg0_21._paintingBgmSheetVolume = {}

	if arg0_21._paintingBgmSheets then
		for iter0_21, iter1_21 in ipairs(arg0_21._paintingBgmSheets) do
			var0_0.CriMgr.GetInstance():UnloadCueSheet(iter1_21)
		end

		arg0_21._paintingBgmSheets = nil
	end
end

function var1_0.LoadCV(arg0_22, arg1_22, arg2_22)
	local var0_22 = var1_0.GetCVBankName(arg1_22)

	arg0_22:LoadCueSheet(var0_22, arg2_22)
end

function var1_0.LoadBattleCV(arg0_23, arg1_23, arg2_23)
	local var0_23 = var1_0.GetBattleCVBankName(arg1_23)

	arg0_23:LoadCueSheet(var0_23, arg2_23)
end

function var1_0.UnloadCVBank(arg0_24)
	var1_0.GetInstance():UnloadCueSheet(arg0_24)
end

function var1_0.GetCVBankName(arg0_25)
	return "cv-" .. arg0_25
end

function var1_0.GetBattleCVBankName(arg0_26)
	return "cv-" .. arg0_26 .. "-battle"
end

function var1_0.CheckFModeEvent(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg1_27 then
		return
	end

	local var0_27
	local var1_27

	string.gsub(arg1_27, "event:/cv/(.+)/(.+)", function(arg0_28, arg1_28)
		local var0_28 = string.gsub(arg1_28, "_%w+", "")
		local var1_28 = tobool(ShipWordHelper.CVBattleKey[var0_28])
		local var2_28 = tobool(ShipWordHelper.CVGiftKey[arg1_28])

		var0_27 = "cv-" .. arg0_28 .. (var1_28 and "-battle" or "") .. (var2_28 and "-gift" or "")
		var1_27 = arg1_28
	end)
	string.gsub(arg1_27, "event:/tb/(.+)/(.+)", function(arg0_29, arg1_29)
		var0_27 = "tb-" .. arg0_29
		var1_27 = arg1_29
	end)
	string.gsub(arg1_27, "event:/educate/(.+)/(.+)", function(arg0_30, arg1_30)
		var0_27 = "educate-" .. arg0_30
		var1_27 = arg1_30
	end)
	string.gsub(arg1_27, "event:/dorm/(.+)/(.+)", function(arg0_31, arg1_31)
		var0_27 = arg0_31
		var1_27 = arg1_31
	end)

	if string.find(arg1_27, "event:/educate%-cv/") then
		local var2_27 = string.split(arg1_27, "/")

		var1_27 = var2_27[#var2_27]
		var0_27 = var2_27[#var2_27 - 1]
	end

	if var0_27 and var1_27 then
		arg2_27(var0_27, var1_27)
	else
		var1_27 = arg1_27
		var1_27 = string.gsub(var1_27, "event:/(battle)/(.+)", "%1-%2")
		var1_27 = string.gsub(var1_27, "event:/(ui)/(.+)", "%1-%2")

		arg3_27(var1_27)
	end

	return var0_27
end

function var1_0.CheckHasCue(arg0_32, arg1_32, arg2_32)
	local var0_32 = CriWare.CriAtom.GetCueSheet(arg1_32)

	return var0_32 ~= nil and var0_32.acb:Exists(arg2_32)
end

function var1_0.PlaySoundEffect_V3(arg0_33, arg1_33, arg2_33)
	arg0_33:CheckFModeEvent(arg1_33, function(arg0_34, arg1_34)
		arg0_33:PlayCV_V3(arg0_34, arg1_34, arg2_33)
	end, function(arg0_35)
		arg0_33:PlaySE_V3(arg0_35, arg2_33)
	end)
end

function var1_0.PlayMultipleSound_V3(arg0_36, arg1_36, arg2_36)
	arg0_36:CheckFModeEvent(arg1_36, function(arg0_37, arg1_37)
		arg0_36:CreateCvMultipleHandler(arg0_37, arg1_37, arg2_36)
	end, function(arg0_38)
		arg0_36:PlaySE_V3(arg0_38, arg2_36)
	end)
end

function var1_0.StopSoundEffect_V3(arg0_39, arg1_39)
	arg0_39:CheckFModeEvent(arg1_39, function(arg0_40, arg1_40)
		arg0_39:StopCV_V3()
	end, function(arg0_41)
		arg0_39:StopSE_V3()
	end)
end

function var1_0.UnloadSoundEffect_V3(arg0_42, arg1_42)
	arg0_42:CheckFModeEvent(arg1_42, function(arg0_43, arg1_43)
		arg0_42:UnloadCueSheet(arg0_43)
	end, function(arg0_44)
		arg0_42:StopSE_V3()
	end)
end

function var1_0.PlayCV_V3(arg0_45, arg1_45, arg2_45, arg3_45)
	assert(arg1_45, "cueSheetName can not be nil.")
	assert(arg2_45, "cueName can not be nil.")
	arg0_45.criInst:PlayVoice(arg2_45, CriWareMgr.CRI_FADE_TYPE.NONE, arg1_45, function(arg0_46)
		if arg3_45 ~= nil then
			arg3_45(arg0_46)
		end
	end)
end

function var1_0.CreateCvMultipleHandler(arg0_47, arg1_47, arg2_47, arg3_47)
	if not arg0_47.luHandle then
		arg0_47.luHandle = LateUpdateBeat:CreateListener(arg0_47.LateCvHandler, arg0_47)

		LateUpdateBeat:AddListener(arg0_47.luHandle)
	end

	arg0_47.cvCacheDataList = arg0_47.cvCacheDataList or {}

	local var0_47 = true

	for iter0_47, iter1_47 in ipairs(arg0_47.cvCacheDataList) do
		if iter1_47[1] == arg1_47 and iter1_47[2] == arg2_47 then
			var0_47 = false

			break
		end
	end

	if var0_47 then
		arg0_47.cvCacheDataList[#arg0_47.cvCacheDataList + 1] = {
			arg1_47,
			arg2_47,
			arg3_47
		}
	end
end

function var1_0.LateCvHandler(arg0_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.cvCacheDataList) do
		local var0_48 = iter1_48[1]
		local var1_48 = iter1_48[2]
		local var2_48 = iter1_48[3]

		if iter0_48 == 1 then
			arg0_48.criInst:PlayVoice(var1_48, CriWareMgr.CRI_FADE_TYPE.NONE, var0_48, function(arg0_49)
				if var2_48 ~= nil then
					var2_48(arg0_49)
				end
			end)
		else
			local var3_48 = CueData.GetCueData()

			var3_48.cueSheetName = var0_48
			var3_48.channelName = var1_0.C_BATTLE_CV_EXTRA
			var3_48.cueName = var1_48

			onDelayTick(function()
				arg0_48.criInst:PlaySound(var3_48, CriWareMgr.CRI_FADE_TYPE.FADE_CROSS, function(arg0_51)
					if var2_48 ~= nil then
						var2_48(arg0_51)
					end
				end)
			end, iter0_48 * 0.4)
		end
	end

	arg0_48.cvCacheDataList = nil

	if arg0_48.luHandle then
		LateUpdateBeat:RemoveListener(arg0_48.luHandle)

		arg0_48.luHandle = nil
	end
end

function var1_0.StopCV_V3(arg0_52)
	arg0_52.criInst:GetChannelData(var1_0.C_VOICE).channelPlayer:Stop()
end

function var1_0.PlaySE_V3(arg0_53, arg1_53, arg2_53)
	assert(arg1_53, "cueName can not be nil.")
	arg0_53.criInst:PlayAnySE(arg1_53, nil, function(arg0_54)
		if arg2_53 ~= nil then
			arg2_53(arg0_54)
		end
	end)
end

function var1_0.StopSE_V3(arg0_55)
	arg0_55.criInst:GetChannelData(var1_0.C_SE).channelPlayer:Stop()
	arg0_55.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.StopSEBattle_V3(arg0_56)
	arg0_56.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.PlaySE_Loop(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57 = CueData.GetCueDataAndInit(var1_0.C_SE_LOOP, arg1_57, arg2_57)

	arg0_57.criInst:PlaySound(var0_57, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_58)
		if arg3_57 ~= nil then
			arg3_57(arg0_58)
		end
	end)
end

function var1_0.StopSE_Loop(arg0_59, arg1_59, arg2_59)
	local var0_59 = CueData.GetCueDataAndInit(var1_0.C_SE_LOOP, arg1_59, arg2_59)

	arg0_59.criInst:StopSound(var0_59, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)
end

function var1_0.LoadCueSheet(arg0_60, arg1_60, arg2_60)
	local var0_60 = CueData.GetCueData()

	var0_60.cueSheetName = arg1_60

	arg0_60.criInst:LoadCueSheet(var0_60, function(arg0_61)
		existCall(arg2_60, arg0_61)
	end, true)
end

function var1_0.UnloadCueSheet(arg0_62, arg1_62)
	arg0_62.criInst:UnloadCueSheet(arg1_62)
end

function var1_0.getCVVolume(arg0_63)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

function var1_0.setCVVolume(arg0_64, arg1_64)
	PlayerPrefs.SetFloat("cv_vol", arg1_64)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, arg1_64)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, arg1_64)
end

function var1_0.getBGMVolume(arg0_65)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

function var1_0.setBGMVolume(arg0_66, arg1_66)
	PlayerPrefs.SetFloat("bgm_vol", arg1_66)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg1_66)
end

function var1_0.changeBGMVolume(arg0_67, arg1_67)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg1_67)
end

function var1_0.getSEVolume(arg0_68)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

function var1_0.setSEVolume(arg0_69, arg1_69)
	PlayerPrefs.SetFloat("se_vol", arg1_69)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, arg1_69)
end

function var1_0.MuteAllVolume(arg0_70)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, 0)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, 0)
end

function var1_0.ResetAllVolume(arg0_71)
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_CV, arg0_71:getCVVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_Mute_Other_CV, arg0_71:getCVVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg0_71:getBGMVolume())
	CriWare.CriAtom.SetCategoryVolume(var1_0.Category_SE, arg0_71:getSEVolume())
end

function var1_0.InitBgmCfg(arg0_72, arg1_72)
	arg0_72.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if Application.isEditor then
			if arg1_72 then
				arg1_72()
			end

			return
		end

		local var0_72 = {
			"Malaysia",
			"Indonesia"
		}
		local var1_72 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2_72 = ""

		local function var3_72(arg0_73)
			local var0_73 = "\"country\":\""
			local var1_73 = "\","
			local var2_73, var3_73 = string.find(arg0_73, var0_73)

			if var3_73 then
				arg0_73 = string.sub(arg0_73, var3_73 + 1)
			end

			local var4_73 = string.find(arg0_73, var1_73)

			if var4_73 then
				arg0_73 = string.sub(arg0_73, 1, var4_73 - 1)
			end

			return arg0_73
		end

		local function var4_72(arg0_74)
			local var0_74 = false

			for iter0_74, iter1_74 in ipairs(var0_72) do
				if iter1_74 == arg0_74 then
					var0_74 = true
				end
			end

			return var0_74
		end

		VersionMgr.Inst:WebRequest(var1_72, function(arg0_75, arg1_75)
			local var0_75 = var3_72(arg1_75)

			originalPrint("content: " .. arg1_75)
			originalPrint("country is: " .. var0_75)

			arg0_72.isDefaultBGM = var4_72(var0_75)

			originalPrint("IP limit: " .. tostring(arg0_72.isDefaultBGM))

			if arg1_72 then
				arg1_72()
			end
		end)
	elseif arg1_72 then
		arg1_72()
	end
end

function var1_0.IsDefaultBGM(arg0_76)
	return arg0_76.isDefaultBGM
end

function var1_0.getAtomSource(arg0_77, arg1_77)
	return GetComponent(GameObject.Find("CRIWARE/" .. arg1_77), "CriAtomSource")
end

function var1_0.GetCueInfo(arg0_78, arg1_78, arg2_78, arg3_78, arg4_78)
	arg0_78:LoadCueSheet(arg1_78, function(arg0_79)
		if not arg0_79 then
			warning("加载CueSheet失败")

			return
		end

		local var0_79 = arg0_78.criInst:GetCueInfo(arg1_78, arg2_78)

		arg3_78(var0_79)

		if not arg4_78 then
			arg0_78:UnloadCueSheet(arg1_78)
		end
	end)
end

function var1_0.SetBgmWaveAnalyzerOnCapture(arg0_80, arg1_80, arg2_80)
	arg0_80.bgmWaveAnalyzer.OnCaptureL = arg1_80
	arg0_80.bgmWaveAnalyzer.OnCaptureR = arg2_80
end
