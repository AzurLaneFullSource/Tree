local var0 = class("ShipProfileCVLoader")
local var1 = pg.ship_skin_words

function var0.Ctor(arg0)
	arg0.loadedCVBankName = nil
	arg0.loadedCVBattleBankName = nil
	arg0.playbackInfo = nil
	arg0.timers = {}
end

function var0.Load(arg0, arg1)
	arg0:ClearSound()

	if ShipWordHelper.ExistVoiceKey(arg1) then
		local var0 = ShipWordHelper.RawGetCVKey(arg1)

		arg0:SetUp(var0)
	end
end

function var0.SetUp(arg0, arg1)
	local function var0()
		local var0 = pg.CriMgr.GetCVBankName(arg1)
		local var1 = pg.CriMgr.GetBattleCVBankName(arg1)

		if arg0.exited then
			pg.CriMgr.UnloadCVBank(var0)
			pg.CriMgr.UnloadCVBank(var1)
		else
			arg0.loadedCVBankName = var0
			arg0.loadedCVBattleBankName = var1
		end
	end

	seriesAsync({
		function(arg0)
			pg.CriMgr.GetInstance():LoadCV(arg1, arg0)
		end,
		function(arg0)
			pg.CriMgr.GetInstance():LoadBattleCV(arg1, arg0)
		end
	}, var0)
end

function var0.PlaySound(arg0, arg1, arg2)
	if not arg0.playbackInfo or arg1 ~= arg0.prevCvPath or arg0.playbackInfo.channelPlayer == nil then
		arg0:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1, function(arg0)
			if arg0 then
				arg0.playbackInfo = arg0

				arg0.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2 then
					arg2(arg0.playbackInfo.cueInfo)
				end
			elseif arg2 then
				arg2()
			end
		end)

		arg0.prevCvPath = arg1

		if arg0.playbackInfo == nil then
			return nil
		end

		return arg0.playbackInfo.cueInfo
	elseif arg0.playbackInfo then
		arg0.playbackInfo:PlaybackStop()
		arg0.playbackInfo:SetStartTimeAndPlay()

		if arg2 then
			arg2(arg0.playbackInfo.cueInfo)
		end

		return arg0.playbackInfo.cueInfo
	elseif arg2 then
		arg2()
	end

	return nil
end

function var0.DelayPlaySound(arg0, arg1, arg2, arg3)
	arg0:RemoveTimer(arg1)

	if arg2 > 0 then
		arg0.timers[arg1] = Timer.New(function()
			local var0 = arg0:PlaySound(arg1, function(arg0)
				if arg3 then
					arg3(arg0)
				end
			end)
		end, arg2, 1)

		arg0.timers[arg1]:Start()
	else
		local var0 = arg0:PlaySound(arg1, function(arg0)
			if arg3 then
				arg3(arg0)
			end
		end)
	end
end

function var0.RawPlaySound(arg0, arg1, arg2)
	arg0:RemoveTimer(arg1)

	if arg2 > 0 then
		arg0.timers[arg1] = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)
		end, arg2, 1)

		arg0.timers[arg1]:Start()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)
	end
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.StopSound(arg0)
	if arg0.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0.playbackInfo)
		arg0.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0.Unload(arg0)
	if arg0.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0.loadedCVBankName)

		arg0.loadedCVBankName = nil
	end

	if arg0.loadedCVBattleBankName then
		pg.CriMgr.UnloadCVBank(arg0.loadedCVBattleBankName)

		arg0.loadedCVBattleBankName = nil
	end
end

function var0.ClearSound(arg0)
	arg0:StopSound()
	arg0:Unload()

	if arg0.playbackInfo then
		arg0.playbackInfo:Dispose()

		arg0.playbackInfo = nil
	end
end

function var0.Dispose(arg0)
	arg0:ClearSound()

	arg0.exited = true

	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil
end

return var0
