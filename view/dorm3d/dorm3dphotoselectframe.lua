local var0_0 = class("Dorm3dPhotoSelectFrame", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dPhotoSelectfFrameUI"
end

function var0_0.init(arg0_2)
	arg0_2.cancelBtnTrans = arg0_2:findTF("cancelBtn")
	arg0_2.confirmBtnTrans = arg0_2:findTF("selectPage/confirmBtn")
	arg0_2.frameAdapter = arg0_2:findTF("frameAdapter")

	local var0_2 = arg0_2:findTF("selectPage/Scroll/Viewport/Content")
	local var1_2 = pg.dorm3d_camera_photo_frame.all

	local function var2_2()
		UIItemList.StaticAlign(var0_2, var0_2:GetChild(0), #var1_2, function(arg0_4, arg1_4, arg2_4)
			if arg0_4 ~= UIItemList.EventUpdate then
				return
			end

			arg1_4 = arg1_4 + 1

			setActive(arg2_4:Find("Selected"), arg0_2.selectIndex == arg1_4)
		end)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, true, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_2.frameDic = {}
	arg0_2.loadingDic = {}
	arg0_2.lateFuncDic = {}

	UIItemList.StaticAlign(var0_2, var0_2:GetChild(0), #var1_2, function(arg0_5, arg1_5, arg2_5)
		if arg0_5 ~= UIItemList.EventUpdate then
			return
		end

		arg1_5 = arg1_5 + 1

		local var0_5 = pg.dorm3d_camera_photo_frame[var1_2[arg1_5]]

		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_5.farme_small_path), "", arg2_5:Find("Icon"))
		setActive(arg2_5:Find("Selected"), false)

		local var1_5, var2_5 = ApartmentProxy.CheckUnlockConfig(var0_5.unlock)

		setActive(arg2_5:Find("lock"), not var1_5)

		if not var1_5 then
			setText(arg2_5:Find("lock/Image/Text"), var0_5.unlock_text)
		end

		onButton(arg0_2, arg2_5, function()
			if not var1_5 then
				pg.TipsMgr.GetInstance():ShowTips(var2_5)

				return
			end

			if arg0_2.selectIndex == arg1_5 then
				return
			end

			arg0_2.selectIndex = arg1_5

			var2_2()

			for iter0_6, iter1_6 in pairs(arg0_2.frameDic) do
				setActive(iter1_6, false)
			end

			local function var0_6(arg0_7)
				local var0_7 = arg0_7:Find("mask/realImage")

				var0_7:GetComponent(typeof(RawImage)).texture = arg0_2.contextData.photoTex
				var0_7.sizeDelta = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta

				setAnchoredPosition(var0_7, {
					x = 0,
					y = 0
				})

				var0_7.localScale = Vector3(1, 1, 1)
			end

			local var1_6 = arg0_2.frameDic[arg0_2.selectIndex]

			if var1_6 then
				setActive(var1_6, true)
				var0_6(var1_6)

				return
			end

			if arg0_2.loadingDic[arg1_5] then
				return
			end

			arg0_2.loadingDic[arg1_5] = true

			ResourceMgr.Inst:getAssetAsync("ui/" .. var0_5.frameTfName, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
				arg0_2.loadingDic[arg1_5] = false

				local var0_8 = Object.Instantiate(arg0_8, arg0_2.frameAdapter).transform

				arg0_2.frameDic[arg1_5] = var0_8

				;(function()
					local var0_9 = var0_8:Find("mask/realImage")
					local var1_9 = GetOrAddComponent(var0_8:Find("mask/realImage"), "PinchZoom")
					local var2_9 = GetOrAddComponent(var0_8:Find("mask/realImage"), "EventTriggerListener")
					local var3_9 = true

					var2_9:AddPointDownFunc(function(arg0_10)
						if Input.touchCount == 1 or IsUnityEditor then
							var3_9 = true
						elseif Input.touchCount >= 2 then
							var3_9 = false
						end
					end)
					var2_9:AddPointUpFunc(function(arg0_11)
						if Input.touchCount <= 2 then
							var3_9 = true
						end
					end)

					local var4_9 = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta
					local var5_9 = var0_8:Find("mask").sizeDelta

					var2_9:AddBeginDragFunc(function(arg0_12, arg1_12)
						touchOffsetX = arg1_12.position.x - var0_9.localPosition.x
						touchOffsetY = arg1_12.position.y - var0_9.localPosition.y
					end)

					local var6_9 = LateUpdateBeat:CreateListener(function()
						if var1_9.processing then
							local var0_13 = var0_9.localScale
							local var1_13 = (var4_9.x * var0_13.x - var5_9.x) / 2
							local var2_13 = (var4_9.y * var0_13.x - var5_9.y) / 2
							local var3_13 = math.clamp(var0_9.localPosition.x, -var1_13, var1_13)
							local var4_13 = math.clamp(var0_9.localPosition.y, -var2_13, var2_13)

							var0_9.localPosition = Vector3(var3_13, var4_13, 1)
						end
					end, arg0_2)

					LateUpdateBeat:AddListener(var6_9)

					arg0_2.lateFuncDic[arg1_5] = var6_9

					var2_9:AddDragFunc(function(arg0_14, arg1_14)
						if var1_9.processing then
							return
						end

						if var3_9 then
							local var0_14 = var0_9.localScale
							local var1_14 = (var4_9.x * var0_14.x - var5_9.x) / 2
							local var2_14 = (var4_9.y * var0_14.x - var5_9.y) / 2
							local var3_14 = math.clamp(arg1_14.position.x - touchOffsetX, -var1_14, var1_14)
							local var4_14 = math.clamp(arg1_14.position.y - touchOffsetY, -var2_14, var2_14)

							var0_9.localPosition = Vector3(var3_14, var4_14, 1)
						end
					end)
				end)()

				if arg0_2.selectIndex == arg1_5 then
					var0_6(var0_8)
				else
					setActive(var0_8, false)
				end
			end), true, true)
		end)

		if arg1_5 == 1 then
			triggerButton(arg2_5)
		end
	end)
end

function var0_0.didEnter(arg0_15)
	onButton(arg0_15, arg0_15.cancelBtnTrans, function()
		arg0_15:closeView()
	end, SFX_CANCEL)
	onButton(arg0_15, arg0_15.confirmBtnTrans, function()
		arg0_15:SelectFrame()
		arg0_15:closeView()
	end, SFX_CANCEL)
end

function var0_0.SelectFrame(arg0_18)
	local var0_18 = pg.dorm3d_camera_photo_frame.all[arg0_18.selectIndex]
	local var1_18 = arg0_18.frameDic[arg0_18.selectIndex]
	local var2_18 = var1_18:Find("mask/realImage").anchoredPosition
	local var3_18 = var1_18:Find("mask/realImage").localScale

	arg0_18:emit(Dorm3dPhotoSelectFrameMediator.CONFIRMFRAME, var0_18, var2_18, var3_18)
end

function var0_0.willExit(arg0_19)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf)

	for iter0_19, iter1_19 in pairs(arg0_19.lateFuncDic) do
		LateUpdateBeat:RemoveListener(iter1_19)
	end
end

return var0_0
