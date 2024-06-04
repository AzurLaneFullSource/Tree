local var0 = class("IdolMasterStageScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "IdolMasterStageUI"
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

	arg0.containers = {
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.IdolMasterStageGraph"))
	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/return_btn"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0:findTF("top/return_main_btn"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idolmaster_main.tip
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiuwoshouhui", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 24)
	end)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_MASTER_PT_ID)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "leijijiangli", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1 and var1.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jinianzhang", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.IDOLMASTER_MEDAL_COLLECTION_SCENE)
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:BindItemBattle()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1
	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3 = getProxy(MiniGameProxy)
	local var4 = var2 and var3:GetHubByHubId(var2:getConfig("config_id"))
	local var5 = var4 and var4.count > 0

	var5 = var5 or var4.usedtime >= var4:getConfig("reward_need") and var4.ultimate == 0

	local var6 = arg0.upper_jiujiuwoshouhui:Find("tip")

	setActive(var6, var5)

	local var7 = var0:getActivityById(ActivityConst.IDOL_MASTER_PT_ID)
	local var8 = arg0.upper_leijijiangli:Find("tip")
	local var9 = var7 and var7:readyToAchieve()

	setActive(var8, var9)

	local var10 = arg0.upper_jinianzhang:Find("tip")
	local var11 = var0.MedalTip()

	setActive(var10, var11)
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
