local var0_0 = class("IslandPhotoSharePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandPhotoShareUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.photoImgTrans = arg0_2._tf:Find("PhotoImg")
	arg0_2.shareBtnTrans = arg0_2._tf:Find("ShareBtn")
	arg0_2.confirmBtnTrans = arg0_2._tf:Find("ConfirmBtn")
	arg0_2.cancelBtnTrans = arg0_2._tf:Find("CancelBtn")
	arg0_2.frameBtn = arg0_2._tf:Find("frameBtn")
	arg0_2.photoAdapter = arg0_2._tf:Find("photoAdapter")
end

function var0_0.OnInit(arg0_3)
	arg0_3.frameDic = {}
	arg0_3.loadingDic = {}

	onButton(arg0_3, arg0_3.shareBtnTrans, function()
		local var0_4 = arg0_3.frameDic[arg0_3.selectFrameId]

		if var0_4 then
			local var1_4 = pg.island_camera_photo_frame[arg0_3.selectFrameId]

			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeDorm3dPhoto, nil, nil, true, var0_4:Find("frame").sizeDelta, var1_4.watermark_location)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtnTrans, function()
		local var0_5 = arg0_3.frameDic[arg0_3.selectFrameId]

		if var0_5 then
			local var1_5 = pg.ShareMgr.GetInstance()
			local var2_5 = var0_5:Find("frame").sizeDelta

			if pg.island_camera_photo_frame[arg0_3.selectFrameId].frameTfName == "IslandWoodFrame" then
				local var3_5 = var0_5:Find("frame"):GetComponent("Image").sprite
				local var4_5 = var0_5:Find("mask").sizeDelta
				local var5_5 = Object.Instantiate(var3_5.texture)
				local var6_5 = UnityEngine.Texture2D.New(var3_5.rect.width, var3_5.rect.height)
				local var7_5 = var5_5:GetPixels(0, 0, var3_5.rect.width, var3_5.rect.height)

				var6_5:SetPixels(var7_5)
				var6_5:Apply()
				arg0_3:TakePhoto(pg.ShareMgr.TypeDorm3dPhoto, var2_5, var6_5, var4_5)
			else
				arg0_3:TakePhoto(pg.ShareMgr.TypeDorm3dPhoto, var2_5)
			end
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Mask"), function()
		arg0_3:Hide()
	end)
	onButton(arg0_3, arg0_3.cancelBtnTrans, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.frameBtn, function()
		arg0_3:OpenPage(IslandPhotoSelectFramePage, arg0_3.bytes, arg0_3.photoTexture, arg0_3.selectFrameId, function(arg0_9)
			arg0_3:AfterSelectFrame(arg0_9)
		end)
	end)

	arg0_3.lateFuncDic = {}
	arg0_3.specialLateFuncDic = {}
end

function var0_0.OnShow(arg0_10, arg1_10, arg2_10)
	arg0_10.bytes = arg1_10
	arg0_10.photoTexture = arg2_10

	arg0_10:InitFrame()
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf, {
		staticBlur = true
	})
end

function var0_0.InitFrame(arg0_11)
	arg0_11.selectFrameId = 1001

	for iter0_11, iter1_11 in pairs(arg0_11.frameDic) do
		setActive(iter1_11, false)
	end

	arg0_11:LoadFrame({
		0,
		0
	})
end

function var0_0.AddListeners(arg0_12)
	return
end

function var0_0.RemoveListeners(arg0_13)
	return
end

function var0_0.AfterSelectFrame(arg0_14, arg1_14)
	arg0_14.selectFrameId = arg1_14.selectFrameId

	for iter0_14, iter1_14 in pairs(arg0_14.frameDic) do
		setActive(iter1_14, false)
	end

	arg0_14:LoadFrame(arg1_14.imagePos, arg1_14.imageScale, arg1_14.specialPosDic)
end

function var0_0.LoadFrame(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = pg.island_camera_photo_frame[arg0_15.selectFrameId]
	local var1_15 = var0_15.frameTfName == "IslandFilmFrame"
	local var2_15 = var0_15.frameTfName == "IslandInsFrame"

	local function var3_15(arg0_16)
		local var0_16 = arg0_16:Find("mask/realImage")
		local var1_16 = var0_16:GetComponent(typeof(RawImage))

		var1_16.texture = arg0_15.photoTexture
		var0_16.sizeDelta = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta

		setAnchoredPosition(var1_16, {
			x = arg1_15.x,
			y = arg1_15.y
		})

		if arg2_15 then
			var0_16.localScale = arg2_15
		end

		if arg3_15 then
			local var2_16 = {
				"mask_up/realImage"
			}

			if var1_15 then
				table.insert(var2_16, "mask_down/realImage")
			end

			local var3_16 = {
				"upPos",
				"downPos"
			}
			local var4_16 = {
				"upScale",
				"downScale"
			}

			for iter0_16, iter1_16 in ipairs(var2_16) do
				local var5_16 = arg0_16:Find(iter1_16)
				local var6_16 = var5_16:GetComponent(typeof(RawImage))

				var6_16.texture = arg0_15.photoTexture

				local var7_16 = GameObject.Find("OverlayCamera").transform:GetChild(0)

				if var2_15 and iter1_16 == "mask_up/realImage" then
					var5_16.sizeDelta = Vector2(var7_16.sizeDelta.x / 10, var7_16.sizeDelta.y / 10)
				else
					var5_16.sizeDelta = var7_16.sizeDelta
				end

				local var8_16 = var3_16[iter0_16]

				setAnchoredPosition(var6_16, {
					x = arg3_15[var8_16].x,
					y = arg3_15[var8_16].y
				})

				local var9_16 = arg3_15[var4_16[iter0_16]]

				if var9_16 then
					var5_16.localScale = var9_16
				end
			end
		end
	end

	local var4_15 = arg0_15.frameDic[arg0_15.selectFrameId]

	if var4_15 then
		setActive(var4_15, true)
		var3_15(var4_15)

		return
	end

	if arg0_15.loadingDic[arg0_15.selectFrameId] then
		return
	end

	local var5_15 = arg0_15.selectFrameId
	local var6_15 = IslandAssetLoadDispatcher.Instance:Enqueue("ui/" .. var0_15.frameTfName, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_17)
		arg0_15.loadingDic[var5_15] = false

		local var0_17 = Object.Instantiate(arg0_17, arg0_15.photoAdapter).transform

		arg0_15.frameDic[var5_15] = var0_17
		var0_17:Find("mask/realImage"):GetComponent(typeof(ScrollRect)).enabled = false
		var0_17:Find("mask/realImage"):GetComponent(typeof(PinchZoom)).enabled = false

		local var1_17 = var0_17:Find("mask_up/realImage")
		local var2_17 = var0_17:Find("mask_down/realImage")

		if var1_17 then
			var1_17:GetComponent(typeof(PinchZoom)).enabled = false
		end

		if var2_17 then
			var2_17:GetComponent(typeof(PinchZoom)).enabled = false
		end

		if arg0_15.selectFrameId == var5_15 then
			var3_15(var0_17)
		else
			setActive(var0_17, false)
		end

		var3_15(var0_17)
	end), true, true)

	table.insert(arg0_15.loadingIdList or {}, var6_15)
end

function var0_0.TakePhoto(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18 = {}
	local var1_18 = {}
	local var2_18 = {}
	local var3_18 = pg.share_template[arg1_18]

	assert(var3_18, "share_template not exist: " .. arg1_18)
	_.each(var3_18.hidden_comps, function(arg0_19)
		local var0_19 = GameObject.Find(arg0_19)

		if not IsNil(var0_19) and var0_19.activeSelf then
			table.insert(var0_18, var0_19)
			var0_19:SetActive(false)
		end
	end)
	_.each(var3_18.show_comps, function(arg0_20)
		local var0_20 = GameObject.Find(arg0_20)

		if not IsNil(var0_20) and not var0_20.activeSelf then
			table.insert(var1_18, var0_20)
			var0_20:SetActive(true)
		end
	end)
	_.each(var3_18.move_comps, function(arg0_21)
		local var0_21 = GameObject.Find(arg0_21.path)

		if not IsNil(var0_21) then
			local var1_21 = var0_21.transform.anchoredPosition.x
			local var2_21 = var0_21.transform.anchoredPosition.y
			local var3_21 = arg0_21.x
			local var4_21 = arg0_21.y

			table.insert(var2_18, {
				var0_21,
				var1_21,
				var2_21
			})
			setAnchoredPosition(var0_21, {
				x = var3_21,
				y = var4_21
			})
		end
	end)

	local var4_18 = GameObject.Find(var3_18.camera):GetComponent(typeof(Camera))
	local var5_18 = var4_18.transform:GetChild(0)

	local function var6_18(arg0_22)
		_.each(var0_18, function(arg0_23)
			arg0_23:SetActive(true)
		end)

		var0_18 = {}

		_.each(var1_18, function(arg0_24)
			arg0_24:SetActive(false)
		end)

		var1_18 = {}

		_.each(var2_18, function(arg0_25)
			setAnchoredPosition(arg0_25[1], {
				x = arg0_25[2],
				y = arg0_25[3]
			})
		end)

		var2_18 = {}

		local var0_22 = arg2_18.x / var5_18.sizeDelta.x * Screen.width
		local var1_22 = arg2_18.y / var5_18.sizeDelta.y * Screen.height
		local var2_22 = UnityEngine.Texture2D.New(var0_22, var1_22)
		local var3_22 = (Screen.width - var0_22) / 2
		local var4_22 = (Screen.height - var1_22) / 2
		local var5_22 = arg0_22:GetPixels(var3_22, var4_22, var0_22, var1_22)

		var2_22:SetPixels(var5_22)
		var2_22:Apply()

		if not arg4_18 then
			local var6_22 = Tex2DExtension.EncodeToPNG(var2_22)

			YSNormalTool.MediaTool.SaveImageWithBytes(var6_22, function(arg0_26, arg1_26)
				if arg0_26 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
				end
			end)

			return
		end

		local var7_22 = arg4_18.x / var5_18.sizeDelta.x * Screen.width
		local var8_22 = arg4_18.y / var5_18.sizeDelta.y * Screen.height
		local var9_22 = var0_22 - var7_22
		local var10_22 = var1_22 - var8_22
		local var11_22 = var2_22:GetPixels(var9_22 / 2, var10_22 / 2, var7_22, var8_22)

		arg3_18:SetPixels(var9_22 / 2, var10_22 / 2, var7_22, var8_22, var11_22)

		local var12_22 = Tex2DExtension.EncodeToPNG(arg3_18)

		YSNormalTool.MediaTool.SaveImageWithBytes(var12_22, function(arg0_27, arg1_27)
			if arg0_27 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
			end
		end)
	end

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(var4_18, var6_18)
end

function var0_0.OnHide(arg0_28)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28._tf)
end

function var0_0.OnDestroy(arg0_29)
	arg0_29:OnHide()

	for iter0_29, iter1_29 in ipairs(arg0_29.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_29)
	end

	arg0_29.loadingIdList = nil
end

return var0_0
