local var0_0 = class("CourtYardSoundAgent", import(".CourtYardAgent"))

function var0_0.Play(arg0_1, arg1_1)
	if not arg1_1 then
		return
	end

	arg0_1:Stop()

	arg0_1.curVoiceKey = arg1_1

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0_1.curVoiceKey)
end

function var0_0.Stop(arg0_2)
	if arg0_2.curVoiceKey ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_2.curVoiceKey)
	end

	arg0_2.curVoiceKey = nil
end

function var0_0.Clear(arg0_3)
	arg0_3:Stop()
end

function var0_0.Dispose(arg0_4)
	arg0_4:Stop()
end

return var0_0
