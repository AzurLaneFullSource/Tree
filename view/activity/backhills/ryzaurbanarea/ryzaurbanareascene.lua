local var0 = class("RyzaUrbanAreaScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "RyzaUrbanAreaUI"
end

var0.edge2area = {
	default = "map_middle",
	["2_3"] = "map_front",
	["1_2"] = "map_front",
	["3_4"] = "map_front"
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
		arg0.map_front,
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.RyzaUrbanAreaGraph"))
	arg0.minigameCount = arg0.top:Find("minigame/count")
	arg0.puniAnim = arg0._map:Find("huodongye/puni"):GetComponent("SpineAnimUI")
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
			helps = pg.gametip.ryza_tip_main.tip
		})
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:BindItemBattle()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 43)
	end)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_PT)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "huodongye", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1 and var1.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "lianjingongfang", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ATELIER_COMPOSITE)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "weituoban", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.RYZA_TASK)
	end)
	arg0:UpdateView()
	arg0:AutoFitScreen()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = getProxy(ActivityTaskProxy)
	local var2
	local var3 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var4 = var0.IsMiniActNeedTip(var3 and var3.id)
	local var5 = arg0.upper_xiaoyouxi:Find("tip")

	setActive(var5, var4)

	local var6 = var3 and getProxy(MiniGameProxy):GetHubByHubId(var3:getConfig("config_id"))

	setText(arg0.minigameCount, var6.usedtime .. "/" .. var6:getConfig("reward_need"))

	local var7 = var0:getActivityById(ActivityConst.RYZA_PT)
	local var8 = arg0.upper_huodongye:Find("tip")
	local var9 = var7 and var7:readyToAchieve()

	setActive(var8, var9)
	arg0:UpdatePuniAnim(var7)

	local var10 = var1:getActTaskTip(ActivityConst.RYZA_TASK)
	local var11 = arg0.upper_weituoban:Find("tip")

	setActive(var11, var10)
end

function var0.UpdatePuniAnim(arg0, arg1)
	if not arg1 then
		arg0.puniAnim:SetAction("normal_" .. math.random(9), 0)
	else
		local var0 = arg1:getConfig("config_client").puni_phase
		local var1 = ActivityPtData.New(arg1):GetLevelProgress()
		local var2 = 1

		for iter0, iter1 in ipairs(var0) do
			if iter1 < var1 then
				var2 = var2 + 1
			end
		end

		if var2 == #var0 then
			var2 = math.random(#var0)
		end

		arg0.puniAnim:SetAction("normal_" .. var2, 0)
	end
end

function var0.IsShowMainTip(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_RYZA)
	end

	local function var1()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_PT)

		return Activity.IsActivityReady(var0)
	end

	local function var2()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.RYZA_TASK)
	end

	return var0() or var1() or var2()
end

function var0.willExit(arg0)
	arg0:clearStudents()
end

return var0
