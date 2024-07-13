local var0_0 = class("ShipPreviewLayer", import("..base.BaseUI"))
local var1_0 = 12
local var2_0 = 3
local var3_0 = Vector3(0, 1, 40)

function var0_0.getUIName(arg0_1)
	return "ShipPreviewUI"
end

function var0_0.init(arg0_2)
	arg0_2.UIMgr = pg.UIMgr.GetInstance()

	arg0_2.UIMgr:BlurPanel(arg0_2._tf, false, arg0_2.contextData.weight and {
		weight = arg0_2.contextData.weight
	} or {})

	arg0_2.UIMain = arg0_2.UIMgr.UIMain
	arg0_2.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0_2.leftPanel = arg0_2:findTF("left_panel")
	arg0_2.sea = arg0_2:findTF("sea", arg0_2.leftPanel)
	arg0_2.seaCamera = arg0_2.seaCameraGO:GetComponent("Camera")
	arg0_2.seaCamera.enabled = true
	arg0_2.rawImage = arg0_2.sea:GetComponent("RawImage")

	setActive(arg0_2.rawImage, false)

	arg0_2.seaCamera.targetTexture = arg0_2.rawImage.texture
	arg0_2.healTF = arg0_2:findTF("resources/heal")
	arg0_2.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_2.healTF, false)
	arg0_2.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0_2.healTF, false)
		setText(arg0_2.healTF:Find("text"), "")
	end)

	arg0_2.seaLoading = arg0_2:findTF("bg/loading", arg0_2.leftPanel)

	arg0_2:playLoadingAni()
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.seaLoading, function()
		if not arg0_4.previewer then
			arg0_4:showBarrage()
		end
	end)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)
end

function var0_0.setShip(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.shipVO = arg1_7
	arg0_7.weaponIds = arg2_7
	arg0_7.equipSkinId = arg3_7
end

function var0_0.showBarrage(arg0_8)
	arg0_8.previewer = WeaponPreviewer.New(arg0_8.rawImage)

	arg0_8.previewer:configUI(arg0_8.healTF)
	arg0_8.previewer:setDisplayWeapon(arg0_8.weaponIds, arg0_8.equipSkinId, true)
	arg0_8.previewer:load(40000, arg0_8.shipVO, arg0_8.weaponIds, function()
		arg0_8:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_10, arg1_10)
	return arg0_10.ship_data_breakout[arg1_10].weapon_ids
end

function var0_0.playLoadingAni(arg0_11)
	setActive(arg0_11.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_12)
	setActive(arg0_12.seaLoading, false)
end

function var0_0.willExit(arg0_13)
	arg0_13.UIMgr:UnblurPanel(arg0_13._tf, arg0_13.UIMain)

	if arg0_13.previewer then
		arg0_13.previewer:clear()

		arg0_13.previewer = nil
	end
end

return var0_0
