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
			local var4_5 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
			local var5_5 = "azur" .. var4_5.year .. var4_5.month .. var4_5.day .. var4_5.hour .. var4_5.min .. var4_5.sec .. ".jpg"
			local var6_5 = Application.persistentDataPath .. "/" .. var5_5

			MediaSaver.SaveImageWithBytes(var6_5, var3_5)
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
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

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
end

function var0_0.exit(arg0_10)
	var0_0.super.exit(arg0_10)
end

function var0_0.AfterSelectFrame(arg0_11, arg1_11)
	arg0_11.selectFrameId = arg1_11.selectFrameId

	for iter0_11, iter1_11 in pairs(arg0_11.frameDic) do
		setActive(iter1_11, false)
	end

	arg0_11:LoadFrame(arg1_11.imagePos, arg1_11.imageScale, arg1_11.specialPosDic)
end

function var0_0.InitFrame(arg0_12)
	arg0_12.selectFrameId = 1001

	arg0_12:LoadFrame({
		0,
		0
	})
end

function var0_0.LoadFrame(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = pg.dorm3d_camera_photo_frame[arg0_13.selectFrameId]
	local var1_13 = var0_13.frameTfName == "FilmFrame"
	local var2_13 = var0_13.frameTfName == "InsFrame"

	local function var3_13(arg0_14)
		local var0_14 = arg0_14:Find("mask/realImage")
		local var1_14 = var0_14:GetComponent(typeof(RawImage))

		var1_14.texture = arg0_13.contextData.photoTex
		var0_14.sizeDelta = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta

		setAnchoredPosition(var1_14, {
			x = arg1_13.x,
			y = arg1_13.y
		})

		if arg2_13 then
			var0_14.localScale = arg2_13
		end

		if arg3_13 then
			local var2_14 = {
				"mask_up/realImage"
			}

			if var1_13 then
				table.insert(var2_14, "mask_down/realImage")
			end

			local var3_14 = {
				"upPos",
				"downPos"
			}
			local var4_14 = {
				"upScale",
				"downScale"
			}

			for iter0_14, iter1_14 in ipairs(var2_14) do
				local var5_14 = arg0_14:Find(iter1_14)
				local var6_14 = var5_14:GetComponent(typeof(RawImage))

				var6_14.texture = arg0_13.contextData.photoTex

				local var7_14 = GameObject.Find("OverlayCamera").transform:GetChild(0)

				if var2_13 and iter1_14 == "mask_up/realImage" then
					var5_14.sizeDelta = Vector2(var7_14.sizeDelta.x / 10, var7_14.sizeDelta.y / 10)
				else
					var5_14.sizeDelta = var7_14.sizeDelta
				end

				local var8_14 = var3_14[iter0_14]

				setAnchoredPosition(var6_14, {
					x = arg3_13[var8_14].x,
					y = arg3_13[var8_14].y
				})

				local var9_14 = arg3_13[var4_14[iter0_14]]

				if var9_14 then
					var5_14.localScale = var9_14
				end
			end
		end
	end

	local var4_13 = arg0_13.frameDic[arg0_13.selectFrameId]

	if var4_13 then
		setActive(var4_13, true)
		var3_13(var4_13)

		return
	end

	if arg0_13.loadingDic[arg0_13.selectFrameId] then
		return
	end

	local var5_13 = arg0_13.selectFrameId

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_13.frameTfName, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_15)
		arg0_13.loadingDic[var5_13] = false

		local var0_15 = Object.Instantiate(arg0_15, arg0_13.photoAdapter).transform

		arg0_13.frameDic[var5_13] = var0_15

		if arg0_13.selectFrameId == var5_13 then
			var3_13(var0_15)
		else
			setActive(var0_15, false)
		end

		var0_15:Find("mask/realImage"):GetComponent(typeof(ScrollRect)).enabled = false
		var0_15:Find("mask/realImage"):GetComponent(typeof(PinchZoom)).enabled = false

		local var1_15 = var0_15:Find("mask_up/realImage")
		local var2_15 = var0_15:Find("mask_down/realImage")

		if var1_15 then
			var1_15:GetComponent(typeof(PinchZoom)).enabled = false
		end

		if var2_15 then
			var2_15:GetComponent(typeof(PinchZoom)).enabled = false
		end

		var3_13(var0_15)
	end), true, true)
end

function var0_0.TakePhoto(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = {}
	local var2_16 = {}
	local var3_16 = pg.share_template[arg1_16]

	assert(var3_16, "share_template not exist: " .. arg1_16)
	_.each(var3_16.hidden_comps, function(arg0_17)
		local var0_17 = GameObject.Find(arg0_17)

		if not IsNil(var0_17) and var0_17.activeSelf then
			table.insert(var0_16, var0_17)
			var0_17:SetActive(false)
		end
	end)
	_.each(var3_16.show_comps, function(arg0_18)
		local var0_18 = GameObject.Find(arg0_18)

		if not IsNil(var0_18) and not var0_18.activeSelf then
			table.insert(var1_16, var0_18)
			var0_18:SetActive(true)
		end
	end)
	_.each(var3_16.move_comps, function(arg0_19)
		local var0_19 = GameObject.Find(arg0_19.path)

		if not IsNil(var0_19) then
			local var1_19 = var0_19.transform.anchoredPosition.x
			local var2_19 = var0_19.transform.anchoredPosition.y
			local var3_19 = arg0_19.x
			local var4_19 = arg0_19.y

			table.insert(var2_16, {
				var0_19,
				var1_19,
				var2_19
			})
			setAnchoredPosition(var0_19, {
				x = var3_19,
				y = var4_19
			})
		end
	end)

	local var4_16 = GameObject.Find(var3_16.camera):GetComponent(typeof(Camera))
	local var5_16 = var4_16.transform:GetChild(0)
	local var6_16 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)
	local var7_16 = arg0_16:TakeTexture(var6_16, var4_16)

	_.each(var0_16, function(arg0_20)
		arg0_20:SetActive(true)
	end)

	var0_16 = {}

	_.each(var1_16, function(arg0_21)
		arg0_21:SetActive(false)
	end)

	var1_16 = {}

	_.each(var2_16, function(arg0_22)
		setAnchoredPosition(arg0_22[1], {
			x = arg0_22[2],
			y = arg0_22[3]
		})
	end)

	var2_16 = {}

	local var8_16 = arg2_16.x / var5_16.sizeDelta.x * Screen.width
	local var9_16 = arg2_16.y / var5_16.sizeDelta.y * Screen.height
	local var10_16 = UnityEngine.Texture2D.New(var8_16, var9_16)
	local var11_16 = (Screen.width - var8_16) / 2
	local var12_16 = (Screen.height - var9_16) / 2
	local var13_16 = var7_16:GetPixels(var11_16, var12_16, var8_16, var9_16)

	var10_16:SetPixels(var13_16)
	var10_16:Apply()

	local var14_16 = var6_16:EncodeToJPG(var10_16)

	return (Tex2DExtension.EncodeToJPG(var14_16))
end

function var0_0.TakeTexture(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:TakePhoto(arg2_23)

	return (arg1_23:EncodeToJPG(var0_23))
end

return var0_0
