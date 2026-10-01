local var0_0 = class("AttireScene", import("..base.BaseUI"))

var0_0.PAGE_ICONFRAME = 1
var0_0.PAGE_CHATFRAME = 2
var0_0.PAGE_ACHIEVEMENT = 3

function var0_0.getUIName(arg0_1)
	return "AttireUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"ui/attireui",
		"ui/attireiconframeui",
		"ui/attirechatframeui",
		"ui/attireachievementui",
		"ui/attirecombatuiui",
		"ui/attireloadingpicui"
	}

	local function var1_2(arg0_3, arg1_3)
		if noEmptyStr(arg1_3) and not table.contains(arg0_3, arg1_3) then
			table.insert(arg0_3, arg1_3)
		end
	end

	local function var2_2()
		local var0_4 = getProxy(AttireProxy):getAllData()
		local var1_4 = {}

		for iter0_4, iter1_4 in ipairs(pg.item_data_frame.all) do
			local var2_4 = var0_4.iconFrames[iter1_4]

			if var2_4 then
				var1_2(var1_4, var2_4:getIcon())
			end
		end

		for iter2_4, iter3_4 in ipairs(pg.item_data_chat.all) do
			local var3_4 = var0_4.chatFrames[iter3_4]

			if var3_4 then
				var1_2(var1_4, var3_4:getIcon())
			end
		end

		for iter4_4, iter5_4 in ipairs(pg.item_data_battleui.all) do
			local var4_4 = var0_4.combatUIStyles[iter5_4]

			if var4_4 then
				local var5_4 = var4_4:getConfig("icon")

				if noEmptyStr(var5_4) then
					var1_2(var1_4, "combatuistyle/" .. var5_4)
				end
			end
		end

		return var1_4
	end

	local function var3_2()
		local var0_5 = {}

		local function var1_5(arg0_6)
			if not arg0_6 then
				return
			end

			if arg0_6:isLoverLetter() then
				var1_2(var0_5, string.lower(arg0_6:GetPrefabName()))
				table.insertto(var0_5, ResPathSupport.GetPaintingSquareIconListByPaintingName(arg0_6:GetPainting()))
			else
				local var0_6 = arg0_6:getConfig("icon")

				var1_2(var0_5, "medal/" .. var0_6)
				var1_2(var0_5, "medal/s_" .. var0_6)
			end
		end

		local var2_5 = getProxy(AttireProxy):getDataAndTrophys()

		for iter0_5, iter1_5 in pairs(var2_5.trophys or {}) do
			if iter1_5:isClaimed() and not iter1_5:isHide() then
				var1_5(iter1_5)
			end
		end

		for iter2_5, iter3_5 in ipairs(var2_5.loveTrophys or {}) do
			if iter3_5:isClaimed() and not iter3_5:isHide() then
				var1_5(iter3_5)
			end
		end

		local var3_5 = getProxy(PlayerProxy):getData()

		for iter4_5, iter5_5 in ipairs(var3_5.displayTrophyList or {}) do
			local var4_5 = iter5_5 > 1000000000 and LoveLetterTrophy.New({
				id = iter5_5
			}) or Trophy.New({
				id = iter5_5
			})

			var1_5(var4_5)
		end

		return var0_5
	end

	local function var4_2()
		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(pg.gallery_config.all) do
			var1_2(var0_7, GalleryConst.GetGalleryPicPathByID(iter1_7))
		end

		for iter2_7, iter3_7 in ipairs(pg.cartoon.all) do
			var1_2(var0_7, MangaConst.GetMangaPicPathByID(iter3_7))
		end

		return var0_7
	end

	local var5_2 = var3_2()
	local var6_2 = var2_2()
	local var7_2 = var4_2()
	local var8_2 = CombatPreviewLayer.PushAllResource()

	return ResPathSupport.MergeLuaArr(var0_2, var6_2, var5_2, var7_2, var8_2)
end

function var0_0.setAttires(arg0_8, arg1_8)
	arg0_8.rawAttireVOs = arg1_8

	arg0_8:updateTips(getProxy(AttireProxy):needTip(arg1_8))
end

function var0_0.setPlayer(arg0_9, arg1_9)
	arg0_9.playerVO = arg1_9
end

function var0_0.init(arg0_10)
	arg0_10.backBtn = arg0_10._tf:Find("blur_panel/adapt/top/back_btn")
	arg0_10.blurPanel = arg0_10._tf:Find("blur_panel")
	arg0_10.toggles = {
		arg0_10.blurPanel:Find("adapt/left_length/frame/tagRoot/iconframe"),
		arg0_10.blurPanel:Find("adapt/left_length/frame/tagRoot/chatframe"),
		arg0_10.blurPanel:Find("adapt/left_length/frame/tagRoot/achievement"),
		arg0_10.blurPanel:Find("adapt/left_length/frame/tagRoot/combatUI"),
		arg0_10.blurPanel:Find("adapt/left_length/frame/tagRoot/loadingpic")
	}
	arg0_10.panels = {
		AttireIconFramePanel.New(arg0_10._tf, arg0_10.event, arg0_10.contextData),
		AttireChatFramePanel.New(arg0_10._tf, arg0_10.event, arg0_10.contextData),
		AttireAchievementPanel.New(arg0_10._tf, arg0_10.event, arg0_10.contextData),
		AttireCombatUIPanel.New(arg0_10._tf, arg0_10.event, arg0_10.contextData),
		AttireLoadingPicPanel.New(arg0_10._tf, arg0_10.event, arg0_10.contextData)
	}
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	for iter0_11, iter1_11 in ipairs(arg0_11.toggles) do
		onToggle(arg0_11, iter1_11, function(arg0_13)
			if arg0_13 then
				arg0_11:switchPage(iter0_11)
			end
		end, SFX_PANEL)
	end

	local var0_11 = arg0_11.contextData.index or var0_0.PAGE_ICONFRAME

	triggerToggle(arg0_11.toggles[var0_11], true)
end

function var0_0.switchPage(arg0_14, arg1_14)
	if arg0_14.page then
		arg0_14.panels[arg0_14.page]:ActionInvoke("Hide")
	end

	arg0_14.page = arg1_14

	arg0_14.panels[arg0_14.page]:Load()
	arg0_14.panels[arg0_14.page]:ActionInvoke("Show")
	arg0_14:updateCurrPage()
end

function var0_0.updateCurrPage(arg0_15)
	assert(arg0_15.page)
	arg0_15.panels[arg0_15.page]:ActionInvoke("Update", arg0_15.rawAttireVOs, arg0_15.playerVO)
end

function var0_0.updateTips(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg1_16) do
		setActive(arg0_16.toggles[iter0_16]:Find("tip"), iter1_16)
	end
end

function var0_0.onBackPressed(arg0_17)
	if arg0_17.panels[arg0_17.page].onBackPressed and arg0_17.panels[arg0_17.page]:onBackPressed() then
		-- block empty
	else
		var0_0.super.onBackPressed(arg0_17)
	end
end

function var0_0.willExit(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.panels) do
		iter1_18:Destroy()
	end
end

return var0_0
