local var0_0 = class("Dorm3dDanceGameSubView", import("..Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1.gamePanel = arg0_1._tf:Find("main")
	arg0_1.cameraContainer = arg0_1.gamePanel:Find("camera")
	arg0_1.gameCucoloris = arg0_1.gamePanel:Find("cucoloris")
	arg0_1.gamePhotos = arg0_1.gamePanel:Find("photos")
	arg0_1.btnHide = arg0_1.gamePanel:Find("bottom/btn_hide")
	arg0_1.btnPhoto = arg0_1.gamePanel:Find("bottom/btn_photo")
	arg0_1.btnGameEnd = arg0_1.gamePanel:Find("bottom/game_end")
	arg0_1.photoCountText = arg0_1.gamePanel:Find("bottom/count")
	arg0_1.photoTpl = arg0_1.gamePanel:Find("tpl")
	arg0_1.gameHideClickUI = arg0_1._tf:Find("hide_click")

	setActive(arg0_1.gameHideClickUI, false)
	setText(arg0_1.btnGameEnd:Find("Text"), i18n("dorm3d_cafe_minigame3"))
	onButton(arg0_1, arg0_1.btnHide, function()
		setActive(arg0_1.gamePanel, false)
		setActive(arg0_1.gameHideClickUI, true)
		arg0_1.contextData.onShowOrHideBaseUI(false)
	end, SFX_DORM_CLICK)
	onButton(arg0_1, arg0_1.gameHideClickUI, function()
		setActive(arg0_1.gamePanel, true)
		setActive(arg0_1.gameHideClickUI, false)
		arg0_1.contextData.onShowOrHideBaseUI(true)
	end, SFX_DORM_CLICK)
	onButton(arg0_1, arg0_1.btnPhoto, function()
		arg0_1.contextData.onTakePhoto()
	end, SFX_DORM_CLICK)
	onButton(arg0_1, arg0_1.btnGameEnd, function()
		arg0_1.contextData.onEndGame()
	end, SFX_DORM_CLICK)
	onButton(arg0_1, arg0_1.gamePhotos, function()
		if #arg0_1.contextData.photoData == 0 then
			return
		end

		arg0_1.contextData.onShowPhotoWindow(#arg0_1.contextData.photoData)
	end)

	arg0_1.gameConfig = pg.dorm3d_dance[arg0_1.contextData.groupId]
	arg0_1.cameraItemList = UIItemList.New(arg0_1.cameraContainer, arg0_1.cameraContainer:Find("tpl"))

	arg0_1.cameraItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg0_1:UpdateCameraFunc(arg0_7, arg1_7, arg2_7)
	end)

	arg0_1.selectedCameraIndex = 1
end

function var0_0.UpdateCameraFunc(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8 + 1
	local var1_8 = arg0_8.gameConfig.camera_names[var0_8]
	local var2_8 = arg0_8.gameConfig.camera_tracks[var0_8]

	if arg1_8 == UIItemList.EventUpdate then
		local var3_8 = var0_8 == arg0_8.selectedCameraIndex

		setActive(arg3_8:Find("selected"), var3_8)
		setActive(arg3_8:Find("normal"), not var3_8)
	elseif arg1_8 == UIItemList.EventInit then
		setText(arg3_8:Find("selected/Text"), var1_8)
		setText(arg3_8:Find("normal/Text"), var1_8)
		onButton(arg0_8, arg3_8, function()
			if arg0_8.selectedCameraIndex ~= var0_8 then
				arg0_8.selectedCameraIndex = var0_8

				arg0_8.contextData.onSwitchCamera(var2_8)
				arg0_8:FlushCamera()
			end
		end, SFX_DORM_CLICK)
	end
end

function var0_0.FlushCamera(arg0_10)
	arg0_10.cameraItemList:align(#arg0_10.gameConfig.camera_names)
end

function var0_0.Flush(arg0_11)
	local var0_11 = ShipGroup.getDefaultShipNameByGroupID(arg0_11.contextData.groupId)

	setText(arg0_11._tf:Find("main/hint"), i18n("dorm3d_cafe_minigame2", var0_11))

	local var1_11 = #arg0_11.contextData.photoData
	local var2_11 = var1_11 >= Dorm3dDanceConst.PHOTO_TIMES

	setActive(arg0_11.btnPhoto, not var2_11)
	setActive(arg0_11.photoCountText, not var2_11)
	setText(arg0_11.photoCountText, var1_11 .. "/" .. Dorm3dDanceConst.PHOTO_TIMES)
	setActive(arg0_11.btnGameEnd, var2_11)
	arg0_11:FlushCamera()

	for iter0_11 = 1, #arg0_11.contextData.cucoloris do
		local var3_11 = arg0_11.gameCucoloris:GetChild(iter0_11 - 1)

		LoadImageSpriteAtlasAsync(arg0_11.contextData.cucoloris[iter0_11]:GetIcon(), "", var3_11:Find("Image"), true)
	end

	if var1_11 > arg0_11.gamePhotos.childCount then
		local var4_11 = cloneTplTo(arg0_11.photoTpl, arg0_11.gamePhotos)
		local var5_11 = math.random(Dorm3dDanceConst.GAME_RANDOM_RANGE_POSX[1], Dorm3dDanceConst.GAME_RANDOM_RANGE_POSX[2])
		local var6_11 = math.random(Dorm3dDanceConst.GAME_RANDOM_RANGE_POSY[1], Dorm3dDanceConst.GAME_RANDOM_RANGE_POSY[2])
		local var7_11 = math.random(Dorm3dDanceConst.GAME_RANDOM_RANGE_ANGLE[1], Dorm3dDanceConst.GAME_RANDOM_RANGE_ANGLE[2])

		var4_11.localPosition = Vector3(var5_11, var6_11, 0)
		var4_11.localEulerAngles = Vector3(0, 0, var7_11)

		arg0_11.contextData.onShowRealImage(var1_11, var4_11:Find("mask/Image"), var4_11:Find("mask"))
	end
end

function var0_0.ClearPhoto(arg0_12)
	for iter0_12 = arg0_12.gamePhotos.childCount, 1, -1 do
		Destroy(arg0_12.gamePhotos:GetChild(iter0_12 - 1).gameObject)
	end
end

return var0_0
