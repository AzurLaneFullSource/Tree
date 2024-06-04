local var0 = class("BackHillCampusFestival2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "BackHillCampusFestivalUI"
end

var0.edge2area = {
	default = "_SDPlace"
}
var0.Buildings = {
	[19] = "teachingbuilding",
	[20] = "astrologerstent",
	[21] = "stage",
	[22] = "shoppingstreet"
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
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	setActive(arg0.map_Decoration, false)

	arg0._SDPlace = arg0._map:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0.gameCountTxt = arg0.top:Find("GameCount/Text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("Material/Text"):GetComponent(typeof(Text))
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillCampusFestiva2022Graph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.backhill_campusfestival_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Invitation"), function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.INVITATION_JP_FIFTH)

		if var0 and not var0:isEnd() then
			arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0.id
			})
		end
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_CAKEMAKING)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "cakeshop", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 42)
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

	setActive(arg0.upper_shujvhuigu, PLATFORM_CODE == PLATFORM_JP)

	if PLATFORM_CODE == PLATFORM_JP then
		local function var1()
			arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		arg0:InitFacilityCross(arg0._map, arg0._upper, "shujvhuigu", var1)
	end

	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:RegisterDataResponse()
	arg0:UpdateView()
end

function var0.UpdateActivity(arg0, arg1)
	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0:UpdateView()
	end
end

local var1 = {
	Vector2(-744, -187.3),
	Vector2(-744, -187.3),
	Vector2(-801.7, -149)
}

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

			arg0.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_atlas", "entrance_" .. iter1 .. arg1, arg0["map_" .. iter1], true)

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("Lv")) then
				return
			end

			setText(var0:Find("Lv"), arg1)
		end)
	end

	arg0.Respones:AddRawListener({
		"view",
		"stage"
	}, function(arg0, arg1)
		local var0 = arg0.map_stage

		setAnchoredPosition(var0, var1[arg1])
	end)

	local var1 = {
		"cakeshop",
		"shujvhuigu"
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
		arg0.gameCountTxt.text = "X " .. arg1.count
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

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0.Respones[iter1] = var0.data1KeyValueList[2][iter0] or 1
		arg0.Respones[iter1 .. "Tip"] = arg0:UpdateBuildingTip(var0, iter0)
	end

	local var1 = _.all(_.keys(arg0.Buildings), function(arg0)
		local var0 = var0.data1KeyValueList[2][arg0] or 1
		local var1 = pg.activity_event_building[arg0]

		return var1 and var0 >= #var1.buff
	end)

	setActive(arg0.map_Decoration, var1)

	local var2 = next(var0.data1KeyValueList[1])

	arg0.Respones.materialCount = var0.data1KeyValueList[1][var2] or 0

	local function var3()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_CAKEMAKING)
	end

	arg0.Respones.cakeshopTip = tobool(var3())

	local var4 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_CAKEMAKING)
	local var5 = getProxy(MiniGameProxy):GetHubByHubId(var4:getConfig("config_id"))

	arg0:UpdateHubData(var5)

	local function var6()
		if PLATFORM_CODE ~= PLATFORM_JP then
			return
		end

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0)
	end

	arg0.Respones.shujvhuiguTip = tobool(var6())
end

function var0.UpdateHubData(arg0, arg1)
	arg0.Respones.hubData.count = arg1.count
	arg0.Respones.hubData.usedtime = arg1.usedtime
	arg0.Respones.hubData.id = arg1.id

	arg0.Respones:PropertyChange("hubData")
end

function var0.IsShowMainTip(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_CAKEMAKING)
	end

	local function var1()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

		return Activity.IsActivityReady(var0)
	end

	local function var2()
		if PLATFORM_CODE ~= PLATFORM_JP then
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
