local var0 = class("USCastle2023Scene", import("..TemplateMV.BackHillTemplate"))

var0.EffectName = {
	"yanhua_01",
	"yanhua_02",
	"yanhua_maomao",
	"yanhua_mofang",
	"yanhua_chuanmao",
	"yanhua_huangji",
	"yanhua_xinxin",
	"yanhua_Azurlane"
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
var0.EffectInterval = 1.5
var0.EffectRecycleTime = 3
var0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0.getUIName(arg0)
	return "USCastle2023UI"
end

var0.edge2area = {
	default = "_SDPlace"
}

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._bg = arg0:findTF("BG")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._upper = arg0:findTF("upper")
	arg0.upper_yanhuiyaoyue = nil
	arg0.upper_xintiaochengbao = nil

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0._SDPlace = arg0._tf:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.USCastle2023Graph"))
	arg0.fireworksTF = arg0:findTF("play_fireworks")
	arg0.fireworksList = {
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

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.uscastle2023_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_XINTIAOCHENGBAO)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "yanhuiyaoyue", function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if var0 and not var0:isEnd() then
			arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.FEAST)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
		end
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xintiaochengbao", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shujvhuigu", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()
	arg0:PlayFireworks()
end

function var0.FeastTip()
	return getProxy(FeastProxy):ShouldTip()
end

function var0.XinTiaoChengBaoTip()
	return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_XINTIAOCHENGBAO)
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_yanhuiyaoyue:Find("Tip"), var0.FeastTip())
	setActive(arg0.upper_xintiaochengbao:Find("Tip"), var0.XinTiaoChengBaoTip())
end

function var0.willExit(arg0)
	arg0:clearStudents()
	arg0:StopPlayFireworks()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.XinTiaoChengBaoTip() or var0.FeastTip()
	end
end

function var0.PlayFireworks(arg0)
	arg0:StopPlayFireworks()
	arg0:PlayerOneFirework()

	arg0.fireworksTimer = Timer.New(function()
		arg0:PlayerOneFirework()
	end, var0.EffectInterval, -1)

	arg0.fireworksTimer:Start()
end

function var0.PlayerOneFirework(arg0)
	local var0 = arg0.fireworksList[math.random(#arg0.fireworksList)]

	table.removebyvalue(arg0.fireworksList, var0)

	local var1 = var0.EffectName[var0]
	local var2 = arg0.fireworksTF:Find(var1)
	local var3 = math.random(#var0.SFX_LIST)

	if var2 then
		setLocalPosition(var2, arg0:GetFireworkPos())
		setActive(var2, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var3])
		Timer.New(function()
			if arg0.fireworksList then
				setActive(var2, false)
				table.insert(arg0.fireworksList, var0)
			end
		end, var0.EffectRecycleTime, 1):Start()
	else
		arg0.loader:GetPrefab("ui/" .. var1, "", function(arg0)
			pg.ViewUtils.SetSortingOrder(arg0, 1)

			arg0.name = var1

			setParent(arg0, arg0.fireworksTF)
			setLocalPosition(arg0, arg0:GetFireworkPos())
			setActive(arg0, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.SFX_LIST[var3])
			Timer.New(function()
				if arg0.fireworksList then
					setActive(arg0, false)
					table.insert(arg0.fireworksList, var0)
				end
			end, var0.EffectRecycleTime, 1):Start()
		end)
	end
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

function var0.StopPlayFireworks(arg0)
	if arg0.fireworksTimer then
		arg0.fireworksTimer:Stop()

		arg0.fireworksTimer = nil
	end
end

return var0
