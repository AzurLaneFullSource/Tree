local var0 = class("SpringFestival2024Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "SpringFestival2024TWUI"
	else
		return "SpringFestival2024UI"
	end
end

var0.edge2area = {
	default = "_SDPlace"
}
var0.EffectPoolCnt = 3
var0.Id2EffectName = {
	[70177] = "yanhua_hongbao",
	[70176] = "yanhua_Azurlane",
	[70175] = "yanhua_2024",
	[70174] = "yanhua_xiaojiajia",
	[70173] = "yanhua_xinxin",
	[70172] = "yanhua_jiezhi",
	[70171] = "yanhua_huangji",
	[70170] = "yanhua_chuanmao",
	[70169] = "yanhua_long",
	[70168] = "yanhua_mofang",
	[70167] = "yanhua_maomao",
	[70166] = "yanhua_02",
	[70165] = "yanhua_01",
	[70178] = "yanhua_denglong"
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

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

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
			trans = var0:Find("Tip")
		}
	end)
	arg0._SDPlace = arg0._tf:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2024Graph"))
	arg0.fireworksTF = arg0:findTF("play_fireworks")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2024.tip
		})
	end)
	onButton(arg0, arg0:findTF("top/firework_btn"), function()
		arg0:OpenFireworkLayer()
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRING_FESTIVAL_2024)

	arg0:InitStudents(var0 and var0.id, 4, 4)

	if PLATFORM_CODE == PLATFORM_CHT then
		arg0:InitFacilityCross(arg0._map, arg0._upper, "feicaiyingxinchuntw", function()
			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FIREWORK_PT_2024_ID
			})
		end)
		arg0:InitFacilityCross(arg0._map, arg0._upper, "aomeiyingchun", function()
			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.ACTIVITY_COUPLET
			})
		end)
		arg0:InitFacilityCross(arg0._map, arg0._upper, "huazhongshijie", function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_HUAZHONGSHIJIE)

			if not var0 or var0:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var1 = var0:getConfig("config_client").linkActID

			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = var1
			})
		end)
	else
		arg0:InitFacilityCross(arg0._map, arg0._upper, "feicaiyingxinchun", function()
			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FIREWORK_PT_2024_ID
			})
		end)
		arg0:InitFacilityCross(arg0._map, arg0._upper, "meiyiyannian", function()
			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.TAIYUAN_ALERT_TASK
			})
		end)
		arg0:InitFacilityCross(arg0._map, arg0._upper, "xinchunmaoxianwang", function()
			arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FEIYUEN_LOGIN
			})
		end)
	end

	arg0:InitFacilityCross(arg0._map, arg0._upper, "fushundamaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 37)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiudajiulou", function()
		arg0:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0:PlayBGM()
			end
		}))
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huituriji", function()
		arg0:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0:UpdateView()

	arg0.firePools = {}

	if arg0.contextData.openFireworkLayer then
		arg0.contextData.openFireworkLayer = nil

		arg0:OpenFireworkLayer()
	else
		arg0:PlayFireworks()
	end

	if arg0.contextData.isOpenRedPacket then
		arg0.contextData.isOpenRedPacket = nil

		arg0:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0:PlayBGM()
			end
		}))
	end
end

function var0.UpdateActivity(arg0, arg1)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	_.each(arg0.tipTfs, function(arg0)
		if arg0.trans then
			setActive(arg0.trans, tobool(var0.CheckTip(arg0.name)))
		end
	end)
end

function var0.OpenFireworkLayer(arg0)
	arg0:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
		mediator = FireworkPanel2024Mediator,
		viewComponent = FireworkPanel2024Layer,
		data = {
			onExit = function()
				arg0:PlayFireworks()
			end
		}
	}))
end

function var0.PlayFireworks(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

	assert(var0 and not var0:isEnd(), "烟花活动(type92)已结束")

	local var1 = getProxy(PlayerProxy):getData().id
	local var2 = pg.activity_template[var0.id].config_data[3]

	arg0.fireworks = {}

	for iter0 = 1, #var2 do
		local var3 = PlayerPrefs.GetInt("fireworks_" .. var0.id .. "_" .. var1 .. "_pos_" .. iter0)

		if var3 ~= 0 then
			table.insert(arg0.fireworks, var3)
		end
	end

	if #arg0.fireworks == 0 then
		return
	end

	eachChild(arg0.fireworksTF, function(arg0)
		setActive(arg0, false)
	end)
	setActive(arg0.fireworksTF, true)
	arg0:StopFireworksTimer()

	arg0.index = 1
	arg0.fireworksTimer = Timer.New(function()
		arg0:PlayerOneFirework()
	end, var0.EffectInterval, #arg0.fireworks)

	arg0.fireworksTimer:Start()
end

function var0.PlayerOneFirework(arg0)
	if arg0.index == #arg0.fireworks then
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:StopPlayFireworks()
			arg0:PlayFireworks()
		end, var0.DelayPop, nil)
	end

	local var0 = arg0.fireworks[arg0.index]
	local var1 = math.random(#var0.SFX_LIST)

	if arg0.firePools[var0] and #arg0.firePools[var0] >= var0.EffectPoolCnt then
		local var2 = arg0.firePools[var0][var0.EffectPoolCnt]

		setLocalPosition(var2, arg0:GetFireworkPos())
		setActive(var2, false)
		setActive(var2, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var1])
		table.removebyvalue(arg0.firePools[var0], var2)
		table.insert(arg0.firePools[var0], var2)
	else
		arg0.loader:GetPrefab("ui/" .. var0.Id2EffectName[var0], "", function(arg0)
			pg.ViewUtils.SetSortingOrder(arg0, 1)
			setParent(arg0, arg0.fireworksTF)
			setLocalPosition(arg0, arg0:GetFireworkPos())
			setActive(arg0, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var1])

			if not arg0.firePools[var0] then
				arg0.firePools[var0] = {}
			end

			table.insert(arg0.firePools[var0], arg0)
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

	setActive(arg0.fireworksTF, false)
end

function var0.willExit(arg0)
	arg0:StopPlayFireworks()
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.CheckTip(arg0)
	return switch(arg0, {
		fushundamaoxian = function()
			return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_SPRING_FESTIVAL_2024)
		end,
		huituriji = function()
			return getProxy(ColoringProxy):CheckTodayTip()
		end,
		jiujiudajiulou = function()
			return RedPacketLayer.isShowRedPoint()
		end,
		xinchunmaoxianwang = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEIYUEN_LOGIN)

			return Activity.IsActivityReady(var0)
		end,
		meiyiyannian = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.TAIYUAN_ALERT_TASK)

			return Activity.IsActivityReady(var0)
		end,
		feicaiyingxinchun = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_2024_ID)

			return Activity.IsActivityReady(var0)
		end,
		feicaiyingxinchuntw = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_2024_ID)

			return Activity.IsActivityReady(var0)
		end,
		aomeiyingchun = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_COUPLET)

			return Activity.IsActivityReady(var0)
		end,
		huazhongshijie = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_HUAZHONGSHIJIE)

			return Activity.IsActivityReady(var0)
		end
	}, function()
		return false
	end)
end

function var0.IsShowMainTip(arg0)
	local var0 = {
		"fushundamaoxian",
		"huituriji",
		"jiujiudajiulou",
		"xinchunmaoxianwang",
		"meiyiyannian",
		"feicaiyingxinchun"
	}

	if PLATFORM_CODE == PLATFORM_CHT then
		var0 = {
			"fushundamaoxian",
			"huituriji",
			"jiujiudajiulou",
			"aomeiyingchun",
			"huazhongshijie",
			"feicaiyingxinchuntw"
		}
	end

	return _.any(var0, function(arg0)
		return tobool(var0.CheckTip(arg0))
	end)
end

return var0
