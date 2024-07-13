local var0_0 = class("IdolMasterStageScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "IdolMasterStageUI"
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

	arg0_2.containers = {
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.IdolMasterStageGraph"))
	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/return_btn"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_3, arg0_3:findTF("top/return_main_btn"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_3, arg0_3:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idolmaster_main.tip
		})
	end)

	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jiujiuwoshouhui", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 24)
	end)

	local var1_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_MASTER_PT_ID)

	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "leijijiangli", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_3 and var1_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jinianzhang", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.IDOLMASTER_MEDAL_COLLECTION_SCENE)
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:BindItemBattle()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_10)
	local var0_10 = getProxy(ActivityProxy)
	local var1_10
	local var2_10 = var0_10:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3_10 = getProxy(MiniGameProxy)
	local var4_10 = var2_10 and var3_10:GetHubByHubId(var2_10:getConfig("config_id"))
	local var5_10 = var4_10 and var4_10.count > 0

	var5_10 = var5_10 or var4_10.usedtime >= var4_10:getConfig("reward_need") and var4_10.ultimate == 0

	local var6_10 = arg0_10.upper_jiujiuwoshouhui:Find("tip")

	setActive(var6_10, var5_10)

	local var7_10 = var0_10:getActivityById(ActivityConst.IDOL_MASTER_PT_ID)
	local var8_10 = arg0_10.upper_leijijiangli:Find("tip")
	local var9_10 = var7_10 and var7_10:readyToAchieve()

	setActive(var8_10, var9_10)

	local var10_10 = arg0_10.upper_jinianzhang:Find("tip")
	local var11_10 = var0_0.MedalTip()

	setActive(var10_10, var11_10)
end

function var0_0.MedalTip()
	local var0_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_11)
end

function var0_0.willExit(arg0_12)
	arg0_12:clearStudents()
	var0_0.super.willExit(arg0_12)
end

return var0_0
