local var0_0 = class("SpringFestival2023Scene", import("..TemplateMV.BackHillTemplate"))

var0_0.Id2EffectName = {
	[70114] = "yanhua_xiaojiajia",
	[70113] = "yanhua_xinxin",
	[70112] = "yanhua_jiezhi",
	[70111] = "yanhua_huangji",
	[70110] = "yanhua_chuanmao",
	[70109] = "yanhua_tutu",
	[70108] = "yanhua_mofang",
	[70107] = "yanhua_maomao",
	[70106] = "yanhua_02",
	[70105] = "yanhua_01",
	[70118] = "yanhua_denglong",
	[70117] = "yanhua_hongbao",
	[70116] = "yanhua_Azurlane",
	[70115] = "yanhua_2023"
}
var0_0.FireworkRange = Vector2(300, 300)
var0_0.EffectPosLimit = {
	limitX = {
		-700,
		700
	},
	limitY = {
		250,
		500
	}
}
var0_0.EffectInterval = 1
var0_0.DelayPop = 2.5
var0_0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0_0.getUIName(arg0_1)
	return "SpringFestival2023UI"
end

var0_0.edge2area = {
	default = "map_middle"
}

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.tipTfs = _.map(_.range(arg0_2._upper.childCount), function(arg0_3)
		local var0_3 = arg0_2._upper:GetChild(arg0_3 - 1)

		return {
			name = var0_3.name,
			trans = var0_3:Find("tip")
		}
	end)
	arg0_2.fireworksTF = arg0_2:findTF("play_fireworks")
	arg0_2.containers = {
		arg0_2.map_front,
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2023Graph"))
	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_4)
	if arg0_4.contextData.openFireworkLayer then
		arg0_4.contextData.openFireworkLayer = nil

		arg0_4:OpenFireworkLayer()
	end

	onButton(arg0_4, arg0_4:findTF("top/return_btn"), function()
		arg0_4:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_4, arg0_4:findTF("top/return_main_btn"), function()
		arg0_4:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_4, arg0_4:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2023.tip
		})
	end)
	onButton(arg0_4, arg0_4:findTF("top/firework_btn"), function()
		arg0_4:OpenFireworkLayer()
	end)
	onButton(arg0_4, arg0_4.fireworksTF, function()
		arg0_4:StopPlayFireworks()
	end)
	arg0_4:BindItemSkinShop()
	arg0_4:BindItemBuildShip()

	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRING_FESTIVAL_2023)

	arg0_4:InitStudents(var0_4 and var0_4.id, 2, 3)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 48)
	end)

	local var1_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_ID)

	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "yanhua", function()
		arg0_4:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_4 and var1_4.id
		})
	end)

	local var2_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_COUPLET)

	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "duilian", function()
		arg0_4:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var2_4 and var2_4.id
		})
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "jiulou", function()
		arg0_4:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0_4:PlayBGM()
			end
		}))
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "huituriji", function()
		arg0_4:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "huazhongshijie", function()
		local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

		if not var0_16 or var0_16:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var1_16 = var0_16:getConfig("config_client").linkActID

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_16
		})
	end)
	arg0_4:UpdateView()
	arg0_4:AutoFitScreen()
end

function var0_0.OpenFireworkLayer(arg0_17)
	arg0_17:emit(SpringFestival2023Mediator.GO_SUBLAYER, Context.New({
		mediator = FireworkPanelMediator,
		viewComponent = FireworkPanelLayer
	}))
end

function var0_0.PlayFireworks(arg0_18, arg1_18)
	if not arg1_18 or #arg1_18 == 0 then
		return
	end

	setActive(arg0_18._upper, false)
	setActive(arg0_18.top, false)
	eachChild(arg0_18.fireworksTF, function(arg0_19)
		setActive(arg0_19, false)
	end)
	setActive(arg0_18.fireworksTF, true)
	arg0_18:StopFireworksTimer()

	arg0_18.fireworks = arg1_18
	arg0_18.index = 1

	arg0_18:PlayerOneFirework()

	if #arg1_18 > 1 then
		arg0_18.fireworksTimer = Timer.New(function()
			arg0_18:PlayerOneFirework()
		end, var0_0.EffectInterval, #arg1_18 - 1)

		arg0_18.fireworksTimer:Start()
	end
end

function var0_0.PlayerOneFirework(arg0_21)
	if arg0_21.index == #arg0_21.fireworks then
		arg0_21:managedTween(LeanTween.delayedCall, function()
			arg0_21:StopPlayFireworks()
		end, var0_0.DelayPop, nil)
	end

	local var0_21 = arg0_21.fireworks[arg0_21.index]
	local var1_21 = arg0_21.fireworksTF:Find(tostring(var0_21))
	local var2_21 = math.random(#var0_0.SFX_LIST)

	if var1_21 then
		setLocalPosition(var1_21, arg0_21:GetFireworkPos())
		setActive(var1_21, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var2_21])
	else
		arg0_21.loader:GetPrefab("ui/" .. var0_0.Id2EffectName[var0_21], "", function(arg0_23)
			pg.ViewUtils.SetSortingOrder(arg0_23, 1)

			arg0_23.name = var0_21

			setParent(arg0_23, arg0_21.fireworksTF)
			setLocalPosition(arg0_23, arg0_21:GetFireworkPos())
			setActive(arg0_23, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var2_21])
		end)
	end

	arg0_21.index = arg0_21.index + 1
end

function var0_0.GetFireworkPos(arg0_24)
	local var0_24 = Vector2(0, 0)

	if arg0_24.lastPos then
		local var1_24 = Vector2(arg0_24.lastPos.x, arg0_24.lastPos.y)
		local var2_24 = math.abs(var1_24.x - arg0_24.lastPos.x)
		local var3_24 = math.abs(var1_24.y - arg0_24.lastPos.y)

		while var2_24 < var0_0.FireworkRange.x / 2 and var3_24 < var0_0.FireworkRange.y or var3_24 < var0_0.FireworkRange.y / 2 and var2_24 < var0_0.FireworkRange.x do
			var1_24.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
			var1_24.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
			var2_24 = math.abs(var1_24.x - arg0_24.lastPos.x)
			var3_24 = math.abs(var1_24.y - arg0_24.lastPos.y)
		end

		var0_24 = var1_24
	else
		var0_24.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
		var0_24.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
	end

	arg0_24.lastPos = var0_24

	return var0_24
end

function var0_0.StopFireworksTimer(arg0_25)
	if arg0_25.fireworksTimer then
		arg0_25.fireworksTimer:Stop()

		arg0_25.fireworksTimer = nil
	end
end

function var0_0.StopPlayFireworks(arg0_26)
	arg0_26:StopFireworksTimer()

	arg0_26.fireworks = nil
	arg0_26.index = nil

	setActive(arg0_26._upper, true)
	setActive(arg0_26.top, true)
	setActive(arg0_26.fireworksTF, false)
	arg0_26:OpenFireworkLayer()
end

function var0_0.UpdateView(arg0_27)
	_.each(arg0_27.tipTfs, function(arg0_28)
		if arg0_28.trans then
			setActive(arg0_28.trans, tobool(var0_0.CheckTip(arg0_28.name)))
		end
	end)
end

function var0_0.willExit(arg0_29)
	arg0_29:clearStudents()
	arg0_29:StopFireworksTimer()
	arg0_29:cleanManagedTween()
	arg0_29.loader:Clear()
end

function var0_0.CheckTip(arg0_30)
	local var0_30 = getProxy(ActivityProxy)

	return switch(arg0_30, {
		xiaoyouxi = function()
			return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_SPRING_FESTIVAL_2023)
		end,
		huituriji = function()
			return getProxy(ColoringProxy):CheckTodayTip()
		end,
		huazhongshijie = function()
			local var0_33 = var0_30:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			return Activity.IsActivityReady(var0_33)
		end,
		jiulou = function()
			return RedPacketLayer.isShowRedPoint()
		end,
		yanhua = function()
			local var0_35 = var0_30:getActivityById(ActivityConst.FIREWORK_PT_ID)

			return Activity.IsActivityReady(var0_35)
		end,
		duilian = function()
			local var0_36 = var0_30:getActivityById(ActivityConst.ACTIVITY_COUPLET)

			return Activity.IsActivityReady(var0_36)
		end
	}, function()
		return false
	end)
end

function var0_0.IsShowMainTip(arg0_38)
	local var0_38 = {
		"xiaoyouxi",
		"huituriji",
		"huazhongshijie",
		"jiulou",
		"yanhua",
		"duilian"
	}

	return _.any(var0_38, function(arg0_39)
		return tobool(var0_0.CheckTip(arg0_39))
	end)
end

return var0_0
