local var0_0 = class("IslandWeatherSystem")
local var1_0 = 60
local var2_0 = 240
local var3_0 = 86400

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
	arg0_1.TOD = GameObject.Find("/[MainBlock]/[Climat]/day/[Settings]/TOD_Timeline")
	arg0_1._inited = false

	if arg0_1.TOD then
		setActive(arg0_1.TOD, true)
	end

	if not arg0_1.TOD then
		warning("TOD_Timeline不存在 如果是室内场景 忽略这条警告")

		return
	end

	arg0_1.director = arg0_1.TOD:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
	arg0_1.speedComp = GetOrAddComponent(arg0_1.TOD, "TimelineSpeed")
	arg0_1.settingComp = GetOrAddComponent(arg0_1.TOD, "TODSettings")

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	local var0_2 = pg.island_set.island_time_rate.key_value_int

	assert(var0_2 and var0_2 > 0, "Invalid island time rate")

	arg0_2.gameDaySec = math.floor(var3_0 / var0_2)

	arg0_2.director:Stop()

	arg0_2.director.playOnAwake = false
	arg0_2.director.extrapolationMode = UnityEngine.Playables.DirectorWrapMode.Loop
	arg0_2._inited = true

	if arg0_2.settingComp.pauseOnEnterTime then
		arg0_2:PauseOnEnterTime()
	else
		arg0_2:Play()
	end
end

function var0_0.Play(arg0_3)
	if not arg0_3._inited then
		return
	end

	local var0_3 = arg0_3:GetFrame()

	arg0_3.director.time = var0_3 / var1_0

	arg0_3.director:Play()
	arg0_3.speedComp:SetTimelineSpeed(var2_0 / var1_0 / arg0_3.gameDaySec)
end

function var0_0.PauseOnEnterTime(arg0_4)
	if not arg0_4._inited then
		return
	end

	local var0_4 = arg0_4:GetFrame()

	arg0_4.director.time = var0_4 / var1_0

	arg0_4.director:Play()
	arg0_4.speedComp:SetTimelineSpeed(0)
end

function var0_0.GetFrame(arg0_5)
	if not arg0_5._inited then
		return 0
	end

	local var0_5 = pg.TimeMgr.GetInstance()
	local var1_5 = (var0_5:GetServerTime() - var0_5._sAnchorTime) % var3_0 % arg0_5.gameDaySec

	return (math.floor(var1_5 / arg0_5.gameDaySec * var2_0))
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
