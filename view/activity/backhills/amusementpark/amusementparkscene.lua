local var0 = class("AmusementParkScene", import("..TemplateMV.BackHillTemplate"))

var0.UIName = "AmusementParkUI"
var0.edge2area = {
	default = "map_middle",
	["1_1"] = "map_top"
}
var0.Buildings = {
	[9] = "xuanzhuanmuma",
	[10] = "guoshanche",
	[12] = "haidaochuan",
	[11] = "tiaolouji"
}

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
		arg0.map_middle,
		arg0.map_top
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph"))
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.gameCountTxt = arg0.top:Find("GameCount/text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	setActive(arg0.map_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0.upper_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
	arg0:RegisterDataResponse()

	arg0.loader = AutoLoader.New()
end

function var0.RegisterDataResponse(arg0)
	arg0.Respones = ResponsableTree.CreateShell({})

	arg0.Respones:SetRawData("view", arg0)

	local var0 = {
		"guoshanche",
		"haidaochuan",
		"xuanzhuanmuma",
		"tiaolouji"
	}

	for iter0, iter1 in ipairs(var0) do
		arg0.Respones:AddRawListener({
			"view",
			iter1
		}, function(arg0, arg1)
			if not arg1 then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/AmusementParkUI_atlas", "entrance_" .. iter1 .. arg1, arg0["map_" .. iter1])

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("Level")) then
				return
			end

			setText(var0:Find("Level"), "LV." .. arg1)
		end)
	end

	local var1 = {
		"guoshanche",
		"haidaochuan",
		"xuanzhuanmuma",
		"tiaolouji",
		"dangaobaoweizhan",
		"jiujiuduihuanwu"
	}

	for iter2, iter3 in ipairs(var1) do
		arg0.Respones:AddRawListener({
			"view",
			iter3 .. "Tip"
		}, function(arg0, arg1)
			local var0 = arg0["upper_" .. iter3]

			if not var0 or IsNil(var0:Find("Tip")) then
				return
			end

			setActive(var0:Find("Tip"), arg1)
		end)
	end

	arg0.Respones.hubData = {}

	arg0.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0, arg1)
		arg0.gameCountTxt.text = "X" .. arg1.count
	end, {
		strict = true
	})
	arg0.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0, arg1)
		arg0.materialTxt.text = arg1
	end)
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
			helps = pg.gametip.amusementpark_help.tip
		})
	end)
	onButton(arg0, arg0.top:Find("Invitation"), function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY)

		if var0 and not var0:isEnd() then
			arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0.id
			})
		end
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiuduihuanwu", function()
		arg0:emit(AmusementParkMediator.GO_SUBLAYER, Context.New({
			mediator = AmusementParkShopMediator,
			viewComponent = AmusementParkShopPage
		}))
	end)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0:InitFacilityCross(arg0._map, arg0._upper, iter1, function()
			arg0:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = BuildingUpgradeMediator,
				viewComponent = BuildingUpgradeLayer,
				data = {
					buildingID = iter0
				}
			}))
		end)
	end

	arg0:InitFacilityCross(arg0._map, arg0._upper, "dangaobaoweizhan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 23)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huiyichengbao", function()
		arg0:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xianshijianzao", function()
		arg0:emit(AmusementParkMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huanzhuangshandian", function()
		arg0:emit(AmusementParkMediator.GO_SCENE, SCENE.SKINSHOP)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:UpdateView()
	arg0.loader:LoadPrefab("ui/houshan_caidai", "", function(arg0)
		setParent(arg0, arg0._map)
	end)
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1
	arg0.Respones.xuanzhuanmuma = arg1.data1KeyValueList[2][9] or 1
	arg0.Respones.guoshanche = arg1.data1KeyValueList[2][10] or 1
	arg0.Respones.tiaolouji = arg1.data1KeyValueList[2][11] or 1
	arg0.Respones.haidaochuan = arg1.data1KeyValueList[2][12] or 1

	local var0 = next(arg1.data1KeyValueList[1])

	arg0.Respones.materialCount = arg1.data1KeyValueList[1][var0] or 0

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0
	local var1 = getProxy(ActivityProxy)

	arg0.Respones.xuanzhuanmumaTip = arg0:UpdateBuildingTip(arg0.activity, 9)
	arg0.Respones.guoshancheTip = arg0:UpdateBuildingTip(arg0.activity, 10)
	arg0.Respones.tiaoloujiTip = arg0:UpdateBuildingTip(arg0.activity, 11)
	arg0.Respones.haidaochuanTip = arg0:UpdateBuildingTip(arg0.activity, 12)

	local var2 = var1:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3 = getProxy(MiniGameProxy):GetHubByHubId(var2:getConfig("config_id"))
	local var4 = var3.count > 0

	arg0.Respones.dangaobaoweizhanTip = var4

	arg0:UpdateHubData(var3)

	arg0.Respones.jiujiuduihuanwuTip = AmusementParkShopPage.GetActivityShopTip()
end

function var0.UpdateHubData(arg0, arg1)
	arg0.Respones.hubData.count = arg1.count
	arg0.Respones.hubData.usedtime = arg1.usedtime
	arg0.Respones.hubData.id = arg1.id

	arg0.Respones:PropertyChange("hubData")
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
