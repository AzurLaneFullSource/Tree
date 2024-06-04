local var0 = class("BackHillFifthAnniversaryScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "BackHillFifthAnniversaryUI"
end

var0.edge2area = {
	default = "_sdPlace",
	["6_7"] = "_sdPlace2"
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

	arg0._shipTpl = arg0:findTF("ship")
	arg0._sdPlace = arg0:findTF("map/SDPlace")
	arg0._sdPlace2 = arg0:findTF("map/SDPlace2")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.containers = {
		arg0._sdPlace,
		arg0._sdPlace2
	}
	arg0.usableTxt = arg0.top:Find("UsableCount/Text"):GetComponent(typeof(Text))
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillFifthAnniversaryGraph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Invitation"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.FIFTH_ANNIVERSARY_INVITATION
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/UsableCount"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 40)
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_DUOMAOMAO_ID)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "youxidian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 40)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "kafeiting", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ACTIVITY_MAID_DAY
		})
	end)
	setActive(arg0.map_longpaifangBanner, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		local function var1()
			arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		onButton(arg0, arg0.map_longpaifang, var1, SFX_PANEL)
		onButton(arg0, arg0.map_longpaifangBanner, var1, SFX_PANEL)
	end

	arg0:BindItemSkinShop()

	local function var2()
		local var0
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1 and not var1:isEnd() then
			var0 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2 and not var2:isEnd() then
			var0 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0
		})
	end

	onButton(arg0, arg0.map_xianshijianzao, var2, SFX_PANEL)
	onButton(arg0, arg0.map_xianshijianzaoBanner, var2, SFX_PANEL)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	end

	setActive(arg0.upper_youxidian:Find("Tip"), var0())

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	local var2 = var1 and getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id"))
	local var3 = var2 and var2.count or 0

	arg0.usableTxt.text = "X" .. var3

	local function var4()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_MAID_DAY)

		return Activity.IsActivityReady(var0)
	end

	setActive(arg0.upper_kafeiting:Find("Tip"), var4())

	local function var5()
		if PLATFORM_CODE ~= PLATFORM_CH then
			return
		end

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0)
	end

	setActive(arg0.map_longpaifangBanner:Find("Tip"), var5())
end

function var0.IsShowMainTip(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	end

	local function var1()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_MAID_DAY)

		return Activity.IsActivityReady(var0)
	end

	local function var2()
		if PLATFORM_CODE ~= PLATFORM_CH then
			return
		end

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0)
	end

	return var0() or var1() or var2()
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
