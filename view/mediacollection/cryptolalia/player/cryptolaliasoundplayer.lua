local var0_0 = class("CryptolaliaSoundPlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	return
end

function var0_0.Load(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg0_2.preCvCueSheetName == arg1_2 then
		arg0_2:Play(arg1_2, arg2_2, arg3_2, arg4_2)
	else
		arg0_2:Unload()
		pg.CriMgr.GetInstance():LoadCueSheet(arg1_2, function(arg0_3)
			arg0_2.preCvCueSheetName = arg1_2

			if arg0_3 then
				arg0_2:Play(arg1_2, arg2_2, arg3_2, arg4_2)
			else
				arg4_2(-1)
			end
		end)
	end
end

function var0_0.Play(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4:Stop()

	local function var0_4()
		pg.CriMgr.GetInstance():PlayCV_V3(arg1_4, arg2_4, function(arg0_6)
			if arg0_6 then
				arg0_4._currentVoice = arg0_6.playback

				local var0_6 = arg0_6:GetLength() * 0.001

				arg4_4(var0_6)
			else
				arg4_4(-1)
			end
		end)
	end

	if (arg3_4 or 0) <= 0 then
		var0_4()
	else
		arg0_4.timer = Timer.New(var0_4, arg3_4, 1)

		arg0_4.timer:Start()
	end
end

function var0_0.Stop(arg0_7)
	arg0_7:RemoveTimer()

	if arg0_7._currentVoice then
		arg0_7._currentVoice:Stop(true)
	end
end

function var0_0.Unload(arg0_8)
	arg0_8:Stop()

	if arg0_8.preCvCueSheetName then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_8.preCvCueSheetName)

		arg0_8.preCvCueSheetName = nil
	end
end

function var0_0.RemoveTimer(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.Dispose(arg0_10)
	arg0_10:Unload()
end

return var0_0
