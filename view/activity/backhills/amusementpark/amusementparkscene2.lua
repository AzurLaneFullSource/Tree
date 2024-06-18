local var0_0 = class("AmusementParkScene2", import("..TemplateMV.BackHillTemplate"))

var0_0.UIName = "AmusementParkUI2"
var0_0.edge2area = {
	default = "map_middle"
}
var0_0.Buildings = {
	[13] = "jiujiuchonglang",
	[15] = "huahuashijie",
	[16] = "jiujiupubu",
	[14] = "jiujiutiaoshui"
}

local var1_0 = 23

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
		arg0_1.map_middle
	}
	arg0_1.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph2"))
	arg0_1._upper = arg0_1:findTF("upper")

	for iter1_1 = 0, arg0_1._upper.childCount - 1 do
		local var2_1 = arg0_1._upper:GetChild(iter1_1)
		local var3_1 = go(var2_1).name

		arg0_1["upper_" .. var3_1] = var2_1
	end

	arg0_1.gameCountTxt = arg0_1.top:Find("GameCount/text"):GetComponent(typeof(Text))
	arg0_1.materialTxt = arg0_1.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(arg0_1.upper_jinianchengbao, false)

		GetOrAddComponent(arg0_1.map_jinianchengbao, typeof(Button)).enabled = false
	end

	arg0_1:RegisterDataResponse()

	arg0_1.loader = AutoLoader.New()
end

function var0_0.RegisterDataResponse(arg0_2)
	arg0_2.Respones = ResponsableTree.CreateShell({})

	arg0_2.Respones:SetRawData("view", arg0_2)

	local var0_2 = _.values(arg0_2.Buildings)

	for iter0_2, iter1_2 in ipairs(var0_2) do
		arg0_2.Respones:AddRawListener({
			"view",
			iter1_2
		}, function(arg0_3, arg1_3)
			if not arg1_3 then
				return
			end

			arg0_3.loader:GetSpriteQuiet("ui/AmusementParkUI2_atlas", "entrance_" .. iter1_2 .. arg1_3, arg0_3["map_" .. iter1_2])

			local var0_3 = arg0_3["upper_" .. iter1_2]

			if not var0_3 or IsNil(var0_3:Find("Level")) then
				return
			end

			setText(var0_3:Find("Level"), "LV." .. arg1_3)
		end)
	end

	local var1_2 = {
		"jiujiudalaotuan"
	}

	table.insertto(var1_2, var0_2)

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
			helps = pg.gametip.activity_event_building.tip
		})
	end)
	onButton(arg0_7, arg0_7.top:Find("Invitation"), function()
		local var0_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.JP_CEREMONY_INVITATION_ID)

		if var0_11 and not var0_11:isEnd() then
			arg0_7:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0_11.id
			})
		end
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

	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "jiujiudalaotuan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 30)
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "jinianchengbao", function()
		arg0_7:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0_7:BindItemSkinShop()
	arg0_7:BindItemBuildShip()

	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0_7:InitStudents(var0_7 and var0_7.id, 3, 4)
	arg0_7:UpdateView()
end

function var0_0.UpdateActivity(arg0_15, arg1_15)
	arg0_15.activity = arg1_15

	for iter0_15, iter1_15 in pairs(arg0_15.Buildings) do
		arg0_15.Respones[iter1_15] = arg1_15.data1KeyValueList[2][iter0_15] or 1
	end

	local var0_15 = next(arg1_15.data1KeyValueList[1])

	arg0_15.Respones.materialCount = arg1_15.data1KeyValueList[1][var0_15] or 0

	arg0_15:UpdateView()
end

function var0_0.UpdateView(arg0_16)
	local var0_16

	for iter0_16, iter1_16 in pairs(arg0_16.Buildings) do
		arg0_16.Respones[iter1_16 .. "Tip"] = arg0_16:UpdateBuildingTip(arg0_16.activity, iter0_16)
	end

	local var1_16 = getProxy(MiniGameProxy):GetHubByHubId(var1_0)
	local var2_16 = var1_16.count > 0

	arg0_16.Respones.jiujiudalaotuanTip = var2_16

	arg0_16:UpdateHubData(var1_16)
end

function var0_0.UpdateHubData(arg0_17, arg1_17)
	arg0_17.Respones.hubData.count = arg1_17.count
	arg0_17.Respones.hubData.usedtime = arg1_17.usedtime
	arg0_17.Respones.hubData.id = arg1_17.id

	arg0_17.Respones:PropertyChange("hubData")
end

function var0_0.willExit(arg0_18)
	arg0_18:clearStudents()
	var0_0.super.willExit(arg0_18)
end

return var0_0
