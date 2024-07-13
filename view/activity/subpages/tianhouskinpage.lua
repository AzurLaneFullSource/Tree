local var0_0 = class("TianHouSkinPage", import("...base.BaseActivityPage"))
local var1_0 = {
	[0] = {
		color = "ffffff",
		name = "none"
	},
	{
		color = "ffed95",
		name = "na"
	},
	{
		color = "feb8ff",
		name = "k"
	},
	{
		color = "ad92ff",
		name = "rb"
	},
	{
		color = "affff4",
		name = "zn"
	},
	{
		color = "ffa685",
		name = "ca"
	},
	{
		color = "c1ffa7",
		name = "cu"
	}
}

function var0_0.GetCurrentDay()
	local var0_1 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():STimeDescS(var0_1, "*t").yday
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2:findTF("AD")
	arg0_2.helpBtn = arg0_2:findTF("help", arg0_2.bg)
	arg0_2.gotTag = arg0_2:findTF("got", arg0_2.bg)
	arg0_2.medalText = arg0_2:findTF("medal", arg0_2.bg)
	arg0_2.ticketText = arg0_2:findTF("ticket", arg0_2.bg)
	arg0_2.fireworkBtn = arg0_2:findTF("game_list/firework", arg0_2.bg)
	arg0_2.shootBtn = arg0_2:findTF("game_list/shoot", arg0_2.bg)
	arg0_2.foodBtn = arg0_2:findTF("game_list/food", arg0_2.bg)
	arg0_2.effectNode = arg0_2:findTF("effectNode", arg0_2.bg)
	arg0_2.playEffectBtn = arg0_2:findTF("fire", arg0_2.bg)
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.hubID = arg0_3.activity:getConfig("config_id")

	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_summer_feast")
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.fireworkBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 26)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shootBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 27)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.foodBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 25)
	end, SFX_PANEL)

	local var0_3 = getProxy(MiniGameProxy):GetMiniGameData(26):GetRuntimeData("elements")

	arg0_3.ishow = var0_3 and #var0_3 >= 4 and var0_3[4] == arg0_3.GetCurrentDay()

	onButton(arg0_3, arg0_3.playEffectBtn, function()
		if not arg0_3.ishow then
			return
		end

		arg0_3:PlayFirework(var0_3)
		setActive(arg0_3.playEffectBtn, false)
	end, SFX_PANEL)
	blinkAni(arg0_3:findTF("light", arg0_3.playEffectBtn), 0.5)
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9 = getProxy(MiniGameProxy):GetHubByHubId(arg0_9.hubID)
	local var1_9 = var0_9:getConfig("reward_need")

	setText(arg0_9.ticketText, var0_9.count)
	setText(arg0_9.medalText, var0_9.usedtime .. "/" .. var1_9)
	setActive(arg0_9.gotTag, var0_9.ultimate ~= 0)

	if var0_9.ultimate == 0 and var1_9 <= var0_9.usedtime then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_9.hubID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	setActive(arg0_9.playEffectBtn, arg0_9.ishow)
	pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1")
end

function var0_0.TransformColor(arg0_10)
	local var0_10 = tonumber(string.sub(arg0_10, 1, 2), 16)
	local var1_10 = tonumber(string.sub(arg0_10, 3, 4), 16)
	local var2_10 = tonumber(string.sub(arg0_10, 5, 6), 16)

	return Color.New(var0_10 / 255, var1_10 / 255, var2_10 / 255)
end

function var0_0.PlayFirework(arg0_11, arg1_11)
	arg1_11 = arg1_11 or {
		0,
		0,
		0
	}

	local var0_11 = UnityEngine.ParticleSystem.MinMaxGradient.New

	pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", false, function(arg0_12)
		local var0_12 = tf(arg0_12):Find("Fire"):GetComponent("ParticleSystem").main.startColor

		tf(arg0_12):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0_11(arg0_11.TransformColor(var1_0[arg1_11[1]].color))
		tf(arg0_12):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0_11(arg0_11.TransformColor(var1_0[arg1_11[2]].color))
		tf(arg0_12):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0_11(arg0_11.TransformColor(var1_0[arg1_11[3]].color))

		setParent(arg0_12, arg0_11.effectNode)

		arg0_12.transform.localPosition = Vector2(0, 0)
		arg0_11.fireEffect = arg0_12
	end)
	arg0_11:PlaySE()
end

function var0_0.ClearEffectFirework(arg0_13)
	arg0_13:StopSE()

	if arg0_13.fireEffect then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/firework", "", arg0_13.fireEffect)
	end
end

function var0_0.PlaySE(arg0_14)
	if arg0_14.SETimer then
		return
	end

	arg0_14.SECount = 10
	arg0_14.SETimer = Timer.New(function()
		arg0_14.SECount = arg0_14.SECount - 1

		if arg0_14.SECount <= 0 then
			arg0_14.SECount = math.random(5, 20)

			pg.CriMgr.GetInstance():PlaySE_V3("battle-firework")
		end
	end, 0.1, -1)

	arg0_14.SETimer:Start()
end

function var0_0.StopSE(arg0_16)
	if arg0_16.SETimer then
		pg.CriMgr.GetInstance():StopSEBattle_V3()
		arg0_16.SETimer:Stop()

		arg0_16.SETimer = nil
	end
end

function var0_0.OnHideFlush(arg0_17)
	arg0_17:ClearEffectFirework()
end

function var0_0.OnDestroy(arg0_18)
	arg0_18:ClearEffectFirework()
end

return var0_0
