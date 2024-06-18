local var0_0 = class("BackHillCampusFestival2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "BackHillCampusFestivalUI"
end

var0_0.edge2area = {
	default = "_SDPlace"
}
var0_0.Buildings = {
	[19] = "teachingbuilding",
	[20] = "astrologerstent",
	[21] = "stage",
	[22] = "shoppingstreet"
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
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	setActive(arg0_2.map_Decoration, false)

	arg0_2._SDPlace = arg0_2._map:Find("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2.gameCountTxt = arg0_2.top:Find("GameCount/Text"):GetComponent(typeof(Text))
	arg0_2.materialTxt = arg0_2.top:Find("Material/Text"):GetComponent(typeof(Text))
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillCampusFestiva2022Graph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.backhill_campusfestival_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Invitation"), function()
		local var0_7 = getProxy(ActivityProxy):getActivityById(ActivityConst.INVITATION_JP_FIFTH)

		if var0_7 and not var0_7:isEnd() then
			arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = var0_7.id
			})
		end
	end)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_CAKEMAKING)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "cakeshop", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 42)
	end)

	for iter0_3, iter1_3 in pairs(arg0_3.Buildings) do
		arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, iter1_3, function()
			arg0_3:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = BuildingUpgradeMediator,
				viewComponent = BuildingUpgradeLayer,
				data = {
					buildingID = iter0_3
				}
			}))
		end)
	end

	setActive(arg0_3.upper_shujvhuigu, PLATFORM_CODE == PLATFORM_JP)

	if PLATFORM_CODE == PLATFORM_JP then
		local function var1_3()
			arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shujvhuigu", var1_3)
	end

	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:RegisterDataResponse()
	arg0_3:UpdateView()
end

function var0_0.UpdateActivity(arg0_11, arg1_11)
	if arg1_11:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0_11:UpdateView()
	end
end

local var1_0 = {
	Vector2(-744, -187.3),
	Vector2(-744, -187.3),
	Vector2(-801.7, -149)
}

function var0_0.RegisterDataResponse(arg0_12)
	arg0_12.Respones = ResponsableTree.CreateShell({})

	arg0_12.Respones:SetRawData("view", arg0_12)

	local var0_12 = _.values(arg0_12.Buildings)

	for iter0_12, iter1_12 in ipairs(var0_12) do
		arg0_12.Respones:AddRawListener({
			"view",
			iter1_12
		}, function(arg0_13, arg1_13)
			if not arg1_13 then
				return
			end

			arg0_13.loader:GetSpriteQuiet("ui/" .. arg0_12:getUIName() .. "_atlas", "entrance_" .. iter1_12 .. arg1_13, arg0_13["map_" .. iter1_12], true)

			local var0_13 = arg0_13["upper_" .. iter1_12]

			if not var0_13 or IsNil(var0_13:Find("Lv")) then
				return
			end

			setText(var0_13:Find("Lv"), arg1_13)
		end)
	end

	arg0_12.Respones:AddRawListener({
		"view",
		"stage"
	}, function(arg0_14, arg1_14)
		local var0_14 = arg0_14.map_stage

		setAnchoredPosition(var0_14, var1_0[arg1_14])
	end)

	local var1_12 = {
		"cakeshop",
		"shujvhuigu"
	}

	table.insertto(var1_12, var0_12)

	for iter2_12, iter3_12 in ipairs(var1_12) do
		arg0_12.Respones:AddRawListener({
			"view",
			iter3_12 .. "Tip"
		}, function(arg0_15, arg1_15)
			local var0_15 = arg0_15["upper_" .. iter3_12]

			if not var0_15 or IsNil(var0_15:Find("Tip")) then
				return
			end

			setActive(var0_15:Find("Tip"), arg1_15)
		end)
	end

	arg0_12.Respones.hubData = {}

	arg0_12.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0_16, arg1_16)
		arg0_16.gameCountTxt.text = "X " .. arg1_16.count
	end, {
		strict = true
	})
	arg0_12.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0_17, arg1_17)
		arg0_17.materialTxt.text = arg1_17
	end)
end

function var0_0.UpdateView(arg0_18)
	local var0_18 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	for iter0_18, iter1_18 in pairs(arg0_18.Buildings) do
		arg0_18.Respones[iter1_18] = var0_18.data1KeyValueList[2][iter0_18] or 1
		arg0_18.Respones[iter1_18 .. "Tip"] = arg0_18:UpdateBuildingTip(var0_18, iter0_18)
	end

	local var1_18 = _.all(_.keys(arg0_18.Buildings), function(arg0_19)
		local var0_19 = var0_18.data1KeyValueList[2][arg0_19] or 1
		local var1_19 = pg.activity_event_building[arg0_19]

		return var1_19 and var0_19 >= #var1_19.buff
	end)

	setActive(arg0_18.map_Decoration, var1_18)

	local var2_18 = next(var0_18.data1KeyValueList[1])

	arg0_18.Respones.materialCount = var0_18.data1KeyValueList[1][var2_18] or 0

	local function var3_18()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_CAKEMAKING)
	end

	arg0_18.Respones.cakeshopTip = tobool(var3_18())

	local var4_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_CAKEMAKING)
	local var5_18 = getProxy(MiniGameProxy):GetHubByHubId(var4_18:getConfig("config_id"))

	arg0_18:UpdateHubData(var5_18)

	local function var6_18()
		if PLATFORM_CODE ~= PLATFORM_JP then
			return
		end

		local var0_21 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_21)
	end

	arg0_18.Respones.shujvhuiguTip = tobool(var6_18())
end

function var0_0.UpdateHubData(arg0_22, arg1_22)
	arg0_22.Respones.hubData.count = arg1_22.count
	arg0_22.Respones.hubData.usedtime = arg1_22.usedtime
	arg0_22.Respones.hubData.id = arg1_22.id

	arg0_22.Respones:PropertyChange("hubData")
end

function var0_0.IsShowMainTip(arg0_23)
	local function var0_23()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_CAKEMAKING)
	end

	local function var1_23()
		local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

		return Activity.IsActivityReady(var0_25)
	end

	local function var2_23()
		if PLATFORM_CODE ~= PLATFORM_JP then
			return
		end

		local var0_26 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_26)
	end

	return var0_23() or var1_23() or var2_23()
end

function var0_0.willExit(arg0_27)
	arg0_27:clearStudents()
	var0_0.super.willExit(arg0_27)
end

return var0_0
