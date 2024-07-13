local var0_0 = class("EducateCharCvLoader")

function var0_0.Play(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1:Stop()

	local function var0_1()
		pg.CriMgr.GetInstance():PlayCV_V3(arg2_1, arg1_1, function(arg0_3)
			if arg0_3 then
				local var0_3 = arg0_3:GetLength() * 0.001

				arg0_1._currentVoice = arg0_3.playback

				arg4_1(var0_3)
			else
				arg4_1(-1)
			end
		end)
	end

	if (arg3_1 or 0) <= 0 then
		var0_1()
	else
		arg0_1.timer = Timer.New(var0_1, arg3_1, 1)

		arg0_1.timer:Start()
	end
end

function var0_0.Stop(arg0_4)
	arg0_4:RemoveTimer()

	if arg0_4._currentVoice then
		arg0_4._currentVoice:Stop(true)
	end
end

function var0_0.Unload(arg0_5)
	arg0_5:Stop()
end

function var0_0.RemoveTimer(arg0_6)
	if arg0_6.timer then
		arg0_6.timer:Stop()

		arg0_6.timer = nil
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:Unload()
end

return var0_0
