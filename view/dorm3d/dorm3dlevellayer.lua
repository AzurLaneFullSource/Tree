local var0_0 = class("Dorm3dLevelLayer", import("view.base.BaseUI"))

var0_0.SERVER_TYPE = 1
var0_0.CLIENT_TYPE = 2
var0_0.STORY_TYPE = 3

function var0_0.getUIName(arg0_1)
	return "Dorm3dLevelUI"
end

function var0_0.init(arg0_2)
	arg0_2.rtLevelPanel = arg0_2._tf:Find("panel")

	onButton(arg0_2, arg0_2._tf:Find("btn_back"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/bottom/btn_time"), function()
		local var0_5 = getDorm3dGameset("drom3d_time_unlock")[1]

		if var0_5 > arg0_2.apartment.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("apartment_level_unenough", var0_5))

			return
		end

		arg0_2:ShowTimeSelectWindow()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/bottom/btn_skin"), function()
		local var0_6 = getDorm3dGameset("drom3d_clothing_unlock")[1]

		if var0_6 > arg0_2.apartment.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("apartment_level_unenough", var0_6))

			return
		end

		arg0_2:ShowSkinSelectWindow()
	end, SFX_PANEL)
	setActive(arg0_2.rtLevelPanel:Find("bg/bottom/btn_skin"), false)

	arg0_2.rtTimeSelectWindow = arg0_2._tf:Find("TimeSelectWindow")

	onButton(arg0_2, arg0_2.rtTimeSelectWindow:Find("bg"), function()
		setActive(arg0_2.rtTimeSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtTimeSelectWindow, arg0_2._tf)
	end, SFX_CANCEL)

	arg0_2.rtSkinSelectWindow = arg0_2._tf:Find("SkinSelectWindow")

	onButton(arg0_2, arg0_2.rtSkinSelectWindow:Find("bg"), function()
		setActive(arg0_2.rtSkinSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtSkinSelectWindow, arg0_2._tf)
	end, SFX_CANCEL)
	arg0_2:InitItemList()
end

function var0_0.SetApartment(arg0_9, arg1_9)
	arg0_9.apartment = arg1_9
end

function var0_0.InitItemList(arg0_10)
	arg0_10.rtLevelContainer = arg0_10.rtLevelPanel:Find("bg/awards/content")
	arg0_10.levelItemList = UIItemList.New(arg0_10.rtLevelContainer, arg0_10.rtLevelContainer:Find("tpl"))

	arg0_10.levelItemList:make(function(arg0_11, arg1_11, arg2_11)
		local var0_11 = arg1_11 + 1
		local var1_11 = arg0_10.apartment:getFavorConfig("levelup_item", var0_11)
		local var2_11 = arg0_10.apartment:getFavorConfig("levelup_client_item", var0_11)
		local var3_11 = arg2_11:Find("items")
		local var4_11 = {}

		for iter0_11, iter1_11 in pairs(var1_11) do
			table.insert(var4_11, {
				type = var0_0.SERVER_TYPE,
				data = iter1_11
			})
		end

		local var5_11 = false

		for iter2_11, iter3_11 in pairs(var2_11) do
			if iter3_11[1] == Dorm3dIconHelper.DORM_STORY then
				table.insert(var4_11, {
					type = var0_0.STORY_TYPE,
					data = iter3_11
				})

				var5_11 = true
			else
				table.insert(var4_11, {
					type = var0_0.CLIENT_TYPE,
					data = iter3_11
				})
			end
		end

		if arg0_11 == UIItemList.EventInit then
			setActive(arg2_11:Find("bg/normal"), not var5_11)
			setActive(arg2_11:Find("bg/special"), var5_11)

			local function var6_11(arg0_12)
				local var0_12 = var3_11:GetChild(arg0_12 - 1)
				local var1_12 = var0_12:Find("item")
				local var2_12 = var1_12:Find("Dorm3dIconTpl")

				if arg0_12 <= #var4_11 then
					switch(var4_11[arg0_12].type, {
						[var0_0.SERVER_TYPE] = function()
							setActive(var2_12:Find("count"), true)

							local var0_13 = Drop.Create(var4_11[arg0_12].data)

							updateDorm3dIcon(var2_12, var0_13)
							onButton(arg0_10, var0_12, function()
								arg0_10:emit(BaseUI.ON_NEW_DROP, {
									drop = var0_13
								})
							end, SFX_PANEL)
						end,
						[var0_0.CLIENT_TYPE] = function()
							setActive(var2_12:Find("count"), true)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_12, var4_11[arg0_12].data)

							local var0_15 = Dorm3dIconHelper.Data2Config(var4_11[arg0_12].data)

							onButton(arg0_10, var0_12, function()
								arg0_10:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_11[arg0_12].data
								})
							end, SFX_PANEL)
						end,
						[var0_0.STORY_TYPE] = function()
							local var0_17 = Dorm3dIconHelper.Data2Config(var4_11[arg0_12].data)

							setActive(var1_12:Find("sp"), true)
							setActive(var0_12:Find("story"), true)
							onButton(arg0_10, var0_12, function()
								arg0_10:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_11[arg0_12].data
								})
							end, SFX_PANEL)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_12, var4_11[arg0_12].data)
							setText(var0_12:Find("story/Text"), i18n("dorm3d_favor_level_story"))
						end
					})
				else
					setActive(var1_12, false)
					setActive(var0_12:Find("empty"), true)
				end
			end

			for iter4_11 = 1, var3_11.childCount do
				var6_11(iter4_11)
			end
		elseif arg0_11 == UIItemList.EventUpdate then
			local var7_11 = var0_11 <= arg0_10.apartment.level

			setActive(arg2_11:Find("unlock"), var7_11)
			setText(arg2_11:Find("number"), string.format("<color=%s>%02d</color>", var5_11 and "#FFFFFF" or var7_11 and "#b6b1b7" or "#827d82", var0_11))

			if var7_11 then
				setGray(arg2_11:Find("items"), true, true)
			end
		end
	end)
end

function var0_0.didEnter(arg0_19)
	local var0_19, var1_19 = arg0_19.apartment:getFavor()

	setText(arg0_19.rtLevelPanel:Find("bg/favor/level"), string.format("Lv.%d : ", arg0_19.apartment.level))
	setText(arg0_19.rtLevelPanel:Find("bg/favor/level/Text"), string.format("%d/%d", var0_19, var1_19))
	setSlider(arg0_19.rtLevelPanel:Find("bg/favor/progressBg/progress"), 0, var1_19, var0_19)
	arg0_19.levelItemList:align(getDorm3dGameset("favor_level")[1])

	arg0_19.rtLevelContainer:GetComponent(typeof(ScrollRect)).horizontalNormalizedPosition = 0

	local var2_19 = arg0_19.apartment.level >= getDorm3dGameset("drom3d_time_unlock")[1]

	setImageAlpha(arg0_19.rtLevelPanel:Find("bg/bottom/btn_time"), not var2_19 and 0.2 or 1)
	setActive(arg0_19.rtLevelPanel:Find("bg/bottom/btn_time/lock"), not var2_19)

	local var3_19 = arg0_19.apartment.level >= getDorm3dGameset("drom3d_clothing_unlock")[1]

	setImageAlpha(arg0_19.rtLevelPanel:Find("bg/bottom/btn_skin/Image"), not var3_19 and 0.2 or 1)
	setActive(arg0_19.rtLevelPanel:Find("bg/bottom/btn_skin/lock"), not var3_19)
end

function var0_0.ShowTimeSelectWindow(arg0_20)
	local var0_20 = arg0_20.rtTimeSelectWindow:Find("panel")

	setText(var0_20:Find("title"), i18n("dorm3d_time_choose"))

	for iter0_20, iter1_20 in ipairs({
		"day",
		"night"
	}) do
		local var1_20 = var0_20:Find("content/" .. iter1_20)

		setText(var1_20:Find("now/Text"), i18n("dorm3d_now_time"))
		setActive(var1_20:Find("now"), iter0_20 == arg0_20.contextData.timeIndex)
		onToggle(arg0_20, var1_20, function(arg0_21)
			if arg0_21 == true then
				arg0_20.selectTimeIndex = iter0_20
			end

			quickPlayAnimation(var1_20, arg0_21 and "anim_dorm3d_timeselect_click" or "anim_dorm3d_timeselect_unclick")
		end, SFX_PANEL)
	end

	triggerToggle(var0_20:Find("content"):GetChild(arg0_20.contextData.timeIndex - 1), true)
	setText(var0_20:Find("bottom/toggle_lock/Text"), i18n("dorm3d_is_auto_time"))
	onToggle(arg0_20, var0_20:Find("bottom/toggle_lock"), function(arg0_22)
		if arg0_22 then
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), 0)
		else
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_20.contextData.timeIndex)
		end

		quickPlayAnimation(var0_20:Find("bottom/toggle_lock"), arg0_22 and "anim_dorm3d_timeselect_bottom_on" or "anim_dorm3d_timeselect_bottom_off")
	end, SFX_PANEL)
	triggerToggle(var0_20:Find("bottom/toggle_lock"), PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) == 0)
	onButton(arg0_20, var0_20:Find("bottom/btn_confirm"), function()
		warning(arg0_20.contextData.timeIndex, arg0_20.selectTimeIndex)
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_day_night_switching" .. arg0_20.selectTimeIndex))

		if arg0_20.contextData.timeIndex == arg0_20.selectTimeIndex then
			return
		else
			if PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) ~= 0 then
				PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_20.selectTimeIndex)
			end

			triggerButton(arg0_20.rtTimeSelectWindow:Find("bg"))
			arg0_20:emit(Dorm3dLevelMediator.CHAMGE_TIME, arg0_20.selectTimeIndex)
		end
	end, SFX_CONFIRM)
	setActive(arg0_20.rtTimeSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_20.rtTimeSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.ShowSkinSelectWindow(arg0_24)
	local var0_24 = arg0_24.rtSkinSelectWindow:Find("panel")

	setText(var0_24:Find("title"), i18n("dorm3d_clothing_choose"))
	UIItemList.StaticAlign(var0_24:Find("content"), var0_24:Find("content/tpl"), #arg0_24.apartment.skinList, function(arg0_25, arg1_25, arg2_25)
		arg1_25 = arg1_25 + 1

		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = arg0_24.apartment.skinList[arg1_25]

			if var0_25 == 0 then
				var0_25 = arg0_24.apartment:getConfig("skin_model")
			end

			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/apartment_skin_%d", var0_25), "", arg2_25:Find("Image"))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/apartment_skin_name_%s", pg.dorm3d_resource[var0_25].picture), "", arg2_25:Find("name"))
			setText(arg2_25:Find("select/now/Text"), i18n("dorm3d_now_clothing"))
			setActive(arg2_25:Find("select/now"), arg0_24.apartment:getSkinId() == var0_25)
			onToggle(arg0_24, arg2_25, function(arg0_26)
				if arg0_26 == true then
					arg0_24.selectSkinId = var0_25
				end
			end, SFX_PANEL)
			triggerToggle(arg2_25, arg0_24.apartment:getSkinId() == var0_25)
		end
	end)
	setText(var0_24:Find("bottom/btn_confirm/Text"), i18n("word_ok"))
	onButton(arg0_24, var0_24:Find("bottom/btn_confirm"), function()
		triggerButton(arg0_24.rtSkinSelectWindow:Find("bg"))

		if arg0_24.apartment:getSkinId() ~= arg0_24.selectSkinId then
			arg0_24:emit(Dorm3dLevelMediator.CHANGE_SKIN, arg0_24.apartment.configId, arg0_24.selectSkinId)
		end
	end, SFX_CONFIRM)
	setActive(arg0_24.rtSkinSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_24.rtSkinSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.onBackPressed(arg0_28)
	if isActive(arg0_28.rtSkinSelectWindow) then
		triggerButton(arg0_28.rtSkinSelectWindow:Find("bg"))
	elseif isActive(arg0_28.rtTimeSelectWindow) then
		triggerButton(arg0_28.rtTimeSelectWindow:Find("bg"))
	else
		var0_0.super.onBackPressed(arg0_28)
	end
end

function var0_0.willExit(arg0_29)
	return
end

return var0_0
