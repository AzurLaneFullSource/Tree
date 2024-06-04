local var0 = class("AnniversaryIsland2023Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "AnniversaryIsland2023UI"
end

var0.edge2area = {
	default = "_SDPlace"
}
var0.Buildings = {
	[24] = "craft",
	[25] = "adventure",
	[26] = "dining",
	[23] = "living"
}

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)

	arg0.loader = AutoLoader.New()
end

function var0.preload(arg0, arg1)
	local var0 = arg0:CalculateSceneLevel()

	arg0.loader:LoadBundle("ui/" .. arg0:getUIName() .. "_level" .. var0, arg1)
end

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._bg = arg0:findTF("BG")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0._SDPlace = arg0._tf:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AnniversaryIsland2023Graph"))
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
			helps = pg.gametip.haidaojudian_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0:InitStudents(var0 and var0.id, 3, 4)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0:InitFacilityCross(arg0._map, arg0._upper, iter1, function()
			arg0:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
				viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
				data = {
					buildingID = iter0
				}
			}))
		end)
		eachChild(arg0._map:Find(iter1), function(arg0)
			GetComponent(arg0, typeof(Image)).alphaHitTestMinimumThreshold = 0.5

			setActive(arg0, false)
		end)
	end

	eachChild(arg0._map:Find("xianshijianzao"), function(arg0)
		GetComponent(arg0, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0._map:Find("huanzhuangshangdian"), function(arg0)
		GetComponent(arg0, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0._map:Find("taskboard"), function(arg0)
		GetComponent(arg0, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)

	GetComponent(arg0._map:Find("bigmap"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

	arg0:InitFacilityCross(arg0._map, arg0._upper, "craft", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "taskboard", function()
		local var0 = Context.New()

		SCENE.SetSceneInfo(var0, SCENE.ISLAND_TASK)
		arg0:emit(BackHillMediatorTemplate.GO_SUBLAYER, var0)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bigmap", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
			checkMain = true
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "giftmake", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SCULPTURE)
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:RegisterDataResponse()
	arg0:UpdateView()
end

function var0.UpdateActivity(arg0, arg1)
	arg0:UpdateView()
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

			setActive(arg0["map_" .. iter1]:Find(tostring(arg1)), true)

			if arg1 - 1 > 0 then
				setActive(arg0["map_" .. iter1]:Find(tostring(arg1 - 1)), false)
			end

			local var0 = arg0["map_" .. iter1]:Find(tostring(arg1))

			arg0.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_atlas", iter1 .. "_" .. arg1, var0, true)

			GetComponent(arg0["map_" .. iter1], typeof(Button)).targetGraphic = GetComponent(var0, typeof(Image))

			local var1 = arg0["upper_" .. iter1]

			if not var1 or IsNil(var1:Find("Level")) then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_atlas", tostring(arg1), var1:Find("Level"), true)
		end)
	end

	arg0.Respones:AddRawListener(_.values(arg0.Buildings), function(...)
		local var0 = 0
		local var1 = {
			...
		}

		for iter0 = 1, table.getCount(arg0.Buildings) do
			var0 = var0 + (var1[iter0] or 1)
		end

		arg0.Respones.sceneLevel = math.floor(var0 / 4)
	end)
	arg0.Respones:AddRawListener({
		"sceneLevel",
		"view"
	}, function(arg0, arg1, arg2, arg3)
		local var0 = arg1[1]
		local var1 = arg1[2]

		local function var2(arg0)
			setActive(var1["map_" .. arg0]:Find(tostring(var0)), true)

			if arg2[1] then
				setActive(var1["map_" .. arg0]:Find(tostring(arg2[1])), false)
			end

			local var0 = {
				huanzhuangshangdian = "skinshop",
				xianshijianzao = "buildship",
				taskboard = "taskboard"
			}
			local var1 = var1["map_" .. arg0]:Find(tostring(var0))

			var1.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_level" .. var0, var0[arg0], var1, true)

			GetComponent(var1["map_" .. arg0], typeof(Button)).targetGraphic = GetComponent(var1, typeof(Image))
		end

		var2("xianshijianzao")
		var2("huanzhuangshangdian")
		var2("taskboard")
		var1.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_atlas", "title_" .. var0, var1:findTF("top/Title/Number"), true)
		var1.loader:GetSpriteQuiet("ui/" .. arg0:getUIName() .. "_level" .. var0, "bg", var1:findTF("map"))
	end, {
		useOldRef = true
	})

	local var1 = {
		"taskboard",
		"bigmap",
		"giftmake"
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

function var0.PlayStory()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
	local var1 = var0:GetTotalBuildingLevel()
	local var2 = {
		false,
		var0:getConfig("config_client").lv2Story,
		var0:getConfig("config_client").lv3Story,
		var0:getConfig("config_client").lv4Story
	}

	table.SerialIpairsAsync(var2, function(arg0, arg1, arg2)
		if arg0 <= var1 and arg1 then
			pg.NewStoryMgr.GetInstance():Play(arg1, arg2)
		else
			arg2()
		end
	end)
end

function var0.UpdateView(arg0)
	AnniversaryIsland2023Scene.PlayStory()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	for iter0, iter1 in pairs(arg0.Buildings) do
		arg0.Respones[iter1] = var0.data1KeyValueList[2][iter0] or 1
		arg0.Respones[iter1 .. "Tip"] = arg0:UpdateBuildingTip(var0, iter0)
	end

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	arg0.Respones.craftTip = arg0.Respones.craftTip or var1:HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily()

	local function var2()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		return Activity.IsActivityReady(var0)
	end

	arg0.Respones.bigmapTip = tobool(var2())

	local function var3()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
	end

	arg0.Respones.taskboardTip = tobool(var3())

	local function var4()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

		return Activity.IsActivityReady(var0)
	end

	arg0.Respones.giftmakeTip = tobool(var4())
end

function var0.CalculateSceneLevel(arg0)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetTotalBuildingLevel()
end

function var0.UpdateBuildingTip(arg0, arg1, arg2)
	local var0 = var0.super.UpdateBuildingTip(arg0, arg1, arg2)

	if var0 then
		local var1 = arg1.data1KeyValueList[2][arg2] or 1

		var0 = var0 and var1 <= arg1:GetTotalBuildingLevel()
	end

	return var0
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		local function var0()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			return Activity.IsActivityReady(var0)
		end

		local function var1()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			for iter0, iter1 in ipairs(var0:GetBuildingIds()) do
				if AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var0, iter1) then
					return true
				end
			end

			if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH):HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily() then
				return true
			end
		end

		local function var2()
			return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
		end

		local function var3()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

			return Activity.IsActivityReady(var0)
		end

		return var0() or var1() or var2() or var3()
	end
end

return var0
