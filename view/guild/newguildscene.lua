local var0_0 = class("NewGuildScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewGuildUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"commonbg/camp_bg",
		"clutter/blhx_icon",
		"clutter/cszz_icon"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.playerVO = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.createPanel = arg0_5._tf:Find("create_panel")
	arg0_5.factionPanel = arg0_5._tf:Find("faction_panel")
	arg0_5.createBtn = arg0_5._tf:Find("create_panel/frame/create_btn")
	arg0_5.joinBtn = arg0_5._tf:Find("create_panel/frame/join_btn")
	arg0_5.topPanel = arg0_5._tf:Find("blur_panel/adapt/top")
	arg0_5.publicGuildBtn = arg0_5._tf:Find("create_panel/frame/public_btn")
	arg0_5.backBtn = arg0_5.topPanel:Find("back")

	setActive(arg0_5.factionPanel, false)

	arg0_5.mask = arg0_5._tf:Find("mask")

	SetActive(arg0_5.mask, false)

	arg0_5.mainRedPage = NewGuildMainRedPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.mainBluePage = NewGuildMainBluePage.New(arg0_5._tf, arg0_5.event)
end

function var0_0.didEnter(arg0_6)
	arg0_6:startCreate()
	onButton(arg0_6, arg0_6.createBtn, function()
		arg0_6:createGuild()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.joinBtn, function()
		arg0_6:emit(NewGuildMediator.OPEN_GUILD_LIST)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.createPanel, function()
		arg0_6:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_6, arg0_6.publicGuildBtn, function()
		arg0_6:emit(NewGuildMediator.OPEN_PUBLIC_GUILD)
	end, SOUND_BACK)
	onButton(arg0_6, arg0_6.backBtn, function()
		if go(arg0_6.createPanel).activeSelf then
			arg0_6:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
end

function var0_0.startCreate(arg0_12)
	setActive(arg0_12.createPanel, true)
end

function var0_0.createGuild(arg0_13)
	setActive(arg0_13.createPanel, false)
	setActive(arg0_13.factionPanel, false)

	arg0_13.createProcess = coroutine.wrap(function()
		setActive(arg0_13.createPanel, false)

		local var0_14 = Guild.New({})

		arg0_13:selectFaction(var0_14, arg0_13.createProcess)
		coroutine.yield()
		arg0_13:setDescInfo(var0_14)
	end)

	arg0_13.createProcess()
end

function var0_0.selectFaction(arg0_15, arg1_15, arg2_15)
	local function var0_15(arg0_16, arg1_16)
		arg0_15.isPlaying = true

		local var0_16 = arg0_16:Find("bg")

		setActive(var0_16, true)

		local var1_16 = var0_16:GetComponent("CanvasGroup")

		LeanTween.value(go(var0_16), 1, 3, 0.5):setOnUpdate(System.Action_float(function(arg0_17)
			var0_16.localScale = Vector3(arg0_17, arg0_17, 1)
			var1_16.alpha = 1 - arg0_17 / 3
		end)):setOnComplete(System.Action(function()
			setActive(var0_16, false)

			var0_16.localScale = Vector3(1, 1, 1)
			arg0_15.isPlaying = false

			arg1_16()
		end))
	end

	setActive(arg0_15.factionPanel, true)

	local var1_15 = arg0_15.factionPanel:Find("panel")
	local var2_15 = var1_15:Find("blhx")
	local var3_15 = var1_15:Find("cszz")
	local var4_15 = var1_15:Find("bg")

	if not arg0_15.isInitFaction then
		setImageSprite(var4_15, GetSpriteFromAtlas("commonbg/camp_bg", ""))
		setImageSprite(var2_15:Find("bg"), GetSpriteFromAtlas("clutter/blhx_icon", ""))
		setImageSprite(var3_15:Find("bg"), GetSpriteFromAtlas("clutter/cszz_icon", ""))
		setActive(var2_15:Find("bg"), false)
		setActive(var3_15:Find("bg"), false)

		arg0_15.isInitFaction = true
	end

	onButton(arg0_15, var2_15, function()
		if arg0_15.isPlaying then
			return
		end

		arg1_15:setFaction(GuildConst.FACTION_TYPE_BLHX)

		if arg2_15 then
			arg2_15()
		else
			return
		end

		var0_15(var2_15, function()
			arg2_15 = nil
		end)
	end, SFX_PANEL)
	onButton(arg0_15, var3_15, function()
		if arg0_15.isPlaying then
			return
		end

		arg1_15:setFaction(GuildConst.FACTION_TYPE_CSZZ)

		if arg2_15 then
			arg2_15()
		else
			return
		end

		var0_15(var3_15, function()
			arg2_15 = nil
		end)
	end)
	onButton(arg0_15, arg0_15.backBtn, function()
		if arg0_15.isPlaying then
			return
		end

		arg0_15.createProcess = nil

		setActive(arg0_15.createPanel, true)
		setActive(arg0_15.factionPanel, false)
		onButton(arg0_15, arg0_15.backBtn, function()
			arg0_15:emit(var0_0.ON_BACK)
		end, SFX_CANCEL)
	end, SFX_CANCEL)
	setActive(arg0_15.topPanel, true)
end

function var0_0.setDescInfo(arg0_25, arg1_25)
	local var0_25 = arg1_25:getFaction()

	if var0_25 == GuildConst.FACTION_TYPE_BLHX then
		arg0_25.mainPage = arg0_25.mainBluePage
	elseif var0_25 == GuildConst.FACTION_TYPE_CSZZ then
		arg0_25.mainPage = arg0_25.mainRedPage
	end

	local function var1_25()
		if not arg0_25.mainPage:GetLoaded() or arg0_25.mainPage:IsPlaying() then
			return
		end

		arg0_25.createProcess = nil

		arg0_25:createGuild()
		arg0_25.mainPage:Hide()
	end

	arg0_25.mainPage:ExecuteAction("Show", arg1_25, arg0_25.playerVO, function()
		setActive(arg0_25.factionPanel, false)
	end, var1_25)
	onButton(arg0_25, arg0_25.backBtn, var1_25, SFX_CANCEL)
end

function var0_0.ClosePage(arg0_28)
	if arg0_28.page and arg0_28.page:GetLoaded() and arg0_28.page:isShowing() then
		arg0_28.page:Hide()
	end
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.createProcess ~= nil then
		triggerButton(arg0_29.backBtn)
	else
		triggerButton(arg0_29.createPanel)
	end
end

function var0_0.willExit(arg0_30)
	arg0_30.mainRedPage:Destroy()
	arg0_30.mainBluePage:Destroy()
end

return var0_0
