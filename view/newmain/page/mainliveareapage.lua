local var0 = class("MainLiveAreaPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MainLiveAreaUI"
end

function var0.OnLoaded(arg0)
	arg0._bg = arg0:findTF("bg")

	setText(arg0:findTF("bg/Text", arg0._bg), i18n("word_harbour"))

	arg0.timeCfg = pg.gameset.main_live_area_time.description
	arg0._academyBtn = arg0:findTF("school_btn")
	arg0._haremBtn = arg0:findTF("backyard_btn")
	arg0._commanderBtn = arg0:findTF("commander_btn")
	arg0._educateBtn = arg0:findTF("educate_btn")
	arg0._islandBtn = arg0:findTF("island_btn")
	arg0._dormBtn = arg0:findTF("dorm_btn")

	pg.redDotHelper:AddNode(RedDotNode.New(arg0._haremBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COURTYARD
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0._academyBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.SCHOOL
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0._commanderBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COMMANDER
	}))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._commanderBtn, function()
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0:Hide()
	end, SFX_MAIN)
	onButton(arg0, arg0._haremBtn, function()
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.COURTYARD)
		arg0:Hide()
	end, SFX_MAIN)
	onButton(arg0, arg0._academyBtn, function()
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		arg0:Hide()
	end, SFX_MAIN)
	onButton(arg0, arg0._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		arg0:emit(NewMainMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
		arg0:Hide()
	end, SFX_MAIN)
	onButton(arg0, arg0._islandBtn, function()
		return
	end, SFX_MAIN)
	onButton(arg0, arg0._dormBtn, function()
		return
	end, SFX_MAIN)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "CommanderCatMediator") then
		arg0._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "CourtYardMediator") then
		arg0._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "EducateMediator") then
		arg0._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0:UpdateTime()

	arg0.timer = Timer.New(function()
		arg0:UpdateTime()
	end, 60, -1)

	arg0.timer:Start()
end

function var0.UpdateTime(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:GetServerHour()
	local var2 = var1 < 12

	GetSpriteFromAtlasAsync("ui/MainUISecondaryPanel_atlas", var2 and "am" or "pm", function(arg0)
		arg0:findTF("bg/AMPM"):GetComponent(typeof(Image)).sprite = arg0
	end)

	local var3 = arg0:getDayOrNight(var1) == "day"
	local var4 = LoadSprite("bg/" .. (var3 and "bg_livingarea_day" or "bg_livingarea_night"), "")

	arg0:findTF("bg", arg0._bg):GetComponent(typeof(Image)).sprite = var4

	local var5 = GetSpriteFromAtlas("ui/MainUISecondaryPanel_atlas", var3 and "island_build_day" or "island_build_night")

	arg0:findTF("bg", arg0._islandBtn):GetComponent(typeof(Image)).sprite = var5

	local var6 = var0:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0:findTF("date", arg0._bg), var6)

	local var7 = var0:CurrentSTimeDesc(":%M", true)

	if var1 > 12 then
		var1 = var1 - 12
	end

	setText(arg0:findTF("time", arg0._bg), var1 .. var7)

	local var8 = EducateHelper.GetWeekStrByNumber(var0:GetServerWeek())

	setText(arg0:findTF("date/week", arg0._bg), var8)
end

function var0.getDayOrNight(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.timeCfg) do
		local var0 = iter1[1]

		if arg1 >= var0[1] and arg1 < var0[2] then
			return iter1[2]
		end
	end

	return "day"
end

function var0.Hide(arg0)
	if arg0:isShowing() then
		var0.super.Hide(arg0)
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	if arg0.timer ~= nil then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
