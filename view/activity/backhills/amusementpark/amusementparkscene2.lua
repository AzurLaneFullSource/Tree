local var0 = class("AmusementParkScene2", import("..TemplateMV.BackHillTemplate"))

var0.UIName = "AmusementParkUI2"
var0.edge2area = {
	default = "map_middle"
}
var0.Buildings = {
	[13] = "jiujiuchonglang",
	[15] = "huahuashijie",
	[16] = "jiujiupubu",
	[14] = "jiujiutiaoshui"
}

local var1 = 23

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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph2"))
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.gameCountTxt = arg0.top:Find("GameCount/text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(arg0.upper_jinianchengbao, false)

		GetOrAddComponent(arg0.map_jinianchengbao, typeof(Button)).enabled = false
	end

	arg0:RegisterDataResponse()

	arg0.loader = AutoLoader.New()
end

function var0.RegisterDataResponse(arg0)
	arg0.Respones = ResponsableTree.CreateShell({})

	arg0.Respones:SetRawData("view", arg0)

	local var0 = _.values(arg0.Buildings)

	for iter0, iter1 in ipairs(var0) do
		arg0.Respones:AddRawListener({
			"view",
			iter1
		}, function(arg0, arg1)
			if not arg1 then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/AmusementParkUI2_atlas", "entrance_" .. iter1 .. arg1, arg0["map_" .. iter1])

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("Level")) then
				return
			end

			setText(var0:Find("Level"), "LV." .. arg1)
		end)
	end

	local var1 = {
		"jiujiudalaotuan"
	}

	table.insertto(var1, var0)

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
			helps = pg.gametip.activity_event_building.tip
		})
	end)
	onButton(arg0, arg0.top:Find("Invitation"), function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.JP_CEREMONY_INVITATION_ID)

		if var0 and not var0:isEnd() then
			arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0.id
			})
		end
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

	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiudalaotuan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 30)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jinianchengbao", function()
		arg0:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:UpdateView()
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0.Respones[iter1] = arg1.data1KeyValueList[2][iter0] or 1
	end

	local var0 = next(arg1.data1KeyValueList[1])

	arg0.Respones.materialCount = arg1.data1KeyValueList[1][var0] or 0

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0.Respones[iter1 .. "Tip"] = arg0:UpdateBuildingTip(arg0.activity, iter0)
	end

	local var1 = getProxy(MiniGameProxy):GetHubByHubId(var1)
	local var2 = var1.count > 0

	arg0.Respones.jiujiudalaotuanTip = var2

	arg0:UpdateHubData(var1)
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
