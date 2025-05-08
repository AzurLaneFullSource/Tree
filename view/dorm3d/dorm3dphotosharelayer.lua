local var0_0 = class("Dorm3dPhotoShareLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dPhotoShareUI"
end

function var0_0.init(arg0_2)
	arg0_2.photoImgTrans = arg0_2:findTF("PhotoImg")
	arg0_2.shareBtnTrans = arg0_2:findTF("ShareBtn")
	arg0_2.confirmBtnTrans = arg0_2:findTF("ConfirmBtn")
	arg0_2.cancelBtnTrans = arg0_2:findTF("CancelBtn")
	arg0_2.frameBtn = arg0_2:findTF("frameBtn")
	arg0_2.photoAdapter = arg0_2:findTF("photoAdapter")
	arg0_2.bytes = arg0_2.contextData.photoData
	arg0_2.frameDic = {}
	arg0_2.loadingDic = {}

	arg0_2:InitFrame()
end

function var0_0.didEnter(arg0_3)
	local var0_3 = false

	onButton(arg0_3, arg0_3.shareBtnTrans, function()
		local var0_4 = arg0_3.frameDic[arg0_3.selectFrameId]

		if var0_4 then
			local var1_4 = pg.dorm3d_camera_photo_frame[arg0_3.selectFrameId]

			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeDorm3dPhoto, nil, {
				weight = LayerWeightConst.TOP_LAYER
			}, true, var0_4:Find("frame").sizeDelta, var1_4.watermark_location)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtnTrans, function()
		local var0_5 = arg0_3.frameDic[arg0_3.selectFrameId]

		if var0_5 then
			local var1_5 = pg.ShareMgr.GetInstance()
			local var2_5 = var0_5:Find("frame").sizeDelta
			local var3_5 = arg0_3:TakePhoto(pg.ShareMgr.TypeDorm3dPhoto, var2_5)

			YSNormalTool.MediaTool.SaveImageWithBytes(var3_5, function(arg0_6, arg1_6)
				if arg0_6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
				end
			end)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Mask"), function()
		arg0_3:closeView()
	end)
	onButton(arg0_3, arg0_3.cancelBtnTrans, function()
		arg0_3:emit(Dorm3dPhotoShareLayerMediator.EXIT_SHARE)
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.frameBtn, function()
		arg0_3:emit(Dorm3dPhotoShareLayerMediator.SELECTFRAME, arg0_3.contextData.photoTex, arg0_3.contextData.photoData)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf)
end

function var0_0.exit(arg0_11)
	var0_0.super.exit(arg0_11)
end

function var0_0.AfterSelectFrame(arg0_12, arg1_12)
	arg0_12.selectFrameId = arg1_12.selectFrameId

	for iter0_12, iter1_12 in pairs(arg0_12.frameDic) do
		setActive(iter1_12, false)
	end

	arg0_12:LoadFrame(arg1_12.imagePos, arg1_12.imageScale, arg1_12.specialPosDic)
end

function var0_0.InitFrame(arg0_13)
	arg0_13.selectFrameId = 1001

	arg0_13:LoadFrame({
		0,
		0
	})
end

function var0_0.LoadFrame(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = pg.dorm3d_camera_photo_frame[arg0_14.selectFrameId]
	local var1_14 = var0_14.frameTfName == "FilmFrame"
	local var2_14 = var0_14.frameTfName == "InsFrame"

	local function var3_14(arg0_15)
		local var0_15 = arg0_15:Find("mask/realImage")
		local var1_15 = var0_15:GetComponent(typeof(RawImage))

		var1_15.texture = arg0_14.contextData.photoTex
		var0_15.sizeDelta = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta

		setAnchoredPosition(var1_15, {
			x = arg1_14.x,
			y = arg1_14.y
		})

		if arg2_14 then
			var0_15.localScale = arg2_14
		end

		if arg3_14 then
			local var2_15 = {
				"mask_up/realImage"
			}

			if var1_14 then
				table.insert(var2_15, "mask_down/realImage")
			end

			local var3_15 = {
				"upPos",
				"downPos"
			}
			local var4_15 = {
				"upScale",
				"downScale"
			}

			for iter0_15, iter1_15 in ipairs(var2_15) do
				local var5_15 = arg0_15:Find(iter1_15)
				local var6_15 = var5_15:GetComponent(typeof(RawImage))

				var6_15.texture = arg0_14.contextData.photoTex

				local var7_15 = GameObject.Find("OverlayCamera").transform:GetChild(0)

				if var2_14 and iter1_15 == "mask_up/realImage" then
					var5_15.sizeDelta = Vector2(var7_15.sizeDelta.x / 10, var7_15.sizeDelta.y / 10)
				else
					var5_15.sizeDelta = var7_15.sizeDelta
				end

				local var8_15 = var3_15[iter0_15]

				setAnchoredPosition(var6_15, {
					x = arg3_14[var8_15].x,
					y = arg3_14[var8_15].y
				})

				local var9_15 = arg3_14[var4_15[iter0_15]]

				if var9_15 then
					var5_15.localScale = var9_15
				end
			end
		end
	end

	local var4_14 = arg0_14.frameDic[arg0_14.selectFrameId]

	if var4_14 then
		setActive(var4_14, true)
		var3_14(var4_14)

		return
	end

	if arg0_14.loadingDic[arg0_14.selectFrameId] then
		return
	end

	local var5_14 = arg0_14.selectFrameId

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_14.frameTfName, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_16)
		arg0_14.loadingDic[var5_14] = false

		local var0_16 = Object.Instantiate(arg0_16, arg0_14.photoAdapter).transform

		arg0_14.frameDic[var5_14] = var0_16

		if arg0_14.selectFrameId == var5_14 then
			var3_14(var0_16)
		else
			setActive(var0_16, false)
		end

		var0_16:Find("mask/realImage"):GetComponent(typeof(ScrollRect)).enabled = false
		var0_16:Find("mask/realImage"):GetComponent(typeof(PinchZoom)).enabled = false

		local var1_16 = var0_16:Find("mask_up/realImage")
		local var2_16 = var0_16:Find("mask_down/realImage")

		if var1_16 then
			var1_16:GetComponent(typeof(PinchZoom)).enabled = false
		end

		if var2_16 then
			var2_16:GetComponent(typeof(PinchZoom)).enabled = false
		end

		var3_14(var0_16)
	end), true, true)
end

function var0_0.TakePhoto(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}
	local var1_17 = {}
	local var2_17 = {}
	local var3_17 = pg.share_template[arg1_17]

	assert(var3_17, "share_template not exist: " .. arg1_17)
	_.each(var3_17.hidden_comps, function(arg0_18)
		local var0_18 = GameObject.Find(arg0_18)

		if not IsNil(var0_18) and var0_18.activeSelf then
			table.insert(var0_17, var0_18)
			var0_18:SetActive(false)
		end
	end)
	_.each(var3_17.show_comps, function(arg0_19)
		local var0_19 = GameObject.Find(arg0_19)

		if not IsNil(var0_19) and not var0_19.activeSelf then
			table.insert(var1_17, var0_19)
			var0_19:SetActive(true)
		end
	end)
	_.each(var3_17.move_comps, function(arg0_20)
		local var0_20 = GameObject.Find(arg0_20.path)

		if not IsNil(var0_20) then
			local var1_20 = var0_20.transform.anchoredPosition.x
			local var2_20 = var0_20.transform.anchoredPosition.y
			local var3_20 = arg0_20.x
			local var4_20 = arg0_20.y

			table.insert(var2_17, {
				var0_20,
				var1_20,
				var2_20
			})
			setAnchoredPosition(var0_20, {
				x = var3_20,
				y = var4_20
			})
		end
	end)

	local var4_17 = GameObject.Find(var3_17.camera):GetComponent(typeof(Camera))
	local var5_17 = var4_17.transform:GetChild(0)
	local var6_17 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)
	local var7_17 = arg0_17:TakeTexture(var6_17, var4_17)

	_.each(var0_17, function(arg0_21)
		arg0_21:SetActive(true)
	end)

	var0_17 = {}

	_.each(var1_17, function(arg0_22)
		arg0_22:SetActive(false)
	end)

	var1_17 = {}

	_.each(var2_17, function(arg0_23)
		setAnchoredPosition(arg0_23[1], {
			x = arg0_23[2],
			y = arg0_23[3]
		})
	end)

	var2_17 = {}

	local var8_17 = arg2_17.x / var5_17.sizeDelta.x * Screen.width
	local var9_17 = arg2_17.y / var5_17.sizeDelta.y * Screen.height
	local var10_17 = UnityEngine.Texture2D.New(var8_17, var9_17)
	local var11_17 = (Screen.width - var8_17) / 2
	local var12_17 = (Screen.height - var9_17) / 2
	local var13_17 = var7_17:GetPixels(var11_17, var12_17, var8_17, var9_17)

	var10_17:SetPixels(var13_17)
	var10_17:Apply()

	local var14_17 = var6_17:EncodeToJPG(var10_17)

	return (Tex2DExtension.EncodeToJPG(var14_17))
end

function var0_0.TakeTexture(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:TakePhoto(arg2_24)

	return (arg1_24:EncodeToJPG(var0_24))
end

return var0_0
