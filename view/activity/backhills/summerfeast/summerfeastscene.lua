local var0 = class("SummerFeastScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SummerFeastUI"
end

var0.HUB_ID = 1
var0.Elements = {
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

function var0.GetTheDay()
	local var0 = os.time({
		year = 2019,
		month = 8,
		hour = 0,
		min = 0,
		sec = 0,
		day = 29,
		isdst = false
	})

	return os.date("*t", var0).yday
end

function var0.TransformColor(arg0)
	local var0 = tonumber(string.sub(arg0, 1, 2), 16)
	local var1 = tonumber(string.sub(arg0, 3, 4), 16)
	local var2 = tonumber(string.sub(arg0, 5, 6), 16)
	local var3 = 255

	if string.len(arg0) > 6 and string.len(arg0) <= 8 then
		var3 = tonumber(string.sub(arg0, 7, 8), 16)
	end

	return Color.New(var0 / 255, var1 / 255, var2 / 255, var3 / 255)
end

function var0.GenerateRandomFanPosition(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = {}

	for iter0 = 1, arg6 do
		table.insert(var0, math.lerp(arg4, arg5, math.random(1, 100) / 100))
	end

	local var1 = arg3 / (arg6 - 1)
	local var2 = math.sin(var1)
	local var3 = math.cos(var1)
	local var4 = Vector2.Normalize(arg2 - arg1)
	local var5 = {}
	local var6 = var4.x
	local var7 = var4.y

	table.insert(var5, Vector2.New(arg1.x + var0[1] * var6, arg1.y + var0[1] * var7))

	for iter1 = 2, arg6 do
		local var8 = var6 * var3 + var7 * var2
		local var9 = var7 * var3 - var6 * var2

		var6, var7 = var8, var9

		table.insert(var5, Vector2.New(arg1.x + var0[iter1] * var6, arg1.y + var0[iter1] * var7))
	end

	return var5
end

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._closeBtn = arg0:findTF("top/back")
	arg0._homeBtn = arg0:findTF("top/home")
	arg0._helpBtn = arg0:findTF("top/help")
	arg0.ticketTimes = arg0.top:Find("ticket/text")
	arg0.yinhuace = arg0.top:Find("yinhuace")
	arg0.yinhuaceTimes = arg0.yinhuace:Find("get")
	arg0.yinhuaceTips = arg0.yinhuace:Find("tip")
	arg0.shouce = arg0.top:Find("yinhuashouceye")
	arg0.shouce_bg = arg0.shouce:Find("bg")
	arg0.layout_shouce = arg0.shouce:Find("yinhuace/go/layout")
	arg0.group_get = CustomIndexLayer.Clone2Full(arg0.layout_shouce, 14)
	arg0.btn_receive = arg0.shouce:Find("yinhuace/receive")
	arg0.btn_shouce_help = arg0.shouce:Find("yinhuace/help")
	arg0.img_get = arg0.shouce:Find("yinhuace/get")

	setActive(arg0.shouce, false)

	arg0.sakura = arg0:findTF("effect")
	arg0._map = arg0:findTF("scrollRect/map")
	arg0.wave = arg0._map:Find("effect_wave")
	arg0.shrine = arg0._map:Find("shrine")
	arg0.snack_street = arg0._map:Find("snack_street")
	arg0.entertainment_street = arg0._map:Find("entertainment_street")
	arg0.firework_factory = arg0._map:Find("firework_factory")
	arg0.btn_fire = arg0.firework_factory:Find("fire")
	arg0.bottom = arg0._map:Find("bottom")
	arg0.middle = arg0._map:Find("middle")
	arg0.front = arg0._map:Find("front")
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SummerFeastGraph"))

	pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", true, function(arg0)
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/firework", "", arg0)
	end)

	arg0.workingEffect = {}
end

function var0.didEnter(arg0)
	local var0 = getProxy(MiniGameProxy)

	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0._homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_feast.tip
		})
	end)
	onButton(arg0, arg0.yinhuace, function()
		setActive(arg0.shouce, true)
	end)
	onButton(arg0, arg0.shouce_bg, function()
		setActive(arg0.shouce, false)
	end)
	onButton(arg0, arg0.btn_shouce_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_stamp.tip
		})
	end)
	onButton(arg0, arg0.btn_receive, function()
		local var0 = var0:GetHubByHubId(arg0.HUB_ID)

		if var0.ultimate ~= 0 or var0.usedtime < var0:getConfig("reward_need") then
			return
		end

		arg0:emit(SummerFeastMediator.MINI_GAME_OPERATOR, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)
	arg0:InitFacility(arg0.shrine, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end)
	arg0:InitFacility(arg0.snack_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 2)
	end)
	arg0:InitFacility(arg0.entertainment_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 5)
	end)
	arg0:InitFacility(arg0.firework_factory, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 4)
	end)
	onButton(arg0, arg0.btn_fire, function()
		local var0 = var0:GetMiniGameData(4):GetRuntimeData("elements")

		if not var0 or not (#var0 >= 4) or var0[4] ~= arg0.GetCurrentDay() then
			return
		end

		arg0:PlayFirework(var0)
		setActive(arg0.btn_fire, false)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top)

	arg0.academyStudents = {}

	arg0:InitAreaTransFunc()
	arg0:updateStudents()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(MiniGameProxy)
	local var1 = var0:GetHubByHubId(arg0.HUB_ID)
	local var2 = var1.usedtime

	setText(arg0.ticketTimes, var1.count)
	setText(arg0.yinhuaceTimes, var2)

	for iter0, iter1 in ipairs(arg0.group_get) do
		setActive(iter1, iter0 <= var2)
	end

	local var3 = var2 >= #arg0.group_get and var1.ultimate == 0

	setActive(arg0.btn_receive, var3)
	setActive(arg0.yinhuaceTips, var3)
	setActive(arg0.img_get, var1.ultimate ~= 0)

	if var1.ultimate == 1 then
		arg0:TryPlayStory()
	end

	local var4 = var0:GetMiniGameData(4):GetRuntimeData("elements")
	local var5 = var4 and #var4 >= 4 and var4[4] == arg0.GetCurrentDay()

	setActive(arg0.btn_fire, var5)
end

function var0.InitFacility(arg0, arg1, arg2)
	onButton(arg0, arg1, arg2)
	onButton(arg0, arg1:Find("button"), arg2)
end

function var0.PlayFirework(arg0, arg1)
	if #arg0.workingEffect > 0 then
		return
	end

	arg1 = arg1 or {
		0,
		0,
		0
	}

	local var0 = {
		Vector2(215, 150)
	}
	local var1 = UnityEngine.ParticleSystem.MinMaxGradient.New

	for iter0, iter1 in pairs(var0) do
		pg.PoolMgr.GetInstance():GetPrefab("ui/firework", "", false, function(arg0)
			local var0 = var0.Elements

			tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var1(arg0.TransformColor(var0[arg1[1]].color))
			tf(arg0):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var1(arg0.TransformColor(var0[arg1[2]].color))
			tf(arg0):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var1(arg0.TransformColor(var0[arg1[3]].color))

			table.insert(arg0.workingEffect, arg0)
			setParent(arg0, arg0._map)

			arg0.transform.localPosition = iter1
		end)
	end

	arg0:PlaySE()
end

function var0.ClearEffectFirework(arg0)
	arg0:StopSE()

	local var0 = pg.PoolMgr.GetInstance()

	for iter0, iter1 in pairs(arg0.workingEffect) do
		var0:ReturnPrefab("ui/firework", "", iter1)
	end

	var0:DestroyPrefab("ui/firework", "")

	arg0.workingEffect = {}
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

function var0.getStudents(arg0)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.SUMMER_FEAST_ID)

	if not var1 then
		return var0
	end

	local var2 = var1:getConfig("config_client")

	var2 = var2 and var2.ships

	if var2 then
		local var3 = Clone(var2)
		local var4 = 0
		local var5 = #var3

		while var4 < 15 and var5 > 0 do
			local var6 = math.random(1, var5)

			table.insert(var0, var3[var6])

			var3[var6] = var3[var5]
			var5 = var5 - 1
			var4 = var4 + math.random(3, 5)
		end
	end

	return var0
end

function var0.InitAreaTransFunc(arg0)
	arg0.edge2area = {
		["1_4"] = arg0.bottom,
		["1_5"] = arg0.bottom,
		["4_5"] = arg0.bottom,
		["3_5"] = arg0.middle
	}
	arg0.graphPath.points[5].isBan = true
end

function var0.updateStudents(arg0)
	local var0 = arg0:getStudents()

	for iter0, iter1 in pairs(var0) do
		if not arg0.academyStudents[iter0] then
			local var1 = cloneTplTo(arg0._shipTpl, arg0._map)

			var1.gameObject.name = iter0

			local var2 = SummerFeastNavigationAgent.New(var1.gameObject)

			var2:attach()
			var2:setPathFinder(arg0.graphPath)
			var2:SetOnTransEdge(function(arg0, arg1, arg2)
				arg1, arg2 = math.min(arg1, arg2), math.max(arg1, arg2)

				local var0 = arg0.edge2area[arg1 .. "_" .. arg2] or arg0.front

				arg0._tf:SetParent(var0)
			end)
			var2:updateStudent(iter1)

			arg0.academyStudents[iter0] = var2
		end
	end

	if #var0 > 0 then
		arg0.sortTimer = Timer.New(function()
			arg0:sortStudents()
		end, 0.2, -1)

		arg0.sortTimer:Start()
		arg0.sortTimer.func()
	end
end

function var0.sortStudents(arg0)
	local var0 = {
		arg0.front,
		arg0.middle,
		arg0.bottom
	}

	for iter0, iter1 in pairs(var0) do
		if iter1.childCount > 1 then
			local var1 = {}

			for iter2 = 1, iter1.childCount do
				local var2 = iter1:GetChild(iter2 - 1)

				table.insert(var1, {
					tf = var2,
					index = iter2
				})
			end

			table.sort(var1, function(arg0, arg1)
				local var0 = arg0.tf.anchoredPosition.y - arg1.tf.anchoredPosition.y

				if math.abs(var0) < 1 then
					return arg0.index < arg1.index
				else
					return var0 > 0
				end
			end)

			for iter3, iter4 in ipairs(var1) do
				iter4.tf:SetSiblingIndex(iter3 - 1)
			end
		end
	end
end

function var0.clearStudents(arg0)
	if arg0.sortTimer then
		arg0.sortTimer:Stop()

		arg0.sortTimer = nil
	end

	for iter0, iter1 in pairs(arg0.academyStudents) do
		iter1:detach()
		Destroy(iter1._go)
	end

	arg0.academyStudents = {}
end

function var0.TryPlayStory(arg0)
	local var0 = "TIANHOUYUYI2"

	if var0 then
		pg.NewStoryMgr.GetInstance():Play(var0)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	arg0:clearStudents()
	arg0:ClearEffectFirework()
end

return var0
