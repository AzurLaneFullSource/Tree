local var0_0 = class("NewGuildScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewGuildUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.createPanel = arg0_4:findTF("create_panel")
	arg0_4.factionPanel = arg0_4:findTF("faction_panel")
	arg0_4.createBtn = arg0_4:findTF("create_panel/frame/create_btn")
	arg0_4.joinBtn = arg0_4:findTF("create_panel/frame/join_btn")
	arg0_4.topPanel = arg0_4:findTF("blur_panel/adapt/top")
	arg0_4.publicGuildBtn = arg0_4:findTF("create_panel/frame/public_btn")
	arg0_4.backBtn = arg0_4:findTF("back", arg0_4.topPanel)

	setActive(arg0_4.factionPanel, false)

	arg0_4.mask = arg0_4:findTF("mask")

	SetActive(arg0_4.mask, false)

	arg0_4.mainRedPage = NewGuildMainRedPage.New(arg0_4._tf, arg0_4.event)
	arg0_4.mainBluePage = NewGuildMainBluePage.New(arg0_4._tf, arg0_4.event)
end

function var0_0.didEnter(arg0_5)
	arg0_5:startCreate()
	onButton(arg0_5, arg0_5.createBtn, function()
		arg0_5:createGuild()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.joinBtn, function()
		arg0_5:emit(NewGuildMediator.OPEN_GUILD_LIST)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.createPanel, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.publicGuildBtn, function()
		arg0_5:emit(NewGuildMediator.OPEN_PUBLIC_GUILD)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.backBtn, function()
		if go(arg0_5.createPanel).activeSelf then
			arg0_5:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
end

function var0_0.startCreate(arg0_11)
	setActive(arg0_11.createPanel, true)
end

function var0_0.createGuild(arg0_12)
	setActive(arg0_12.createPanel, false)
	setActive(arg0_12.factionPanel, false)

	arg0_12.createProcess = coroutine.wrap(function()
		setActive(arg0_12.createPanel, false)

		local var0_13 = Guild.New({})

		arg0_12:selectFaction(var0_13, arg0_12.createProcess)
		coroutine.yield()
		arg0_12:setDescInfo(var0_13)
	end)

	arg0_12.createProcess()
end

function var0_0.selectFaction(arg0_14, arg1_14, arg2_14)
	local function var0_14(arg0_15, arg1_15)
		arg0_14.isPlaying = true

		local var0_15 = arg0_15:Find("bg")

		setActive(var0_15, true)

		local var1_15 = var0_15:GetComponent("CanvasGroup")

		LeanTween.value(go(var0_15), 1, 3, 0.5):setOnUpdate(System.Action_float(function(arg0_16)
			var0_15.localScale = Vector3(arg0_16, arg0_16, 1)
			var1_15.alpha = 1 - arg0_16 / 3
		end)):setOnComplete(System.Action(function()
			setActive(var0_15, false)

			var0_15.localScale = Vector3(1, 1, 1)
			arg0_14.isPlaying = false

			arg1_15()
		end))
	end

	setActive(arg0_14.factionPanel, true)

	local var1_14 = arg0_14.factionPanel:Find("panel")
	local var2_14 = var1_14:Find("blhx")
	local var3_14 = var1_14:Find("cszz")
	local var4_14 = var1_14:Find("bg")

	if not arg0_14.isInitFaction then
		setImageSprite(var4_14, GetSpriteFromAtlas("commonbg/camp_bg", ""))
		setImageSprite(var2_14:Find("bg"), GetSpriteFromAtlas("clutter/blhx_icon", ""))
		setImageSprite(var3_14:Find("bg"), GetSpriteFromAtlas("clutter/cszz_icon", ""))
		setActive(var2_14:Find("bg"), false)
		setActive(var3_14:Find("bg"), false)

		arg0_14.isInitFaction = true
	end

	onButton(arg0_14, var2_14, function()
		if arg0_14.isPlaying then
			return
		end

		arg1_14:setFaction(GuildConst.FACTION_TYPE_BLHX)

		if arg2_14 then
			arg2_14()
		else
			return
		end

		var0_14(var2_14, function()
			arg2_14 = nil
		end)
	end, SFX_PANEL)
	onButton(arg0_14, var3_14, function()
		if arg0_14.isPlaying then
			return
		end

		arg1_14:setFaction(GuildConst.FACTION_TYPE_CSZZ)

		if arg2_14 then
			arg2_14()
		else
			return
		end

		var0_14(var3_14, function()
			arg2_14 = nil
		end)
	end)
	onButton(arg0_14, arg0_14.backBtn, function()
		if arg0_14.isPlaying then
			return
		end

		arg0_14.createProcess = nil

		setActive(arg0_14.createPanel, true)
		setActive(arg0_14.factionPanel, false)
		onButton(arg0_14, arg0_14.backBtn, function()
			arg0_14:emit(var0_0.ON_BACK)
		end, SFX_CANCEL)
	end, SFX_CANCEL)
	setActive(arg0_14.topPanel, true)
end

function var0_0.setDescInfo(arg0_24, arg1_24)
	local var0_24 = arg1_24:getFaction()

	if var0_24 == GuildConst.FACTION_TYPE_BLHX then
		arg0_24.mainPage = arg0_24.mainBluePage
	elseif var0_24 == GuildConst.FACTION_TYPE_CSZZ then
		arg0_24.mainPage = arg0_24.mainRedPage
	end

	local function var1_24()
		if not arg0_24.mainPage:GetLoaded() or arg0_24.mainPage:IsPlaying() then
			return
		end

		arg0_24.createProcess = nil

		arg0_24:createGuild()
		arg0_24.mainPage:Hide()
	end

	arg0_24.mainPage:ExecuteAction("Show", arg1_24, arg0_24.playerVO, function()
		setActive(arg0_24.factionPanel, false)
	end, var1_24)
	onButton(arg0_24, arg0_24.backBtn, var1_24, SFX_CANCEL)
end

function var0_0.ClosePage(arg0_27)
	if arg0_27.page and arg0_27.page:GetLoaded() and arg0_27.page:isShowing() then
		arg0_27.page:Hide()
	end
end

function var0_0.onBackPressed(arg0_28)
	if arg0_28.createProcess ~= nil then
		triggerButton(arg0_28.backBtn)
	else
		triggerButton(arg0_28.createPanel)
	end
end

function var0_0.willExit(arg0_29)
	arg0_29.mainRedPage:Destroy()
	arg0_29.mainBluePage:Destroy()
end

return var0_0
