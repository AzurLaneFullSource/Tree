local var0_0 = class("MusicFestivalScene2", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "MusicFestivalUI2"
end

var0_0.edge2area = {
	default = "_middle"
}

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._stageShip = arg0_2._map:Find("stageship")
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.modelTip = arg0_2.upper_model:Find("tip")

	setActive(arg0_2.modelTip, false)

	arg0_2._middle = arg0_2._map:Find("middle")
	arg0_2.containers = {
		arg0_2._middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.MusicFestivalGraph2"))

	local var4_2 = arg0_2._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5_2 = var4_2 and var4_2.sortingOrder

	arg0_2._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 2

	local var6_2 = GetComponent(arg0_2._map, "ItemList")

	for iter2_2 = 1, 3 do
		local var7_2 = var6_2.prefabItem[iter2_2 - 1]
		local var8_2 = tf(Instantiate(var7_2))

		setParent(var8_2, arg0_2._map)
	end

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
			helps = pg.gametip.music_main.tip
		})
	end)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	onButton(arg0_3, arg0_3.upper_model, function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jichangwutai", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end)

	local var1_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "leijipt", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "bujishangdian", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huangzhuangshangdian", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xianshijianzao", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jinianzhang", function()
		local var0_13 = Context.New({
			mediator = IdolMedalCollectionMediator,
			viewComponent = IdolMedalCollectionView2
		})

		arg0_3:emit(MusicFestivalMediator.GO_SUBLAYER, var0_13)
	end)
	arg0_3:BindItemBattle()
	arg0_3:updateStageShip()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_14)
	local var0_14 = getProxy(ActivityProxy)
	local var1_14
	local var2_14 = var0_14:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)
	local var3_14 = getProxy(MiniGameProxy):GetHubByHubId(var2_14:getConfig("config_id"))
	local var4_14 = var3_14.count > 0
	local var5_14 = arg0_14.upper_jichangwutai:Find("tip")

	setActive(var5_14, var4_14)

	local var6_14 = var3_14.usedtime >= var3_14:getConfig("reward_need") and var3_14.ultimate == 0

	setActive(arg0_14.modelTip, var6_14)

	local var7_14 = var0_14:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)
	local var8_14 = arg0_14.upper_leijipt:Find("tip")
	local var9_14 = var7_14:readyToAchieve()

	setActive(var8_14, var9_14)

	local var10_14 = arg0_14.upper_jinianzhang:Find("tip")
	local var11_14 = var0_0.MedalTip()

	setActive(var10_14, var11_14)
end

function var0_0.getStageShip(arg0_15)
	local var0_15 = getProxy(ActivityProxy)
	local var1_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	if not var1_15 then
		return
	end

	local var2_15 = var1_15:getConfig("config_client")
	local var3_15 = var2_15 and var2_15.stage_on_ship

	if var3_15 then
		local var4_15 = #var3_15

		return var3_15[math.random(1, var4_15)], var3_15.action[1]
	end
end

function var0_0.updateStageShip(arg0_16)
	local var0_16, var1_16 = arg0_16:getStageShip()

	if not var0_16 then
		return
	end

	arg0_16.loader:GetSpine(var0_16, function(arg0_17)
		arg0_17.transform.localScale = Vector3(0.63, 0.63, 1)
		arg0_17.transform.localPosition = Vector3.zero

		arg0_17.transform:SetParent(arg0_16._stageShip, false)
		arg0_17.transform:SetSiblingIndex(1)
		setActive(arg0_16._stageShip, true)
		arg0_17:GetComponent(typeof(SpineAnimUI)):SetAction(var1_16, 0)
	end, arg0_16._stageShip)
end

function var0_0.getStudents(arg0_18, arg1_18, arg2_18)
	local var0_18 = {}
	local var1_18 = getProxy(ActivityProxy):getActivityById(arg0_18)

	if not var1_18 then
		return var0_18
	end

	local var2_18 = var1_18:getConfig("config_client")

	var2_18 = var2_18 and var2_18.stage_off_ship

	if var2_18 then
		local var3_18 = Clone(var2_18)
		local var4_18 = math.random(arg1_18, arg2_18)
		local var5_18 = #var3_18

		while var4_18 > 0 and var5_18 > 0 do
			local var6_18 = math.random(1, var5_18)

			table.insert(var0_18, var3_18[var6_18])

			var3_18[var6_18] = var3_18[var5_18]
			var5_18 = var5_18 - 1
			var4_18 = var4_18 - 1
		end
	end

	return var0_18
end

function var0_0.MedalTip()
	local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_19)
end

function var0_0.IsShowMainTip(arg0_20)
	local var0_20 = getProxy(ActivityProxy)
	local var1_20 = var0_20:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2)

	assert(var1_20)

	local function var2_20()
		local var0_21 = var0_20:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

		return var0_21 and not var0_21:isEnd() and var0_21:readyToAchieve()
	end

	local var3_20 = var0_0.MedalTip

	local function var4_20()
		local var0_22 = getProxy(MiniGameProxy):GetHubByHubId(var1_20:getConfig("config_id"))

		return var0_22.usedtime >= var0_22:getConfig("reward_need") and var0_22.ultimate == 0
	end

	local function var5_20()
		return getProxy(MiniGameProxy):GetHubByHubId(var1_20:getConfig("config_id")).count > 0
	end

	return var2_20() or var3_20() or var4_20() or var5_20()
end

function var0_0.willExit(arg0_24)
	arg0_24:clearStudents()
	var0_0.super.willExit(arg0_24)
end

return var0_0
