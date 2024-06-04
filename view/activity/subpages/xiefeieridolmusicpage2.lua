local var0 = class("XiefeierIdolMusicPage2", import("...base.BaseActivityPage"))
local var1 = {
	0.08,
	0.19,
	0.4,
	0.6,
	0.734,
	0.876,
	1,
	1
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.masklist = arg0.bg:Find("maskList")
	arg0.slider = arg0.bg:Find("slider")
end

function var0.OnDataSetting(arg0)
	arg0.HubID = arg0.activity:getConfig("config_id")

	print("self.HubID:" .. arg0.HubID)

	arg0.mgProxy = getProxy(MiniGameProxy)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.bg:Find("battle_btn"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	arg0.hubData = arg0.mgProxy:GetHubByHubId(arg0.HubID)
	arg0.finish_times = arg0.hubData.usedtime
	arg0.all_times = arg0.hubData.usedtime + arg0.hubData.count

	for iter0 = 1, 7 do
		setActive(arg0.masklist:Find("mask" .. iter0 .. "/dot"), iter0 <= arg0.finish_times)
		setActive(arg0.masklist:Find("mask" .. iter0 .. "/frame"), iter0 <= arg0.all_times and not isActive(arg0.masklist:Find("mask" .. iter0 .. "/dot")))
	end

	setSlider(arg0.slider, 0, 1, var1[arg0.finish_times])

	if arg0.finish_times >= arg0.hubData:getConfig("reward_need") and arg0.hubData.ultimate == 0 then
		arg0:emit(ActivityMediator.MUSIC_GAME_OPERATOR, {
			hubid = arg0.HubID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
end

return var0
