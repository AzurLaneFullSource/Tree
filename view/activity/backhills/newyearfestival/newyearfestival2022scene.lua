local var0 = class("NewYearFestival2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "NewyearFestival2022UI"
end

var0.edge2area = {
	default = "_middle"
}
var0.Buildings = {
	[18] = "ironbloodmaid",
	[17] = "royalmaid"
}

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._middle = arg0:findTF("middle")
	arg0._shipTpl = arg0._map:Find("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.containers = {
		arg0.map_middle
	}
	arg0.usableTxt = arg0.top:Find("usable_count/text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("material/text"):GetComponent(typeof(Text))
	arg0.btnPlayFirework = arg0.top:Find("playFirework")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2022Graph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_feast.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btnPlayFirework, function()
		local var0 = getProxy(MiniGameProxy):GetMiniGameData(36):GetRuntimeData("elements")

		if not var0 or not (#var0 >= 4) or var0[4] ~= SummerFeastScene.GetCurrentDay() then
			return
		end

		arg0:PlayFirework(var0)
		setActive(arg0.btnPlayFirework, false)
	end)
	arg0:InitStudents(ActivityConst.MINIGAME_CURLING, 3, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "qiyuanwu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 34)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bingqiu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 33)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "yanhua", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 36)
	end)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0:InitFacilityCross(arg0._map, arg0._upper, iter1, function()
			arg0:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = BuildingUpgradeMediator,
				viewComponent = BuildingCafeUpgradeLayer,
				data = {
					buildingID = iter0
				}
			}))
		end)
	end

	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:RegisterDataResponse()
	arg0:UpdateView()
end

function var0.RegisterDataResponse(arg0)
	arg0.Respones = ResponsableTree.CreateShell({})

	arg0.Respones:SetRawData("view", arg0)

	local var0 = _.values(arg0.Buildings)

	for iter0, iter1 in ipairs(var0) do
		arg0.Respones:AddRawListener({
			"view",
			iter1
		}, function(arg0, arg1)
			if not arg1 then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/NewyearFestival2022UI_atlas", iter1 .. arg1, arg0["map_" .. iter1], true)

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("level")) then
				return
			end

			setText(var0:Find("level"), arg1)
		end)
	end

	local var1 = {
		"bingqiu",
		"qiyuanwu",
		"yanhua"
	}

	table.insertto(var1, var0)

	for iter2, iter3 in ipairs(var1) do
		arg0.Respones:AddRawListener({
			"view",
			iter3 .. "Tip"
		}, function(arg0, arg1)
			local var0 = arg0["upper_" .. iter3]

			if not var0 or IsNil(var0:Find("tip")) then
				return
			end

			setActive(var0:Find("tip"), arg1)
		end)
	end

	arg0.Respones:AddRawListener({
		"view",
		"shrineCount"
	}, function(arg0, arg1)
		arg0.usableTxt.text = arg1
	end)
	arg0.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0, arg1)
		arg0.materialTxt.text = arg1
	end)
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0.Respones[iter1] = var0.data1KeyValueList[2][iter0] or 1
		arg0.Respones[iter1 .. "Tip"] = arg0:UpdateBuildingTip(var0, iter0)
	end

	;(function()
		local var0 = var0.data1KeyValueList[2][17] or 1
		local var1 = var0.data1KeyValueList[2][18] or 1
		local var2 = pg.activity_event_building[17]
		local var3 = var2.material[1][1][2]
		local var4 = var0.data1KeyValueList[1][var3] or 0
		local var5 = #var2.buff

		arg0.Respones.royalmaidTip = var0 < var5 and var4 >= var2.material[var0][1][3] and var0 <= var1
		arg0.Respones.ironbloodmaidTip = var1 < var5 and var4 >= var2.material[var1][1][3] and var1 <= var0
	end)()

	local var1 = next(var0.data1KeyValueList[1])

	arg0.Respones.materialCount = var0.data1KeyValueList[1][var1] or 0

	local var2 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)
	local var3 = var2 and var2:GetRuntimeData("count") or 0

	arg0.Respones.shrineCount = var3
	arg0.Respones.bingqiuTip = var0.IsMiniActNeedTip(ActivityConst.MINIGAME_CURLING)
	arg0.Respones.yanhuaTip = var0.IsMiniActNeedTip(ActivityConst.MINIGAME_FIREWORK_2022)
	arg0.Respones.qiyuanwuTip = Shrine2022View.IsNeedShowTipWithoutActivityFinalReward()

	local var4 = getProxy(MiniGameProxy):GetMiniGameData(36):GetRuntimeData("elements")
	local var5 = var4 and #var4 >= 4 and var4[4] == SummerFeastScene.GetCurrentDay()

	setActive(arg0.btnPlayFirework, var5 and not tobool(arg0.loader:GetRequestPackage("Firework")))
	arg0:TryPlayStory()
end

function var0.TryPlayStory(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)
	local var1 = var0.data1KeyValueList[2][17] or 1
	local var2 = var0.data1KeyValueList[2][18] or 1
	local var3 = var0:getConfig("config_client").story
	local var4 = pg.NewStoryMgr.GetInstance()

	table.Foreach(var3, function(arg0, arg1)
		local var0 = false
		local var1 = math.floor((arg0 - 1) / 3) + 2

		if arg0 % 3 == 1 then
			var1 = var1 - 1
			var0 = var1 <= var1 and var1 <= var2
		elseif arg0 % 3 == 2 then
			var0 = var1 <= var2
		elseif arg0 % 3 == 0 then
			var0 = var1 <= var1
		end

		if var0 then
			var4:Play(arg1[1])
		end
	end)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	arg0:ClearEffectFirework()
	var0.super.willExit(arg0)
end

function var0.PlayFirework(arg0, arg1)
	arg1 = arg1 or {
		0,
		0,
		0
	}

	local var0 = UnityEngine.ParticleSystem.MinMaxGradient.New

	arg0.loader:GetPrefab("ui/firework", "", function(arg0)
		local var0 = SummerFeastScene.Elements

		tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[1]].color))
		tf(arg0):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[2]].color))
		tf(arg0):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[3]].color))

		setParent(arg0, arg0._map)

		arg0.transform.localPosition = Vector2(663, 50)
		arg0.transform.localScale = Vector3(0.7, 0.7, 0.7)

		pg.ViewUtils.SetSortingOrder(arg0, -1)
		arg0:PlaySE()
	end, "Firework")

	arg0.fireworkTimer = Timer.New(function()
		arg0.loader:GetPrefab("ui/firework", "", function(arg0)
			local var0 = SummerFeastScene.Elements

			tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[1]].color))
			tf(arg0):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[2]].color))
			tf(arg0):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[3]].color))

			setParent(arg0, arg0._map)

			arg0.transform.localPosition = Vector2(123, 110)
			arg0.transform.localScale = Vector3(1.2, 1.2, 1.2)
		end, "Firework2")
	end, 2)

	arg0.fireworkTimer:Start()

	arg0.fireworkTimer2 = Timer.New(function()
		arg0.loader:GetPrefab("ui/firework", "", function(arg0)
			local var0 = SummerFeastScene.Elements

			tf(arg0):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[1]].color))
			tf(arg0):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[2]].color))
			tf(arg0):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0(SummerFeastScene.TransformColor(var0[arg1[3]].color))

			setParent(arg0, arg0._map)

			arg0.transform.localPosition = Vector2(-465, -90)
		end, "Firework3")
	end, 3)

	arg0.fireworkTimer2:Start()
end

function var0.ClearEffectFirework(arg0)
	arg0:StopSE()
	arg0.loader:ClearRequest("Firework")
	arg0.loader:ClearRequest("Firework2")
	arg0.loader:ClearRequest("Firework3")

	if arg0.fireworkTimer then
		arg0.fireworkTimer:Stop()

		arg0.fireworkTimer = nil
	end

	if arg0.fireworkTimer2 then
		arg0.fireworkTimer2:Stop()

		arg0.fireworkTimer2 = nil
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

return var0
