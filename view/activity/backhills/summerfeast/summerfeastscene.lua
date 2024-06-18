local var0_0 = class("SummerFeastScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SummerFeastUI"
end

var0_0.HUB_ID = 1
var0_0.Elements = {
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
	local var0_2 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():STimeDescS(var0_2, "*t").yday
end

function var0_0.GetTheDay()
	local var0_3 = os.time({
		year = 2019,
		month = 8,
		hour = 0,
		min = 0,
		sec = 0,
		day = 29,
		isdst = false
	})

	return os.date("*t", var0_3).yday
end

function var0_0.TransformColor(arg0_4)
	local var0_4 = tonumber(string.sub(arg0_4, 1, 2), 16)
	local var1_4 = tonumber(string.sub(arg0_4, 3, 4), 16)
	local var2_4 = tonumber(string.sub(arg0_4, 5, 6), 16)
	local var3_4 = 255

	if string.len(arg0_4) > 6 and string.len(arg0_4) <= 8 then
		var3_4 = tonumber(string.sub(arg0_4, 7, 8), 16)
	end

	return Color.New(var0_4 / 255, var1_4 / 255, var2_4 / 255, var3_4 / 255)
end

function var0_0.GenerateRandomFanPosition(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5, arg6_5)
	local var0_5 = {}

	for iter0_5 = 1, arg6_5 do
		table.insert(var0_5, math.lerp(arg4_5, arg5_5, math.random(1, 100) / 100))
	end

	local var1_5 = arg3_5 / (arg6_5 - 1)
	local var2_5 = math.sin(var1_5)
	local var3_5 = math.cos(var1_5)
	local var4_5 = Vector2.Normalize(arg2_5 - arg1_5)
	local var5_5 = {}
	local var6_5 = var4_5.x
	local var7_5 = var4_5.y

	table.insert(var5_5, Vector2.New(arg1_5.x + var0_5[1] * var6_5, arg1_5.y + var0_5[1] * var7_5))

	for iter1_5 = 2, arg6_5 do
		local var8_5 = var6_5 * var3_5 + var7_5 * var2_5
		local var9_5 = var7_5 * var3_5 - var6_5 * var2_5

		var6_5, var7_5 = var8_5, var9_5

		table.insert(var5_5, Vector2.New(arg1_5.x + var0_5[iter1_5] * var6_5, arg1_5.y + var0_5[iter1_5] * var7_5))
	end

	return var5_5
end

function var0_0.init(arg0_6)
	arg0_6.top = arg0_6:findTF("top")
	arg0_6._closeBtn = arg0_6:findTF("top/back")
	arg0_6._homeBtn = arg0_6:findTF("top/home")
	arg0_6._helpBtn = arg0_6:findTF("top/help")
	arg0_6.ticketTimes = arg0_6.top:Find("ticket/text")
	arg0_6.yinhuace = arg0_6.top:Find("yinhuace")
	arg0_6.yinhuaceTimes = arg0_6.yinhuace:Find("get")
	arg0_6.yinhuaceTips = arg0_6.yinhuace:Find("tip")
	arg0_6.shouce = arg0_6.top:Find("yinhuashouceye")
	arg0_6.shouce_bg = arg0_6.shouce:Find("bg")
	arg0_6.layout_shouce = arg0_6.shouce:Find("yinhuace/go/layout")
	arg0_6.group_get = CustomIndexLayer.Clone2Full(arg0_6.layout_shouce, 14)
	arg0_6.btn_receive = arg0_6.shouce:Find("yinhuace/receive")
	arg0_6.btn_shouce_help = arg0_6.shouce:Find("yinhuace/help")
	arg0_6.img_get = arg0_6.shouce:Find("yinhuace/get")

	setActive(arg0_6.shouce, false)

	arg0_6.sakura = arg0_6:findTF("effect")
	arg0_6._map = arg0_6:findTF("scrollRect/map")
	arg0_6.wave = arg0_6._map:Find("effect_wave")
	arg0_6.shrine = arg0_6._map:Find("shrine")
	arg0_6.snack_street = arg0_6._map:Find("snack_street")
	arg0_6.entertainment_street = arg0_6._map:Find("entertainment_street")
	arg0_6.firework_factory = arg0_6._map:Find("firework_factory")
	arg0_6.btn_fire = arg0_6.firework_factory:Find("fire")
	arg0_6.bottom = arg0_6._map:Find("bottom")
	arg0_6.middle = arg0_6._map:Find("middle")
	arg0_6.front = arg0_6._map:Find("front")
	arg0_6._shipTpl = arg0_6._map:Find("ship")
	arg0_6.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SummerFeastGraph"))

	pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", true, function(arg0_7)
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/firework", "", arg0_7)
	end)

	arg0_6.workingEffect = {}
end

function var0_0.didEnter(arg0_8)
	local var0_8 = getProxy(MiniGameProxy)

	onButton(arg0_8, arg0_8._closeBtn, function()
		arg0_8:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_8, arg0_8._homeBtn, function()
		arg0_8:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_8, arg0_8._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_feast.tip
		})
	end)
	onButton(arg0_8, arg0_8.yinhuace, function()
		setActive(arg0_8.shouce, true)
	end)
	onButton(arg0_8, arg0_8.shouce_bg, function()
		setActive(arg0_8.shouce, false)
	end)
	onButton(arg0_8, arg0_8.btn_shouce_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_stamp.tip
		})
	end)
	onButton(arg0_8, arg0_8.btn_receive, function()
		local var0_15 = var0_8:GetHubByHubId(arg0_8.HUB_ID)

		if var0_15.ultimate ~= 0 or var0_15.usedtime < var0_15:getConfig("reward_need") then
			return
		end

		arg0_8:emit(SummerFeastMediator.MINI_GAME_OPERATOR, {
			hubid = var0_15.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)
	arg0_8:InitFacility(arg0_8.shrine, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end)
	arg0_8:InitFacility(arg0_8.snack_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 2)
	end)
	arg0_8:InitFacility(arg0_8.entertainment_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 5)
	end)
	arg0_8:InitFacility(arg0_8.firework_factory, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 4)
	end)
	onButton(arg0_8, arg0_8.btn_fire, function()
		local var0_20 = var0_8:GetMiniGameData(4):GetRuntimeData("elements")

		if not var0_20 or not (#var0_20 >= 4) or var0_20[4] ~= arg0_8.GetCurrentDay() then
			return
		end

		arg0_8:PlayFirework(var0_20)
		setActive(arg0_8.btn_fire, false)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8.top)

	arg0_8.academyStudents = {}

	arg0_8:InitAreaTransFunc()
	arg0_8:updateStudents()
	arg0_8:UpdateView()
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = getProxy(MiniGameProxy)
	local var1_21 = var0_21:GetHubByHubId(arg0_21.HUB_ID)
	local var2_21 = var1_21.usedtime

	setText(arg0_21.ticketTimes, var1_21.count)
	setText(arg0_21.yinhuaceTimes, var2_21)

	for iter0_21, iter1_21 in ipairs(arg0_21.group_get) do
		setActive(iter1_21, iter0_21 <= var2_21)
	end

	local var3_21 = var2_21 >= #arg0_21.group_get and var1_21.ultimate == 0

	setActive(arg0_21.btn_receive, var3_21)
	setActive(arg0_21.yinhuaceTips, var3_21)
	setActive(arg0_21.img_get, var1_21.ultimate ~= 0)

	if var1_21.ultimate == 1 then
		arg0_21:TryPlayStory()
	end

	local var4_21 = var0_21:GetMiniGameData(4):GetRuntimeData("elements")
	local var5_21 = var4_21 and #var4_21 >= 4 and var4_21[4] == arg0_21.GetCurrentDay()

	setActive(arg0_21.btn_fire, var5_21)
end

function var0_0.InitFacility(arg0_22, arg1_22, arg2_22)
	onButton(arg0_22, arg1_22, arg2_22)
	onButton(arg0_22, arg1_22:Find("button"), arg2_22)
end

function var0_0.PlayFirework(arg0_23, arg1_23)
	if #arg0_23.workingEffect > 0 then
		return
	end

	arg1_23 = arg1_23 or {
		0,
		0,
		0
	}

	local var0_23 = {
		Vector2(215, 150)
	}
	local var1_23 = UnityEngine.ParticleSystem.MinMaxGradient.New

	for iter0_23, iter1_23 in pairs(var0_23) do
		pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", false, function(arg0_24)
			local var0_24 = var0_0.Elements

			tf(arg0_24):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var1_23(arg0_23.TransformColor(var0_24[arg1_23[1]].color))
			tf(arg0_24):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var1_23(arg0_23.TransformColor(var0_24[arg1_23[2]].color))
			tf(arg0_24):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var1_23(arg0_23.TransformColor(var0_24[arg1_23[3]].color))

			table.insert(arg0_23.workingEffect, arg0_24)
			setParent(arg0_24, arg0_23._map)

			arg0_24.transform.localPosition = iter1_23
		end)
	end

	arg0_23:PlaySE()
end

function var0_0.ClearEffectFirework(arg0_25)
	arg0_25:StopSE()

	local var0_25 = pg.PoolMgr.GetInstance()

	for iter0_25, iter1_25 in pairs(arg0_25.workingEffect) do
		var0_25:ReturnPrefab("ui/firework", "", iter1_25)
	end

	var0_25:DestroyPrefab("ui/firework", "")

	arg0_25.workingEffect = {}
end

function var0_0.PlaySE(arg0_26)
	if arg0_26.SETimer then
		return
	end

	arg0_26.SECount = 10
	arg0_26.SETimer = Timer.New(function()
		arg0_26.SECount = arg0_26.SECount - 1

		if arg0_26.SECount <= 0 then
			arg0_26.SECount = math.random(5, 20)

			pg.CriMgr.GetInstance():PlaySE_V3("battle-firework")
		end
	end, 0.1, -1)

	arg0_26.SETimer:Start()
end

function var0_0.StopSE(arg0_28)
	if arg0_28.SETimer then
		pg.CriMgr.GetInstance():StopSEBattle_V3()
		arg0_28.SETimer:Stop()

		arg0_28.SETimer = nil
	end
end

function var0_0.getStudents(arg0_29)
	local var0_29 = {}
	local var1_29 = getProxy(ActivityProxy):getActivityById(ActivityConst.SUMMER_FEAST_ID)

	if not var1_29 then
		return var0_29
	end

	local var2_29 = var1_29:getConfig("config_client")

	var2_29 = var2_29 and var2_29.ships

	if var2_29 then
		local var3_29 = Clone(var2_29)
		local var4_29 = 0
		local var5_29 = #var3_29

		while var4_29 < 15 and var5_29 > 0 do
			local var6_29 = math.random(1, var5_29)

			table.insert(var0_29, var3_29[var6_29])

			var3_29[var6_29] = var3_29[var5_29]
			var5_29 = var5_29 - 1
			var4_29 = var4_29 + math.random(3, 5)
		end
	end

	return var0_29
end

function var0_0.InitAreaTransFunc(arg0_30)
	arg0_30.edge2area = {
		["1_4"] = arg0_30.bottom,
		["1_5"] = arg0_30.bottom,
		["4_5"] = arg0_30.bottom,
		["3_5"] = arg0_30.middle
	}
	arg0_30.graphPath.points[5].isBan = true
end

function var0_0.updateStudents(arg0_31)
	local var0_31 = arg0_31:getStudents()

	for iter0_31, iter1_31 in pairs(var0_31) do
		if not arg0_31.academyStudents[iter0_31] then
			local var1_31 = cloneTplTo(arg0_31._shipTpl, arg0_31._map)

			var1_31.gameObject.name = iter0_31

			local var2_31 = SummerFeastNavigationAgent.New(var1_31.gameObject)

			var2_31:attach()
			var2_31:setPathFinder(arg0_31.graphPath)
			var2_31:SetOnTransEdge(function(arg0_32, arg1_32, arg2_32)
				arg1_32, arg2_32 = math.min(arg1_32, arg2_32), math.max(arg1_32, arg2_32)

				local var0_32 = arg0_31.edge2area[arg1_32 .. "_" .. arg2_32] or arg0_31.front

				arg0_32._tf:SetParent(var0_32)
			end)
			var2_31:updateStudent(iter1_31)

			arg0_31.academyStudents[iter0_31] = var2_31
		end
	end

	if #var0_31 > 0 then
		arg0_31.sortTimer = Timer.New(function()
			arg0_31:sortStudents()
		end, 0.2, -1)

		arg0_31.sortTimer:Start()
		arg0_31.sortTimer.func()
	end
end

function var0_0.sortStudents(arg0_34)
	local var0_34 = {
		arg0_34.front,
		arg0_34.middle,
		arg0_34.bottom
	}

	for iter0_34, iter1_34 in pairs(var0_34) do
		if iter1_34.childCount > 1 then
			local var1_34 = {}

			for iter2_34 = 1, iter1_34.childCount do
				local var2_34 = iter1_34:GetChild(iter2_34 - 1)

				table.insert(var1_34, {
					tf = var2_34,
					index = iter2_34
				})
			end

			table.sort(var1_34, function(arg0_35, arg1_35)
				local var0_35 = arg0_35.tf.anchoredPosition.y - arg1_35.tf.anchoredPosition.y

				if math.abs(var0_35) < 1 then
					return arg0_35.index < arg1_35.index
				else
					return var0_35 > 0
				end
			end)

			for iter3_34, iter4_34 in ipairs(var1_34) do
				iter4_34.tf:SetSiblingIndex(iter3_34 - 1)
			end
		end
	end
end

function var0_0.clearStudents(arg0_36)
	if arg0_36.sortTimer then
		arg0_36.sortTimer:Stop()

		arg0_36.sortTimer = nil
	end

	for iter0_36, iter1_36 in pairs(arg0_36.academyStudents) do
		iter1_36:detach()
		Destroy(iter1_36._go)
	end

	arg0_36.academyStudents = {}
end

function var0_0.TryPlayStory(arg0_37)
	local var0_37 = "TIANHOUYUYI2"

	if var0_37 then
		pg.NewStoryMgr.GetInstance():Play(var0_37)
	end
end

function var0_0.willExit(arg0_38)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.top, arg0_38._tf)
	arg0_38:clearStudents()
	arg0_38:ClearEffectFirework()
end

return var0_0
