local var0_0 = class("RyzaUrbanAreaScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "RyzaUrbanAreaUI"
end

var0_0.edge2area = {
	default = "map_middle",
	["2_3"] = "map_front",
	["1_2"] = "map_front",
	["3_4"] = "map_front"
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
		arg0_2.map_front,
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.RyzaUrbanAreaGraph"))
	arg0_2.minigameCount = arg0_2.top:Find("minigame/count")
	arg0_2.puniAnim = arg0_2._map:Find("huodongye/puni"):GetComponent("SpineAnimUI")
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
			helps = pg.gametip.ryza_tip_main.tip
		})
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:BindItemBattle()

	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 43)
	end)

	local var1_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_PT)

	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huodongye", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_3 and var1_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "lianjingongfang", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ATELIER_COMPOSITE)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "weituoban", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.RYZA_TASK)
	end)
	arg0_3:UpdateView()
	arg0_3:AutoFitScreen()
end

function var0_0.UpdateView(arg0_11)
	local var0_11 = getProxy(ActivityProxy)
	local var1_11 = getProxy(ActivityTaskProxy)
	local var2_11
	local var3_11 = var0_11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var4_11 = var0_0.IsMiniActNeedTip(var3_11 and var3_11.id)
	local var5_11 = arg0_11.upper_xiaoyouxi:Find("tip")

	setActive(var5_11, var4_11)

	local var6_11 = var3_11 and getProxy(MiniGameProxy):GetHubByHubId(var3_11:getConfig("config_id"))

	setText(arg0_11.minigameCount, var6_11.usedtime .. "/" .. var6_11:getConfig("reward_need"))

	local var7_11 = var0_11:getActivityById(ActivityConst.RYZA_PT)
	local var8_11 = arg0_11.upper_huodongye:Find("tip")
	local var9_11 = var7_11 and var7_11:readyToAchieve()

	setActive(var8_11, var9_11)
	arg0_11:UpdatePuniAnim(var7_11)

	local var10_11 = var1_11:getActTaskTip(ActivityConst.RYZA_TASK)
	local var11_11 = arg0_11.upper_weituoban:Find("tip")

	setActive(var11_11, var10_11)
end

function var0_0.UpdatePuniAnim(arg0_12, arg1_12)
	if not arg1_12 then
		arg0_12.puniAnim:SetAction("normal_" .. math.random(9), 0)
	else
		local var0_12 = arg1_12:getConfig("config_client").puni_phase
		local var1_12 = ActivityPtData.New(arg1_12):GetLevelProgress()
		local var2_12 = 1

		for iter0_12, iter1_12 in ipairs(var0_12) do
			if iter1_12 < var1_12 then
				var2_12 = var2_12 + 1
			end
		end

		if var2_12 == #var0_12 then
			var2_12 = math.random(#var0_12)
		end

		arg0_12.puniAnim:SetAction("normal_" .. var2_12, 0)
	end
end

function var0_0.IsShowMainTip(arg0_13)
	local function var0_13()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_RYZA)
	end

	local function var1_13()
		local var0_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_PT)

		return Activity.IsActivityReady(var0_15)
	end

	local function var2_13()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.RYZA_TASK)
	end

	return var0_13() or var1_13() or var2_13()
end

function var0_0.willExit(arg0_17)
	arg0_17:clearStudents()
end

return var0_0
