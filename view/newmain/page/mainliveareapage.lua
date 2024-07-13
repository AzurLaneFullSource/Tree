local var0_0 = class("MainLiveAreaPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainLiveAreaUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._bg = arg0_2:findTF("bg")

	setText(arg0_2:findTF("bg/Text", arg0_2._bg), i18n("word_harbour"))

	arg0_2.timeCfg = pg.gameset.main_live_area_time.description
	arg0_2._academyBtn = arg0_2:findTF("school_btn")
	arg0_2._haremBtn = arg0_2:findTF("backyard_btn")
	arg0_2._commanderBtn = arg0_2:findTF("commander_btn")
	arg0_2._educateBtn = arg0_2:findTF("educate_btn")
	arg0_2._islandBtn = arg0_2:findTF("island_btn")
	arg0_2._dormBtn = arg0_2:findTF("dorm_btn")

	pg.redDotHelper:AddNode(RedDotNode.New(arg0_2._haremBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COURTYARD
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_2._academyBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.SCHOOL
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_2._commanderBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COMMANDER
	}))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._commanderBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._haremBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.COURTYARD)
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._academyBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._islandBtn, function()
		return
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._dormBtn, function()
		return
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_11)
	var0_0.super.Show(arg0_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0_11 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_11.level, "CommanderCatMediator") then
		arg0_11._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_11._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_11.level, "CourtYardMediator") then
		arg0_11._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_11._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_11.level, "EducateMediator") then
		arg0_11._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_11._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_11:UpdateTime()

	arg0_11.timer = Timer.New(function()
		arg0_11:UpdateTime()
	end, 60, -1)

	arg0_11.timer:Start()
end

function var0_0.UpdateTime(arg0_13)
	local var0_13 = pg.TimeMgr.GetInstance()
	local var1_13 = var0_13:GetServerHour()
	local var2_13 = var1_13 < 12

	GetSpriteFromAtlasAsync("ui/MainUISecondaryPanel_atlas", var2_13 and "am" or "pm", function(arg0_14)
		arg0_13:findTF("bg/AMPM"):GetComponent(typeof(Image)).sprite = arg0_14
	end)

	local var3_13 = arg0_13:getDayOrNight(var1_13) == "day"
	local var4_13 = LoadSprite("bg/" .. (var3_13 and "bg_livingarea_day" or "bg_livingarea_night"), "")

	arg0_13:findTF("bg", arg0_13._bg):GetComponent(typeof(Image)).sprite = var4_13

	local var5_13 = GetSpriteFromAtlas("ui/MainUISecondaryPanel_atlas", var3_13 and "island_build_day" or "island_build_night")

	arg0_13:findTF("bg", arg0_13._islandBtn):GetComponent(typeof(Image)).sprite = var5_13

	local var6_13 = var0_13:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_13:findTF("date", arg0_13._bg), var6_13)

	local var7_13 = var0_13:CurrentSTimeDesc(":%M", true)

	if var1_13 > 12 then
		var1_13 = var1_13 - 12
	end

	setText(arg0_13:findTF("time", arg0_13._bg), var1_13 .. var7_13)

	local var8_13 = EducateHelper.GetWeekStrByNumber(var0_13:GetServerWeek())

	setText(arg0_13:findTF("date/week", arg0_13._bg), var8_13)
end

function var0_0.getDayOrNight(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.timeCfg) do
		local var0_15 = iter1_15[1]

		if arg1_15 >= var0_15[1] and arg1_15 < var0_15[2] then
			return iter1_15[2]
		end
	end

	return "day"
end

function var0_0.Hide(arg0_16)
	if arg0_16:isShowing() then
		var0_0.super.Hide(arg0_16)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, arg0_16._parentTf)
	end

	if arg0_16.timer ~= nil then
		arg0_16.timer:Stop()

		arg0_16.timer = nil
	end
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:Hide()
end

return var0_0
