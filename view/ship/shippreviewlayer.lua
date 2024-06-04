local var0 = class("ShipPreviewLayer", import("..base.BaseUI"))
local var1 = 12
local var2 = 3
local var3 = Vector3(0, 1, 40)

function var0.getUIName(arg0)
	return "ShipPreviewUI"
end

function var0.init(arg0)
	arg0.UIMgr = pg.UIMgr.GetInstance()

	arg0.UIMgr:BlurPanel(arg0._tf, false, arg0.contextData.weight and {
		weight = arg0.contextData.weight
	} or {})

	arg0.UIMain = arg0.UIMgr.UIMain
	arg0.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0.leftPanel = arg0:findTF("left_panel")
	arg0.sea = arg0:findTF("sea", arg0.leftPanel)
	arg0.seaCamera = arg0.seaCameraGO:GetComponent("Camera")
	arg0.seaCamera.enabled = true
	arg0.rawImage = arg0.sea:GetComponent("RawImage")

	setActive(arg0.rawImage, false)

	arg0.seaCamera.targetTexture = arg0.rawImage.texture
	arg0.healTF = arg0:findTF("resources/heal")
	arg0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0.healTF, false)
	arg0.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0.healTF, false)
		setText(arg0.healTF:Find("text"), "")
	end)

	arg0.seaLoading = arg0:findTF("bg/loading", arg0.leftPanel)

	arg0:playLoadingAni()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.seaLoading, function()
		if not arg0.previewer then
			arg0:showBarrage()
		end
	end)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end)
end

function var0.setShip(arg0, arg1, arg2, arg3)
	arg0.shipVO = arg1
	arg0.weaponIds = arg2
	arg0.equipSkinId = arg3
end

function var0.showBarrage(arg0)
	arg0.previewer = WeaponPreviewer.New(arg0.rawImage)

	arg0.previewer:configUI(arg0.healTF)
	arg0.previewer:setDisplayWeapon(arg0.weaponIds, arg0.equipSkinId, true)
	arg0.previewer:load(40000, arg0.shipVO, arg0.weaponIds, function()
		arg0:stopLoadingAni()
	end)
end

function var0.getWaponIdsById(arg0, arg1)
	return arg0.ship_data_breakout[arg1].weapon_ids
end

function var0.playLoadingAni(arg0)
	setActive(arg0.seaLoading, true)
end

function var0.stopLoadingAni(arg0)
	setActive(arg0.seaLoading, false)
end

function var0.willExit(arg0)
	arg0.UIMgr:UnblurPanel(arg0._tf, arg0.UIMain)

	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end
end

return var0
