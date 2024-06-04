local var0 = class("TianHouSkinPage", import("...base.BaseActivityPage"))
local var1 = {
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

function var0.GetCurrentDay()
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():STimeDescS(var0, "*t").yday
end

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.helpBtn = arg0:findTF("help", arg0.bg)
	arg0.gotTag = arg0:findTF("got", arg0.bg)
	arg0.medalText = arg0:findTF("medal", arg0.bg)
	arg0.ticketText = arg0:findTF("ticket", arg0.bg)
	arg0.fireworkBtn = arg0:findTF("game_list/firework", arg0.bg)
	arg0.shootBtn = arg0:findTF("game_list/shoot", arg0.bg)
	arg0.foodBtn = arg0:findTF("game_list/food", arg0.bg)
	arg0.effectNode = arg0:findTF("effectNode", arg0.bg)
	arg0.playEffectBtn = arg0:findTF("fire", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	arg0.hubID = arg0.activity:getConfig("config_id")

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_summer_feast")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.fireworkBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 26)
	end, SFX_PANEL)
	onButton(arg0, arg0.shootBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 27)
	end, SFX_PANEL)
	onButton(arg0, arg0.foodBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 25)
	end, SFX_PANEL)

	local var0 = getProxy(MiniGameProxy):GetMiniGameData(26):GetRuntimeData("elements")

	arg0.ishow = var0 and #var0 >= 4 and var0[4] == arg0.GetCurrentDay()

	onButton(arg0, arg0.playEffectBtn, function()
		if not arg0.ishow then
			return
		end

		arg0:PlayFirework(var0)
		setActive(arg0.playEffectBtn, false)
	end, SFX_PANEL)
	blinkAni(arg0:findTF("light", arg0.playEffectBtn), 0.5)
end

function var0.OnUpdateFlush(arg0)
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(arg0.hubID)
	local var1 = var0:getConfig("reward_need")

	setText(arg0.ticketText, var0.count)
	setText(arg0.medalText, var0.usedtime .. "/" .. var1)
	setActive(arg0.gotTag, var0.ultimate ~= 0)

	if var0.ultimate == 0 and var1 <= var0.usedtime then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0.hubID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	setActive(arg0.playEffectBtn, arg0.ishow)
	pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1")
end

function var0.TransformColor(arg0)
	local var0 = tonumber(string.sub(arg0, 1, 2), 16)
	local var1 = tonumber(string.sub(arg0, 3, 4), 16)
	local var2 = tonumber(string.sub(arg0, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

function var0.PlayFirework(arg0, arg1)
	arg1 = arg1 or {
		0,
		0,
		0
	}

	local var0 = UnityEngine.ParticleSystem.MinMaxGradient.New

	pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", false, function(arg0)
		local var0 = tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor

		tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0(arg0.TransformColor(var1[arg1[1]].color))
		tf(arg0):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0(arg0.TransformColor(var1[arg1[2]].color))
		tf(arg0):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0(arg0.TransformColor(var1[arg1[3]].color))

		setParent(arg0, arg0.effectNode)

		arg0.transform.localPosition = Vector2(0, 0)
		arg0.fireEffect = arg0
	end)
	arg0:PlaySE()
end

function var0.ClearEffectFirework(arg0)
	arg0:StopSE()

	if arg0.fireEffect then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/firework", "", arg0.fireEffect)
	end
end

function var0.PlaySE(arg0)
	if arg0.SETimer then
		return
	end

	arg0.SECount = 10
	arg0.SETimer = Timer.New(function()
		arg0.SECount = arg0.SECount - 1

		if arg0.SECount <= 0 then
			arg0.SECount = math.random(5, 20)

			pg.CriMgr.GetInstance():PlaySE_V3("battle-firework")
		end
	end, 0.1, -1)

	arg0.SETimer:Start()
end

function var0.StopSE(arg0)
	if arg0.SETimer then
		pg.CriMgr.GetInstance():StopSEBattle_V3()
		arg0.SETimer:Stop()

		arg0.SETimer = nil
	end
end

function var0.OnHideFlush(arg0)
	arg0:ClearEffectFirework()
end

function var0.OnDestroy(arg0)
	arg0:ClearEffectFirework()
end

return var0
