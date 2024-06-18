local var0_0 = class("AnniversaryIsland2023Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIsland2023UI"
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

function var0_0.Ctor(arg0_2)
	var0_0.super.Ctor(arg0_2)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = arg0_3:CalculateSceneLevel()

	arg0_3.loader:LoadBundle("ui/" .. arg0_3:getUIName() .. "_level" .. var0_3, arg1_3)
end

function var0_0.init(arg0_4)
	arg0_4.top = arg0_4:findTF("top")
	arg0_4._bg = arg0_4:findTF("BG")
	arg0_4._map = arg0_4:findTF("map")

	for iter0_4 = 0, arg0_4._map.childCount - 1 do
		local var0_4 = arg0_4._map:GetChild(iter0_4)
		local var1_4 = go(var0_4).name

		arg0_4["map_" .. var1_4] = var0_4
	end

	arg0_4._upper = arg0_4:findTF("upper")

	for iter1_4 = 0, arg0_4._upper.childCount - 1 do
		local var2_4 = arg0_4._upper:GetChild(iter1_4)
		local var3_4 = go(var2_4).name

		arg0_4["upper_" .. var3_4] = var2_4
	end

	arg0_4._SDPlace = arg0_4._tf:Find("SDPlace")
	arg0_4.containers = {
		arg0_4._SDPlace
	}
	arg0_4._shipTpl = arg0_4._map:Find("ship")
	arg0_4.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AnniversaryIsland2023Graph"))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5:findTF("top/Back"), function()
		arg0_5:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5:findTF("top/Home"), function()
		arg0_5:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.haidaojudian_help.tip
		})
	end, SFX_PANEL)

	local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_5:InitStudents(var0_5 and var0_5.id, 3, 4)

	for iter0_5, iter1_5 in pairs(arg0_5.Buildings) do
		arg0_5:InitFacilityCross(arg0_5._map, arg0_5._upper, iter1_5, function()
			arg0_5:emit(BackHillMediatorTemplate.GO_SUBLAYER, Context.New({
				mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
				viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
				data = {
					buildingID = iter0_5
				}
			}))
		end)
		eachChild(arg0_5._map:Find(iter1_5), function(arg0_10)
			GetComponent(arg0_10, typeof(Image)).alphaHitTestMinimumThreshold = 0.5

			setActive(arg0_10, false)
		end)
	end

	eachChild(arg0_5._map:Find("xianshijianzao"), function(arg0_11)
		GetComponent(arg0_11, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0_5._map:Find("huanzhuangshangdian"), function(arg0_12)
		GetComponent(arg0_12, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)
	eachChild(arg0_5._map:Find("taskboard"), function(arg0_13)
		GetComponent(arg0_13, typeof(Image)).alphaHitTestMinimumThreshold = 0.5
	end)

	GetComponent(arg0_5._map:Find("bigmap"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

	arg0_5:InitFacilityCross(arg0_5._map, arg0_5._upper, "craft", function()
		arg0_5:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH)
	end)
	arg0_5:InitFacilityCross(arg0_5._map, arg0_5._upper, "taskboard", function()
		local var0_15 = Context.New()

		SCENE.SetSceneInfo(var0_15, SCENE.ISLAND_TASK)
		arg0_5:emit(BackHillMediatorTemplate.GO_SUBLAYER, var0_15)
	end)
	arg0_5:InitFacilityCross(arg0_5._map, arg0_5._upper, "bigmap", function()
		arg0_5:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
			checkMain = true
		})
	end)
	arg0_5:InitFacilityCross(arg0_5._map, arg0_5._upper, "giftmake", function()
		arg0_5:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SCULPTURE)
	end)
	arg0_5:BindItemSkinShop()
	arg0_5:BindItemBuildShip()
	arg0_5:RegisterDataResponse()
	arg0_5:UpdateView()
end

function var0_0.UpdateActivity(arg0_18, arg1_18)
	arg0_18:UpdateView()
end

function var0_0.RegisterDataResponse(arg0_19)
	arg0_19.Respones = ResponsableTree.CreateShell({})

	arg0_19.Respones:SetRawData("view", arg0_19)

	local var0_19 = _.values(arg0_19.Buildings)

	for iter0_19, iter1_19 in ipairs(var0_19) do
		arg0_19.Respones:AddRawListener({
			"view",
			iter1_19
		}, function(arg0_20, arg1_20)
			if not arg1_20 then
				return
			end

			setActive(arg0_20["map_" .. iter1_19]:Find(tostring(arg1_20)), true)

			if arg1_20 - 1 > 0 then
				setActive(arg0_20["map_" .. iter1_19]:Find(tostring(arg1_20 - 1)), false)
			end

			local var0_20 = arg0_20["map_" .. iter1_19]:Find(tostring(arg1_20))

			arg0_20.loader:GetSpriteQuiet("ui/" .. arg0_19:getUIName() .. "_atlas", iter1_19 .. "_" .. arg1_20, var0_20, true)

			GetComponent(arg0_20["map_" .. iter1_19], typeof(Button)).targetGraphic = GetComponent(var0_20, typeof(Image))

			local var1_20 = arg0_20["upper_" .. iter1_19]

			if not var1_20 or IsNil(var1_20:Find("Level")) then
				return
			end

			arg0_20.loader:GetSpriteQuiet("ui/" .. arg0_19:getUIName() .. "_atlas", tostring(arg1_20), var1_20:Find("Level"), true)
		end)
	end

	arg0_19.Respones:AddRawListener(_.values(arg0_19.Buildings), function(...)
		local var0_21 = 0
		local var1_21 = {
			...
		}

		for iter0_21 = 1, table.getCount(arg0_19.Buildings) do
			var0_21 = var0_21 + (var1_21[iter0_21] or 1)
		end

		arg0_19.Respones.sceneLevel = math.floor(var0_21 / 4)
	end)
	arg0_19.Respones:AddRawListener({
		"sceneLevel",
		"view"
	}, function(arg0_22, arg1_22, arg2_22, arg3_22)
		local var0_22 = arg1_22[1]
		local var1_22 = arg1_22[2]

		local function var2_22(arg0_23)
			setActive(var1_22["map_" .. arg0_23]:Find(tostring(var0_22)), true)

			if arg2_22[1] then
				setActive(var1_22["map_" .. arg0_23]:Find(tostring(arg2_22[1])), false)
			end

			local var0_23 = {
				huanzhuangshangdian = "skinshop",
				xianshijianzao = "buildship",
				taskboard = "taskboard"
			}
			local var1_23 = var1_22["map_" .. arg0_23]:Find(tostring(var0_22))

			var1_22.loader:GetSpriteQuiet("ui/" .. arg0_19:getUIName() .. "_level" .. var0_22, var0_23[arg0_23], var1_23, true)

			GetComponent(var1_22["map_" .. arg0_23], typeof(Button)).targetGraphic = GetComponent(var1_23, typeof(Image))
		end

		var2_22("xianshijianzao")
		var2_22("huanzhuangshangdian")
		var2_22("taskboard")
		var1_22.loader:GetSpriteQuiet("ui/" .. arg0_19:getUIName() .. "_atlas", "title_" .. var0_22, var1_22:findTF("top/Title/Number"), true)
		var1_22.loader:GetSpriteQuiet("ui/" .. arg0_19:getUIName() .. "_level" .. var0_22, "bg", var1_22:findTF("map"))
	end, {
		useOldRef = true
	})

	local var1_19 = {
		"taskboard",
		"bigmap",
		"giftmake"
	}

	table.insertto(var1_19, var0_19)

	for iter2_19, iter3_19 in ipairs(var1_19) do
		arg0_19.Respones:AddRawListener({
			"view",
			iter3_19 .. "Tip"
		}, function(arg0_24, arg1_24)
			local var0_24 = arg0_24["upper_" .. iter3_19]

			if not var0_24 or IsNil(var0_24:Find("Tip")) then
				return
			end

			setActive(var0_24:Find("Tip"), arg1_24)
		end)
	end

	arg0_19.Respones.hubData = {}

	arg0_19.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0_25, arg1_25)
		arg0_25.gameCountTxt.text = "X " .. arg1_25.count
	end, {
		strict = true
	})
	arg0_19.Respones:AddRawListener({
		"view",
		"materialCount"
	}, function(arg0_26, arg1_26)
		arg0_26.materialTxt.text = arg1_26
	end)
end

function var0_0.PlayStory()
	local var0_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
	local var1_27 = var0_27:GetTotalBuildingLevel()
	local var2_27 = {
		false,
		var0_27:getConfig("config_client").lv2Story,
		var0_27:getConfig("config_client").lv3Story,
		var0_27:getConfig("config_client").lv4Story
	}

	table.SerialIpairsAsync(var2_27, function(arg0_28, arg1_28, arg2_28)
		if arg0_28 <= var1_27 and arg1_28 then
			pg.NewStoryMgr.GetInstance():Play(arg1_28, arg2_28)
		else
			arg2_28()
		end
	end)
end

function var0_0.UpdateView(arg0_29)
	AnniversaryIsland2023Scene.PlayStory()

	local var0_29 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	for iter0_29, iter1_29 in pairs(arg0_29.Buildings) do
		arg0_29.Respones[iter1_29] = var0_29.data1KeyValueList[2][iter0_29] or 1
		arg0_29.Respones[iter1_29 .. "Tip"] = arg0_29:UpdateBuildingTip(var0_29, iter0_29)
	end

	local var1_29 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	arg0_29.Respones.craftTip = arg0_29.Respones.craftTip or var1_29:HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily()

	local function var2_29()
		local var0_30 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		return Activity.IsActivityReady(var0_30)
	end

	arg0_29.Respones.bigmapTip = tobool(var2_29())

	local function var3_29()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
	end

	arg0_29.Respones.taskboardTip = tobool(var3_29())

	local function var4_29()
		local var0_32 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

		return Activity.IsActivityReady(var0_32)
	end

	arg0_29.Respones.giftmakeTip = tobool(var4_29())
end

function var0_0.CalculateSceneLevel(arg0_33)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetTotalBuildingLevel()
end

function var0_0.UpdateBuildingTip(arg0_34, arg1_34, arg2_34)
	local var0_34 = var0_0.super.UpdateBuildingTip(arg0_34, arg1_34, arg2_34)

	if var0_34 then
		local var1_34 = arg1_34.data1KeyValueList[2][arg2_34] or 1

		var0_34 = var0_34 and var1_34 <= arg1_34:GetTotalBuildingLevel()
	end

	return var0_34
end

function var0_0.willExit(arg0_35)
	arg0_35:clearStudents()
	var0_0.super.willExit(arg0_35)
end

function var0_0.IsShowMainTip(arg0_36)
	if arg0_36 and not arg0_36:isEnd() then
		local function var0_36()
			local var0_37 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			return Activity.IsActivityReady(var0_37)
		end

		local function var1_36()
			local var0_38 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			for iter0_38, iter1_38 in ipairs(var0_38:GetBuildingIds()) do
				if AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var0_38, iter1_38) then
					return true
				end
			end

			if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH):HasAvaliableFormula() and getProxy(SettingsProxy):IsTipWorkbenchDaily() then
				return true
			end
		end

		local function var2_36()
			return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID)
		end

		local function var3_36()
			local var0_40 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

			return Activity.IsActivityReady(var0_40)
		end

		return var0_36() or var1_36() or var2_36() or var3_36()
	end
end

return var0_0
