local var0 = class("DOALinkIslandScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "DOALinkIslandUI"
end

var0.edge2area = {
	default = "map_middle",
	["2_2"] = "map_bridge"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.DOAIslandGraph"))

	local var4 = arg0._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5 = var4 and var4.sortingOrder

	arg0._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 3
	arg0.map_tebiezuozhan:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 1
	arg0.map_bridge:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 1

	local var6 = GetComponent(arg0._map, "ItemList")

	for iter2 = 1, 1 do
		local var7 = var6.prefabItem[iter2 - 1]
		local var8 = tf(Instantiate(var7))

		pg.ViewUtils.SetSortingOrder(var8, var5 - 2)
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
			helps = pg.gametip.doa_main.tip
		})
	end)
	arg0:InitStudents(ActivityConst.MINIGAME_VOLLEYBALL, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shatanpaiqiu", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 17)
	end)
	onButton(arg0, arg0._upper:Find("pengpengdong"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 51)
	end, SFX_PANEL)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "daoyvjianshe", function()
		arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.DOA_PT_ID
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bujishangdian", function()
		arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huanzhuangshangdian", function()
		arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xianshijianzao", function()
		arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jinianzhang", function()
		arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.DOA2_MEDAL_COLLECTION_SCENE)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "tebiezuozhan", function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1

	setActive(arg0.upper_shatanpaiqiu:Find("tip"), var0.IsMiniActNeedTip(ActivityConst.MINIGAME_VOLLEYBALL))
	setActive(arg0.upper_pengpengdong:Find("tip"), var0.IsMiniActNeedTip(ActivityConst.MINIGAME_PENGPENGDONG))

	local var2 = var0:getActivityById(ActivityConst.MINIGAME_VOLLEYBALL)

	assert(var2)

	local var3 = getProxy(MiniGameProxy):GetHubByHubId(var2:getConfig("config_id"))

	assert(var3)
	arg0.loader:GetSpriteQuiet("ui/DOALinkIslandUI_atlas", tostring(var3.usedtime or 0), arg0.map_shatanpaiqiu:Find("Digit"), true)

	local var4 = var0:getActivityById(ActivityConst.DOA_PT_ID)

	assert(var4)

	local var5 = arg0.upper_daoyvjianshe:Find("tip")
	local var6 = var4 and var4:readyToAchieve()

	setActive(var5, var6)

	local var7 = arg0.upper_jinianzhang:Find("tip")
	local var8 = var0.MedalTip()

	setActive(var7, var8)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		local var0 = getProxy(ActivityProxy)

		local function var1()
			local var0 = var0:getActivityById(ActivityConst.DOA_PT_ID)

			return var0 and not var0:isEnd() and var0:readyToAchieve()
		end

		local var2 = var0.MedalTip

		local function var3()
			return var0.IsMiniActNeedTip(ActivityConst.MINIGAME_VOLLEYBALL)
		end

		local function var4()
			return var0.IsMiniActNeedTip(ActivityConst.MINIGAME_PENGPENGDONG)
		end

		return var1() or var2() or var3() or var4()
	end
end

return var0
