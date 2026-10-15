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

	local var3_2 = (function()
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
	end)()
	local var4_2 = var2_2()
	local var5_2 = CombatPreviewLayer.PushAllResource()

	return ResPathSupport.MergeLuaArr(var0_2, var4_2, var3_2, var5_2)
end

function var0_0.setAttires(arg0_7, arg1_7)
	arg0_7.rawAttireVOs = arg1_7

	arg0_7:updateTips(getProxy(AttireProxy):needTip(arg1_7))
end

function var0_0.setPlayer(arg0_8, arg1_8)
	arg0_8.playerVO = arg1_8
end

function var0_0.init(arg0_9)
	arg0_9.backBtn = arg0_9._tf:Find("blur_panel/adapt/top/back_btn")
	arg0_9.blurPanel = arg0_9._tf:Find("blur_panel")
	arg0_9.toggles = {
		arg0_9.blurPanel:Find("adapt/left_length/frame/tagRoot/iconframe"),
		arg0_9.blurPanel:Find("adapt/left_length/frame/tagRoot/chatframe"),
		arg0_9.blurPanel:Find("adapt/left_length/frame/tagRoot/achievement"),
		arg0_9.blurPanel:Find("adapt/left_length/frame/tagRoot/combatUI"),
		arg0_9.blurPanel:Find("adapt/left_length/frame/tagRoot/loadingpic")
	}
	arg0_9.panels = {
		AttireIconFramePanel.New(arg0_9._tf, arg0_9.event, arg0_9.contextData),
		AttireChatFramePanel.New(arg0_9._tf, arg0_9.event, arg0_9.contextData),
		AttireAchievementPanel.New(arg0_9._tf, arg0_9.event, arg0_9.contextData),
		AttireCombatUIPanel.New(arg0_9._tf, arg0_9.event, arg0_9.contextData),
		AttireLoadingPicPanel.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	}
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	for iter0_10, iter1_10 in ipairs(arg0_10.toggles) do
		onToggle(arg0_10, iter1_10, function(arg0_12)
			if arg0_12 then
				arg0_10:switchPage(iter0_10)
			end
		end, SFX_PANEL)
	end

	local var0_10 = arg0_10.contextData.index or var0_0.PAGE_ICONFRAME

	triggerToggle(arg0_10.toggles[var0_10], true)
end

function var0_0.switchPage(arg0_13, arg1_13)
	if arg0_13.page then
		arg0_13.panels[arg0_13.page]:ActionInvoke("Hide")
	end

	arg0_13.page = arg1_13

	arg0_13.panels[arg0_13.page]:Load()
	arg0_13.panels[arg0_13.page]:ActionInvoke("Show")
	arg0_13:updateCurrPage()
end

function var0_0.updateCurrPage(arg0_14)
	assert(arg0_14.page)
	arg0_14.panels[arg0_14.page]:ActionInvoke("Update", arg0_14.rawAttireVOs, arg0_14.playerVO)
end

function var0_0.updateTips(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		setActive(arg0_15.toggles[iter0_15]:Find("tip"), iter1_15)
	end
end

function var0_0.onBackPressed(arg0_16)
	if arg0_16.panels[arg0_16.page].onBackPressed and arg0_16.panels[arg0_16.page]:onBackPressed() then
		-- block empty
	else
		var0_0.super.onBackPressed(arg0_16)
	end
end

function var0_0.willExit(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.panels) do
		iter1_17:Destroy()
	end
end

return var0_0
