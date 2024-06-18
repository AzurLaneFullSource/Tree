local var0_0 = class("CourtYardBGMAgent", import(".CourtYardAgent"))
local var1_0 = 0
local var2_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.recoders = {}
	arg0_1.playName = nil
	arg0_1.waitForStop = false
	arg0_1.defaultBgm = arg0_1:GetDefaultBgm()

	arg0_1:PlayVoice(arg0_1.defaultBgm)
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	if not arg1_2 or arg1_2 == "" then
		return
	end

	arg2_2 = arg2_2 or var1_0

	if not arg0_2.recoders[arg1_2] then
		arg0_2.recoders = {}

		arg0_2:PlayVoice(arg1_2, function(arg0_3)
			if arg2_2 == var2_0 then
				arg0_2:HandlePlayOnce(arg0_3)
			end
		end)
	end

	arg0_2.recoders[arg1_2] = (arg0_2.recoders[arg1_2] or 0) + 1
end

function var0_0.HandlePlayOnce(arg0_4, arg1_4)
	local var0_4 = long2int(arg1_4.length) * 0.001

	arg0_4:AddTimerToStopBgm(var0_4)
end

function var0_0.AddTimerToStopBgm(arg0_5, arg1_5)
	arg0_5.waitForStop = true
	arg0_5.timer = Timer.New(function()
		arg0_5:Reset()

		arg0_5.waitForStop = false
	end, arg1_5, 1)

	arg0_5.timer:Start()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Stop(arg0_8, arg1_8)
	if arg0_8.waitForStop then
		return
	end

	if not arg0_8.recoders[arg1_8] then
		return
	end

	arg0_8.recoders[arg1_8] = arg0_8.recoders[arg1_8] - 1

	if arg0_8.recoders[arg1_8] == 0 then
		arg0_8:Reset()
	end
end

function var0_0.Reset(arg0_9)
	arg0_9.recoders = {}

	arg0_9:PlayVoice(arg0_9.defaultBgm)
end

function var0_0.PlayVoice(arg0_10, arg1_10, arg2_10)
	if arg0_10.playName == arg1_10 then
		return
	end

	local var0_10 = "bgm-" .. arg1_10

	CriWareMgr.Inst:PlayBGM(var0_10, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_11)
		if arg0_11 == nil then
			warning("Missing BGM :" .. (arg1_10 or "NIL"))
		elseif arg2_10 then
			arg2_10(arg0_11.cueInfo)
		end
	end)

	arg0_10.playName = arg1_10
end

function var0_0.Clear(arg0_12)
	arg0_12:RemoveTimer()

	arg0_12.recoders = {}
	arg0_12.playName = nil
	arg0_12.waitForStop = false

	pg.CriMgr.GetInstance():StopBGM()
end

function var0_0.Dispose(arg0_13)
	arg0_13.recoders = nil

	arg0_13:RemoveTimer()
end

return var0_0
