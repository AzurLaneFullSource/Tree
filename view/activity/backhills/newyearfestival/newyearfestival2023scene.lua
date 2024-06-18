local var0_0 = class("NewYearFestival2023Scene", import("..TemplateMV.BackHillTemplate"))

var0_0.edge2area = {
	default = "map_middle",
	["4_4"] = "map_bottom"
}

function var0_0.getUIName(arg0_1)
	return "NewYearFestival2023UI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("Top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.containers = {
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2023Graph"))
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.tipTfs = _.map(_.range(arg0_2._upper.childCount), function(arg0_3)
		local var0_3 = arg0_2._upper:GetChild(arg0_3 - 1)

		return {
			name = var0_3.name,
			trans = var0_3:Find("Tip")
		}
	end)

	pg.ViewUtils.SetSortingOrder(arg0_2._map:GetChild(arg0_2._map.childCount - 1), 1)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.top:Find("Back"), function()
		arg0_4:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_4, arg0_4.top:Find("Home"), function()
		arg0_4:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_4, arg0_4.top:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.resorts_help.tip
		})
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "hotspring", function()
		arg0_4:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.HOTSPRING)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "duihuanwu", function()
		local var0_9 = Context.New()

		SCENE.SetSceneInfo(var0_9, SCENE.HOTSPRING_SHOP)
		arg0_4:emit(BackHillMediatorTemplate.GO_SUBLAYER, var0_9)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "firework", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 44)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "shrine", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 45)
	end)
	arg0_4:InitFacilityCross(arg0_4._map, arg0_4._upper, "fudai", function()
		arg0_4:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.HOTSPRING_REDPACKET)
	end)
	arg0_4:BindItemBuildShip()
	arg0_4:BindItemSkinShop()
	arg0_4:InitStudents(ActivityConst.MINIGAME_FIREWORK_VS_SAIREN, 3, 4)
	arg0_4:UpdateView()
end

function var0_0.UpdateActivity(arg0_13, arg1_13)
	arg0_13:UpdateView()
end

function var0_0.UpdateView(arg0_14)
	_.each(arg0_14.tipTfs, function(arg0_15)
		local var0_15 = switch(arg0_15.name, {
			fudai = function()
				return BeachPacketLayer.isShowRedPoint()
			end,
			hotspring = function()
				local var0_17 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

				return Activity.IsActivityReady(var0_17)
			end,
			shrine = function()
				return Shrine2023View.IsNeedShowTipWithoutActivityFinalReward()
			end,
			duihuanwu = function()
				return AmusementParkShopPage.GetActivityShopTip()
			end,
			firework = function()
				return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_FIREWORK_VS_SAIREN)
			end
		}, function()
			return false
		end)

		setActive(arg0_15.trans, tobool(var0_15))
	end)
end

function var0_0.IsShowMainTip(arg0_22)
	local var0_22 = {
		fudai = function()
			return BeachPacketLayer.isShowRedPoint()
		end,
		hotspring = function()
			local var0_24 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

			return Activity.IsActivityReady(var0_24)
		end,
		shrine = function()
			return Shrine2023View.IsNeedShowTipWithoutActivityFinalReward()
		end,
		duihuanwu = function()
			return AmusementParkShopPage.GetActivityShopTip()
		end,
		firework = function()
			return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_FIREWORK_VS_SAIREN)
		end
	}

	return _.any(_.values(var0_22), function(arg0_28)
		return arg0_28()
	end)
end

function var0_0.willExit(arg0_29)
	arg0_29:clearStudents()
	var0_0.super.willExit(arg0_29)
end

return var0_0
