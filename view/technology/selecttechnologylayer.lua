local var0 = class("SelectTechnologyLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SelectTechnologyUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.LOWER_LAYER
	})

	arg0.bg = arg0:findTF("frame/bg")
	arg0.bluePrintBtn = arg0:findTF("blueprint_btn", arg0.bg)
	arg0.bluePrintBtnTip = arg0.bluePrintBtn:Find("tip")
	arg0.technologyBtn = arg0:findTF("technology_btn", arg0.bg)
	arg0.technologyBtnTip = arg0.technologyBtn:Find("tip")
	arg0.fleetBtn = arg0:findTF("fleet_btn", arg0.bg)
	arg0.fleetBtnTip = arg0.fleetBtn:Find("tip")
	arg0.transformBtn = arg0:findTF("transform_btn", arg0.bg)
	arg0.transformBtnTip = arg0.transformBtn:Find("tip")

	setActive(arg0.transformBtn, not LOCK_EQUIPMENT_TRANSFORM)

	arg0.metaBtn = arg0:findTF("meta_btn", arg0.bg)
	arg0.metaBtnTip = arg0.metaBtn:Find("tip")

	setActive(arg0.metaBtn, true)

	arg0.helpBtn = arg0:findTF("help_btn")
	arg0.lockedTpl = arg0:findTF("lockedTpl")
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")

	if not OPEN_TEC_TREE_SYSTEM then
		setActive(arg0.fleetBtn, false)
	end
end

function var0.didEnter(arg0)
	arg0:checkSystemOpen("ShipBluePrintMediator", arg0.bluePrintBtn)
	arg0:checkSystemOpen("TechnologyMediator", arg0.technologyBtn)
	arg0:checkSystemOpen("EquipmentTransformTreeMediator", arg0.transformBtn)
	arg0:checkSystemOpen("MetaCharacterMediator", arg0.metaBtn)
	onButton(arg0, arg0.fleetBtn, function()
		arg0:emit(TechnologyConst.OPEN_TECHNOLOGY_TREE_SCENE)
	end, SFX_PANEL)
	onButton(arg0, arg0.bluePrintBtn, function()
		arg0:emit(SelectTechnologyMediator.ON_BLUEPRINT)
	end, SFX_PANEL)
	onButton(arg0, arg0.technologyBtn, function()
		arg0:emit(SelectTechnologyMediator.ON_TECHNOLOGY)
	end, SFX_PANEL)
	onButton(arg0, arg0.transformBtn, function()
		arg0:emit(SelectTechnologyMediator.ON_TRANSFORM_EQUIPMENT)
	end, SFX_PANEL)
	onButton(arg0, arg0.metaBtn, function()
		if isActive(arg0:findTF("word", arg0.metaBtn)) then
			arg0:emit(SelectTechnologyMediator.ON_META)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_sys_lock_tip"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.playerVO.level, "ShipBluePrintMediator") and "help_technolog" or "help_technolog0"

		if pg.gametip[var0] then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip[var0].tip,
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0.checkSystemOpen(arg0, arg1, arg2)
	if arg1 == "MetaCharacterMediator" then
		local var0 = true

		setActive(arg0:findTF("word", arg2), var0)
		setGray(arg2, not var0)

		arg2:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, var0 and 1 or 0.7)

		local var1 = arg0:findTF("locked", arg2)

		if var1 then
			setActive(var1, false)
		end

		if not var0 then
			if IsNil(var1) then
				var1 = cloneTplTo(arg0.lockedTpl, arg2)
				var1.localPosition = Vector3.zero
			end

			setActive(var1, true)
		end

		return
	end

	local var2 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.playerVO.level, arg1)

	setActive(arg0:findTF("word", arg2), var2)
	setGray(arg2, not var2)

	arg2:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, var2 and 1 or 0.7)

	local var3 = arg0:findTF("locked", arg2)

	if var3 then
		setActive(var3, false)
	end

	if not var2 then
		if IsNil(var3) then
			var3 = cloneTplTo(arg0.lockedTpl, arg2)
			var3.localPosition = Vector3.zero
		end

		setActive(var3, true)
	end
end

function var0.notifyTechnology(arg0, arg1)
	setActive(arg0.technologyBtnTip, arg1)
end

function var0.notifyBlueprint(arg0, arg1)
	setActive(arg0.bluePrintBtnTip, arg1)
end

function var0.notifyFleet(arg0, arg1)
	setActive(arg0.fleetBtnTip, arg1)
end

function var0.notifyTransform(arg0, arg1)
	setActive(arg0.transformBtnTip, arg1)
end

function var0.notifyMeta(arg0, arg1)
	setActive(arg0.metaBtnTip, arg1)
end

function var0.willExit(arg0)
	return
end

return var0
