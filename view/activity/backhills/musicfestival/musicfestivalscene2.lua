local var0 = class("MusicFestivalScene2", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "MusicFestivalUI2"
end

var0.edge2area = {
	default = "_middle"
}

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._stageShip = arg0._map:Find("stageship")
	arg0._shipTpl = arg0._map:Find("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.modelTip = arg0.upper_model:Find("tip")

	setActive(arg0.modelTip, false)

	arg0._middle = arg0._map:Find("middle")
	arg0.containers = {
		arg0._middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.MusicFestivalGraph2"))

	local var4 = arg0._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5 = var4 and var4.sortingOrder

	arg0._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 2

	local var6 = GetComponent(arg0._map, "ItemList")

	for iter2 = 1, 3 do
		local var7 = var6.prefabItem[iter2 - 1]
		local var8 = tf(Instantiate(var7))

		setParent(var8, arg0._map)
	end

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
			helps = pg.gametip.music_main.tip
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	onButton(arg0, arg0.upper_model, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jichangwutai", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end)

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "leijipt", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bujishangdian", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huangzhuangshangdian", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xianshijianzao", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jinianzhang", function()
		local var0 = Context.New({
			mediator = IdolMedalCollectionMediator,
			viewComponent = IdolMedalCollectionView2
		})

		arg0:emit(MusicFestivalMediator.GO_SUBLAYER, var0)
	end)
	arg0:BindItemBattle()
	arg0:updateStageShip()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1
	local var2 = var0:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)
	local var3 = getProxy(MiniGameProxy):GetHubByHubId(var2:getConfig("config_id"))
	local var4 = var3.count > 0
	local var5 = arg0.upper_jichangwutai:Find("tip")

	setActive(var5, var4)

	local var6 = var3.usedtime >= var3:getConfig("reward_need") and var3.ultimate == 0

	setActive(arg0.modelTip, var6)

	local var7 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)
	local var8 = arg0.upper_leijipt:Find("tip")
	local var9 = var7:readyToAchieve()

	setActive(var8, var9)

	local var10 = arg0.upper_jinianzhang:Find("tip")
	local var11 = var0.MedalTip()

	setActive(var10, var11)
end

function var0.getStageShip(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	if not var1 then
		return
	end

	local var2 = var1:getConfig("config_client")
	local var3 = var2 and var2.stage_on_ship

	if var3 then
		local var4 = #var3

		return var3[math.random(1, var4)], var3.action[1]
	end
end

function var0.updateStageShip(arg0)
	local var0, var1 = arg0:getStageShip()

	if not var0 then
		return
	end

	arg0.loader:GetSpine(var0, function(arg0)
		arg0.transform.localScale = Vector3(0.63, 0.63, 1)
		arg0.transform.localPosition = Vector3.zero

		arg0.transform:SetParent(arg0._stageShip, false)
		arg0.transform:SetSiblingIndex(1)
		setActive(arg0._stageShip, true)
		arg0:GetComponent(typeof(SpineAnimUI)):SetAction(var1, 0)
	end, arg0._stageShip)
end

function var0.getStudents(arg0, arg1, arg2)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var1 then
		return var0
	end

	local var2 = var1:getConfig("config_client")

	var2 = var2 and var2.stage_off_ship

	if var2 then
		local var3 = Clone(var2)
		local var4 = math.random(arg1, arg2)
		local var5 = #var3

		while var4 > 0 and var5 > 0 do
			local var6 = math.random(1, var5)

			table.insert(var0, var3[var6])

			var3[var6] = var3[var5]
			var5 = var5 - 1
			var4 = var4 - 1
		end
	end

	return var0
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.IsShowMainTip(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	assert(var1)

	local function var2()
		local var0 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

		return var0 and not var0:isEnd() and var0:readyToAchieve()
	end

	local var3 = var0.MedalTip

	local function var4()
		local var0 = getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id"))

		return var0.usedtime >= var0:getConfig("reward_need") and var0.ultimate == 0
	end

	local function var5()
		return getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id")).count > 0
	end

	return var2() or var3() or var4() or var5()
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
