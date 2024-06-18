local var0_0 = class("USCastle2023Scene", import("..TemplateMV.BackHillTemplate"))

var0_0.EffectName = {
	"yanhua_01",
	"yanhua_02",
	"yanhua_maomao",
	"yanhua_mofang",
	"yanhua_chuanmao",
	"yanhua_huangji",
	"yanhua_xinxin",
	"yanhua_Azurlane"
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
var0_0.EffectInterval = 1.5
var0_0.EffectRecycleTime = 3
var0_0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0_0.getUIName(arg0_1)
	return "USCastle2023UI"
end

var0_0.edge2area = {
	default = "_SDPlace"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._bg = arg0_2:findTF("BG")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._upper = arg0_2:findTF("upper")
	arg0_2.upper_yanhuiyaoyue = nil
	arg0_2.upper_xintiaochengbao = nil

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2._SDPlace = arg0_2._tf:Find("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.USCastle2023Graph"))
	arg0_2.fireworksTF = arg0_2:findTF("play_fireworks")
	arg0_2.fireworksList = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8
	}
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.uscastle2023_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_XINTIAOCHENGBAO)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "yanhuiyaoyue", function()
		local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if var0_7 and not var0_7:isEnd() then
			arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.FEAST)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
		end
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xintiaochengbao", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shujvhuigu", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()
	arg0_3:PlayFireworks()
end

function var0_0.FeastTip()
	return getProxy(FeastProxy):ShouldTip()
end

function var0_0.XinTiaoChengBaoTip()
	return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_XINTIAOCHENGBAO)
end

function var0_0.UpdateView(arg0_12)
	setActive(arg0_12.upper_yanhuiyaoyue:Find("Tip"), var0_0.FeastTip())
	setActive(arg0_12.upper_xintiaochengbao:Find("Tip"), var0_0.XinTiaoChengBaoTip())
end

function var0_0.willExit(arg0_13)
	arg0_13:clearStudents()
	arg0_13:StopPlayFireworks()
	var0_0.super.willExit(arg0_13)
end

function var0_0.IsShowMainTip(arg0_14)
	if arg0_14 and not arg0_14:isEnd() then
		return var0_0.XinTiaoChengBaoTip() or var0_0.FeastTip()
	end
end

function var0_0.PlayFireworks(arg0_15)
	arg0_15:StopPlayFireworks()
	arg0_15:PlayerOneFirework()

	arg0_15.fireworksTimer = Timer.New(function()
		arg0_15:PlayerOneFirework()
	end, var0_0.EffectInterval, -1)

	arg0_15.fireworksTimer:Start()
end

function var0_0.PlayerOneFirework(arg0_17)
	local var0_17 = arg0_17.fireworksList[math.random(#arg0_17.fireworksList)]

	table.removebyvalue(arg0_17.fireworksList, var0_17)

	local var1_17 = var0_0.EffectName[var0_17]
	local var2_17 = arg0_17.fireworksTF:Find(var1_17)
	local var3_17 = math.random(#var0_0.SFX_LIST)

	if var2_17 then
		setLocalPosition(var2_17, arg0_17:GetFireworkPos())
		setActive(var2_17, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var3_17])
		Timer.New(function()
			if arg0_17.fireworksList then
				setActive(var2_17, false)
				table.insert(arg0_17.fireworksList, var0_17)
			end
		end, var0_0.EffectRecycleTime, 1):Start()
	else
		arg0_17.loader:GetPrefab("ui/" .. var1_17, "", function(arg0_19)
			pg.ViewUtils.SetSortingOrder(arg0_19, 1)

			arg0_19.name = var1_17

			setParent(arg0_19, arg0_17.fireworksTF)
			setLocalPosition(arg0_19, arg0_17:GetFireworkPos())
			setActive(arg0_19, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var3_17])
			Timer.New(function()
				if arg0_17.fireworksList then
					setActive(arg0_19, false)
					table.insert(arg0_17.fireworksList, var0_17)
				end
			end, var0_0.EffectRecycleTime, 1):Start()
		end)
	end
end

function var0_0.GetFireworkPos(arg0_21)
	local var0_21 = Vector2(0, 0)

	if arg0_21.lastPos then
		local var1_21 = Vector2(arg0_21.lastPos.x, arg0_21.lastPos.y)
		local var2_21 = math.abs(var1_21.x - arg0_21.lastPos.x)
		local var3_21 = math.abs(var1_21.y - arg0_21.lastPos.y)

		while var2_21 < var0_0.FireworkRange.x / 2 and var3_21 < var0_0.FireworkRange.y or var3_21 < var0_0.FireworkRange.y / 2 and var2_21 < var0_0.FireworkRange.x do
			var1_21.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
			var1_21.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
			var2_21 = math.abs(var1_21.x - arg0_21.lastPos.x)
			var3_21 = math.abs(var1_21.y - arg0_21.lastPos.y)
		end

		var0_21 = var1_21
	else
		var0_21.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
		var0_21.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
	end

	arg0_21.lastPos = var0_21

	return var0_21
end

function var0_0.StopPlayFireworks(arg0_22)
	if arg0_22.fireworksTimer then
		arg0_22.fireworksTimer:Stop()

		arg0_22.fireworksTimer = nil
	end
end

return var0_0
