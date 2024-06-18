local var0_0 = class("AmusementParkScene", import("..TemplateMV.BackHillTemplate"))

var0_0.UIName = "AmusementParkUI"
var0_0.edge2area = {
	default = "map_middle",
	["1_1"] = "map_top"
}
var0_0.Buildings = {
	[9] = "xuanzhuanmuma",
	[10] = "guoshanche",
	[12] = "haidaochuan",
	[11] = "tiaolouji"
}

function var0_0.init(arg0_1)
	arg0_1.top = arg0_1:findTF("Top")
	arg0_1._map = arg0_1:findTF("map")

	for iter0_1 = 0, arg0_1._map.childCount - 1 do
		local var0_1 = arg0_1._map:GetChild(iter0_1)
		local var1_1 = go(var0_1).name

		arg0_1["map_" .. var1_1] = var0_1
	end

	arg0_1._shipTpl = arg0_1._map:Find("ship")
	arg0_1.containers = {
		arg0_1.map_middle,
		arg0_1.map_top
	}
	arg0_1.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph"))
	arg0_1._upper = arg0_1:findTF("upper")

	for iter1_1 = 0, arg0_1._upper.childCount - 1 do
		local var2_1 = arg0_1._upper:GetChild(iter1_1)
		local var3_1 = go(var2_1).name

		arg0_1["upper_" .. var3_1] = var2_1
	end

	arg0_1.gameCountTxt = arg0_1.top:Find("GameCount/text"):GetComponent(typeof(Text))
	arg0_1.materialTxt = arg0_1.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	setActive(arg0_1.map_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0_1.upper_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
	arg0_1:RegisterDataResponse()

	arg0_1.loader = AutoLoader.New()
end

function var0_0.RegisterDataResponse(arg0_2)
	arg0_2.Respones = ResponsableTree.CreateShell({})

	arg0_2.Respones:SetRawData("view", arg0_2)

	local var0_2 = {
		"guoshanche",
		"haidaochuan",
		"xuanzhuanmuma",
		"tiaolouji"
	}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		arg0_2.Respones:AddRawListener({
			"view",
			iter1_2
		}, function(arg0_3, arg1_3)
			if not arg1_3 then
				return
			end

			arg0_3.loader:GetSpriteQuiet("ui/AmusementParkUI_atlas", "entrance_" .. iter1_2 .. arg1_3, arg0_3["map_" .. iter1_2])

			local var0_3 = arg0_3["upper_" .. iter1_2]

			if not var0_3 or IsNil(var0_3:Find("Level")) then
				return
			end

			setText(var0_3:Find("Level"), "LV." .. arg1_3)
		end)
	end

	local var1_2 = {
		"guoshanche",
		"haidaochuan",
		"xuanzhuanmuma",
		"tiaolouji",
		"dangaobaoweizhan",
		"jiujiuduihuanwu"
	}

	for iter2_2, iter3_2 in ipairs(var1_2) do
		arg0_2.Respones:AddRawListener({
			"view",
			iter3_2 .. "Tip"
		}, function(arg0_4, arg1_4)
			local var0_4 = arg0_4["upper_" .. iter3_2]

			if not var0_4 or IsNil(var0_4:Find("Tip")) then
				return
			end

			setActive(var0_4:Find("Tip"), arg1_4)
		end)
	end

	arg0_2.Respones.hubData = {}

	arg0_2.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0_5, arg1_5)
		arg0_5.gameCountTxt.text = "X" .. arg1_5.count
	end, {
		strict = true
	})
	arg0_2.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0_6, arg1_6)
		arg0_6.materialTxt.text = arg1_6
	end)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.top:Find("Back"), function()
		arg0_7:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_7, arg0_7.top:Find("Home"), function()
		arg0_7:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_7, arg0_7.top:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.amusementpark_help.tip
		})
	end)
	onButton(arg0_7, arg0_7.top:Find("Invitation"), function()
		local var0_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY)

		if var0_11 and not var0_11:isEnd() then
			arg0_7:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0_11.id
			})
		end
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "jiujiuduihuanwu", function()
		arg0_7:emit(AmusementParkMediator.GO_SUBLAYER, Context.New({
			mediator = AmusementParkShopMediator,
			viewComponent = AmusementParkShopPage
		}))
	end)

	for iter0_7, iter1_7 in pairs(arg0_7.Buildings) do
		arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, iter1_7, function()
			arg0_7:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = BuildingUpgradeMediator,
				viewComponent = BuildingUpgradeLayer,
				data = {
					buildingID = iter0_7
				}
			}))
		end)
	end

	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "dangaobaoweizhan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 23)
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "huiyichengbao", function()
		arg0_7:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "xianshijianzao", function()
		arg0_7:emit(AmusementParkMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "huanzhuangshandian", function()
		arg0_7:emit(AmusementParkMediator.GO_SCENE, SCENE.SKINSHOP)
	end)

	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0_7:InitStudents(var0_7 and var0_7.id, 2, 3)
	arg0_7:UpdateView()
	arg0_7.loader:LoadPrefab("ui/houshan_caidai", "", function(arg0_18)
		setParent(arg0_18, arg0_7._map)
	end)
end

function var0_0.UpdateActivity(arg0_19, arg1_19)
	arg0_19.activity = arg1_19
	arg0_19.Respones.xuanzhuanmuma = arg1_19.data1KeyValueList[2][9] or 1
	arg0_19.Respones.guoshanche = arg1_19.data1KeyValueList[2][10] or 1
	arg0_19.Respones.tiaolouji = arg1_19.data1KeyValueList[2][11] or 1
	arg0_19.Respones.haidaochuan = arg1_19.data1KeyValueList[2][12] or 1

	local var0_19 = next(arg1_19.data1KeyValueList[1])

	arg0_19.Respones.materialCount = arg1_19.data1KeyValueList[1][var0_19] or 0

	arg0_19:UpdateView()
end

function var0_0.UpdateView(arg0_20)
	local var0_20
	local var1_20 = getProxy(ActivityProxy)

	arg0_20.Respones.xuanzhuanmumaTip = arg0_20:UpdateBuildingTip(arg0_20.activity, 9)
	arg0_20.Respones.guoshancheTip = arg0_20:UpdateBuildingTip(arg0_20.activity, 10)
	arg0_20.Respones.tiaoloujiTip = arg0_20:UpdateBuildingTip(arg0_20.activity, 11)
	arg0_20.Respones.haidaochuanTip = arg0_20:UpdateBuildingTip(arg0_20.activity, 12)

	local var2_20 = var1_20:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3_20 = getProxy(MiniGameProxy):GetHubByHubId(var2_20:getConfig("config_id"))
	local var4_20 = var3_20.count > 0

	arg0_20.Respones.dangaobaoweizhanTip = var4_20

	arg0_20:UpdateHubData(var3_20)

	arg0_20.Respones.jiujiuduihuanwuTip = AmusementParkShopPage.GetActivityShopTip()
end

function var0_0.UpdateHubData(arg0_21, arg1_21)
	arg0_21.Respones.hubData.count = arg1_21.count
	arg0_21.Respones.hubData.usedtime = arg1_21.usedtime
	arg0_21.Respones.hubData.id = arg1_21.id

	arg0_21.Respones:PropertyChange("hubData")
end

function var0_0.willExit(arg0_22)
	arg0_22:clearStudents()
	var0_0.super.willExit(arg0_22)
end

return var0_0
