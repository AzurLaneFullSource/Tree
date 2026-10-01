local var0_0 = class("AnniversaryIsland2023Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIsland2023UI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)
	local var1_2 = arg0_2:CalculateSceneLevel()

	table.insert(var0_2, "ui/" .. arg0_2:getUIName() .. "_level" .. var1_2)

	return var0_2
end

var0_0.edge2area = {
	default = "_SDPlace"
}
var0_0.Buildings = {
	[24] = "craft",
	[25] = "adventure",
	[26] = "dining",
	[23] = "living"
}

function var0_0.Ctor(arg0_3)
	var0_0.super.Ctor(arg0_3)

	arg0_3.loader = AutoLoader.New()
end

function var0_0.preload(arg0_4, arg1_4)
	local var0_4 = arg0_4:CalculateSceneLevel()

	arg0_4.loader:LoadBundle("ui/" .. arg0_4:getUIName() .. "_level" .. var0_4, arg1_4)
end

function var0_0.init(arg0_5)
	arg0_5.top = arg0_5._tf:Find("top")
	arg0_5._bg = arg0_5._tf:Find("BG")
	arg0_5._map = arg0_5._tf:Find("map")

	for iter0_5 = 0, arg0_5._map.childCount - 1 do
		local var0_5 = arg0_5._map:GetChild(iter0_5)
		local var1_5 = go(var0_5).name

		arg0_5["map_" .. var1_5] = var0_5
	end

	arg0_5._upper = arg0_5._tf:Find("upper")

	for iter1_5 = 0, arg0_5._upper.childCount - 1 do
		local var2_5 = arg0_5._upper:GetChild(iter1_5)
		local var3_5 = go(var2_5).name

		arg0_5["upper_" .. var3_5] = var2_5
	end

	arg0_5._SDPlace = arg0_5._tf:Find("SDPlace")
	arg0_5.containers = {
		arg0_5._SDPlace
	}
	arg0_5._shipTpl = arg0_5._map:Find("ship")
	arg0_5.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AnniversaryIsland2023Graph"))
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("top/Back"), function()
		arg0_6:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6._tf:Find("top/Home"), function()
		arg0_6:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.haidaojudian_help.tip
		})
	end, SFX_PANEL)

	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_6:InitStudents(var0_6 and var0_6.id, 3, 4)

	for iter0_6, iter1_6 in pairs(arg0_6.Buildings) do
		arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, iter1_6, function()
			arg0_6:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
				viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
				data = {
					buildingID = iter0_6
				}
			}))
		end)
		eachChild(arg0_6._map:Find(iter1_6), function(arg0_11)
			GetComponent(arg0_11, typeof(Image)).alphaHitTestMinimumThreshold = 0.5

			setActive(arg0_11, false)
		end)
	end

	eachChild(arg0_6._map:Find("xianshijianzao"), function(arg0_12)
		GetComponent(arg0_12, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0_6._map:Find("huanzhuangshangdian"), function(arg0_13)
		GetComponent(arg0_13, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0_6._map:Find("taskboard"), function(arg0_14)
		GetComponent(arg0_14, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)

	GetComponent(arg0_6._map:Find("bigmap"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "craft", function()
		arg0_6:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH)
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "taskboard", function()
		local var0_16 = Context.New()

		SCENE.SetSceneInfo(var0_16, SCENE.ISLAND_TASK)
		arg0_6:emit(BackHillMediatorTemplate.GO_SUBLAYER, var0_16)
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "bigmap", function()
		arg0_6:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
			checkMain = true
		})
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "giftmake", function()
		arg0_6:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SCULPTURE)
	end)
	arg0_6:BindItemSkinShop()
	arg0_6:BindItemBuildShip()
	arg0_6:RegisterDataResponse()
	arg0_6:UpdateView()
end

function var0_0.UpdateActivity(arg0_19, arg1_19)
	arg0_19:UpdateView()
end

function var0_0.RegisterDataResponse(arg0_20)
	arg0_20.Respones = ResponsableTree.CreateShell({})

	arg0_20.Respones:SetRawData("view", arg0_20)

	local var0_20 = _.values(arg0_20.Buildings)

	for iter0_20, iter1_20 in ipairs(var0_20) do
		arg0_20.Respones:AddRawListener({
			"view",
			iter1_20
		}, function(arg0_21, arg1_21)
			if not arg1_21 then
				return
			end

			setActive(arg0_21["map_" .. iter1_20]:Find(tostring(arg1_21)), true)

			if arg1_21 - 1 > 0 then
				setActive(arg0_21["map_" .. iter1_20]:Find(tostring(arg1_21 - 1)), false)
			end

			local var0_21 = arg0_21["map_" .. iter1_20]:Find(tostring(arg1_21))

			arg0_21.loader:GetSpriteQuiet("ui/" .. arg0_20:getUIName() .. "_atlas", iter1_20 .. "_" .. arg1_21, var0_21, true)

			GetComponent(arg0_21["map_" .. iter1_20], typeof(Button)).targetGraphic = GetComponent(var0_21, typeof(Image))

			local var1_21 = arg0_21["upper_" .. iter1_20]

			if not var1_21 or IsNil(var1_21:Find("Level")) then
				return
			end

			arg0_21.loader:GetSpriteQuiet("ui/" .. arg0_20:getUIName() .. "_atlas", tostring(arg1_21), var1_21:Find("Level"), true)
		end)
	end

	arg0_20.Respones:AddRawListener(_.values(arg0_20.Buildings), function(...)
		local var0_22 = 0
		local var1_22 = {
			...
		}

		for iter0_22 = 1, table.getCount(arg0_20.Buildings) do
			var0_22 = var0_22 + (var1_22[iter0_22] or 1)
		end

		arg0_20.Respones.sceneLevel = math.floor(var0_22 / 4)
	end)
	arg0_20.Respones:AddRawListener({
		"sceneLevel",
		"view"
	}, function(arg0_23, arg1_23, arg2_23, arg3_23)
		local var0_23 = arg1_23[1]
		local var1_23 = arg1_23[2]

		local function var2_23(arg0_24)
			setActive(var1_23["map_" .. arg0_24]:Find(tostring(var0_23)), true)

			if arg2_23[1] then
				setActive(var1_23["map_" .. arg0_24]:Find(tostring(arg2_23[1])), false)
			end

			local var0_24 = {
				huanzhuangshangdian = "skinshop",
				xianshijianzao = "buildship",
				taskboard = "taskboard"
			}
			local var1_24 = var1_23["map_" .. arg0_24]:Find(tostring(var0_23))

			var1_23.loader:GetSpriteQuiet("ui/" .. arg0_20:getUIName() .. "_level" .. var0_23, var0_24[arg0_24], var1_24, true)

			GetComponent(var1_23["map_" .. arg0_24], typeof(Button)).targetGraphic = GetComponent(var1_24, typeof(Image))
		end

		var2_23("xianshijianzao")
		var2_23("huanzhuangshangdian")
		var2_23("taskboard")
		var1_23.loader:GetSpriteQuiet("ui/" .. arg0_20:getUIName() .. "_atlas", "title_" .. var0_23, var1_23._tf:Find("top/Title/Number"), true)
		var1_23.loader:GetSpriteQuiet("ui/" .. arg0_20:getUIName() .. "_level" .. var0_23, "bg", var1_23._tf:Find("map"))
	end, {
		useOldRef = true
	})

	local var1_20 = {
		"taskboard",
		"bigmap",
		"giftmake"
	}

	table.insertto(var1_20, var0_20)

	for iter2_20, iter3_20 in ipairs(var1_20) do
		arg0_20.Respones:AddRawListener({
			"view",
			iter3_20 .. "Tip"
		}, function(arg0_25, arg1_25)
			local var0_25 = arg0_25["upper_" .. iter3_20]

			if not var0_25 or IsNil(var0_25:Find("Tip")) then
				return
			end

			setActive(var0_25:Find("Tip"), arg1_25)
		end)
	end

	arg0_20.Respones.hubData = {}

	arg0_20.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0_26, arg1_26)
		arg0_26.gameCountTxt.text = "X " .. arg1_26.count
	end, {
		strict = true
	})
	arg0_20.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0_27, arg1_27)
		arg0_27.materialTxt.text = arg1_27
	end)
end

function var0_0.PlayStory()
	local var0_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
	local var1_28 = var0_28:GetTotalBuildingLevel()
	local var2_28 = {
		false,
		var0_28:getConfig("config_client").lv2Story,
		var0_28:getConfig("config_client").lv3Story,
		var0_28:getConfig("config_client").lv4Story
	}

	table.SerialIpairsAsync(var2_28, function(arg0_29, arg1_29, arg2_29)
		if arg0_29 <= var1_28 and arg1_29 then
			pg.NewStoryMgr.GetInstance():Play(arg1_29, arg2_29)
		else
			arg2_29()
		end
	end)
end

function var0_0.UpdateView(arg0_30)
	AnniversaryIsland2023Scene.PlayStory()

	local var0_30 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	for iter0_30, iter1_30 in pairs(arg0_30.Buildings) do
		arg0_30.Respones[iter1_30] = var0_30.data1KeyValueList[2][iter0_30] or 1
		arg0_30.Respones[iter1_30 .. "Tip"] = arg0_30:UpdateBuildingTip(var0_30, iter0_30)
	end

	local var1_30 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	arg0_30.Respones.craftTip = arg0_30.Respones.craftTip or var1_30:HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily()

	local function var2_30()
		local var0_31 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		return Activity.IsActivityReady(var0_31)
	end

	arg0_30.Respones.bigmapTip = tobool(var2_30())

	local function var3_30()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
	end

	arg0_30.Respones.taskboardTip = tobool(var3_30())

	local function var4_30()
		local var0_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

		return Activity.IsActivityReady(var0_33)
	end

	arg0_30.Respones.giftmakeTip = tobool(var4_30())
end

function var0_0.CalculateSceneLevel(arg0_34)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetTotalBuildingLevel()
end

function var0_0.UpdateBuildingTip(arg0_35, arg1_35, arg2_35)
	local var0_35 = var0_0.super.UpdateBuildingTip(arg0_35, arg1_35, arg2_35)

	if var0_35 then
		local var1_35 = arg1_35.data1KeyValueList[2][arg2_35] or 1

		var0_35 = var0_35 and var1_35 <= arg1_35:GetTotalBuildingLevel()
	end

	return var0_35
end

function var0_0.willExit(arg0_36)
	arg0_36:clearStudents()
	var0_0.super.willExit(arg0_36)
end

function var0_0.IsShowMainTip(arg0_37)
	if arg0_37 and not arg0_37:isEnd() then
		local function var0_37()
			local var0_38 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			return Activity.IsActivityReady(var0_38)
		end

		local function var1_37()
			local var0_39 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			for iter0_39, iter1_39 in ipairs(var0_39:GetBuildingIds()) do
				if AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var0_39, iter1_39) then
					return true
				end
			end

			if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH):HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily() then
				return true
			end
		end

		local function var2_37()
			return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
		end

		local function var3_37()
			local var0_41 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

			return Activity.IsActivityReady(var0_41)
		end

		return var0_37() or var1_37() or var2_37() or var3_37()
	end
end

return var0_0
