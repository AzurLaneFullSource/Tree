local var0_0 = class("MainCVLoader")

function var0_0.Ctor(arg0_1, arg1_1)
	return
end

function var0_0.Load(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg0_2.preCvCueSheetName == arg1_2 then
		arg0_2:Play(arg2_2, arg3_2, arg4_2)
	else
		arg0_2:Unload()
		pg.CriMgr.GetInstance():LoadCueSheet(arg1_2, function(arg0_3)
			arg0_2.preCvCueSheetName = arg1_2

			if arg0_3 then
				arg0_2:Play(arg2_2, arg3_2, arg4_2)
			else
				arg4_2(-1)
			end
		end)
	end
end

function var0_0.preloadCv(arg0_4, arg1_4, arg2_4)
	pg.CriMgr.GetInstance():LoadCueSheet(arg1_4, function(arg0_5)
		if arg2_4 then
			arg2_4()
		end
	end)
end

function var0_0.Play(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6:Stop()

	local function var0_6()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_6, function(arg0_8)
			if arg0_8 then
				arg0_6._currentVoice = arg0_8.playback

				local var0_8 = arg0_8:GetLength() * 0.001

				arg3_6(var0_8)
			else
				arg3_6(-1)
			end
		end)
	end

	if (arg2_6 or 0) <= 0 then
		var0_6()
	else
		arg0_6.timer = Timer.New(var0_6, arg2_6, 1)

		arg0_6.timer:Start()
	end
end

function var0_0.Stop(arg0_9)
	arg0_9:RemoveTimer()

	if arg0_9._currentVoice then
		arg0_9._currentVoice:Stop(true)
	end
end

function var0_0.Unload(arg0_10)
	arg0_10:Stop()

	if arg0_10.preCvCueSheetName then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_10.preCvCueSheetName)

		arg0_10.preCvCueSheetName = nil
	end
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.Dispose(arg0_12)
	arg0_12:Unload()
end

return var0_0
