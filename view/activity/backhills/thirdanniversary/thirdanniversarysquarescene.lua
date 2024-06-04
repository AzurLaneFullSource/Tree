local var0 = class("ThirdAnniversarySquareScene", import("..TemplateMV.BackHillTemplate"))

var0.UIName = "ThirdAnniversarySquareUI"
var0.HUB_ID = 9
var0.edge2area = {
	default = "_middle",
	["3_4"] = "_bottom",
	["4_5"] = "_bottom",
	["7_7"] = "_front"
}
var0.Buildings = {
	"nvpukafeiting",
	"xiaolongbaodian",
	"zhajihanbaodian",
	"heguozidian"
}

function var0.init(arg0)
	arg0.loader = AutoLoader.New()
	arg0.top = arg0:findTF("top")
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

	arg0._front = arg0._map:Find("top")
	arg0._middle = arg0._map:Find("middle")
	arg0._bottom = arg0._map:Find("bottom")
	arg0.containers = {
		arg0._front,
		arg0._middle,
		arg0._bottom
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.ThirdAnniversarySquareGraph"))
	arg0.usableTxt = arg0.top:Find("usable_count/text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("material/text"):GetComponent(typeof(Text))

	arg0:RegisterDataResponse()
end

function var0.RegisterDataResponse(arg0)
	arg0.Respones = ResponsableTree.CreateShell({})

	arg0.Respones:SetRawData("view", arg0)

	local var0 = {
		"xiaolongbaodian",
		"heguozidian",
		"nvpukafeiting",
		"zhajihanbaodian"
	}

	for iter0, iter1 in ipairs(var0) do
		arg0.Respones:AddRawListener({
			"view",
			iter1
		}, function(arg0, arg1)
			if not arg1 then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/thirdanniversarysquareui_atlas", iter1 .. arg1, arg0["map_" .. iter1])

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("level")) then
				return
			end

			setText(var0:Find("level"), "LV." .. arg1)
		end)
	end

	local var1 = {
		"xiaolongbaodian",
		"heguozidian",
		"nvpukafeiting",
		"zhajihanbaodian",
		"gangqvchenlieshi",
		"huanzhuangshandian",
		"shujvhuigu",
		"xianshijianzao"
	}

	for iter2, iter3 in ipairs(var1) do
		arg0.Respones:AddRawListener({
			"view",
			iter3 .. "Tip"
		}, function(arg0, arg1)
			local var0 = arg0["upper_" .. iter3]

			if not var0 or IsNil(var0:Find("tip")) then
				return
			end

			setActive(var0:Find("tip"), arg1)
		end)
	end

	arg0.Respones.hubData = {}

	arg0.Respones:AddRawListener({
		"view",
		"hubData"
	}, function(arg0, arg1)
		arg0.usableTxt.text = "X" .. arg1.count
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
	onButton(arg0, arg0:findTF("top/return_btn"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0.top:Find("daka_count"), function()
		arg0:emit(ThirdAnniversarySquareMediator.ON_OPEN_TOWERCLIMBING_SIGNED)
	end)
	onButton(arg0, arg0:findTF("top/return_main_btn"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.qingdianguangchang_help.tip
		})
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

	arg0:InitFacilityCross(arg0._map, arg0._upper, "gangqvchenlieshi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 13)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shujvhuigu", function()
		arg0:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xianshijianzao", function()
		arg0:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huanzhuangshandian", function()
		arg0:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, false)
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1
	arg0.Respones.nvpukafeiting = arg1.data1KeyValueList[2][1] or 1
	arg0.Respones.xiaolongbaodian = arg1.data1KeyValueList[2][2] or 1
	arg0.Respones.zhajihanbaodian = arg1.data1KeyValueList[2][3] or 1
	arg0.Respones.heguozidian = arg1.data1KeyValueList[2][4] or 1

	local var0 = next(arg1.data1KeyValueList[1])

	arg0.Respones.materialCount = arg1.data1KeyValueList[1][var0] or 0

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)

	arg0.Respones.nvpukafeitingTip = arg0:UpdateBuildingTip(arg0.activity, 1)
	arg0.Respones.xiaolongbaodianTip = arg0:UpdateBuildingTip(arg0.activity, 2)
	arg0.Respones.zhajihanbaodianTip = arg0:UpdateBuildingTip(arg0.activity, 3)
	arg0.Respones.heguozidianTip = arg0:UpdateBuildingTip(arg0.activity, 4)
	arg0.Respones.shujvhuiguTip = false

	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id"))

	arg0.Respones.gangqvchenlieshiTip = var2.count > 0

	arg0:UpdateHubData(var2)

	if not arg0.InitStudentBegin then
		arg0:InitStudents(var1.id, 2, 3)

		arg0.InitStudentBegin = true
	end
end

function var0.UpdateHubData(arg0, arg1)
	arg0.Respones.hubData.count = arg1.count
	arg0.Respones.hubData.usedtime = arg1.usedtime
	arg0.Respones.hubData.id = arg1.id

	arg0.Respones:PropertyChange("hubData")
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	arg0:clearStudents()

	arg0.Respones = nil

	var0.super.willExit(arg0)
end

return var0
