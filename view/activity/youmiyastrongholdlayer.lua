local var0_0 = class("YoumiyaStrongholdLayer", import("view.base.BaseUI"))
local var1_0 = pg.activity_ryza_furniture
local var2_0 = pg.furniture_data_template

function var0_0.getUIName(arg0_1)
	return "YoumiyaStrongholdUI"
end

function var0_0.init(arg0_2)
	arg0_2.adapt = arg0_2._tf:Find("adapt")
	arg0_2.backBtn = arg0_2.adapt:Find("backBtn")
	arg0_2.homeBtn = arg0_2.adapt:Find("homeBtn")
	arg0_2.desc = arg0_2.adapt:Find("desc/text")
	arg0_2.res = arg0_2.adapt:Find("res")
	arg0_2.strongholdPage = arg0_2._tf:Find("pages/strongholdPage")
	arg0_2.detailPage = arg0_2._tf:Find("pages/detailPage")
	arg0_2.makeFurniturePanel = arg0_2._tf:Find("pages/makeFurniturePanel")
	arg0_2.awardList = UIItemList.New(arg0_2.detailPage:Find("detail/awardList"), arg0_2.detailPage:Find("detail/awardList/stage"))
	arg0_2.isOnMake = false

	setText(arg0_2.desc, i18n("yumia_stronghold_2"))

	for iter0_2 = 1, 3 do
		setText(arg0_2.strongholdPage:Find(iter0_2 .. "/comfort/text"), i18n("yumia_stronghold_3"))

		local var0_2 = arg0_2.detailPage:Find("detail/stronghold/furnitures/" .. iter0_2)

		for iter1_2 = 1, var0_2.childCount do
			local var1_2 = var0_2:Find(iter1_2)

			for iter2_2 = 0, var1_2.childCount - 1 do
				local var2_2 = var1_2:GetChild(iter2_2)

				setText(var2_2:Find("comfort/comf/text"), i18n("yumia_stronghold_3"))
			end
		end

		setText(arg0_2.detailPage:Find("info/" .. iter0_2 .. "/comfort/text"), i18n("yumia_stronghold_3"))
	end

	setText(arg0_2.detailPage:Find("detail/progress/Root/text"), i18n("yumia_stronghold_4"))
	setText(arg0_2.detailPage:Find("detail/awardTitle/text"), i18n("yumia_stronghold_5"))
	setText(arg0_2.detailPage:Find("detail/awardList/stage/got/text"), i18n("yumia_stronghold_6"))
	setText(arg0_2.makeFurniturePanel:Find("panel/complete/root/text"), i18n("yumia_stronghold_7"))
	setText(arg0_2.makeFurniturePanel:Find("panel/comfort/title"), i18n("yumia_stronghold_3"))
	setText(arg0_2.makeFurniturePanel:Find("panel/consume/title"), i18n("yumia_stronghold_8"))
	setText(arg0_2.makeFurniturePanel:Find("panel/consume/text"), i18n("yumia_stronghold_9"))
	setText(arg0_2.makeFurniturePanel:Find("panel/makeBtn/text"), i18n("yumia_stronghold_10"))

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_3, arg1_3)
		arg0_2:UpdateAdapt()
	end)

	local var3_2 = arg0_2._tf.rect.height

	if var3_2 > 1440 then
		arg0_2.adapt:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(0, 1440 - var3_2)
		arg0_2.makeFurniturePanel:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(0, 1440 - var3_2)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false)
	arg0_2._tf:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		for iter0_4 = 0, 2 do
			arg0_2.strongholdPage:GetChild(iter0_4):GetComponent(typeof(Animation)):Play("Anim_YoumiyaStrongholdUI_Strongholdpage01_In")
		end
	end)

	local var4_2 = arg0_2.detailPage:GetComponent(typeof(DftAniEvent))

	var4_2:SetTriggerEvent(function()
		for iter0_5 = 0, 2 do
			local var0_5 = arg0_2.detailPage:Find("info"):GetChild(iter0_5)
			local var1_5 = var0_5:GetComponent(typeof(Animation))

			if isActive(var0_5) then
				var1_5:Play("Anim_YoumiyaStrongholdUI_Strongholdpage01_In")
			end
		end
	end)
	var4_2:SetEndEvent(function()
		for iter0_6 = 1, 3 do
			local var0_6 = arg0_2.detailPage:Find("detail/stronghold/furnitures/" .. iter0_6)

			for iter1_6 = 1, var0_6.childCount do
				local var1_6 = var0_6:Find(iter1_6)

				for iter2_6 = 0, var1_6.childCount - 1 do
					local var2_6 = var1_6:GetChild(iter2_6)

					setActive(var2_6:Find("comfort/icon/VX"), true)
				end
			end
		end
	end)
end

function var0_0.didEnter(arg0_7)
	arg0_7:InitData()
	arg0_7:UpdateAdapt()
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:GoBack()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.homeBtn, function()
		arg0_7:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	setActive(arg0_7.strongholdPage, true)
	setActive(arg0_7.detailPage, false)
	setActive(arg0_7.makeFurniturePanel, false)
	arg0_7:RefreshView()
end

function var0_0.UpdateAdapt(arg0_10)
	local var0_10 = 1.33333333333333
	local var1_10 = 2.16666666666667
	local var2_10 = pg.CameraFixMgr.GetInstance()
	local var3_10 = var2_10.currentWidth / var2_10.currentHeight
	local var4_10 = math.clamp(var3_10, var0_10, var1_10)

	arg0_10._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_10

	setSizeDelta(arg0_10._tf:Find("adapt"), {
		x = 0,
		y = 0
	})
end

function var0_0.InitData(arg0_11)
	arg0_11.activityProxy = getProxy(ActivityProxy)
	arg0_11.allFurnitureCount = {
		0,
		0,
		0
	}
	arg0_11.allComfortCount = {
		0,
		0,
		0
	}

	for iter0_11 = 1, 3 do
		local var0_11 = var1_0.get_id_list_by_type[iter0_11]

		arg0_11.allFurnitureCount[iter0_11] = #var0_11

		for iter1_11, iter2_11 in ipairs(var0_11) do
			local var1_11 = var1_0[iter2_11]

			arg0_11.allComfortCount[iter0_11] = arg0_11.allComfortCount[iter0_11] + var1_11.com_add
		end
	end

	arg0_11.awardInfos = pg.activity_template[ActivityConst.YUMIA_BASE_ACT_ID].config_client.rewards
end

function var0_0.RefreshData(arg0_12)
	arg0_12.items = arg0_12.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK):GetItems()
	arg0_12.activity = arg0_12.activityProxy:getActivityById(ActivityConst.YUMIA_BASE_ACT_ID)
	arg0_12.okFurnitureIds = arg0_12.activity:getData1List()
	arg0_12.gotAwardIndex = {
		0,
		0,
		0
	}

	for iter0_12 = 1, 3 do
		arg0_12.gotAwardIndex[iter0_12] = arg0_12.activity:getKVPList(1, iter0_12)
	end

	arg0_12.furnitureCount = {
		0,
		0,
		0
	}
	arg0_12.comfortCount = {
		0,
		0,
		0
	}

	for iter1_12 = 1, 3 do
		local var0_12 = var1_0.get_id_list_by_type[iter1_12]

		for iter2_12, iter3_12 in ipairs(var0_12) do
			if table.contains(arg0_12.okFurnitureIds, iter3_12) then
				local var1_12 = var1_0[iter3_12]

				arg0_12.furnitureCount[iter1_12] = arg0_12.furnitureCount[iter1_12] + 1
				arg0_12.comfortCount[iter1_12] = arg0_12.comfortCount[iter1_12] + var1_12.com_add
			end
		end
	end
end

function var0_0.SetRes(arg0_13, arg1_13)
	local var0_13 = getProxy(PlayerProxy):getRawData()
	local var1_13 = {
		{
			138,
			arg0_13:GetItemCount(138)
		},
		{
			139,
			arg0_13:GetItemCount(139)
		},
		{
			140,
			arg0_13:GetItemCount(140)
		},
		{
			141,
			arg0_13:GetItemCount(141)
		},
		{
			6,
			arg0_13:GetItemCount(6)
		}
	}

	for iter0_13 = 0, arg1_13.childCount - 1 do
		setActive(arg1_13:GetChild(iter0_13), false)
	end

	for iter1_13, iter2_13 in ipairs(var1_13) do
		local var2_13 = iter2_13[1]
		local var3_13 = iter2_13[2]

		for iter3_13 = 0, arg1_13.childCount - 1 do
			local var4_13 = arg1_13:GetChild(iter3_13)

			if var4_13.name == tostring(var2_13) then
				setActive(var4_13, true)
				setText(var4_13:Find("Text"), var3_13)

				break
			end
		end
	end
end

function var0_0.RefreshView(arg0_14)
	arg0_14:RefreshData()
	arg0_14:SetRes(arg0_14.res)
	arg0_14:SetDetailPage()

	for iter0_14 = 1, 3 do
		local var0_14 = arg0_14.strongholdPage:GetChild(iter0_14 - 1)

		setText(var0_14:Find("root/name"), i18n("yumia_base_name_" .. iter0_14))
		setText(var0_14:Find("comfort/count2/count1"), arg0_14.comfortCount[iter0_14])
		setText(var0_14:Find("comfort/count2"), "/" .. arg0_14.allComfortCount[iter0_14])
		GetImageSpriteFromAtlasAsync("ui/CourtyardUI_atlas", "express_" .. arg0_14:GetComfortableLevel(arg0_14.comfortCount[iter0_14]), var0_14:Find("comfort/icon"))
		onButton(arg0_14, var0_14, function()
			arg0_14:EnterDetailPage(iter0_14)
		end, SFX_PANEL)

		local var1_14 = false
		local var2_14 = arg0_14.awardInfos[iter0_14]

		for iter1_14 = 1, #var2_14 do
			local var3_14 = var2_14[iter1_14][1]
			local var4_14 = var2_14[iter1_14][2]

			if var3_14 <= arg0_14.comfortCount[iter0_14] and iter1_14 > arg0_14.gotAwardIndex[iter0_14] then
				var1_14 = true

				break
			end
		end

		setActive(var0_14:Find("tip"), var1_14)
	end

	if arg0_14.strongholdIndex then
		arg0_14:EnterDetailPage(arg0_14.strongholdIndex)
	end
end

function var0_0.SetDetailPage(arg0_16)
	for iter0_16 = 1, 3 do
		setText(arg0_16.detailPage:Find("info/" .. iter0_16 .. "/root/name"), i18n("yumia_base_name_" .. iter0_16))
		setText(arg0_16.detailPage:Find("info/" .. iter0_16 .. "/comfort/count2/count1"), arg0_16.comfortCount[iter0_16])
		setText(arg0_16.detailPage:Find("info/" .. iter0_16 .. "/comfort/count2"), "/" .. arg0_16.allComfortCount[iter0_16])
		GetImageSpriteFromAtlasAsync("ui/CourtyardUI_atlas", "express_" .. arg0_16:GetComfortableLevel(arg0_16.comfortCount[iter0_16]), arg0_16.detailPage:Find("info/" .. iter0_16 .. "/comfort/icon"))

		local var0_16 = arg0_16.detailPage:Find("detail/stronghold/furnitures/" .. iter0_16)
		local var1_16 = false

		for iter1_16 = 0, var0_16.childCount - 1 do
			local var2_16 = var0_16:GetChild(iter1_16)
			local var3_16 = true

			for iter2_16 = 0, var2_16.childCount - 1 do
				local var4_16 = var2_16:GetChild(iter2_16)
				local var5_16 = tonumber(var4_16.name)
				local var6_16 = table.contains(arg0_16.okFurnitureIds, var5_16)

				setActive(var4_16:Find("fur"), var6_16)
				setActive(var4_16:Find("lockFur"), not var6_16)
				setActive(var4_16:Find("comfort"), not var6_16)
				setText(var4_16:Find("comfort/comf/count"), var1_0[var5_16].com_add)

				if not var6_16 then
					var3_16 = false

					onButton(arg0_16, var4_16, function()
						arg0_16:ShowMakePanel(var5_16)
					end, SFX_PANEL)
				else
					removeOnButton(var4_16)
				end
			end

			setActive(var2_16, not var1_16)

			if not var1_16 and not var3_16 then
				var1_16 = true
			end
		end
	end

	onButton(arg0_16, arg0_16.detailPage:Find("leftChange"), function()
		arg0_16:EnterDetailPage(arg0_16.strongholdIndex - 1 == 0 and 3 or arg0_16.strongholdIndex - 1)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.detailPage:Find("rightChange"), function()
		arg0_16:EnterDetailPage(arg0_16.strongholdIndex + 1 == 4 and 1 or arg0_16.strongholdIndex + 1)
	end, SFX_PANEL)
end

function var0_0.EnterDetailPage(arg0_20, arg1_20)
	arg0_20.strongholdIndex = arg1_20

	setActive(arg0_20.strongholdPage, false)
	setActive(arg0_20.detailPage, true)

	for iter0_20 = 1, 3 do
		setActive(arg0_20.detailPage:Find("info/" .. iter0_20), iter0_20 == arg1_20)
	end

	setText(arg0_20.detailPage:Find("detail/progress/countBg/furnitureCount"), arg0_20.furnitureCount[arg1_20] .. "/" .. arg0_20.allFurnitureCount[arg1_20])

	for iter1_20 = 1, 3 do
		setActive(arg0_20.detailPage:Find("detail/stronghold/furnitures/" .. iter1_20), iter1_20 == arg1_20)
	end

	local var0_20 = false
	local var1_20 = 0
	local var2_20 = arg0_20.awardInfos[arg1_20]

	arg0_20.awardList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var2_20[arg1_21 + 1][1]
			local var1_21 = var2_20[arg1_21 + 1][2]
			local var2_21 = {
				type = var1_21[1],
				id = var1_21[2],
				count = var1_21[3]
			}

			updateDrop(arg2_21:Find("award"), var2_21)
			onButton(arg0_20, arg2_21:Find("award"), function()
				arg0_20:emit(BaseUI.ON_DROP, var2_21)
			end, SFX_PANEL)
			setText(arg2_21:Find("comfort"), var0_21)
			setActive(arg2_21:Find("got"), arg1_21 < arg0_20.gotAwardIndex[arg1_20])
			setActive(arg2_21:Find("canGet"), var0_21 <= arg0_20.comfortCount[arg1_20] and arg1_21 >= arg0_20.gotAwardIndex[arg1_20])

			if var0_21 <= arg0_20.comfortCount[arg1_20] and arg1_21 >= arg0_20.gotAwardIndex[arg1_20] then
				var0_20 = true
				var1_20 = arg1_21 + 1
			end
		end
	end)
	arg0_20.awardList:align(#var2_20)
	setActive(arg0_20.detailPage:Find("detail/allGetBtn/VX"), var0_20)

	if var0_20 then
		setGray(arg0_20.detailPage:Find("detail/allGetBtn"), false, false)
		onButton(arg0_20, arg0_20.detailPage:Find("detail/allGetBtn"), function()
			arg0_20:emit(YoumiyaStrongholdMediator.GET_AWARD, arg1_20, var1_20)
		end, SFX_PANEL)
	else
		setGray(arg0_20.detailPage:Find("detail/allGetBtn"), true, false)
		removeOnButton(arg0_20.detailPage:Find("detail/allGetBtn"))
	end

	if isActive(arg0_20.makeFurniturePanel) then
		triggerButton(arg0_20.makeFurniturePanel:Find("panel/closeBtn"))
	end
end

function var0_0.ShowMakePanel(arg0_24, arg1_24)
	setActive(arg0_24.makeFurniturePanel, true)

	local var0_24 = var1_0[arg1_24]
	local var1_24 = var2_0[var0_24.fur_id]
	local var2_24 = arg0_24.makeFurniturePanel:GetComponent(typeof(Animation))
	local var3_24 = arg0_24.makeFurniturePanel:GetComponent(typeof(DftAniEvent))

	onButton(arg0_24, arg0_24.makeFurniturePanel:Find("panel/closeBtn"), function()
		if arg0_24.isOnMake then
			return
		end

		var3_24:SetEndEvent(function()
			setActive(arg0_24.makeFurniturePanel, false)
		end)
		var2_24:Play("Anim_YoumiyaStrongholdUI_makeFurniture_Out")
	end, SFX_PANEL)
	onButton(arg0_24, arg0_24._tf:Find("bg"), function()
		triggerButton(arg0_24.makeFurniturePanel:Find("panel/closeBtn"))
	end, SFX_PANEL)
	setText(arg0_24.makeFurniturePanel:Find("panel/name"), var1_24.name)

	local var4_24, var5_24 = HXSet.autoHxShiftPath("furnitures/" .. var1_24.picture, "")
	local var6_24 = arg0_24.makeFurniturePanel:Find("panel/icon"):GetComponent(typeof(Image))

	GetSpriteFromAtlasAsync(var4_24, var5_24, function(arg0_28)
		var6_24.sprite = arg0_28

		var6_24:SetNativeSize()

		local var0_28 = var6_24.sprite.rect.width
		local var1_28 = var6_24.sprite.rect.height
		local var2_28 = var1_28 <= var0_28 and 300 / var0_28 or 300 / var1_28

		arg0_24.makeFurniturePanel:Find("panel/icon").localScale = Vector3(var2_28, var2_28, 1)
	end)
	setText(arg0_24.makeFurniturePanel:Find("panel/comfort/count"), var0_24.com_add)
	setText(arg0_24.makeFurniturePanel:Find("panel/desc"), var1_24.describe)
	setActive(arg0_24.makeFurniturePanel:Find("panel/complete"), false)
	onButton(arg0_24, arg0_24.makeFurniturePanel:Find("panel/consume/goBtn"), function()
		arg0_24:emit(YoumiyaStrongholdMediator.YOUMIA_GO_SCENE, SCENE.ATELIER_COMPOSITE, {
			activityID = 50043,
			versionIndex = 2
		})
	end, SFX_PANEL)
	arg0_24:SetConsumeList(var0_24.material)

	local var7_24 = true

	for iter0_24, iter1_24 in ipairs(var0_24.material) do
		local var8_24 = iter1_24[2]

		if iter1_24[3] > arg0_24:GetItemCount(var8_24) then
			var7_24 = false
		end
	end

	if var7_24 then
		setGray(arg0_24.makeFurniturePanel:Find("panel/makeBtn"), false, true)
		onButton(arg0_24, arg0_24.makeFurniturePanel:Find("panel/makeBtn"), function()
			arg0_24.isOnMake = true

			var3_24:SetTriggerEvent(function()
				arg0_24:emit(YoumiyaStrongholdMediator.MAKE_FURNITURE, arg1_24, var0_24.material)

				arg0_24.isOnMake = false

				triggerButton(arg0_24.makeFurniturePanel:Find("panel/closeBtn"))
			end)
			setActive(arg0_24.makeFurniturePanel:Find("panel/complete"), true)
			arg0_24.makeFurniturePanel:GetComponent(typeof(Animation)):Play("Anim_YoumiyaStrongholdUI_makeFurniture_Complete")
			removeOnButton(arg0_24.makeFurniturePanel:Find("panel/makeBtn"))
		end, SFX_PANEL)
	else
		setGray(arg0_24.makeFurniturePanel:Find("panel/makeBtn"), true, true)
		removeOnButton(arg0_24.makeFurniturePanel:Find("panel/makeBtn"))
	end
end

function var0_0.SetConsumeList(arg0_32, arg1_32)
	local var0_32 = arg0_32.makeFurniturePanel:Find("panel/consume/consumeList")
	local var1_32 = {}

	for iter0_32, iter1_32 in ipairs(arg1_32) do
		table.insert(var1_32, {
			iter1_32[2],
			iter1_32[3]
		})
	end

	for iter2_32 = 0, var0_32.childCount - 1 do
		setActive(var0_32:GetChild(iter2_32), false)
	end

	for iter3_32, iter4_32 in ipairs(var1_32) do
		local var2_32 = iter4_32[1]
		local var3_32 = iter4_32[2]

		for iter5_32 = 0, var0_32.childCount - 1 do
			local var4_32 = var0_32:GetChild(iter5_32)

			if var4_32.name == tostring(var2_32) then
				setActive(var4_32, true)
				setText(var4_32:Find("count1"), arg0_32:GetItemCount(var2_32))
				setText(var4_32:Find("count2"), "/" .. var3_32)

				break
			end
		end
	end
end

function var0_0.GetComfortableLevel(arg0_33, arg1_33)
	if arg1_33 < 30 then
		return 1
	elseif arg1_33 >= 30 and arg1_33 < 68 then
		return 2
	else
		return 3
	end
end

function var0_0.GetItemCount(arg0_34, arg1_34)
	local var0_34 = 0

	if arg1_34 == 6 then
		var0_34 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResDormMoney)
	elseif arg0_34.items[arg1_34] then
		var0_34 = arg0_34.items[arg1_34].count
	end

	return var0_34
end

function var0_0.GoBack(arg0_35)
	if isActive(arg0_35.detailPage) then
		setActive(arg0_35.strongholdPage, true)
		setActive(arg0_35.detailPage, false)

		arg0_35.strongholdIndex = nil

		if isActive(arg0_35.makeFurniturePanel) then
			triggerButton(arg0_35.makeFurniturePanel:Find("panel/closeBtn"))
		end

		for iter0_35 = 1, 3 do
			local var0_35 = arg0_35.detailPage:Find("detail/stronghold/furnitures/" .. iter0_35)

			for iter1_35 = 1, var0_35.childCount do
				local var1_35 = var0_35:Find(iter1_35)

				for iter2_35 = 0, var1_35.childCount - 1 do
					local var2_35 = var1_35:GetChild(iter2_35)

					setActive(var2_35:Find("comfort/icon/VX"), false)
				end
			end
		end

		return
	end

	arg0_35:closeView()
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf)

	if arg0_36.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_36.camEventId)

		arg0_36.camEventId = nil
	end
end

function var0_0.onBackPressed(arg0_37)
	arg0_37:GoBack()
end

function var0_0.ShouldShowTip()
	local var0_38 = pg.activity_template[ActivityConst.YUMIA_BASE_ACT_ID].config_client.rewards
	local var1_38 = getProxy(ActivityProxy):getActivityById(ActivityConst.YUMIA_BASE_ACT_ID)
	local var2_38 = var1_38:getData1List()
	local var3_38 = {
		0,
		0,
		0
	}

	for iter0_38 = 1, 3 do
		var3_38[iter0_38] = var1_38:getKVPList(1, iter0_38)
	end

	local var4_38 = {
		0,
		0,
		0
	}

	for iter1_38 = 1, 3 do
		local var5_38 = var1_0.get_id_list_by_type[iter1_38]

		for iter2_38, iter3_38 in ipairs(var5_38) do
			if table.contains(var2_38, iter3_38) then
				local var6_38 = var1_0[iter3_38]

				var4_38[iter1_38] = var4_38[iter1_38] + var6_38.com_add
			end
		end
	end

	local var7_38 = false

	for iter4_38 = 1, 3 do
		local var8_38 = false
		local var9_38 = var0_38[iter4_38]

		for iter5_38 = 1, #var9_38 do
			local var10_38 = var9_38[iter5_38][1]
			local var11_38 = var9_38[iter5_38][2]

			if var10_38 <= var4_38[iter4_38] and iter5_38 > var3_38[iter4_38] then
				var8_38 = true

				break
			end
		end

		if var8_38 then
			var7_38 = true

			break
		end
	end

	return var7_38
end

return var0_0
