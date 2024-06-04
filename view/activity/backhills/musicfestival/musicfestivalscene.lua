local var0 = class("MusicFestivalScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "MusicFestivalUI"
end

var0.HUB_ID = 2

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._closeBtn = arg0:findTF("top/back")
	arg0._helpBtn = arg0:findTF("top/help")
	arg0.btn_actskin = arg0.top:Find("idol_jump")
	arg0.btn_ins = arg0.top:Find("ins_jump")
	arg0._map = arg0:findTF("scrollRect/map")
	arg0.stage = arg0._map:Find("stage")
	arg0.screen = arg0._map:Find("screen")
	arg0.shop = arg0._map:Find("shop")
	arg0.painting = arg0._map:Find("painting")
	arg0.cube = arg0._map:Find("cube")
	arg0.foutain = arg0._map:Find("foutain")
	arg0.door = arg0._map:Find("door")
	arg0.bottom = arg0._map:Find("bottom")
	arg0.front = arg0._map:Find("front")
	arg0._shipTpl = arg0._map:Find("ship")
	arg0._xiefei = arg0._map:Find("model/xiefei")
	arg0._modeltip = arg0._xiefei:Find("tip")
	arg0._stageShip = arg0._map:Find("stageship")

	setActive(arg0._modeltip, false)

	arg0.graphPath = GraphPath.New(import("GameCfg/BackHillGraphs/MusicFestivalGraph"))
	arg0._loadingRequest = {}
	arg0._ReturnRequest = {}

	local var0 = "ouxiangxiaoditu"
	local var1 = LoadPrefabRequestPackage.New("ui/" .. var0, var0, function(arg0)
		setParent(arg0, arg0._map)

		local var0 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1 = arg0:GetComponentsInChildren(typeof(Renderer))

		for iter0 = 0, var1.Length - 1 do
			var1[iter0].sortingOrder = var0 + 1
		end
	end):Start()

	table.insert(arg0._loadingRequest, var1)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_main.tip
		})
	end)
	onButton(arg0, arg0.btn_actskin, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MUSIC_CHUIXUE7DAY_ID
		})
	end)
	onButton(arg0, arg0.btn_ins, function()
		arg0:emit(MusicFestivalMediator.GO_SUBLAYER, Context.New({
			viewComponent = InstagramLayer,
			mediator = InstagramMediator,
			data = {
				id = ActivityConst.IDOL_INS_ID
			}
		}))
	end)
	onButton(arg0, arg0._xiefei, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MUSIC_FESTIVAL_ID
		})
	end)
	arg0:InitFacility(arg0.stage, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 6)
	end)
	arg0:InitFacility(arg0.screen, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.IDOL_PT_ID
		})
	end)
	arg0:InitFacility(arg0.shop, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:InitFacility(arg0.painting, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacility(arg0.cube, function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacility(arg0.foutain, function()
		local var0 = Context.New({
			mediator = IdolMedalCollectionMediator,
			viewComponent = IdolMedalCollectionView,
			data = {},
			onRemoved = function()
				setActive(arg0._tf, true)
			end
		})

		arg0:emit(MusicFestivalMediator.GO_SUBLAYER, var0, function()
			setActive(arg0._tf, false)
		end)
	end)
	arg0:InitFacility(arg0.door, function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)

	arg0.academyStudents = {}

	arg0:InitAreaTransFunc()
	arg0:updateStudents()
	arg0:updateStageShip()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)
	local var2

	if var1 and not var1:isEnd() then
		var2 = var1:readyToAchieve()
	end

	setActive(arg0._modeltip, var2)

	local var3 = arg0.btn_actskin:Find("tip")
	local var4 = var0:getActivityById(ActivityConst.MUSIC_CHUIXUE7DAY_ID)
	local var5 = var4 and not var4:isEnd() and var4:readyToAchieve()

	setActive(var3, var5)

	local var6 = arg0.btn_ins:Find("tip")
	local var7 = getProxy(InstagramProxy):ShouldShowTip()

	setActive(var6, var7)

	local var8 = arg0.screen:Find("tip")
	local var9 = IdolPTPage.NeedTip()

	setActive(var8, var9)

	local var10 = arg0.foutain:Find("tip")
	local var11 = var0.MedalTip()

	setActive(var10, var11)

	local var12 = arg0.stage:Find("tip")
	local var13 = getProxy(MiniGameProxy):GetHubByHubId(arg0.HUB_ID).count > 0

	setActive(var12, var13)
end

function var0.InitFacility(arg0, arg1, arg2)
	onButton(arg0, arg1, arg2)
	onButton(arg0, arg1:Find("button"), arg2)
end

function var0.getStudents(arg0)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)

	if not var1 then
		return var0
	end

	local var2 = var1:getConfig("config_client")

	var2 = var2 and var2.stage_off_ship

	if var2 then
		local var3 = Clone(var2)
		local var4 = 0
		local var5 = #var3

		while var4 < 3 and var5 > 0 do
			local var6 = math.random(1, var5)

			table.insert(var0, var3[var6])

			var3[var6] = var3[var5]
			var5 = var5 - 1
			var4 = var4 + 1
		end
	end

	return var0
end

function var0.InitAreaTransFunc(arg0)
	arg0.edge2area = {
		["1_2"] = arg0.bottom,
		["2_3"] = arg0.bottom,
		["3_4"] = arg0.bottom
	}
end

function var0.updateStudents(arg0)
	local var0 = arg0:getStudents()

	for iter0, iter1 in pairs(var0) do
		if not arg0.academyStudents[iter0] then
			local var1 = cloneTplTo(arg0._shipTpl, arg0._map)

			var1.gameObject.name = iter0

			local var2 = SummerFeastNavigationAgent.New(var1.gameObject)

			var2:attach()
			var2:setPathFinder(arg0.graphPath)
			var2:SetOnTransEdge(function(arg0, arg1, arg2)
				arg1, arg2 = math.min(arg1, arg2), math.max(arg1, arg2)

				local var0 = arg0.edge2area[arg1 .. "_" .. arg2] or arg0.front

				arg0._tf:SetParent(var0)
			end)
			var2:updateStudent(iter1)

			arg0.academyStudents[iter0] = var2
		end
	end

	if #var0 > 0 then
		arg0.sortTimer = Timer.New(function()
			arg0:sortStudents()
		end, 0.2, -1)

		arg0.sortTimer:Start()
		arg0.sortTimer.func()
	end
end

function var0.getStageShip(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)

	if not var0 then
		return
	end

	local var1 = var0:getConfig("config_client")
	local var2 = var1 and var1.stage_on_ship

	if var2 then
		local var3 = #var2

		return var2[math.random(1, var3)], var2.action[1]
	end
end

function var0.updateStageShip(arg0)
	local var0, var1 = arg0:getStageShip()

	if var0 then
		local var2 = GetSpineRequestPackage.New(var0, function(arg0)
			arg0.transform.localScale = Vector3(0.5, 0.5, 1)
			arg0.transform.localPosition = Vector3.zero

			arg0.transform:SetParent(arg0._stageShip, false)
			arg0.transform:SetSiblingIndex(1)
			setActive(arg0._stageShip, true)
			arg0:GetComponent(typeof(SpineAnimUI)):SetAction(var1, 0)

			arg0._loadingRequest[var0] = nil
			arg0._ReturnRequest[var0] = ReturnSpineRequestPackage.New(var0, arg0)
		end):Start()

		arg0._loadingRequest[var0] = var2
	end
end

function var0.sortStudents(arg0)
	local var0 = {
		arg0.front,
		arg0.middle,
		arg0.bottom
	}

	for iter0, iter1 in pairs(var0) do
		if iter1.childCount > 1 then
			local var1 = {}

			for iter2 = 1, iter1.childCount do
				local var2 = iter1:GetChild(iter2 - 1)

				table.insert(var1, {
					tf = var2,
					index = iter2
				})
			end

			table.sort(var1, function(arg0, arg1)
				local var0 = arg0.tf.anchoredPosition.y - arg1.tf.anchoredPosition.y

				if math.abs(var0) < 1 then
					return arg0.index < arg1.index
				else
					return var0 > 0
				end
			end)

			for iter3, iter4 in ipairs(var1) do
				iter4.tf:SetSiblingIndex(iter3 - 1)
			end
		end
	end
end

function var0.clearStudents(arg0)
	if arg0.sortTimer then
		arg0.sortTimer:Stop()

		arg0.sortTimer = nil
	end

	for iter0, iter1 in pairs(arg0.academyStudents) do
		iter1:detach()
		Destroy(iter1._go)
	end

	arg0.academyStudents = {}
end

function var0.TryPlayStory(arg0)
	local var0 = "TIANHOUYUYI2"

	if var0 then
		pg.NewStoryMgr.GetInstance():Play(var0)
	end
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.willExit(arg0)
	arg0:clearStudents()

	for iter0, iter1 in pairs(arg0._loadingRequest) do
		iter1:Stop()
	end

	table.clear(arg0._loadingRequest)

	for iter2, iter3 in pairs(arg0._ReturnRequest) do
		iter3()
	end

	table.clear(arg0._ReturnRequest)
end

return var0
