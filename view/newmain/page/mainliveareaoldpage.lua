local var0 = class("MainLiveAreaOldPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MainLiveAreaOldUI"
end

function var0.OnLoaded(arg0)
	arg0._academyBtn = arg0:findTF("school_btn")
	arg0._haremBtn = arg0:findTF("backyard_btn")
	arg0._commanderBtn = arg0:findTF("commander_btn")

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
		arg0._commanderBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "CourtYardMediator") then
		arg0._haremBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end
end

function var0.Hide(arg0)
	if arg0:isShowing() then
		var0.super.Hide(arg0)
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
