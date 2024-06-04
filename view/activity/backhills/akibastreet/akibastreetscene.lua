local var0 = class("AkibaStreetScene", import("..TemplateMV.BackHillTemplate"))

var0.UIName = "AkibaStreetUI"
var0.edge2area = {
	["4_5"] = "_bottom",
	default = "_middle",
	["5_6"] = "_bottom"
}
var0.Buildings = {
	nil,
	nil,
	nil,
	nil,
	"shudian",
	"youxidian",
	"moxingdian",
	"kafeiting"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AkibaGraph"))
	arg0.usableTxt = arg0.top:Find("usable_count/text"):GetComponent(typeof(Text))
	arg0.materialTxt = arg0.top:Find("material/text"):GetComponent(typeof(Text))

	arg0:RegisterDataResponse()

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(arg0._upper:Find("shujvhuigu"), false)

		GetOrAddComponent(arg0._map:Find("shujvhuigu"), typeof(Button)).enabled = false
	end
end

function var0.RegisterDataResponse(arg0)
	arg0.Respones = ResponsableTree.CreateShell({})

	arg0.Respones:SetRawData("view", arg0)

	local var0 = {
		"shudian",
		"youxidian",
		"moxingdian",
		"kafeiting"
	}

	for iter0, iter1 in ipairs(var0) do
		arg0.Respones:AddRawListener({
			"view",
			iter1
		}, function(arg0, arg1)
			if not arg1 then
				return
			end

			arg0.loader:GetSpriteQuiet("ui/AkibaStreetUI_atlas", iter1 .. arg1, arg0["map_" .. iter1])

			local var0 = arg0["upper_" .. iter1]

			if not var0 or IsNil(var0:Find("level")) then
				return
			end

			setText(var0:Find("level"), "LV." .. arg1)
		end)
	end

	local var1 = {
		"shudian",
		"youxidian",
		"moxingdian",
		"kafeiting",
		"jiejiting",
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
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY)

		if var0 and not var0:isEnd() then
			arg0:emit(ThirdAnniversarySquareMediator.GO_SCENE, SCENE.ACTIVITY, {
				id = var0.id
			})
		end
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

	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiejiting", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 14)
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
	arg0.loader:GetPrefab("ui/zhuanzhu_caidai", "zhuanzhu_caidai", function(arg0)
		setParent(arg0, arg0._map)

		local var0 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder

		pg.ViewUtils.SetSortingOrder(tf(arg0), var0 + 1)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, false)
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1
	arg0.Respones.shudian = arg1.data1KeyValueList[2][5] or 1
	arg0.Respones.youxidian = arg1.data1KeyValueList[2][6] or 1
	arg0.Respones.moxingdian = arg1.data1KeyValueList[2][7] or 1
	arg0.Respones.kafeiting = arg1.data1KeyValueList[2][8] or 1

	local var0 = next(arg1.data1KeyValueList[1])

	arg0.Respones.materialCount = arg1.data1KeyValueList[1][var0] or 0

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)

	arg0.Respones.shudianTip = arg0:UpdateBuildingTip(arg0.activity, 5)
	arg0.Respones.youxidianTip = arg0:UpdateBuildingTip(arg0.activity, 6)
	arg0.Respones.moxingdianTip = arg0:UpdateBuildingTip(arg0.activity, 7)
	arg0.Respones.kafeitingTip = arg0:UpdateBuildingTip(arg0.activity, 8)
	arg0.Respones.shujvhuiguTip = false

	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id"))

	arg0.Respones.jiejitingTip = var2.count > 0

	arg0:UpdateHubData(var2)

	if not arg0.InitStudentBegin then
		arg0:InitStudents(var1.id, 3, 4)

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
