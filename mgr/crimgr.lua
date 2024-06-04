pg = pg or {}

local var0 = pg

var0.CriMgr = singletonClass("CriMgr")

local var1 = var0.CriMgr

var1.Category_CV = "Category_CV"
var1.Category_BGM = "Category_BGM"
var1.Category_SE = "Category_SE"
var1.C_BGM = "C_BGM"
var1.C_VOICE = "cv"
var1.C_SE = "C_SE"
var1.C_BATTLE_SE = "C_BATTLE_SE"
var1.C_GALLERY_MUSIC = "C_GALLERY_MUSIC"
var1.C_BATTLE_CV_EXTRA = "C_BATTLE_CV_EXTRA"
var1.NEXT_VER = 40

function var1.Init(arg0, arg1)
	print("initializing cri manager...")
	seriesAsync({
		function(arg0)
			arg0:InitCri(arg0)
		end,
		function(arg0)
			local var0 = CueData.GetCueData()

			var0.cueSheetName = "se-ui"
			var0.channelName = var1.C_SE

			arg0.criInst:LoadCueSheet(var0, function(arg0)
				arg0()
			end, true)
		end,
		function(arg0)
			local var0 = CueData.GetCueData()

			var0.cueSheetName = "se-battle"
			var0.channelName = var1.C_BATTLE_SE

			arg0.criInst:LoadCueSheet(var0, function(arg0)
				arg0()
			end, true)
		end,
		function(arg0)
			arg0:InitBgmCfg(arg0)
		end
	}, arg1)
end

function var1.InitCri(arg0, arg1)
	arg0.criInitializer = GameObject.Find("CRIWARE"):GetComponent(typeof(CriWareInitializer))
	arg0.criInitializer.fileSystemConfig.numberOfLoaders = 128
	arg0.criInitializer.manaConfig.numberOfDecoders = 128
	arg0.criInitializer.atomConfig.useRandomSeedWithTime = true

	arg0.criInitializer:Initialize()

	arg0.criInst = CriWareMgr.Inst

	arg0.criInst:Init(function()
		CriAtom.SetCategoryVolume(var1.Category_CV, arg0:getCVVolume())
		CriAtom.SetCategoryVolume(var1.Category_SE, arg0:getSEVolume())
		CriAtom.SetCategoryVolume(var1.Category_BGM, arg0:getBGMVolume())
		arg0.criInst:RemoveChannel("C_VOICE")
		Object.Destroy(GameObject.Find("CRIWARE/C_VOICE"))
		arg0.criInst:CreateChannel(var1.C_VOICE, CriWareMgr.CRI_CHANNEL_TYPE.MULTI_NOT_REPEAT)

		CriWareMgr.C_VOICE = var1.C_VOICE

		local var0 = arg0.criInst:GetChannelData(var1.C_VOICE)

		arg0.criInst:CreateChannel(var1.C_GALLERY_MUSIC, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0.criInst:GetChannelData(var1.C_BGM).channelPlayer.loop = true

		arg0.criInst:CreateChannel(var1.C_BATTLE_CV_EXTRA, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		arg0.criInst:GetChannelData(var1.C_BATTLE_CV_EXTRA).channelPlayer.volume = 0.6

		arg1()
	end)
end

function var1.PlayBGM(arg0, arg1, arg2)
	local var0 = "bgm-" .. arg1

	if arg0.bgmName == var0 then
		return
	end

	arg0.bgmName = var0

	arg0.criInst:PlayBGM(var0, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0)
		if arg0 == nil then
			warning("Missing BGM :" .. (arg1 or "NIL"))
		end
	end)
end

function var1.StopBGM(arg0)
	arg0.criInst:StopBGM(CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)

	arg0.bgmName = nil
end

function var1.StopPlaybackInfoForce(arg0, arg1)
	arg1.playback:Stop(true)
end

function var1.LoadCV(arg0, arg1, arg2)
	local var0 = var1.GetCVBankName(arg1)

	arg0:LoadCueSheet(var0, arg2)
end

function var1.LoadBattleCV(arg0, arg1, arg2)
	local var0 = var1.GetBattleCVBankName(arg1)

	arg0:LoadCueSheet(var0, arg2)
end

function var1.UnloadCVBank(arg0)
	var1.GetInstance():UnloadCueSheet(arg0)
end

function var1.GetCVBankName(arg0)
	return "cv-" .. arg0
end

function var1.GetBattleCVBankName(arg0)
	return "cv-" .. arg0 .. "-battle"
end

function var1.CheckFModeEvent(arg0, arg1, arg2, arg3)
	if not arg1 then
		return
	end

	local var0
	local var1

	string.gsub(arg1, "event:/cv/(.+)/(.+)", function(arg0, arg1)
		local var0 = string.gsub(arg1, "_%w+", "")
		local var1 = tobool(ShipWordHelper.CVBattleKey[var0])

		var0 = "cv-" .. arg0 .. (var1 and "-battle" or "")
		var1 = arg1
	end)
	string.gsub(arg1, "event:/tb/(.+)/(.+)", function(arg0, arg1)
		var0 = "tb-" .. arg0
		var1 = arg1
	end)
	string.gsub(arg1, "event:/educate/(.+)/(.+)", function(arg0, arg1)
		var0 = "educate-" .. arg0
		var1 = arg1
	end)

	if string.find(arg1, "event:/educate%-cv/") then
		local var2 = string.split(arg1, "/")

		var1 = var2[#var2]
		var0 = var2[#var2 - 1]
	end

	if var0 and var1 then
		arg2(var0, var1)
	else
		var1 = arg1
		var1 = string.gsub(var1, "event:/(battle)/(.+)", "%1-%2")
		var1 = string.gsub(var1, "event:/(ui)/(.+)", "%1-%2")

		arg3(var1)
	end
end

function var1.CheckHasCue(arg0, arg1, arg2)
	local var0 = CriAtom.GetCueSheet(arg1)

	return var0 ~= nil and var0.acb:Exists(arg2)
end

function var1.PlaySoundEffect_V3(arg0, arg1, arg2)
	arg0:CheckFModeEvent(arg1, function(arg0, arg1)
		arg0:PlayCV_V3(arg0, arg1, arg2)
	end, function(arg0)
		arg0:PlaySE_V3(arg0, arg2)
	end)
end

function var1.PlayMultipleSound_V3(arg0, arg1, arg2)
	arg0:CheckFModeEvent(arg1, function(arg0, arg1)
		arg0:CreateCvMultipleHandler(arg0, arg1, arg2)
	end, function(arg0)
		arg0:PlaySE_V3(arg0, arg2)
	end)
end

function var1.StopSoundEffect_V3(arg0, arg1)
	arg0:CheckFModeEvent(arg1, function(arg0, arg1)
		arg0:StopCV_V3()
	end, function(arg0)
		arg0:StopSE_V3()
	end)
end

function var1.UnloadSoundEffect_V3(arg0, arg1)
	arg0:CheckFModeEvent(arg1, function(arg0, arg1)
		arg0:UnloadCueSheet(arg0)
	end, function(arg0)
		arg0:StopSE_V3()
	end)
end

function var1.PlayCV_V3(arg0, arg1, arg2, arg3)
	assert(arg1, "cueSheetName can not be nil.")
	assert(arg2, "cueName can not be nil.")
	arg0.criInst:PlayVoice(arg2, CriWareMgr.CRI_FADE_TYPE.NONE, arg1, function(arg0)
		if arg3 ~= nil then
			arg3(arg0)
		end
	end)
end

function var1.CreateCvMultipleHandler(arg0, arg1, arg2, arg3)
	if not arg0.luHandle then
		arg0.luHandle = LateUpdateBeat:CreateListener(arg0.LateCvHandler, arg0)

		LateUpdateBeat:AddListener(arg0.luHandle)
	end

	arg0.cvCacheDataList = arg0.cvCacheDataList or {}

	local var0 = true

	for iter0, iter1 in ipairs(arg0.cvCacheDataList) do
		if iter1[1] == arg1 and iter1[2] == arg2 then
			var0 = false

			break
		end
	end

	if var0 then
		arg0.cvCacheDataList[#arg0.cvCacheDataList + 1] = {
			arg1,
			arg2,
			arg3
		}
	end
end

function var1.LateCvHandler(arg0)
	for iter0, iter1 in ipairs(arg0.cvCacheDataList) do
		local var0 = iter1[1]
		local var1 = iter1[2]
		local var2 = iter1[3]

		if iter0 == 1 then
			arg0.criInst:PlayVoice(var1, CriWareMgr.CRI_FADE_TYPE.NONE, var0, function(arg0)
				if var2 ~= nil then
					var2(arg0)
				end
			end)
		else
			local var3 = CueData.GetCueData()

			var3.cueSheetName = var0
			var3.channelName = var1.C_BATTLE_CV_EXTRA
			var3.cueName = var1

			onDelayTick(function()
				arg0.criInst:PlaySound(var3, CriWareMgr.CRI_FADE_TYPE.FADE_CROSS, function(arg0)
					if var2 ~= nil then
						var2(arg0)
					end
				end)
			end, iter0 * 0.4)
		end
	end

	arg0.cvCacheDataList = nil

	if arg0.luHandle then
		LateUpdateBeat:RemoveListener(arg0.luHandle)

		arg0.luHandle = nil
	end
end

function var1.StopCV_V3(arg0)
	arg0.criInst:GetChannelData(var1.C_VOICE).channelPlayer:Stop()
end

function var1.PlaySE_V3(arg0, arg1, arg2)
	assert(arg1, "cueName can not be nil.")
	arg0.criInst:PlayAnySE(arg1, nil, function(arg0)
		if arg2 ~= nil then
			arg2(arg0)
		end
	end)
end

function var1.StopSE_V3(arg0)
	arg0.criInst:GetChannelData(var1.C_SE).channelPlayer:Stop()
	arg0.criInst:GetChannelData(var1.C_BATTLE_SE).channelPlayer:Stop()
end

function var1.StopSEBattle_V3(arg0)
	arg0.criInst:GetChannelData(var1.C_BATTLE_SE).channelPlayer:Stop()
end

function var1.LoadCueSheet(arg0, arg1, arg2)
	local var0 = CueData.GetCueData()

	var0.cueSheetName = arg1

	arg0.criInst:LoadCueSheet(var0, function(arg0)
		arg2(arg0)
	end, true)
end

function var1.UnloadCueSheet(arg0, arg1)
	arg0.criInst:UnloadCueSheet(arg1)
end

function var1.getCVVolume(arg0)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

function var1.setCVVolume(arg0, arg1)
	PlayerPrefs.SetFloat("cv_vol", arg1)
	CriAtom.SetCategoryVolume(var1.Category_CV, arg1)
end

function var1.getBGMVolume(arg0)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

function var1.setBGMVolume(arg0, arg1)
	PlayerPrefs.SetFloat("bgm_vol", arg1)
	CriAtom.SetCategoryVolume(var1.Category_BGM, arg1)
end

function var1.getSEVolume(arg0)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

function var1.setSEVolume(arg0, arg1)
	PlayerPrefs.SetFloat("se_vol", arg1)
	CriAtom.SetCategoryVolume(var1.Category_SE, arg1)
end

function var1.InitBgmCfg(arg0, arg1)
	arg0.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if Application.isEditor then
			if arg1 then
				arg1()
			end

			return
		end

		local var0 = {
			"Malaysia",
			"Indonesia"
		}
		local var1 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2 = ""

		local function var3(arg0)
			local var0 = "\"country\":\""
			local var1 = "\","
			local var2, var3 = string.find(arg0, var0)

			if var3 then
				arg0 = string.sub(arg0, var3 + 1)
			end

			local var4 = string.find(arg0, var1)

			if var4 then
				arg0 = string.sub(arg0, 1, var4 - 1)
			end

			return arg0
		end

		local function var4(arg0)
			local var0 = false

			for iter0, iter1 in ipairs(var0) do
				if iter1 == arg0 then
					var0 = true
				end
			end

			return var0
		end

		VersionMgr.Inst:WebRequest(var1, function(arg0, arg1)
			local var0 = var3(arg1)

			print("content: " .. arg1)
			print("country is: " .. var0)

			arg0.isDefaultBGM = var4(var0)

			print("IP limit: " .. tostring(arg0.isDefaultBGM))

			if arg1 then
				arg1()
			end
		end)
	elseif arg1 then
		arg1()
	end
end

function var1.IsDefaultBGM(arg0)
	return arg0.isDefaultBGM
end

function var1.getAtomSource(arg0, arg1)
	return GetComponent(GameObject.Find("CRIWARE/" .. arg1), "CriAtomSource")
end
