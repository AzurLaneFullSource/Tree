local var0 = class("NewYearFestival2023Scene", import("..TemplateMV.BackHillTemplate"))

var0.edge2area = {
	default = "map_middle",
	["4_4"] = "map_bottom"
}

function var0.getUIName(arg0)
	return "NewYearFestival2023UI"
end

function var0.init(arg0)
	arg0.top = arg0:findTF("Top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._shipTpl = arg0._map:Find("ship")
	arg0.containers = {
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2023Graph"))
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.tipTfs = _.map(_.range(arg0._upper.childCount), function(arg0)
		local var0 = arg0._upper:GetChild(arg0 - 1)

		return {
			name = var0.name,
			trans = var0:Find("Tip")
		}
	end)

	pg.ViewUtils.SetSortingOrder(arg0._map:GetChild(arg0._map.childCount - 1), 1)

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.top:Find("Back"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0.top:Find("Home"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0.top:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.resorts_help.tip
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "hotspring", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.HOTSPRING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "duihuanwu", function()
		local var0 = Context.New()

		SCENE.SetSceneInfo(var0, SCENE.HOTSPRING_SHOP)
		arg0:emit(BackHillMediatorTemplate.GO_SUBLAYER, var0)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "firework", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 44)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shrine", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 45)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "fudai", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.HOTSPRING_REDPACKET)
	end)
	arg0:BindItemBuildShip()
	arg0:BindItemSkinShop()
	arg0:InitStudents(ActivityConst.MINIGAME_FIREWORK_VS_SAIREN, 3, 4)
	arg0:UpdateView()
end

function var0.UpdateActivity(arg0, arg1)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	_.each(arg0.tipTfs, function(arg0)
		local var0 = switch(arg0.name, {
			fudai = function()
				return BeachPacketLayer.isShowRedPoint()
			end,
			hotspring = function()
				local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

				return Activity.IsActivityReady(var0)
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

		setActive(arg0.trans, tobool(var0))
	end)
end

function var0.IsShowMainTip(arg0)
	local var0 = {
		fudai = function()
			return BeachPacketLayer.isShowRedPoint()
		end,
		hotspring = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

			return Activity.IsActivityReady(var0)
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

	return _.any(_.values(var0), function(arg0)
		return arg0()
	end)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
