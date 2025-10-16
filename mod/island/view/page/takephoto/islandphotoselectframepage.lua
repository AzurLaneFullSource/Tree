local var0_0 = class("IslandPhotoSelectFramePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandPhotoSelectFrameUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.cancelBtnTrans = arg0_2._tf:Find("cancelBtn")
	arg0_2.confirmBtnTrans = arg0_2._tf:Find("selectPage/confirmBtn")
	arg0_2.frameAdapter = arg0_2._tf:Find("frameAdapter")

	local var0_2 = arg0_2._tf:Find("selectPage/Scroll/Viewport/Content")

	arg0_2.frameDataList = {}

	if IslandConst.OnlyShowOwnedFrame == true then
		for iter0_2, iter1_2 in ipairs(pg.island_camera_photo_frame.all) do
			local var1_2 = pg.island_camera_photo_frame[iter1_2]
			local var2_2, var3_2 = ApartmentProxy.CheckUnlockConfig(var1_2.unlock)

			if var2_2 then
				table.insert(arg0_2.frameDataList, iter1_2)
			end
		end
	else
		arg0_2.frameDataList = pg.island_camera_photo_frame.all
	end

	local function var4_2()
		UIItemList.StaticAlign(var0_2, var0_2:GetChild(0), #arg0_2.frameDataList, function(arg0_4, arg1_4, arg2_4)
			if arg0_4 ~= UIItemList.EventUpdate then
				return
			end

			arg1_4 = arg1_4 + 1

			local var0_4 = arg0_2.frameDataList[arg1_4]

			setActive(arg2_4:Find("Selected"), arg0_2.selectId == var0_4)
		end)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, {
		staticBlur = true
	})

	arg0_2.frameDic = {}
	arg0_2.loadingDic = {}
	arg0_2.lateFuncDic = {}
	arg0_2.specialLateFuncDic = {}
	arg0_2.frameUIList = UIItemList.New(var0_2, var0_2:GetChild(0))

	arg0_2.frameUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg1_5 = arg1_5 + 1

			local var0_5 = pg.island_camera_photo_frame[arg0_2.frameDataList[arg1_5]]
			local var1_5 = var0_5.id

			GetImageSpriteFromAtlasAsync(string.format("Island/IslandPhotoFrame/%s", var0_5.farme_small_path), "", arg2_5:Find("Icon"))
			setActive(arg2_5:Find("Selected"), false)
			setActive(arg2_5:Find("lock"), false)

			local var2_5, var3_5 = ApartmentProxy.CheckUnlockConfig(var0_5.unlock)

			setActive(arg2_5:Find("lock"), not var2_5)

			if not var2_5 then
				setText(arg2_5:Find("lock/Image/Text"), var0_5.unlock_text)
			end

			onButton(arg0_2, arg2_5, function()
				if not var2_5 then
					pg.TipsMgr.GetInstance():ShowTips(var3_5)

					return
				end

				if arg0_2.selectId == var1_5 then
					return
				end

				arg0_2.selectId = var1_5

				var4_2()

				local var0_6 = var0_5.frameTfName == "IslandFilmFrame"
				local var1_6 = var0_5.frameTfName == "IslandInsFrame"

				for iter0_6, iter1_6 in pairs(arg0_2.frameDic) do
					setActive(iter1_6, false)
				end

				local function var2_6(arg0_7)
					local var0_7 = arg0_7:Find("mask/realImage")

					var0_7:GetComponent(typeof(RawImage)).texture = arg0_2.texture
					var0_7.sizeDelta = GameObject.Find("OverlayCamera").transform:GetChild(0).sizeDelta

					setAnchoredPosition(var0_7, {
						x = 0,
						y = 0
					})

					var0_7.localScale = Vector3(1, 1, 1)

					local var1_7 = {}

					if var1_6 then
						table.insert(var1_7, "mask_up/realImage")
					elseif var0_6 then
						table.insert(var1_7, "mask_up/realImage")
						table.insert(var1_7, "mask_down/realImage")
					end

					for iter0_7, iter1_7 in ipairs(var1_7) do
						local var2_7 = arg0_7:Find(iter1_7)

						var2_7:GetComponent(typeof(RawImage)).texture = arg0_2.texture

						local var3_7 = GameObject.Find("OverlayCamera").transform:GetChild(0)

						if var1_6 and iter1_7 == "mask_up/realImage" then
							var2_7.sizeDelta = Vector2(var3_7.sizeDelta.x / 10, var3_7.sizeDelta.y / 10)
						else
							var2_7.sizeDelta = var3_7.sizeDelta
						end

						setAnchoredPosition(var2_7, {
							x = 0,
							y = 0
						})

						var2_7.localScale = Vector3(1, 1, 1)
					end
				end

				local var3_6 = arg0_2.frameDic[arg0_2.selectId]

				if var3_6 then
					setActive(var3_6, true)
					var2_6(var3_6)

					return
				end

				if arg0_2.loadingDic[arg1_5] then
					return
				end

				arg0_2.loadingDic[arg1_5] = true

				local var4_6 = IslandAssetLoadDispatcher.Instance:Enqueue("ui/" .. var0_5.frameTfName, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
					arg0_2.loadingDic[arg1_5] = false

					local var0_8 = Object.Instantiate(arg0_8, arg0_2.frameAdapter).transform

					arg0_2.frameDic[var1_5] = var0_8

					local var1_8 = {
						"mask/realImage"
					}
					local var2_8 = {
						"mask"
					}

					if var1_6 then
						table.insert(var1_8, "mask_up/realImage")
						table.insert(var2_8, "mask_up")
					elseif var0_6 then
						table.insert(var1_8, "mask_up/realImage")
						table.insert(var1_8, "mask_down/realImage")
						table.insert(var2_8, "mask_up")
						table.insert(var2_8, "mask_down")
					end

					;(function()
						for iter0_9, iter1_9 in ipairs(var1_8) do
							local var0_9 = var0_8:Find(iter1_9)
							local var1_9 = GetOrAddComponent(var0_8:Find(iter1_9), "PinchZoom")
							local var2_9 = GetOrAddComponent(var0_8:Find(iter1_9), "EventTriggerListener")
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

							if var1_6 and iter1_9 == "mask_up/realImage" then
								var4_9 = Vector2(var4_9.x / 10, var4_9.y / 10)
							end

							local var5_9 = var0_8:Find(var2_8[iter0_9]).sizeDelta

							var2_9:AddBeginDragFunc(function(arg0_12, arg1_12)
								touchOffsetX = arg1_12.position.x - var0_9.localPosition.x
								touchOffsetY = arg1_12.position.y - var0_9.localPosition.y
							end)

							local var6_9 = math.max(var5_9.x / var4_9.x, var5_9.y / var4_9.y)
							local var7_9 = LateUpdateBeat:CreateListener(function()
								if var1_9.processing then
									local var0_13 = var0_9.localScale

									if var0_13.x < var6_9 then
										var0_9.localScale = Vector3(var6_9, var6_9, var0_13.z)
										var0_13 = var0_9.localScale
									end

									local var1_13 = (var4_9.x * var0_13.x - var5_9.x) / 2
									local var2_13 = (var4_9.y * var0_13.x - var5_9.y) / 2
									local var3_13 = math.clamp(var0_9.localPosition.x, -var1_13, var1_13)
									local var4_13 = math.clamp(var0_9.localPosition.y, -var2_13, var2_13)

									var0_9.localPosition = Vector3(var3_13, var4_13, 1)
								end
							end, arg0_2)

							LateUpdateBeat:AddListener(var7_9)

							if var0_6 or var1_6 then
								table.insert(arg0_2.specialLateFuncDic, var7_9)
							else
								arg0_2.lateFuncDic[arg1_5] = var7_9
							end

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
						end
					end)()

					if arg0_2.selectId == var1_5 then
						var2_6(var0_8)
					else
						setActive(var0_8, false)
					end
				end), true, true)

				table.insert(arg0_2.loadingIdList or {}, var4_6)
			end)

			if var1_5 == arg0_2.originIndex then
				triggerButton(arg2_5)
			end
		end
	end)
	onButton(arg0_2, arg0_2.cancelBtnTrans, function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.confirmBtnTrans, function()
		arg0_2:SelectFrame()
		arg0_2:Hide()
	end, SFX_CANCEL)
end

function var0_0.SelectFrame(arg0_17)
	local var0_17 = arg0_17.selectId
	local var1_17 = arg0_17.frameDic[arg0_17.selectId]
	local var2_17 = var1_17:Find("mask/realImage").anchoredPosition
	local var3_17 = var1_17:Find("mask/realImage").localScale
	local var4_17
	local var5_17 = pg.island_camera_photo_frame[var0_17].frameTfName

	if var5_17 == "IslandFilmFrame" or var5_17 == "IslandInsFrame" then
		var4_17 = {
			upPos = var1_17:Find("mask_up/realImage").anchoredPosition,
			upScale = var1_17:Find("mask_up/realImage").localScale
		}

		if var1_17:Find("mask_down/realImage") then
			var4_17.downPos = var1_17:Find("mask_down/realImage").anchoredPosition
			var4_17.downScale = var1_17:Find("mask_up/realImage").localScale
		end
	end

	existCall(arg0_17.selectCallback, {
		selectFrameId = var0_17,
		imagePos = var2_17,
		imageScale = var3_17,
		specialPosDic = var4_17
	})
end

function var0_0.OnShow(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg0_18.photoData = arg1_18
	arg0_18.texture = arg2_18
	arg0_18.selectCallback = arg4_18
	arg0_18.originIndex = arg3_18

	arg0_18.frameUIList:align(#arg0_18.frameDataList)
	pg.UIMgr.GetInstance():BlurPanel(arg0_18._tf, {
		staticBlur = true
	})
end

function var0_0.OnHide(arg0_19)
	arg0_19.selectId = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf)
end

function var0_0.OnDestroy(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.lateFuncDic) do
		LateUpdateBeat:RemoveListener(iter1_20)
	end

	for iter2_20, iter3_20 in ipairs(arg0_20.specialLateFuncDic) do
		LateUpdateBeat:RemoveListener(iter3_20)
	end

	for iter4_20, iter5_20 in ipairs(arg0_20.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter5_20)
	end

	arg0_20.loadingIdList = nil
end

return var0_0
