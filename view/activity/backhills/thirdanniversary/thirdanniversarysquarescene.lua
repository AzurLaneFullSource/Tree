local var0_0 = class("ThirdAnniversarySquareScene", import("..TemplateMV.BackHillTemplate"))

var0_0.UIName = "ThirdAnniversarySquareUI"
var0_0.HUB_ID = 9
var0_0.edge2area = {
	default = "_middle",
	["3_4"] = "_bottom",
	["4_5"] = "_bottom",
	["7_7"] = "_front"
}
var0_0.Buildings = {
	"nvpukafeiting",
	"xiaolongbaodian",
	"zhajihanbaodian",
	"heguozidian"
}

function var0_0.init(arg0_1)
	arg0_1.loader = AutoLoader.New()
	arg0_1.top = arg0_1:findTF("top")
	arg0_1._map = arg0_1:findTF("map")

	for iter0_1 = 0, arg0_1._map.childCount - 1 do
		local var0_1 = arg0_1._map:GetChild(iter0_1)
		local var1_1 = go(var0_1).name

		arg0_1["map_" .. var1_1] = var0_1
	end

	arg0_1._upper = arg0_1:findTF("upper")

	for iter1_1 = 0, arg0_1._upper.childCount - 1 do
		local var2_1 = arg0_1._upper:GetChild(iter1_1)
		local var3_1 = go(var2_1).name

		arg0_1["upper_" .. var3_1] = var2_1
	end

	arg0_1._front = arg0_1._map:Find("top")
	arg0_1._middle = arg0_1._map:Find("middle")
	arg0_1._bottom = arg0_1._map:Find("bottom")
	arg0_1.containers = {
		arg0_1._front,
		arg0_1._middle,
		arg0_1._bottom
	}
	arg0_1._shipTpl = arg0_1._map:Find("ship")
	arg0_1.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.ThirdAnniversarySquareGraph"))
	arg0_1.usableTxt = arg0_1.top:Find("usable_count/text"):GetComponent(typeof(Text))
	arg0_1.materialTxt = arg0_1.top:Find("material/text"):GetComponent(typeof(Text))

	arg0_1:RegisterDataResponse()
end

function var0_0.RegisterDataResponse(arg0_2)
	arg0_2.Respones = ResponsableTree.CreateShell({})

	arg0_2.Respones:SetRawData("view", arg0_2)

	local var0_2 = {
		"xiaolongbaodian",
		"heguozidian",
		"nvpukafeiting",
		"zhajihanbaodian"
	}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		arg0_2.Respones:AddRawListener({
			"view",
			iter1_2
		}, function(arg0_3, arg1_3)
			if not arg1_3 then
				return
			end

			arg0_3.loader:GetSpriteQuiet("ui/thirdanniversarysquareui_atlas", iter1_2 .. arg1_3, arg0_3["map_" .. iter1_2])

			local var0_3 = arg0_3["upper_" .. iter1_2]

			if not var0_3 or IsNil(var0_3:Find("level")) then
				return
			end

			setText(var0_3:Find("level"), "LV." .. arg1_3)
		end)
	end

	local var1_2 = {
		"xiaolongbaodian",
		"heguozidian",
		"nvpukafeiting",
		"zhajihanbaodian",
		"gangqvchenlieshi",
		"huanzhuangshandian",
		"shujvhuigu",
		"xianshijianzao"
	}

	for iter2_2, iter3_2 in ipairs(var1_2) do
		arg0_2.Respones:AddRawListener({
			"view",
			iter3_2 .. "Tip"
		}, function(arg0_4, arg1_4)
			local var0_4 = arg0_4["upper_" .. iter3_2]

			if not var0_4 or IsNil(var0_4:Find("tip")) then
				return
			end

			setActive(var0_4:Find("tip"), arg1_4)
		end)
	end

	arg0_2.Respones.hubData = {}

	arg0_2.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0_5, arg1_5)
		arg0_5.usableTxt.text = "X" .. arg1_5.count
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
	onButton(arg0_7, arg0_7:findTF("top/return_btn"), function()
		arg0_7:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_7, arg0_7.top:Find("daka_count"), function()
		arg0_7:emit(ThirdAnniversarySquareMediator.ON_OPEN_TOWERCLIMBING_SIGNED)
	end)
	onButton(arg0_7, arg0_7:findTF("top/return_main_btn"), function()
		arg0_7:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_7, arg0_7:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.qingdianguangchang_help.tip
		})
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

	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "gangqvchenlieshi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 13)
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "shujvhuigu", function()
		arg0_7:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "xianshijianzao", function()
		arg0_7:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_7:InitFacilityCross(arg0_7._map, arg0_7._upper, "huanzhuangshandian", function()
		arg0_7:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.top, false)
end

function var0_0.UpdateActivity(arg0_17, arg1_17)
	arg0_17.activity = arg1_17
	arg0_17.Respones.nvpukafeiting = arg1_17.data1KeyValueList[2][1] or 1
	arg0_17.Respones.xiaolongbaodian = arg1_17.data1KeyValueList[2][2] or 1
	arg0_17.Respones.zhajihanbaodian = arg1_17.data1KeyValueList[2][3] or 1
	arg0_17.Respones.heguozidian = arg1_17.data1KeyValueList[2][4] or 1

	local var0_17 = next(arg1_17.data1KeyValueList[1])

	arg0_17.Respones.materialCount = arg1_17.data1KeyValueList[1][var0_17] or 0

	arg0_17:UpdateView()
end

function var0_0.UpdateView(arg0_18)
	local var0_18 = getProxy(ActivityProxy)

	arg0_18.Respones.nvpukafeitingTip = arg0_18:UpdateBuildingTip(arg0_18.activity, 1)
	arg0_18.Respones.xiaolongbaodianTip = arg0_18:UpdateBuildingTip(arg0_18.activity, 2)
	arg0_18.Respones.zhajihanbaodianTip = arg0_18:UpdateBuildingTip(arg0_18.activity, 3)
	arg0_18.Respones.heguozidianTip = arg0_18:UpdateBuildingTip(arg0_18.activity, 4)
	arg0_18.Respones.shujvhuiguTip = false

	local var1_18 = var0_18:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var2_18 = getProxy(MiniGameProxy):GetHubByHubId(var1_18:getConfig("config_id"))

	arg0_18.Respones.gangqvchenlieshiTip = var2_18.count > 0

	arg0_18:UpdateHubData(var2_18)

	if not arg0_18.InitStudentBegin then
		arg0_18:InitStudents(var1_18.id, 2, 3)

		arg0_18.InitStudentBegin = true
	end
end

function var0_0.UpdateHubData(arg0_19, arg1_19)
	arg0_19.Respones.hubData.count = arg1_19.count
	arg0_19.Respones.hubData.usedtime = arg1_19.usedtime
	arg0_19.Respones.hubData.id = arg1_19.id

	arg0_19.Respones:PropertyChange("hubData")
end

function var0_0.willExit(arg0_20)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20.top, arg0_20._tf)
	arg0_20:clearStudents()

	arg0_20.Respones = nil

	var0_0.super.willExit(arg0_20)
end

return var0_0
