local var0 = class("NewyearFestivalScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "NewyearFestivalUI"
end

var0.HUB_ID = 4

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._closeBtn = arg0:findTF("top/back")
	arg0._homeBtn = arg0:findTF("top/home")
	arg0._helpBtn = arg0:findTF("top/help")
	arg0.ticketTimes = arg0.top:Find("ticket/text")
	arg0.yinhuace = arg0.top:Find("sign")
	arg0.yinhuaceTimes = arg0.yinhuace:Find("get")
	arg0.yinhuaceTips = arg0.yinhuace:Find("tip")
	arg0.shouce = arg0.top:Find("yinhuashouceye")
	arg0.shouce_bg = arg0.shouce:Find("bg")
	arg0.layout_shouce = arg0.shouce:Find("yinhuace/layout")
	arg0.group_get = CustomIndexLayer.Clone2Full(arg0.layout_shouce, 7)
	arg0.btn_receive = arg0.shouce:Find("yinhuace/receive")
	arg0.btn_shouce_help = arg0.shouce:Find("yinhuace/help")
	arg0.img_get = arg0.shouce:Find("yinhuace/get")

	setActive(arg0.shouce, false)

	arg0._map = arg0:findTF("map")
	arg0.shrine = arg0._map:Find("shrine")
	arg0.snack_street = arg0._map:Find("snack")
	arg0.divination = arg0._map:Find("divination")
	arg0.shop = arg0._map:Find("shop")
	arg0.cube = arg0._map:Find("magiccube")
	arg0.bottom2 = arg0._map:Find("bottom2")
	arg0.bottom = arg0._map:Find("bottom")
	arg0.middle = arg0._map:Find("middle")
	arg0.front = arg0._map:Find("top")
	arg0.containers = {
		arg0.front,
		arg0.middle,
		arg0.bottom,
		arg0.bottom2
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestivalGraph"))
	arg0.effectReq = LoadPrefabRequestPackage.New("ui/xuedichangjing", "xuedichangjing", function(arg0)
		setParent(arg0, arg0._map, false)

		local var0 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1 = arg0:GetComponentsInChildren(typeof(Renderer))

		for iter0 = 0, var1.Length - 1 do
			var1[iter0].sortingOrder = var0 + 1
		end
	end):Start()
end

function var0.didEnter(arg0)
	local var0 = getProxy(MiniGameProxy)

	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0._homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_feast.tip
		})
	end)
	onButton(arg0, arg0.yinhuace, function()
		setActive(arg0.shouce, true)
	end)
	onButton(arg0, arg0.shouce_bg, function()
		setActive(arg0.shouce, false)
	end)
	onButton(arg0, arg0.btn_shouce_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_stamp.tip
		})
	end)
	onButton(arg0, arg0.btn_receive, function()
		local var0 = var0:GetHubByHubId(arg0.HUB_ID)

		if var0.ultimate ~= 0 or var0.usedtime < var0:getConfig("reward_need") then
			return
		end

		arg0:emit(NewYearFestivalMediator.MINI_GAME_OPERATOR, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)
	arg0:InitFacility(arg0.shrine, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end)
	arg0:InitFacility(arg0.snack_street, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 8)
	end)
	arg0:InitFacility(arg0.divination, function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.CYGNET_BATHROBE_PAGE_ID
		})
	end)
	arg0:InitFacility(arg0.shop, function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacility(arg0.cube, function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, false)

	arg0.academyStudents = {}

	arg0:InitStudents(ActivityConst.NEWYEAR_ACTIVITY, 3, 5)
	arg0:UpdateView()

	if arg0.contextData.isOpenShrine then
		arg0.contextData.isOpenShrine = nil

		pg.m02:sendNotification(GAME.GO_MINI_GAME, 3)
	end

	local var1 = var0:GetMiniGameData(3)

	if var1 and not var1:GetRuntimeData("isInited") then
		arg0:emit(NewYearFestivalMediator.MINIGAME_OPERATION, arg0.HUB_ID, MiniGameOPCommand.CMD_SPECIAL_GAME, {
			3,
			1
		})
	end
end

function var0.UpdateView(arg0)
	local var0 = getProxy(MiniGameProxy)
	local var1 = var0:GetHubByHubId(arg0.HUB_ID)
	local var2 = var1.usedtime

	setText(arg0.ticketTimes, "X " .. var1.count)
	setText(arg0.yinhuaceTimes, string.format("%02d", var2))

	for iter0, iter1 in ipairs(arg0.group_get) do
		setActive(iter1, iter0 <= var2)
	end

	local var3 = var2 >= #arg0.group_get and var1.ultimate == 0

	setActive(arg0.btn_receive, var3)
	setActive(arg0.yinhuaceTips, var3)
	setActive(arg0.img_get, var1.ultimate ~= 0)

	if var1.ultimate == 1 then
		arg0:TryPlayStory()
	end

	local var4 = arg0.snack_street:Find("tip")

	setActive(var4, var1.count > 0)

	local var5 = arg0.shrine:Find("tip")
	local var6 = var0:GetMiniGameData(3)
	local var7 = false

	if var6 then
		var7 = (var6:GetRuntimeData("count") or 0) > 0 and NewYearShrinePage.IsTip()
	end

	setActive(var5, var7)

	local var8 = arg0.divination:Find("tip")

	setActive(var8, CygnetBathrobePage.IsTip())
end

var0.edge2area = {
	["7_8"] = "bottom2",
	["3_8"] = "bottom",
	["5_6"] = "front"
}

function var0.TryPlayStory(arg0)
	return
end

function var0.willExit(arg0)
	arg0.effectReq:Stop()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	arg0:clearStudents()
end

return var0
