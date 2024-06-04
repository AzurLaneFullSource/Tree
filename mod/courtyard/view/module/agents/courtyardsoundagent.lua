local var0 = class("CourtYardSoundAgent", import(".CourtYardAgent"))

function var0.Play(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:Stop()

	arg0.curVoiceKey = arg1

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0.curVoiceKey)
end

function var0.Stop(arg0)
	if arg0.curVoiceKey ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0.curVoiceKey)
	end

	arg0.curVoiceKey = nil
end

function var0.Clear(arg0)
	arg0:Stop()
end

function var0.Dispose(arg0)
	arg0:Stop()
end

return var0
