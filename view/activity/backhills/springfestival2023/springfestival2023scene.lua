local var0 = class("SpringFestival2023Scene", import("..TemplateMV.BackHillTemplate"))

var0.Id2EffectName = {
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
var0.FireworkRange = Vector2(300, 300)
var0.EffectPosLimit = {
	limitX = {
		-700,
		700
	},
	limitY = {
		250,
		500
	}
}
var0.EffectInterval = 1
var0.DelayPop = 2.5
var0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0.getUIName(arg0)
	return "SpringFestival2023UI"
end

var0.edge2area = {
	default = "map_middle"
}

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._shipTpl = arg0._map:Find("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.tipTfs = _.map(_.range(arg0._upper.childCount), function(arg0)
		local var0 = arg0._upper:GetChild(arg0 - 1)

		return {
			name = var0.name,
			trans = var0:Find("tip")
		}
	end)
	arg0.fireworksTF = arg0:findTF("play_fireworks")
	arg0.containers = {
		arg0.map_front,
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2023Graph"))
	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	if arg0.contextData.openFireworkLayer then
		arg0.contextData.openFireworkLayer = nil

		arg0:OpenFireworkLayer()
	end

	onButton(arg0, arg0:findTF("top/return_btn"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0:findTF("top/return_main_btn"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2023.tip
		})
	end)
	onButton(arg0, arg0:findTF("top/firework_btn"), function()
		arg0:OpenFireworkLayer()
	end)
	onButton(arg0, arg0.fireworksTF, function()
		arg0:StopPlayFireworks()
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRING_FESTIVAL_2023)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 48)
	end)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_ID)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "yanhua", function()
		arg0:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1 and var1.id
		})
	end)

	local var2 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_COUPLET)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "duilian", function()
		arg0:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var2 and var2.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiulou", function()
		arg0:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0:PlayBGM()
			end
		}))
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huituriji", function()
		arg0:emit(SpringFestival2023Mediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huazhongshijie", function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var1 = var0:getConfig("config_client").linkActID

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = var1
		})
	end)
	arg0:UpdateView()
	arg0:AutoFitScreen()
end

function var0.OpenFireworkLayer(arg0)
	arg0:emit(SpringFestival2023Mediator.GO_SUBLAYER, Context.New({
		mediator = FireworkPanelMediator,
		viewComponent = FireworkPanelLayer
	}))
end

function var0.PlayFireworks(arg0, arg1)
	if not arg1 or #arg1 == 0 then
		return
	end

	setActive(arg0._upper, false)
	setActive(arg0.top, false)
	eachChild(arg0.fireworksTF, function(arg0)
		setActive(arg0, false)
	end)
	setActive(arg0.fireworksTF, true)
	arg0:StopFireworksTimer()

	arg0.fireworks = arg1
	arg0.index = 1

	arg0:PlayerOneFirework()

	if #arg1 > 1 then
		arg0.fireworksTimer = Timer.New(function()
			arg0:PlayerOneFirework()
		end, var0.EffectInterval, #arg1 - 1)

		arg0.fireworksTimer:Start()
	end
end

function var0.PlayerOneFirework(arg0)
	if arg0.index == #arg0.fireworks then
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:StopPlayFireworks()
		end, var0.DelayPop, nil)
	end

	local var0 = arg0.fireworks[arg0.index]
	local var1 = arg0.fireworksTF:Find(tostring(var0))
	local var2 = math.random(#var0.SFX_LIST)

	if var1 then
		setLocalPosition(var1, arg0:GetFireworkPos())
		setActive(var1, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var2])
	else
		arg0.loader:GetPrefab("ui/" .. var0.Id2EffectName[var0], "", function(arg0)
			pg.ViewUtils.SetSortingOrder(arg0, 1)

			arg0.name = var0

			setParent(arg0, arg0.fireworksTF)
			setLocalPosition(arg0, arg0:GetFireworkPos())
			setActive(arg0, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var2])
		end)
	end

	arg0.index = arg0.index + 1
end

function var0.GetFireworkPos(arg0)
	local var0 = Vector2(0, 0)

	if arg0.lastPos then
		local var1 = Vector2(arg0.lastPos.x, arg0.lastPos.y)
		local var2 = math.abs(var1.x - arg0.lastPos.x)
		local var3 = math.abs(var1.y - arg0.lastPos.y)

		while var2 < var0.FireworkRange.x / 2 and var3 < var0.FireworkRange.y or var3 < var0.FireworkRange.y / 2 and var2 < var0.FireworkRange.x do
			var1.x = math.random(var0.EffectPosLimit.limitX[1], var0.EffectPosLimit.limitX[2])
			var1.y = math.random(var0.EffectPosLimit.limitY[1], var0.EffectPosLimit.limitY[2])
			var2 = math.abs(var1.x - arg0.lastPos.x)
			var3 = math.abs(var1.y - arg0.lastPos.y)
		end

		var0 = var1
	else
		var0.x = math.random(var0.EffectPosLimit.limitX[1], var0.EffectPosLimit.limitX[2])
		var0.y = math.random(var0.EffectPosLimit.limitY[1], var0.EffectPosLimit.limitY[2])
	end

	arg0.lastPos = var0

	return var0
end

function var0.StopFireworksTimer(arg0)
	if arg0.fireworksTimer then
		arg0.fireworksTimer:Stop()

		arg0.fireworksTimer = nil
	end
end

function var0.StopPlayFireworks(arg0)
	arg0:StopFireworksTimer()

	arg0.fireworks = nil
	arg0.index = nil

	setActive(arg0._upper, true)
	setActive(arg0.top, true)
	setActive(arg0.fireworksTF, false)
	arg0:OpenFireworkLayer()
end

function var0.UpdateView(arg0)
	_.each(arg0.tipTfs, function(arg0)
		if arg0.trans then
			setActive(arg0.trans, tobool(var0.CheckTip(arg0.name)))
		end
	end)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	arg0:StopFireworksTimer()
	arg0:cleanManagedTween()
	arg0.loader:Clear()
end

function var0.CheckTip(arg0)
	local var0 = getProxy(ActivityProxy)

	return switch(arg0, {
		xiaoyouxi = function()
			return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_SPRING_FESTIVAL_2023)
		end,
		huituriji = function()
			return getProxy(ColoringProxy):CheckTodayTip()
		end,
		huazhongshijie = function()
			local var0 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			return Activity.IsActivityReady(var0)
		end,
		jiulou = function()
			return RedPacketLayer.isShowRedPoint()
		end,
		yanhua = function()
			local var0 = var0:getActivityById(ActivityConst.FIREWORK_PT_ID)

			return Activity.IsActivityReady(var0)
		end,
		duilian = function()
			local var0 = var0:getActivityById(ActivityConst.ACTIVITY_COUPLET)

			return Activity.IsActivityReady(var0)
		end
	}, function()
		return false
	end)
end

function var0.IsShowMainTip(arg0)
	local var0 = {
		"xiaoyouxi",
		"huituriji",
		"huazhongshijie",
		"jiulou",
		"yanhua",
		"duilian"
	}

	return _.any(var0, function(arg0)
		return tobool(var0.CheckTip(arg0))
	end)
end

return var0
