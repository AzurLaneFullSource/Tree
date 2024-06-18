local var0_0 = class("ShipProfileCVLoader")
local var1_0 = pg.ship_skin_words

function var0_0.Ctor(arg0_1)
	arg0_1.loadedCVBankName = nil
	arg0_1.loadedCVBattleBankName = nil
	arg0_1.playbackInfo = nil
	arg0_1.timers = {}
end

function var0_0.Load(arg0_2, arg1_2)
	arg0_2:ClearSound()

	if ShipWordHelper.ExistVoiceKey(arg1_2) then
		local var0_2 = ShipWordHelper.RawGetCVKey(arg1_2)

		arg0_2:SetUp(var0_2)
	end
end

function var0_0.SetUp(arg0_3, arg1_3)
	local function var0_3()
		local var0_4 = pg.CriMgr.GetCVBankName(arg1_3)
		local var1_4 = pg.CriMgr.GetBattleCVBankName(arg1_3)

		if arg0_3.exited then
			pg.CriMgr.UnloadCVBank(var0_4)
			pg.CriMgr.UnloadCVBank(var1_4)
		else
			arg0_3.loadedCVBankName = var0_4
			arg0_3.loadedCVBattleBankName = var1_4
		end
	end

	seriesAsync({
		function(arg0_5)
			pg.CriMgr.GetInstance():LoadCV(arg1_3, arg0_5)
		end,
		function(arg0_6)
			pg.CriMgr.GetInstance():LoadBattleCV(arg1_3, arg0_6)
		end
	}, var0_3)
end

function var0_0.PlaySound(arg0_7, arg1_7, arg2_7)
	if not arg0_7.playbackInfo or arg1_7 ~= arg0_7.prevCvPath or arg0_7.playbackInfo.channelPlayer == nil then
		arg0_7:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_7, function(arg0_8)
			if arg0_8 then
				arg0_7.playbackInfo = arg0_8

				arg0_7.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2_7 then
					arg2_7(arg0_7.playbackInfo.cueInfo)
				end
			elseif arg2_7 then
				arg2_7()
			end
		end)

		arg0_7.prevCvPath = arg1_7

		if arg0_7.playbackInfo == nil then
			return nil
		end

		return arg0_7.playbackInfo.cueInfo
	elseif arg0_7.playbackInfo then
		arg0_7.playbackInfo:PlaybackStop()
		arg0_7.playbackInfo:SetStartTimeAndPlay()

		if arg2_7 then
			arg2_7(arg0_7.playbackInfo.cueInfo)
		end

		return arg0_7.playbackInfo.cueInfo
	elseif arg2_7 then
		arg2_7()
	end

	return nil
end

function var0_0.DelayPlaySound(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9:RemoveTimer(arg1_9)

	if arg2_9 > 0 then
		arg0_9.timers[arg1_9] = Timer.New(function()
			local var0_10 = arg0_9:PlaySound(arg1_9, function(arg0_11)
				if arg3_9 then
					arg3_9(arg0_11)
				end
			end)
		end, arg2_9, 1)

		arg0_9.timers[arg1_9]:Start()
	else
		local var0_9 = arg0_9:PlaySound(arg1_9, function(arg0_12)
			if arg3_9 then
				arg3_9(arg0_12)
			end
		end)
	end
end

function var0_0.RawPlaySound(arg0_13, arg1_13, arg2_13)
	arg0_13:RemoveTimer(arg1_13)

	if arg2_13 > 0 then
		arg0_13.timers[arg1_13] = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_13)
		end, arg2_13, 1)

		arg0_13.timers[arg1_13]:Start()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_13)
	end
end

function var0_0.RemoveTimer(arg0_15, arg1_15)
	if arg0_15.timers[arg1_15] then
		arg0_15.timers[arg1_15]:Stop()

		arg0_15.timers[arg1_15] = nil
	end
end

function var0_0.StopSound(arg0_16)
	if arg0_16.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_16.playbackInfo)
		arg0_16.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0_0.Unload(arg0_17)
	if arg0_17.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_17.loadedCVBankName)

		arg0_17.loadedCVBankName = nil
	end

	if arg0_17.loadedCVBattleBankName then
		pg.CriMgr.UnloadCVBank(arg0_17.loadedCVBattleBankName)

		arg0_17.loadedCVBattleBankName = nil
	end
end

function var0_0.ClearSound(arg0_18)
	arg0_18:StopSound()
	arg0_18:Unload()

	if arg0_18.playbackInfo then
		arg0_18.playbackInfo:Dispose()

		arg0_18.playbackInfo = nil
	end
end

function var0_0.Dispose(arg0_19)
	arg0_19:ClearSound()

	arg0_19.exited = true

	for iter0_19, iter1_19 in pairs(arg0_19.timers) do
		iter1_19:Stop()
	end

	arg0_19.timers = nil
end

return var0_0
