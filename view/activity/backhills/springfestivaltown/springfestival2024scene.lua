local var0_0 = class("SpringFestival2024Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "SpringFestival2024TWUI"
	else
		return "SpringFestival2024UI"
	end
end

var0_0.edge2area = {
	default = "_SDPlace"
}
var0_0.EffectPoolCnt = 3
var0_0.Id2EffectName = {
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

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

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
			trans = var0_3:Find("Tip")
		}
	end)
	arg0_2._SDPlace = arg0_2._tf:Find("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2024Graph"))
	arg0_2.fireworksTF = arg0_2:findTF("play_fireworks")
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("top/Back"), function()
		arg0_4:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_4, arg0_4:findTF("top/Home"), function()
		arg0_4:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_4, arg0_4:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2024.tip
		})
	end)
	onButton(arg0_4, arg0_4:findTF("top/firework_btn"), function()
		arg0_4:OpenFireworkLayer()
	end)
	arg0_4:BindItemSkinShop()
	arg0_4:BindItemBuildShip()

	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRING_FESTIVAL_2024)

	arg0_4:InitStudents(var0_4 and var0_4.id, 4, 4)

	if PLATFORM_CODE == PLATFORM_CHT then
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "feicaiyingxinchuntw", function()
			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FIREWORK_PT_2024_ID
			})
		end)
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "aomeiyingchun", function()
			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.ACTIVITY_COUPLET
			})
		end)
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "huazhongshijie", function()
			local var0_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_HUAZHONGSHIJIE)

			if not var0_11 or var0_11:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var1_11 = var0_11:getConfig("config_client").linkActID

			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = var1_11
			})
		end)
	else
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "feicaiyingxinchun", function()
			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FIREWORK_PT_2024_ID
			})
		end)
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "meiyiyannian", function()
			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.TAIYUAN_ALERT_TASK
			})
		end)
		arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "xinchunmaoxianwang", function()
			arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.ACTIVITY, {
				id = ActivityConst.FEIYUEN_LOGIN
			})
		end)
	end

	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "fushundamaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 37)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "jiujiudajiulou", function()
		arg0_4:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0_4:PlayBGM()
			end
		}))
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "huituriji", function()
		arg0_4:emit(SpringFestival2024Mediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0_4:UpdateView()

	arg0_4.firePools = {}

	if arg0_4.contextData.openFireworkLayer then
		arg0_4.contextData.openFireworkLayer = nil

		arg0_4:OpenFireworkLayer()
	else
		arg0_4:PlayFireworks()
	end

	if arg0_4.contextData.isOpenRedPacket then
		arg0_4.contextData.isOpenRedPacket = nil

		arg0_4:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				arg0_4:PlayBGM()
			end
		}))
	end
end

function var0_0.UpdateActivity(arg0_20, arg1_20)
	arg0_20:UpdateView()
end

function var0_0.UpdateView(arg0_21)
	_.each(arg0_21.tipTfs, function(arg0_22)
		if arg0_22.trans then
			setActive(arg0_22.trans, tobool(var0_0.CheckTip(arg0_22.name)))
		end
	end)
end

function var0_0.OpenFireworkLayer(arg0_23)
	arg0_23:emit(SpringFestival2024Mediator.GO_SUBLAYER, Context.New({
		mediator = FireworkPanel2024Mediator,
		viewComponent = FireworkPanel2024Layer,
		data = {
			onExit = function()
				arg0_23:PlayFireworks()
			end
		}
	}))
end

function var0_0.PlayFireworks(arg0_25)
	local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

	assert(var0_25 and not var0_25:isEnd(), "烟花活动(type92)已结束")

	local var1_25 = getProxy(PlayerProxy):getData().id
	local var2_25 = pg.activity_template[var0_25.id].config_data[3]

	arg0_25.fireworks = {}

	for iter0_25 = 1, #var2_25 do
		local var3_25 = PlayerPrefs.GetInt("fireworks_" .. var0_25.id .. "_" .. var1_25 .. "_pos_" .. iter0_25)

		if var3_25 ~= 0 then
			table.insert(arg0_25.fireworks, var3_25)
		end
	end

	if #arg0_25.fireworks == 0 then
		return
	end

	eachChild(arg0_25.fireworksTF, function(arg0_26)
		setActive(arg0_26, false)
	end)
	setActive(arg0_25.fireworksTF, true)
	arg0_25:StopFireworksTimer()

	arg0_25.index = 1
	arg0_25.fireworksTimer = Timer.New(function()
		arg0_25:PlayerOneFirework()
	end, var0_0.EffectInterval, #arg0_25.fireworks)

	arg0_25.fireworksTimer:Start()
end

function var0_0.PlayerOneFirework(arg0_28)
	if arg0_28.index == #arg0_28.fireworks then
		arg0_28:managedTween(LeanTween.delayedCall, function()
			arg0_28:StopPlayFireworks()
			arg0_28:PlayFireworks()
		end, var0_0.DelayPop, nil)
	end

	local var0_28 = arg0_28.fireworks[arg0_28.index]
	local var1_28 = math.random(#var0_0.SFX_LIST)

	if arg0_28.firePools[var0_28] and #arg0_28.firePools[var0_28] >= var0_0.EffectPoolCnt then
		local var2_28 = arg0_28.firePools[var0_28][var0_0.EffectPoolCnt]

		setLocalPosition(var2_28, arg0_28:GetFireworkPos())
		setActive(var2_28, false)
		setActive(var2_28, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_28])
		table.removebyvalue(arg0_28.firePools[var0_28], var2_28)
		table.insert(arg0_28.firePools[var0_28], var2_28)
	else
		arg0_28.loader:GetPrefab("ui/" .. var0_0.Id2EffectName[var0_28], "", function(arg0_30)
			pg.ViewUtils.SetSortingOrder(arg0_30, 1)
			setParent(arg0_30, arg0_28.fireworksTF)
			setLocalPosition(arg0_30, arg0_28:GetFireworkPos())
			setActive(arg0_30, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_28])

			if not arg0_28.firePools[var0_28] then
				arg0_28.firePools[var0_28] = {}
			end

			table.insert(arg0_28.firePools[var0_28], arg0_30)
		end)
	end

	arg0_28.index = arg0_28.index + 1
end

function var0_0.GetFireworkPos(arg0_31)
	local var0_31 = Vector2(0, 0)

	if arg0_31.lastPos then
		local var1_31 = Vector2(arg0_31.lastPos.x, arg0_31.lastPos.y)
		local var2_31 = math.abs(var1_31.x - arg0_31.lastPos.x)
		local var3_31 = math.abs(var1_31.y - arg0_31.lastPos.y)

		while var2_31 < var0_0.FireworkRange.x / 2 and var3_31 < var0_0.FireworkRange.y or var3_31 < var0_0.FireworkRange.y / 2 and var2_31 < var0_0.FireworkRange.x do
			var1_31.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
			var1_31.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
			var2_31 = math.abs(var1_31.x - arg0_31.lastPos.x)
			var3_31 = math.abs(var1_31.y - arg0_31.lastPos.y)
		end

		var0_31 = var1_31
	else
		var0_31.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
		var0_31.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
	end

	arg0_31.lastPos = var0_31

	return var0_31
end

function var0_0.StopFireworksTimer(arg0_32)
	if arg0_32.fireworksTimer then
		arg0_32.fireworksTimer:Stop()

		arg0_32.fireworksTimer = nil
	end
end

function var0_0.StopPlayFireworks(arg0_33)
	arg0_33:StopFireworksTimer()

	arg0_33.fireworks = nil
	arg0_33.index = nil

	setActive(arg0_33.fireworksTF, false)
end

function var0_0.willExit(arg0_34)
	arg0_34:StopPlayFireworks()
	arg0_34:clearStudents()
	var0_0.super.willExit(arg0_34)
end

function var0_0.CheckTip(arg0_35)
	return switch(arg0_35, {
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
			local var0_39 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEIYUEN_LOGIN)

			return Activity.IsActivityReady(var0_39)
		end,
		meiyiyannian = function()
			local var0_40 = getProxy(ActivityProxy):getActivityById(ActivityConst.TAIYUAN_ALERT_TASK)

			return Activity.IsActivityReady(var0_40)
		end,
		feicaiyingxinchun = function()
			local var0_41 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_2024_ID)

			return Activity.IsActivityReady(var0_41)
		end,
		feicaiyingxinchuntw = function()
			local var0_42 = getProxy(ActivityProxy):getActivityById(ActivityConst.FIREWORK_PT_2024_ID)

			return Activity.IsActivityReady(var0_42)
		end,
		aomeiyingchun = function()
			local var0_43 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_COUPLET)

			return Activity.IsActivityReady(var0_43)
		end,
		huazhongshijie = function()
			local var0_44 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_HUAZHONGSHIJIE)

			return Activity.IsActivityReady(var0_44)
		end
	}, function()
		return false
	end)
end

function var0_0.IsShowMainTip(arg0_46)
	local var0_46 = {
		"fushundamaoxian",
		"huituriji",
		"jiujiudajiulou",
		"xinchunmaoxianwang",
		"meiyiyannian",
		"feicaiyingxinchun"
	}

	if PLATFORM_CODE == PLATFORM_CHT then
		var0_46 = {
			"fushundamaoxian",
			"huituriji",
			"jiujiudajiulou",
			"aomeiyingchun",
			"huazhongshijie",
			"feicaiyingxinchuntw"
		}
	end

	return _.any(var0_46, function(arg0_47)
		return tobool(var0_0.CheckTip(arg0_47))
	end)
end

return var0_0
