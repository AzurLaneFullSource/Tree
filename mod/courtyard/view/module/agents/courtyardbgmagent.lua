local var0 = class("CourtYardBGMAgent", import(".CourtYardAgent"))
local var1 = 0
local var2 = 1

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.recoders = {}
	arg0.playName = nil
	arg0.waitForStop = false
	arg0.defaultBgm = arg0:GetDefaultBgm()

	arg0:PlayVoice(arg0.defaultBgm)
end

function var0.Play(arg0, arg1, arg2)
	if not arg1 or arg1 == "" then
		return
	end

	arg2 = arg2 or var1

	if not arg0.recoders[arg1] then
		arg0.recoders = {}

		arg0:PlayVoice(arg1, function(arg0)
			if arg2 == var2 then
				arg0:HandlePlayOnce(arg0)
			end
		end)
	end

	arg0.recoders[arg1] = (arg0.recoders[arg1] or 0) + 1
end

function var0.HandlePlayOnce(arg0, arg1)
	local var0 = long2int(arg1.length) * 0.001

	arg0:AddTimerToStopBgm(var0)
end

function var0.AddTimerToStopBgm(arg0, arg1)
	arg0.waitForStop = true
	arg0.timer = Timer.New(function()
		arg0:Reset()

		arg0.waitForStop = false
	end, arg1, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Stop(arg0, arg1)
	if arg0.waitForStop then
		return
	end

	if not arg0.recoders[arg1] then
		return
	end

	arg0.recoders[arg1] = arg0.recoders[arg1] - 1

	if arg0.recoders[arg1] == 0 then
		arg0:Reset()
	end
end

function var0.Reset(arg0)
	arg0.recoders = {}

	arg0:PlayVoice(arg0.defaultBgm)
end

function var0.PlayVoice(arg0, arg1, arg2)
	if arg0.playName == arg1 then
		return
	end

	local var0 = "bgm-" .. arg1

	CriWareMgr.Inst:PlayBGM(var0, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0)
		if arg0 == nil then
			warning("Missing BGM :" .. (arg1 or "NIL"))
		elseif arg2 then
			arg2(arg0.cueInfo)
		end
	end)

	arg0.playName = arg1
end

function var0.Clear(arg0)
	arg0:RemoveTimer()

	arg0.recoders = {}
	arg0.playName = nil
	arg0.waitForStop = false

	pg.CriMgr.GetInstance():StopBGM()
end

function var0.Dispose(arg0)
	arg0.recoders = nil

	arg0:RemoveTimer()
end

return var0
