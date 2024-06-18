local var0_0 = class("NewyearFestivalScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewyearFestivalUI"
end

var0_0.HUB_ID = 4

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._closeBtn = arg0_2:findTF("top/back")
	arg0_2._homeBtn = arg0_2:findTF("top/home")
	arg0_2._helpBtn = arg0_2:findTF("top/help")
	arg0_2.ticketTimes = arg0_2.top:Find("ticket/text")
	arg0_2.yinhuace = arg0_2.top:Find("sign")
	arg0_2.yinhuaceTimes = arg0_2.yinhuace:Find("get")
	arg0_2.yinhuaceTips = arg0_2.yinhuace:Find("tip")
	arg0_2.shouce = arg0_2.top:Find("yinhuashouceye")
	arg0_2.shouce_bg = arg0_2.shouce:Find("bg")
	arg0_2.layout_shouce = arg0_2.shouce:Find("yinhuace/layout")
	arg0_2.group_get = CustomIndexLayer.Clone2Full(arg0_2.layout_shouce, 7)
	arg0_2.btn_receive = arg0_2.shouce:Find("yinhuace/receive")
	arg0_2.btn_shouce_help = arg0_2.shouce:Find("yinhuace/help")
	arg0_2.img_get = arg0_2.shouce:Find("yinhuace/get")

	setActive(arg0_2.shouce, false)

	arg0_2._map = arg0_2:findTF("map")
	arg0_2.shrine = arg0_2._map:Find("shrine")
	arg0_2.snack_street = arg0_2._map:Find("snack")
	arg0_2.divination = arg0_2._map:Find("divination")
	arg0_2.shop = arg0_2._map:Find("shop")
	arg0_2.cube = arg0_2._map:Find("magiccube")
	arg0_2.bottom2 = arg0_2._map:Find("bottom2")
	arg0_2.bottom = arg0_2._map:Find("bottom")
	arg0_2.middle = arg0_2._map:Find("middle")
	arg0_2.front = arg0_2._map:Find("top")
	arg0_2.containers = {
		arg0_2.front,
		arg0_2.middle,
		arg0_2.bottom,
		arg0_2.bottom2
	}
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestivalGraph"))
	arg0_2.effectReq = LoadPrefabRequestPackage.New("ui/xuedichangjing", "xuedichangjing", function(arg0_3)
		setParent(arg0_3, arg0_2._map, false)

		local var0_3 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1_3 = arg0_3:GetComponentsInChildren(typeof(Renderer))

		for iter0_3 = 0, var1_3.Length - 1 do
			var1_3[iter0_3].sortingOrder = var0_3 + 1
		end
	end):Start()
end

function var0_0.didEnter(arg0_4)
	local var0_4 = getProxy(MiniGameProxy)

	onButton(arg0_4, arg0_4._closeBtn, function()
		arg0_4:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_4, arg0_4._homeBtn, function()
		arg0_4:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_4, arg0_4._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_feast.tip
		})
	end)
	onButton(arg0_4, arg0_4.yinhuace, function()
		setActive(arg0_4.shouce, true)
	end)
	onButton(arg0_4, arg0_4.shouce_bg, function()
		setActive(arg0_4.shouce, false)
	end)
	onButton(arg0_4, arg0_4.btn_shouce_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_stamp.tip
		})
	end)
	onButton(arg0_4, arg0_4.btn_receive, function()
		local var0_11 = var0_4:GetHubByHubId(arg0_4.HUB_ID)

		if var0_11.ultimate ~= 0 or var0_11.usedtime < var0_11:getConfig("reward_need") then
			return
		end

		arg0_4:emit(NewYearFestivalMediator.MINI_GAME_OPERATOR, {
			hubid = var0_11.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)
	arg0_4:InitFacility(arg0_4.shrine, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end)
	arg0_4:InitFacility(arg0_4.snack_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 8)
	end)
	arg0_4:InitFacility(arg0_4.divination, function()
		arg0_4:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.CYGNET_BATHROBE_PAGE_ID
		})
	end)
	arg0_4:InitFacility(arg0_4.shop, function()
		arg0_4:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_4:InitFacility(arg0_4.cube, function()
		arg0_4:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4.top, false)

	arg0_4.academyStudents = {}

	arg0_4:InitStudents(ActivityConst.NEWYEAR_ACTIVITY, 3, 5)
	arg0_4:UpdateView()

	if arg0_4.contextData.isOpenShrine then
		arg0_4.contextData.isOpenShrine = nil

		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end

	local var1_4 = var0_4:GetMiniGameData(3)

	if var1_4 and not var1_4:GetRuntimeData("isInited") then
		arg0_4:emit(NewYearFestivalMediator.MINIGAME_OPERATION, arg0_4.HUB_ID, MiniGameOPCommand.CMD_SPECIAL_GAME, {
			3,
			1
		})
	end
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = getProxy(MiniGameProxy)
	local var1_17 = var0_17:GetHubByHubId(arg0_17.HUB_ID)
	local var2_17 = var1_17.usedtime

	setText(arg0_17.ticketTimes, "X " .. var1_17.count)
	setText(arg0_17.yinhuaceTimes, string.format("%02d", var2_17))

	for iter0_17, iter1_17 in ipairs(arg0_17.group_get) do
		setActive(iter1_17, iter0_17 <= var2_17)
	end

	local var3_17 = var2_17 >= #arg0_17.group_get and var1_17.ultimate == 0

	setActive(arg0_17.btn_receive, var3_17)
	setActive(arg0_17.yinhuaceTips, var3_17)
	setActive(arg0_17.img_get, var1_17.ultimate ~= 0)

	if var1_17.ultimate == 1 then
		arg0_17:TryPlayStory()
	end

	local var4_17 = arg0_17.snack_street:Find("tip")

	setActive(var4_17, var1_17.count > 0)

	local var5_17 = arg0_17.shrine:Find("tip")
	local var6_17 = var0_17:GetMiniGameData(3)
	local var7_17 = false

	if var6_17 then
		var7_17 = (var6_17:GetRuntimeData("count") or 0) > 0 and NewYearShrinePage.IsTip()
	end

	setActive(var5_17, var7_17)

	local var8_17 = arg0_17.divination:Find("tip")

	setActive(var8_17, CygnetBathrobePage.IsTip())
end

var0_0.edge2area = {
	["7_8"] = "bottom2",
	["3_8"] = "bottom",
	["5_6"] = "front"
}

function var0_0.TryPlayStory(arg0_18)
	return
end

function var0_0.willExit(arg0_19)
	arg0_19.effectReq:Stop()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19.top, arg0_19._tf)
	arg0_19:clearStudents()
end

return var0_0
