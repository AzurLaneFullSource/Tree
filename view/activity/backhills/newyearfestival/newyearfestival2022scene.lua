local var0_0 = class("NewYearFestival2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewyearFestival2022UI"
end

var0_0.edge2area = {
	default = "_middle"
}
var0_0.Buildings = {
	[18] = "ironbloodmaid",
	[17] = "royalmaid"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._middle = arg0_2:findTF("middle")
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.containers = {
		arg0_2.map_middle
	}
	arg0_2.usableTxt = arg0_2.top:Find("usable_count/text"):GetComponent(typeof(Text))
	arg0_2.materialTxt = arg0_2.top:Find("material/text"):GetComponent(typeof(Text))
	arg0_2.btnPlayFirework = arg0_2.top:Find("playFirework")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2022Graph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_feast.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnPlayFirework, function()
		local var0_7 = getProxy(MiniGameProxy):GetMiniGameData(36):GetRuntimeData("elements")

		if not var0_7 or not (#var0_7 >= 4) or var0_7[4] ~= SummerFeastScene.GetCurrentDay() then
			return
		end

		arg0_3:PlayFirework(var0_7)
		setActive(arg0_3.btnPlayFirework, false)
	end)
	arg0_3:InitStudents(ActivityConst.MINIGAME_CURLING, 3, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "qiyuanwu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 34)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "bingqiu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 33)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "yanhua", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 36)
	end)

	for iter0_3, iter1_3 in pairs(arg0_3.Buildings) do
		arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, iter1_3, function()
			arg0_3:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = BuildingUpgradeMediator,
				viewComponent = BuildingCafeUpgradeLayer,
				data = {
					buildingID = iter0_3
				}
			}))
		end)
	end

	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:RegisterDataResponse()
	arg0_3:UpdateView()
end

function var0_0.RegisterDataResponse(arg0_12)
	arg0_12.Respones = ResponsableTree.CreateShell({})

	arg0_12.Respones:SetRawData("view", arg0_12)

	local var0_12 = _.values(arg0_12.Buildings)

	for iter0_12, iter1_12 in ipairs(var0_12) do
		arg0_12.Respones:AddRawListener({
			"view",
			iter1_12
		}, function(arg0_13, arg1_13)
			if not arg1_13 then
				return
			end

			arg0_13.loader:GetSpriteQuiet("ui/NewyearFestival2022UI_atlas", iter1_12 .. arg1_13, arg0_13["map_" .. iter1_12], true)

			local var0_13 = arg0_13["upper_" .. iter1_12]

			if not var0_13 or IsNil(var0_13:Find("level")) then
				return
			end

			setText(var0_13:Find("level"), arg1_13)
		end)
	end

	local var1_12 = {
		"bingqiu",
		"qiyuanwu",
		"yanhua"
	}

	table.insertto(var1_12, var0_12)

	for iter2_12, iter3_12 in ipairs(var1_12) do
		arg0_12.Respones:AddRawListener({
			"view",
			iter3_12 .. "Tip"
		}, function(arg0_14, arg1_14)
			local var0_14 = arg0_14["upper_" .. iter3_12]

			if not var0_14 or IsNil(var0_14:Find("tip")) then
				return
			end

			setActive(var0_14:Find("tip"), arg1_14)
		end)
	end

	arg0_12.Respones:AddRawListener({
		"view",
		"shrineCount"
	}, function(arg0_15, arg1_15)
		arg0_15.usableTxt.text = arg1_15
	end)
	arg0_12.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0_16, arg1_16)
		arg0_16.materialTxt.text = arg1_16
	end)
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	for iter0_17, iter1_17 in pairs(arg0_17.Buildings) do
		arg0_17.Respones[iter1_17] = var0_17.data1KeyValueList[2][iter0_17] or 1
		arg0_17.Respones[iter1_17 .. "Tip"] = arg0_17:UpdateBuildingTip(var0_17, iter0_17)
	end

	;(function()
		local var0_18 = var0_17.data1KeyValueList[2][17] or 1
		local var1_18 = var0_17.data1KeyValueList[2][18] or 1
		local var2_18 = pg.activity_event_building[17]
		local var3_18 = var2_18.material[1][1][2]
		local var4_18 = var0_17.data1KeyValueList[1][var3_18] or 0
		local var5_18 = #var2_18.buff

		arg0_17.Respones.royalmaidTip = var0_18 < var5_18 and var4_18 >= var2_18.material[var0_18][1][3] and var0_18 <= var1_18
		arg0_17.Respones.ironbloodmaidTip = var1_18 < var5_18 and var4_18 >= var2_18.material[var1_18][1][3] and var1_18 <= var0_18
	end)()

	local var1_17 = next(var0_17.data1KeyValueList[1])

	arg0_17.Respones.materialCount = var0_17.data1KeyValueList[1][var1_17] or 0

	local var2_17 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)
	local var3_17 = var2_17 and var2_17:GetRuntimeData("count") or 0

	arg0_17.Respones.shrineCount = var3_17
	arg0_17.Respones.bingqiuTip = var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_CURLING)
	arg0_17.Respones.yanhuaTip = var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_FIREWORK_2022)
	arg0_17.Respones.qiyuanwuTip = Shrine2022View.IsNeedShowTipWithoutActivityFinalReward()

	local var4_17 = getProxy(MiniGameProxy):GetMiniGameData(36):GetRuntimeData("elements")
	local var5_17 = var4_17 and #var4_17 >= 4 and var4_17[4] == SummerFeastScene.GetCurrentDay()

	setActive(arg0_17.btnPlayFirework, var5_17 and not tobool(arg0_17.loader:GetRequestPackage("Firework")))
	arg0_17:TryPlayStory()
end

function var0_0.TryPlayStory(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)
	local var1_19 = var0_19.data1KeyValueList[2][17] or 1
	local var2_19 = var0_19.data1KeyValueList[2][18] or 1
	local var3_19 = var0_19:getConfig("config_client").story
	local var4_19 = pg.NewStoryMgr.GetInstance()

	table.Foreach(var3_19, function(arg0_20, arg1_20)
		local var0_20 = false
		local var1_20 = math.floor((arg0_20 - 1) / 3) + 2

		if arg0_20 % 3 == 1 then
			var1_20 = var1_20 - 1
			var0_20 = var1_20 <= var1_19 and var1_20 <= var2_19
		elseif arg0_20 % 3 == 2 then
			var0_20 = var1_20 <= var2_19
		elseif arg0_20 % 3 == 0 then
			var0_20 = var1_20 <= var1_19
		end

		if var0_20 then
			var4_19:Play(arg1_20[1])
		end
	end)
end

function var0_0.willExit(arg0_21)
	arg0_21:clearStudents()
	arg0_21:ClearEffectFirework()
	var0_0.super.willExit(arg0_21)
end

function var0_0.PlayFirework(arg0_22, arg1_22)
	arg1_22 = arg1_22 or {
		0,
		0,
		0
	}

	local var0_22 = UnityEngine.ParticleSystem.MinMaxGradient.New

	arg0_22.loader:GetPrefab("ui/firework", "", function(arg0_23)
		local var0_23 = SummerFeastScene.Elements

		tf(arg0_23):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_23[arg1_22[1]].color))
		tf(arg0_23):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_23[arg1_22[2]].color))
		tf(arg0_23):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_23[arg1_22[3]].color))

		setParent(arg0_23, arg0_22._map)

		arg0_23.transform.localPosition = Vector2(663, 50)
		arg0_23.transform.localScale = Vector3(0.7, 0.7, 0.7)

		pg.ViewUtils.SetSortingOrder(arg0_23, -1)
		arg0_22:PlaySE()
	end, "Firework")

	arg0_22.fireworkTimer = Timer.New(function()
		arg0_22.loader:GetPrefab("ui/firework", "", function(arg0_25)
			local var0_25 = SummerFeastScene.Elements

			tf(arg0_25):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_25[arg1_22[1]].color))
			tf(arg0_25):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_25[arg1_22[2]].color))
			tf(arg0_25):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_25[arg1_22[3]].color))

			setParent(arg0_25, arg0_22._map)

			arg0_25.transform.localPosition = Vector2(123, 110)
			arg0_25.transform.localScale = Vector3(1.2, 1.2, 1.2)
		end, "Firework2")
	end, 2)

	arg0_22.fireworkTimer:Start()

	arg0_22.fireworkTimer2 = Timer.New(function()
		arg0_22.loader:GetPrefab("ui/firework", "", function(arg0_27)
			local var0_27 = SummerFeastScene.Elements

			tf(arg0_27):Find("Fire"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_27[arg1_22[1]].color))
			tf(arg0_27):Find("Fire/par_small"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_27[arg1_22[2]].color))
			tf(arg0_27):Find("Fire/par_small/par_big"):GetComponent("ParticleSystem").main.startColor = var0_22(SummerFeastScene.TransformColor(var0_27[arg1_22[3]].color))

			setParent(arg0_27, arg0_22._map)

			arg0_27.transform.localPosition = Vector2(-465, -90)
		end, "Firework3")
	end, 3)

	arg0_22.fireworkTimer2:Start()
end

function var0_0.ClearEffectFirework(arg0_28)
	arg0_28:StopSE()
	arg0_28.loader:ClearRequest("Firework")
	arg0_28.loader:ClearRequest("Firework2")
	arg0_28.loader:ClearRequest("Firework3")

	if arg0_28.fireworkTimer then
		arg0_28.fireworkTimer:Stop()

		arg0_28.fireworkTimer = nil
	end

	if arg0_28.fireworkTimer2 then
		arg0_28.fireworkTimer2:Stop()

		arg0_28.fireworkTimer2 = nil
	end
end

function var0_0.PlaySE(arg0_29)
	if arg0_29.SETimer then
		return
	end

	arg0_29.SECount = 10
	arg0_29.SETimer = Timer.New(function()
		arg0_29.SECount = arg0_29.SECount - 1

		if arg0_29.SECount <= 0 then
			arg0_29.SECount = math.random(5, 20)

			pg.CriMgr.GetInstance():PlaySE_V3("battle-firework")
		end
	end, 0.1, -1)

	arg0_29.SETimer:Start()
end

function var0_0.StopSE(arg0_31)
	if arg0_31.SETimer then
		pg.CriMgr.GetInstance():StopSEBattle_V3()
		arg0_31.SETimer:Stop()

		arg0_31.SETimer = nil
	end
end

return var0_0
