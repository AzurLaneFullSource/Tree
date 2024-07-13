local var0_0 = class("SelectTechnologyLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectTechnologyUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.init(arg0_4)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		weight = LayerWeightConst.LOWER_LAYER
	})

	arg0_4.bg = arg0_4:findTF("frame/bg")
	arg0_4.bluePrintBtn = arg0_4:findTF("blueprint_btn", arg0_4.bg)
	arg0_4.bluePrintBtnTip = arg0_4.bluePrintBtn:Find("tip")
	arg0_4.technologyBtn = arg0_4:findTF("technology_btn", arg0_4.bg)
	arg0_4.technologyBtnTip = arg0_4.technologyBtn:Find("tip")
	arg0_4.fleetBtn = arg0_4:findTF("fleet_btn", arg0_4.bg)
	arg0_4.fleetBtnTip = arg0_4.fleetBtn:Find("tip")
	arg0_4.transformBtn = arg0_4:findTF("transform_btn", arg0_4.bg)
	arg0_4.transformBtnTip = arg0_4.transformBtn:Find("tip")

	setActive(arg0_4.transformBtn, not LOCK_EQUIPMENT_TRANSFORM)

	arg0_4.metaBtn = arg0_4:findTF("meta_btn", arg0_4.bg)
	arg0_4.metaBtnTip = arg0_4.metaBtn:Find("tip")

	setActive(arg0_4.metaBtn, true)

	arg0_4.helpBtn = arg0_4:findTF("help_btn")
	arg0_4.lockedTpl = arg0_4:findTF("lockedTpl")
	arg0_4.backBtn = arg0_4:findTF("blur_panel/adapt/top/back")

	if not OPEN_TEC_TREE_SYSTEM then
		setActive(arg0_4.fleetBtn, false)
	end
end

function var0_0.didEnter(arg0_5)
	arg0_5:checkSystemOpen("ShipBluePrintMediator", arg0_5.bluePrintBtn)
	arg0_5:checkSystemOpen("TechnologyMediator", arg0_5.technologyBtn)
	arg0_5:checkSystemOpen("EquipmentTransformTreeMediator", arg0_5.transformBtn)
	arg0_5:checkSystemOpen("MetaCharacterMediator", arg0_5.metaBtn)
	onButton(arg0_5, arg0_5.fleetBtn, function()
		arg0_5:emit(TechnologyConst.OPEN_TECHNOLOGY_TREE_SCENE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.bluePrintBtn, function()
		arg0_5:emit(SelectTechnologyMediator.ON_BLUEPRINT)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.technologyBtn, function()
		arg0_5:emit(SelectTechnologyMediator.ON_TECHNOLOGY)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.transformBtn, function()
		arg0_5:emit(SelectTechnologyMediator.ON_TRANSFORM_EQUIPMENT)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.metaBtn, function()
		if isActive(arg0_5:findTF("word", arg0_5.metaBtn)) then
			arg0_5:emit(SelectTechnologyMediator.ON_META)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_sys_lock_tip"))
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		local var0_12 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_5.playerVO.level, "ShipBluePrintMediator") and "help_technolog" or "help_technolog0"

		if pg.gametip[var0_12] then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip[var0_12].tip,
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0_0.checkSystemOpen(arg0_13, arg1_13, arg2_13)
	if arg1_13 == "MetaCharacterMediator" then
		local var0_13 = true

		setActive(arg0_13:findTF("word", arg2_13), var0_13)
		setGray(arg2_13, not var0_13)

		arg2_13:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, var0_13 and 1 or 0.7)

		local var1_13 = arg0_13:findTF("locked", arg2_13)

		if var1_13 then
			setActive(var1_13, false)
		end

		if not var0_13 then
			if IsNil(var1_13) then
				var1_13 = cloneTplTo(arg0_13.lockedTpl, arg2_13)
				var1_13.localPosition = Vector3.zero
			end

			setActive(var1_13, true)
		end

		return
	end

	local var2_13 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_13.playerVO.level, arg1_13)

	setActive(arg0_13:findTF("word", arg2_13), var2_13)
	setGray(arg2_13, not var2_13)

	arg2_13:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, var2_13 and 1 or 0.7)

	local var3_13 = arg0_13:findTF("locked", arg2_13)

	if var3_13 then
		setActive(var3_13, false)
	end

	if not var2_13 then
		if IsNil(var3_13) then
			var3_13 = cloneTplTo(arg0_13.lockedTpl, arg2_13)
			var3_13.localPosition = Vector3.zero
		end

		setActive(var3_13, true)
	end
end

function var0_0.notifyTechnology(arg0_14, arg1_14)
	setActive(arg0_14.technologyBtnTip, arg1_14)
end

function var0_0.notifyBlueprint(arg0_15, arg1_15)
	setActive(arg0_15.bluePrintBtnTip, arg1_15)
end

function var0_0.notifyFleet(arg0_16, arg1_16)
	setActive(arg0_16.fleetBtnTip, arg1_16)
end

function var0_0.notifyTransform(arg0_17, arg1_17)
	setActive(arg0_17.transformBtnTip, arg1_17)
end

function var0_0.notifyMeta(arg0_18, arg1_18)
	setActive(arg0_18.metaBtnTip, arg1_18)
end

function var0_0.willExit(arg0_19)
	return
end

return var0_0
