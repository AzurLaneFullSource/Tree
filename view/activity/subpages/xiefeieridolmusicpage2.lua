local var0_0 = class("XiefeierIdolMusicPage2", import("...base.BaseActivityPage"))
local var1_0 = {
	0.08,
	0.19,
	0.4,
	0.6,
	0.734,
	0.876,
	1,
	1
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.masklist = arg0_1.bg:Find("maskList")
	arg0_1.slider = arg0_1.bg:Find("slider")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.HubID = arg0_2.activity:getConfig("config_id")

	print("self.HubID:" .. arg0_2.HubID)

	arg0_2.mgProxy = getProxy(MiniGameProxy)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.bg:Find("battle_btn"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5.hubData = arg0_5.mgProxy:GetHubByHubId(arg0_5.HubID)
	arg0_5.finish_times = arg0_5.hubData.usedtime
	arg0_5.all_times = arg0_5.hubData.usedtime + arg0_5.hubData.count

	for iter0_5 = 1, 7 do
		setActive(arg0_5.masklist:Find("mask" .. iter0_5 .. "/dot"), iter0_5 <= arg0_5.finish_times)
		setActive(arg0_5.masklist:Find("mask" .. iter0_5 .. "/frame"), iter0_5 <= arg0_5.all_times and not isActive(arg0_5.masklist:Find("mask" .. iter0_5 .. "/dot")))
	end

	setSlider(arg0_5.slider, 0, 1, var1_0[arg0_5.finish_times])

	if arg0_5.finish_times >= arg0_5.hubData:getConfig("reward_need") and arg0_5.hubData.ultimate == 0 then
		arg0_5:emit(ActivityMediator.MUSIC_GAME_OPERATOR, {
			hubid = arg0_5.HubID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.OnDestroy(arg0_6)
	clearImageSprite(arg0_6.bg)
end

return var0_0
