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

function var1_0.CheckHasCue(arg0_23, arg1_23, arg2_23)
	local var0_23 = CriAtom.GetCueSheet(arg1_23)

	return var0_23 ~= nil and var0_23.acb:Exists(arg2_23)
end

function var1_0.PlaySoundEffect_V3(arg0_24, arg1_24, arg2_24)
	arg0_24:CheckFModeEvent(arg1_24, function(arg0_25, arg1_25)
		arg0_24:PlayCV_V3(arg0_25, arg1_25, arg2_24)
	end, function(arg0_26)
		arg0_24:PlaySE_V3(arg0_26, arg2_24)
	end)
end

function var1_0.PlayMultipleSound_V3(arg0_27, arg1_27, arg2_27)
	arg0_27:CheckFModeEvent(arg1_27, function(arg0_28, arg1_28)
		arg0_27:CreateCvMultipleHandler(arg0_28, arg1_28, arg2_27)
	end, function(arg0_29)
		arg0_27:PlaySE_V3(arg0_29, arg2_27)
	end)
end

function var1_0.StopSoundEffect_V3(arg0_30, arg1_30)
	arg0_30:CheckFModeEvent(arg1_30, function(arg0_31, arg1_31)
		arg0_30:StopCV_V3()
	end, function(arg0_32)
		arg0_30:StopSE_V3()
	end)
end

function var1_0.UnloadSoundEffect_V3(arg0_33, arg1_33)
	arg0_33:CheckFModeEvent(arg1_33, function(arg0_34, arg1_34)
		arg0_33:UnloadCueSheet(arg0_34)
	end, function(arg0_35)
		arg0_33:StopSE_V3()
	end)
end

function var1_0.PlayCV_V3(arg0_36, arg1_36, arg2_36, arg3_36)
	assert(arg1_36, "cueSheetName can not be nil.")
	assert(arg2_36, "cueName can not be nil.")
	arg0_36.criInst:PlayVoice(arg2_36, CriWareMgr.CRI_FADE_TYPE.NONE, arg1_36, function(arg0_37)
		if arg3_36 ~= nil then
			arg3_36(arg0_37)
		end
	end)
end

function var1_0.CreateCvMultipleHandler(arg0_38, arg1_38, arg2_38, arg3_38)
	if not arg0_38.luHandle then
		arg0_38.luHandle = LateUpdateBeat:CreateListener(arg0_38.LateCvHandler, arg0_38)

		LateUpdateBeat:AddListener(arg0_38.luHandle)
	end

	arg0_38.cvCacheDataList = arg0_38.cvCacheDataList or {}

	local var0_38 = true

	for iter0_38, iter1_38 in ipairs(arg0_38.cvCacheDataList) do
		if iter1_38[1] == arg1_38 and iter1_38[2] == arg2_38 then
			var0_38 = false

			break
		end
	end

	if var0_38 then
		arg0_38.cvCacheDataList[#arg0_38.cvCacheDataList + 1] = {
			arg1_38,
			arg2_38,
			arg3_38
		}
	end
end

function var1_0.LateCvHandler(arg0_39)
	for iter0_39, iter1_39 in ipairs(arg0_39.cvCacheDataList) do
		local var0_39 = iter1_39[1]
		local var1_39 = iter1_39[2]
		local var2_39 = iter1_39[3]

		if iter0_39 == 1 then
			arg0_39.criInst:PlayVoice(var1_39, CriWareMgr.CRI_FADE_TYPE.NONE, var0_39, function(arg0_40)
				if var2_39 ~= nil then
					var2_39(arg0_40)
				end
			end)
		else
			local var3_39 = CueData.GetCueData()

			var3_39.cueSheetName = var0_39
			var3_39.channelName = var1_0.C_BATTLE_CV_EXTRA
			var3_39.cueName = var1_39

			onDelayTick(function()
				arg0_39.criInst:PlaySound(var3_39, CriWareMgr.CRI_FADE_TYPE.FADE_CROSS, function(arg0_42)
					if var2_39 ~= nil then
						var2_39(arg0_42)
					end
				end)
			end, iter0_39 * 0.4)
		end
	end

	arg0_39.cvCacheDataList = nil

	if arg0_39.luHandle then
		LateUpdateBeat:RemoveListener(arg0_39.luHandle)

		arg0_39.luHandle = nil
	end
end

function var1_0.StopCV_V3(arg0_43)
	arg0_43.criInst:GetChannelData(var1_0.C_VOICE).channelPlayer:Stop()
end

function var1_0.PlaySE_V3(arg0_44, arg1_44, arg2_44)
	assert(arg1_44, "cueName can not be nil.")
	arg0_44.criInst:PlayAnySE(arg1_44, nil, function(arg0_45)
		if arg2_44 ~= nil then
			arg2_44(arg0_45)
		end
	end)
end

function var1_0.StopSE_V3(arg0_46)
	arg0_46.criInst:GetChannelData(var1_0.C_SE).channelPlayer:Stop()
	arg0_46.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.StopSEBattle_V3(arg0_47)
	arg0_47.criInst:GetChannelData(var1_0.C_BATTLE_SE).channelPlayer:Stop()
end

function var1_0.LoadCueSheet(arg0_48, arg1_48, arg2_48)
	local var0_48 = CueData.GetCueData()

	var0_48.cueSheetName = arg1_48

	arg0_48.criInst:LoadCueSheet(var0_48, function(arg0_49)
		arg2_48(arg0_49)
	end, true)
end

function var1_0.UnloadCueSheet(arg0_50, arg1_50)
	arg0_50.criInst:UnloadCueSheet(arg1_50)
end

function var1_0.getCVVolume(arg0_51)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

function var1_0.setCVVolume(arg0_52, arg1_52)
	PlayerPrefs.SetFloat("cv_vol", arg1_52)
	CriAtom.SetCategoryVolume(var1_0.Category_CV, arg1_52)
end

function var1_0.getBGMVolume(arg0_53)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

function var1_0.setBGMVolume(arg0_54, arg1_54)
	PlayerPrefs.SetFloat("bgm_vol", arg1_54)
	CriAtom.SetCategoryVolume(var1_0.Category_BGM, arg1_54)
end

function var1_0.getSEVolume(arg0_55)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

function var1_0.setSEVolume(arg0_56, arg1_56)
	PlayerPrefs.SetFloat("se_vol", arg1_56)
	CriAtom.SetCategoryVolume(var1_0.Category_SE, arg1_56)
end

function var1_0.InitBgmCfg(arg0_57, arg1_57)
	arg0_57.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if Application.isEditor then
			if arg1_57 then
				arg1_57()
			end

			return
		end

		local var0_57 = {
			"Malaysia",
			"Indonesia"
		}
		local var1_57 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2_57 = ""

		local function var3_57(arg0_58)
			local var0_58 = "\"country\":\""
			local var1_58 = "\","
			local var2_58, var3_58 = string.find(arg0_58, var0_58)

			if var3_58 then
				arg0_58 = string.sub(arg0_58, var3_58 + 1)
			end

			local var4_58 = string.find(arg0_58, var1_58)

			if var4_58 then
				arg0_58 = string.sub(arg0_58, 1, var4_58 - 1)
			end

			return arg0_58
		end

		local function var4_57(arg0_59)
			local var0_59 = false

			for iter0_59, iter1_59 in ipairs(var0_57) do
				if iter1_59 == arg0_59 then
					var0_59 = true
				end
			end

			return var0_59
		end

		VersionMgr.Inst:WebRequest(var1_57, function(arg0_60, arg1_60)
			local var0_60 = var3_57(arg1_60)

			print("content: " .. arg1_60)
			print("country is: " .. var0_60)

			arg0_57.isDefaultBGM = var4_57(var0_60)

			print("IP limit: " .. tostring(arg0_57.isDefaultBGM))

			if arg1_57 then
				arg1_57()
			end
		end)
	elseif arg1_57 then
		arg1_57()
	end
end

function var1_0.IsDefaultBGM(arg0_61)
	return arg0_61.isDefaultBGM
end

function var1_0.getAtomSource(arg0_62, arg1_62)
	return GetComponent(GameObject.Find("CRIWARE/" .. arg1_62), "CriAtomSource")
end
