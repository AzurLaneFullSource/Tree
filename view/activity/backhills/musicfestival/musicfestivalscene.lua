local var0_0 = class("MusicFestivalScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MusicFestivalUI"
end

var0_0.HUB_ID = 2

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._closeBtn = arg0_2:findTF("top/back")
	arg0_2._helpBtn = arg0_2:findTF("top/help")
	arg0_2.btn_actskin = arg0_2.top:Find("idol_jump")
	arg0_2.btn_ins = arg0_2.top:Find("ins_jump")
	arg0_2._map = arg0_2:findTF("scrollRect/map")
	arg0_2.stage = arg0_2._map:Find("stage")
	arg0_2.screen = arg0_2._map:Find("screen")
	arg0_2.shop = arg0_2._map:Find("shop")
	arg0_2.painting = arg0_2._map:Find("painting")
	arg0_2.cube = arg0_2._map:Find("cube")
	arg0_2.foutain = arg0_2._map:Find("foutain")
	arg0_2.door = arg0_2._map:Find("door")
	arg0_2.bottom = arg0_2._map:Find("bottom")
	arg0_2.front = arg0_2._map:Find("front")
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._xiefei = arg0_2._map:Find("model/xiefei")
	arg0_2._modeltip = arg0_2._xiefei:Find("tip")
	arg0_2._stageShip = arg0_2._map:Find("stageship")

	setActive(arg0_2._modeltip, false)

	arg0_2.graphPath = GraphPath.New(import("GameCfg/BackHillGraphs/MusicFestivalGraph"))
	arg0_2._loadingRequest = {}
	arg0_2._ReturnRequest = {}

	local var0_2 = "ouxiangxiaoditu"
	local var1_2 = LoadPrefabRequestPackage.New("ui/" .. var0_2, var0_2, function(arg0_3)
		setParent(arg0_3, arg0_2._map)

		local var0_3 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1_3 = arg0_3:GetComponentsInChildren(typeof(Renderer))

		for iter0_3 = 0, var1_3.Length - 1 do
			var1_3[iter0_3].sortingOrder = var0_3 + 1
		end
	end):Start()

	table.insert(arg0_2._loadingRequest, var1_2)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._closeBtn, function()
		arg0_4:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_4, arg0_4._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_main.tip
		})
	end)
	onButton(arg0_4, arg0_4.btn_actskin, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MUSIC_CHUIXUE7DAY_ID
		})
	end)
	onButton(arg0_4, arg0_4.btn_ins, function()
		arg0_4:emit(MusicFestivalMediator.GO_SUBLAYER, Context.New({
			viewComponent = InstagramLayer,
			mediator = InstagramMediator,
			data = {
				id = ActivityConst.IDOL_INS_ID
			}
		}))
	end)
	onButton(arg0_4, arg0_4._xiefei, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MUSIC_FESTIVAL_ID
		})
	end)
	arg0_4:InitFacility(arg0_4.stage, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 6)
	end)
	arg0_4:InitFacility(arg0_4.screen, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.IDOL_PT_ID
		})
	end)
	arg0_4:InitFacility(arg0_4.shop, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_4:InitFacility(arg0_4.painting, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_4:InitFacility(arg0_4.cube, function()
		arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_4:InitFacility(arg0_4.foutain, function()
		local var0_15 = Context.New({
			mediator = IdolMedalCollectionMediator,
			viewComponent = IdolMedalCollectionView,
			data = {},
			onRemoved = function()
				setActive(arg0_4._tf, true)
			end
		})

		arg0_4:emit(MusicFestivalMediator.GO_SUBLAYER, var0_15, function()
			setActive(arg0_4._tf, false)
		end)
	end)
	arg0_4:InitFacility(arg0_4.door, function()
		local var0_18 = getProxy(ChapterProxy)
		local var1_18, var2_18 = var0_18:getLastMapForActivity()

		if not var1_18 or not var0_18:getMapById(var1_18):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_4:emit(MusicFestivalMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_18,
				mapIdx = var1_18
			})
		end
	end)

	arg0_4.academyStudents = {}

	arg0_4:InitAreaTransFunc()
	arg0_4:updateStudents()
	arg0_4:updateStageShip()
	arg0_4:UpdateView()
end

function var0_0.UpdateView(arg0_19)
	local var0_19 = getProxy(ActivityProxy)
	local var1_19 = var0_19:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)
	local var2_19

	if var1_19 and not var1_19:isEnd() then
		var2_19 = var1_19:readyToAchieve()
	end

	setActive(arg0_19._modeltip, var2_19)

	local var3_19 = arg0_19.btn_actskin:Find("tip")
	local var4_19 = var0_19:getActivityById(ActivityConst.MUSIC_CHUIXUE7DAY_ID)
	local var5_19 = var4_19 and not var4_19:isEnd() and var4_19:readyToAchieve()

	setActive(var3_19, var5_19)

	local var6_19 = arg0_19.btn_ins:Find("tip")
	local var7_19 = getProxy(InstagramProxy):ShouldShowTip()

	setActive(var6_19, var7_19)

	local var8_19 = arg0_19.screen:Find("tip")
	local var9_19 = IdolPTPage.NeedTip()

	setActive(var8_19, var9_19)

	local var10_19 = arg0_19.foutain:Find("tip")
	local var11_19 = var0_0.MedalTip()

	setActive(var10_19, var11_19)

	local var12_19 = arg0_19.stage:Find("tip")
	local var13_19 = getProxy(MiniGameProxy):GetHubByHubId(arg0_19.HUB_ID).count > 0

	setActive(var12_19, var13_19)
end

function var0_0.InitFacility(arg0_20, arg1_20, arg2_20)
	onButton(arg0_20, arg1_20, arg2_20)
	onButton(arg0_20, arg1_20:Find("button"), arg2_20)
end

function var0_0.getStudents(arg0_21)
	local var0_21 = {}
	local var1_21 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)

	if not var1_21 then
		return var0_21
	end

	local var2_21 = var1_21:getConfig("config_client")

	var2_21 = var2_21 and var2_21.stage_off_ship

	if var2_21 then
		local var3_21 = Clone(var2_21)
		local var4_21 = 0
		local var5_21 = #var3_21

		while var4_21 < 3 and var5_21 > 0 do
			local var6_21 = math.random(1, var5_21)

			table.insert(var0_21, var3_21[var6_21])

			var3_21[var6_21] = var3_21[var5_21]
			var5_21 = var5_21 - 1
			var4_21 = var4_21 + 1
		end
	end

	return var0_21
end

function var0_0.InitAreaTransFunc(arg0_22)
	arg0_22.edge2area = {
		["1_2"] = arg0_22.bottom,
		["2_3"] = arg0_22.bottom,
		["3_4"] = arg0_22.bottom
	}
end

function var0_0.updateStudents(arg0_23)
	local var0_23 = arg0_23:getStudents()

	for iter0_23, iter1_23 in pairs(var0_23) do
		if not arg0_23.academyStudents[iter0_23] then
			local var1_23 = cloneTplTo(arg0_23._shipTpl, arg0_23._map)

			var1_23.gameObject.name = iter0_23

			local var2_23 = SummerFeastNavigationAgent.New(var1_23.gameObject)

			var2_23:attach()
			var2_23:setPathFinder(arg0_23.graphPath)
			var2_23:SetOnTransEdge(function(arg0_24, arg1_24, arg2_24)
				arg1_24, arg2_24 = math.min(arg1_24, arg2_24), math.max(arg1_24, arg2_24)

				local var0_24 = arg0_23.edge2area[arg1_24 .. "_" .. arg2_24] or arg0_23.front

				arg0_24._tf:SetParent(var0_24)
			end)
			var2_23:updateStudent(iter1_23)

			arg0_23.academyStudents[iter0_23] = var2_23
		end
	end

	if #var0_23 > 0 then
		arg0_23.sortTimer = Timer.New(function()
			arg0_23:sortStudents()
		end, 0.2, -1)

		arg0_23.sortTimer:Start()
		arg0_23.sortTimer.func()
	end
end

function var0_0.getStageShip(arg0_26)
	local var0_26 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID)

	if not var0_26 then
		return
	end

	local var1_26 = var0_26:getConfig("config_client")
	local var2_26 = var1_26 and var1_26.stage_on_ship

	if var2_26 then
		local var3_26 = #var2_26

		return var2_26[math.random(1, var3_26)], var2_26.action[1]
	end
end

function var0_0.updateStageShip(arg0_27)
	local var0_27, var1_27 = arg0_27:getStageShip()

	if var0_27 then
		local var2_27 = GetSpineRequestPackage.New(var0_27, function(arg0_28)
			arg0_28.transform.localScale = Vector3(0.5, 0.5, 1)
			arg0_28.transform.localPosition = Vector3.zero

			arg0_28.transform:SetParent(arg0_27._stageShip, false)
			arg0_28.transform:SetSiblingIndex(1)
			setActive(arg0_27._stageShip, true)
			arg0_28:GetComponent(typeof(SpineAnimUI)):SetAction(var1_27, 0)

			arg0_27._loadingRequest[var0_27] = nil
			arg0_27._ReturnRequest[var0_27] = ReturnSpineRequestPackage.New(var0_27, arg0_28)
		end):Start()

		arg0_27._loadingRequest[var0_27] = var2_27
	end
end

function var0_0.sortStudents(arg0_29)
	local var0_29 = {
		arg0_29.front,
		arg0_29.middle,
		arg0_29.bottom
	}

	for iter0_29, iter1_29 in pairs(var0_29) do
		if iter1_29.childCount > 1 then
			local var1_29 = {}

			for iter2_29 = 1, iter1_29.childCount do
				local var2_29 = iter1_29:GetChild(iter2_29 - 1)

				table.insert(var1_29, {
					tf = var2_29,
					index = iter2_29
				})
			end

			table.sort(var1_29, function(arg0_30, arg1_30)
				local var0_30 = arg0_30.tf.anchoredPosition.y - arg1_30.tf.anchoredPosition.y

				if math.abs(var0_30) < 1 then
					return arg0_30.index < arg1_30.index
				else
					return var0_30 > 0
				end
			end)

			for iter3_29, iter4_29 in ipairs(var1_29) do
				iter4_29.tf:SetSiblingIndex(iter3_29 - 1)
			end
		end
	end
end

function var0_0.clearStudents(arg0_31)
	if arg0_31.sortTimer then
		arg0_31.sortTimer:Stop()

		arg0_31.sortTimer = nil
	end

	for iter0_31, iter1_31 in pairs(arg0_31.academyStudents) do
		iter1_31:detach()
		Destroy(iter1_31._go)
	end

	arg0_31.academyStudents = {}
end

function var0_0.TryPlayStory(arg0_32)
	local var0_32 = "TIANHOUYUYI2"

	if var0_32 then
		pg.NewStoryMgr.GetInstance():Play(var0_32)
	end
end

function var0_0.MedalTip()
	local var0_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_33)
end

function var0_0.willExit(arg0_34)
	arg0_34:clearStudents()

	for iter0_34, iter1_34 in pairs(arg0_34._loadingRequest) do
		iter1_34:Stop()
	end

	table.clear(arg0_34._loadingRequest)

	for iter2_34, iter3_34 in pairs(arg0_34._ReturnRequest) do
		iter3_34()
	end

	table.clear(arg0_34._ReturnRequest)
end

return var0_0
