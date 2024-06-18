local var0_0 = class("DOALinkIslandScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "DOALinkIslandUI"
end

var0_0.edge2area = {
	default = "map_middle",
	["2_2"] = "map_bridge"
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
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.DOAIslandGraph"))

	local var4_2 = arg0_2._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5_2 = var4_2 and var4_2.sortingOrder

	arg0_2._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 3
	arg0_2.map_tebiezuozhan:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 1
	arg0_2.map_bridge:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 1

	local var6_2 = GetComponent(arg0_2._map, "ItemList")

	for iter2_2 = 1, 1 do
		local var7_2 = var6_2.prefabItem[iter2_2 - 1]
		local var8_2 = tf(Instantiate(var7_2))

		pg.ViewUtils.SetSortingOrder(var8_2, var5_2 - 2)
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
			helps = pg.gametip.doa_main.tip
		})
	end)
	arg0_3:InitStudents(ActivityConst.MINIGAME_VOLLEYBALL, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shatanpaiqiu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 17)
	end)
	onButton(arg0_3, arg0_3._upper:Find("pengpengdong"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 51)
	end, SFX_PANEL)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "daoyvjianshe", function()
		arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.DOA_PT_ID
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "bujishangdian", function()
		arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huanzhuangshangdian", function()
		arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xianshijianzao", function()
		arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jinianzhang", function()
		arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.DOA2_MEDAL_COLLECTION_SCENE)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "tebiezuozhan", function()
		local var0_14 = getProxy(ChapterProxy)
		local var1_14, var2_14 = var0_14:getLastMapForActivity()

		if not var1_14 or not var0_14:getMapById(var1_14):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_3:emit(DOALinkIslandMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_14,
				mapIdx = var1_14
			})
		end
	end)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_15)
	local var0_15 = getProxy(ActivityProxy)
	local var1_15

	setActive(arg0_15.upper_shatanpaiqiu:Find("tip"), var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_VOLLEYBALL))
	setActive(arg0_15.upper_pengpengdong:Find("tip"), var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_PENGPENGDONG))

	local var2_15 = var0_15:getActivityById(ActivityConst.MINIGAME_VOLLEYBALL)

	assert(var2_15)

	local var3_15 = getProxy(MiniGameProxy):GetHubByHubId(var2_15:getConfig("config_id"))

	assert(var3_15)
	arg0_15.loader:GetSpriteQuiet("ui/DOALinkIslandUI_atlas", tostring(var3_15.usedtime or 0), arg0_15.map_shatanpaiqiu:Find("Digit"), true)

	local var4_15 = var0_15:getActivityById(ActivityConst.DOA_PT_ID)

	assert(var4_15)

	local var5_15 = arg0_15.upper_daoyvjianshe:Find("tip")
	local var6_15 = var4_15 and var4_15:readyToAchieve()

	setActive(var5_15, var6_15)

	local var7_15 = arg0_15.upper_jinianzhang:Find("tip")
	local var8_15 = var0_0.MedalTip()

	setActive(var7_15, var8_15)
end

function var0_0.willExit(arg0_16)
	arg0_16:clearStudents()
	var0_0.super.willExit(arg0_16)
end

function var0_0.MedalTip()
	local var0_17 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_17)
end

function var0_0.IsShowMainTip(arg0_18)
	if arg0_18 and not arg0_18:isEnd() then
		local var0_18 = getProxy(ActivityProxy)

		local function var1_18()
			local var0_19 = var0_18:getActivityById(ActivityConst.DOA_PT_ID)

			return var0_19 and not var0_19:isEnd() and var0_19:readyToAchieve()
		end

		local var2_18 = var0_0.MedalTip

		local function var3_18()
			return var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_VOLLEYBALL)
		end

		local function var4_18()
			return var0_0.IsMiniActNeedTip(ActivityConst.MINIGAME_PENGPENGDONG)
		end

		return var1_18() or var2_18() or var3_18() or var4_18()
	end
end

return var0_0
