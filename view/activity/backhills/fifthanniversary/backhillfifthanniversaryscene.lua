local var0_0 = class("BackHillFifthAnniversaryScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "BackHillFifthAnniversaryUI"
end

var0_0.edge2area = {
	default = "_sdPlace",
	["6_7"] = "_sdPlace2"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._bg = arg0_2:findTF("BG")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._shipTpl = arg0_2:findTF("ship")
	arg0_2._sdPlace = arg0_2:findTF("map/SDPlace")
	arg0_2._sdPlace2 = arg0_2:findTF("map/SDPlace2")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.containers = {
		arg0_2._sdPlace,
		arg0_2._sdPlace2
	}
	arg0_2.usableTxt = arg0_2.top:Find("UsableCount/Text"):GetComponent(typeof(Text))
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillFifthAnniversaryGraph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Invitation"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.FIFTH_ANNIVERSARY_INVITATION
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/UsableCount"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 40)
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_DUOMAOMAO_ID)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "youxidian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 40)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "kafeiting", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ACTIVITY_MAID_DAY
		})
	end)
	setActive(arg0_3.map_longpaifangBanner, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		local function var1_3()
			arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		onButton(arg0_3, arg0_3.map_longpaifang, var1_3, SFX_PANEL)
		onButton(arg0_3, arg0_3.map_longpaifangBanner, var1_3, SFX_PANEL)
	end

	arg0_3:BindItemSkinShop()

	local function var2_3()
		local var0_11
		local var1_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1_11 and not var1_11:isEnd() then
			var0_11 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2_11 and not var2_11:isEnd() then
			var0_11 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2_11:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0_11
		})
	end

	onButton(arg0_3, arg0_3.map_xianshijianzao, var2_3, SFX_PANEL)
	onButton(arg0_3, arg0_3.map_xianshijianzaoBanner, var2_3, SFX_PANEL)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	local function var0_12()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	end

	setActive(arg0_12.upper_youxidian:Find("Tip"), var0_12())

	local var1_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	local var2_12 = var1_12 and getProxy(MiniGameProxy):GetHubByHubId(var1_12:getConfig("config_id"))
	local var3_12 = var2_12 and var2_12.count or 0

	arg0_12.usableTxt.text = "X" .. var3_12

	local function var4_12()
		local var0_14 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_MAID_DAY)

		return Activity.IsActivityReady(var0_14)
	end

	setActive(arg0_12.upper_kafeiting:Find("Tip"), var4_12())

	local function var5_12()
		if PLATFORM_CODE ~= PLATFORM_CH then
			return
		end

		local var0_15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_15)
	end

	setActive(arg0_12.map_longpaifangBanner:Find("Tip"), var5_12())
end

function var0_0.IsShowMainTip(arg0_16)
	local function var0_16()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.JIUJIU_DUOMAOMAO_ID)
	end

	local function var1_16()
		local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_MAID_DAY)

		return Activity.IsActivityReady(var0_18)
	end

	local function var2_16()
		if PLATFORM_CODE ~= PLATFORM_CH then
			return
		end

		local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_19)
	end

	return var0_16() or var1_16() or var2_16()
end

function var0_0.willExit(arg0_20)
	arg0_20:clearStudents()
	var0_0.super.willExit(arg0_20)
end

return var0_0
