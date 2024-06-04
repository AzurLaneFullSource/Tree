local var0 = class("CryptolaliaSoundPlayer")

function var0.Ctor(arg0, arg1)
	return
end

function var0.Load(arg0, arg1, arg2, arg3, arg4)
	if arg0.preCvCueSheetName == arg1 then
		arg0:Play(arg1, arg2, arg3, arg4)
	else
		arg0:Unload()
		pg.CriMgr.GetInstance():LoadCueSheet(arg1, function(arg0)
			arg0.preCvCueSheetName = arg1

			if arg0 then
				arg0:Play(arg1, arg2, arg3, arg4)
			else
				arg4(-1)
			end
		end)
	end
end

function var0.Play(arg0, arg1, arg2, arg3, arg4)
	arg0:Stop()

	local function var0()
		pg.CriMgr.GetInstance():PlayCV_V3(arg1, arg2, function(arg0)
			if arg0 then
				arg0._currentVoice = arg0.playback

				local var0 = arg0:GetLength() * 0.001

				arg4(var0)
			else
				arg4(-1)
			end
		end)
	end

	if (arg3 or 0) <= 0 then
		var0()
	else
		arg0.timer = Timer.New(var0, arg3, 1)

		arg0.timer:Start()
	end
end

function var0.Stop(arg0)
	arg0:RemoveTimer()

	if arg0._currentVoice then
		arg0._currentVoice:Stop(true)
	end
end

function var0.Unload(arg0)
	arg0:Stop()

	if arg0.preCvCueSheetName then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0.preCvCueSheetName)

		arg0.preCvCueSheetName = nil
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:Unload()
end

return var0
