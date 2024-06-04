local var0 = class("NewGuildScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "NewGuildUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.init(arg0)
	arg0.createPanel = arg0:findTF("create_panel")
	arg0.factionPanel = arg0:findTF("faction_panel")
	arg0.createBtn = arg0:findTF("create_panel/frame/create_btn")
	arg0.joinBtn = arg0:findTF("create_panel/frame/join_btn")
	arg0.topPanel = arg0:findTF("blur_panel/adapt/top")
	arg0.publicGuildBtn = arg0:findTF("create_panel/frame/public_btn")
	arg0.backBtn = arg0:findTF("back", arg0.topPanel)

	setActive(arg0.factionPanel, false)

	arg0.mask = arg0:findTF("mask")

	SetActive(arg0.mask, false)

	arg0.mainRedPage = NewGuildMainRedPage.New(arg0._tf, arg0.event)
	arg0.mainBluePage = NewGuildMainBluePage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	arg0:startCreate()
	onButton(arg0, arg0.createBtn, function()
		arg0:createGuild()
	end, SFX_PANEL)
	onButton(arg0, arg0.joinBtn, function()
		arg0:emit(NewGuildMediator.OPEN_GUILD_LIST)
	end, SFX_PANEL)
	onButton(arg0, arg0.createPanel, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.publicGuildBtn, function()
		arg0:emit(NewGuildMediator.OPEN_PUBLIC_GUILD)
	end, SOUND_BACK)
	onButton(arg0, arg0.backBtn, function()
		if go(arg0.createPanel).activeSelf then
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
end

function var0.startCreate(arg0)
	setActive(arg0.createPanel, true)
end

function var0.createGuild(arg0)
	setActive(arg0.createPanel, false)
	setActive(arg0.factionPanel, false)

	arg0.createProcess = coroutine.wrap(function()
		setActive(arg0.createPanel, false)

		local var0 = Guild.New({})

		arg0:selectFaction(var0, arg0.createProcess)
		coroutine.yield()
		arg0:setDescInfo(var0)
	end)

	arg0.createProcess()
end

function var0.selectFaction(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		arg0.isPlaying = true

		local var0 = arg0:Find("bg")

		setActive(var0, true)

		local var1 = var0:GetComponent("CanvasGroup")

		LeanTween.value(go(var0), 1, 3, 0.5):setOnUpdate(System.Action_float(function(arg0)
			var0.localScale = Vector3(arg0, arg0, 1)
			var1.alpha = 1 - arg0 / 3
		end)):setOnComplete(System.Action(function()
			setActive(var0, false)

			var0.localScale = Vector3(1, 1, 1)
			arg0.isPlaying = false

			arg1()
		end))
	end

	setActive(arg0.factionPanel, true)

	local var1 = arg0.factionPanel:Find("panel")
	local var2 = var1:Find("blhx")
	local var3 = var1:Find("cszz")
	local var4 = var1:Find("bg")

	if not arg0.isInitFaction then
		setImageSprite(var4, GetSpriteFromAtlas("commonbg/camp_bg", ""))
		setImageSprite(var2:Find("bg"), GetSpriteFromAtlas("clutter/blhx_icon", ""))
		setImageSprite(var3:Find("bg"), GetSpriteFromAtlas("clutter/cszz_icon", ""))
		setActive(var2:Find("bg"), false)
		setActive(var3:Find("bg"), false)

		arg0.isInitFaction = true
	end

	onButton(arg0, var2, function()
		if arg0.isPlaying then
			return
		end

		arg1:setFaction(GuildConst.FACTION_TYPE_BLHX)

		if arg2 then
			arg2()
		else
			return
		end

		var0(var2, function()
			arg2 = nil
		end)
	end, SFX_PANEL)
	onButton(arg0, var3, function()
		if arg0.isPlaying then
			return
		end

		arg1:setFaction(GuildConst.FACTION_TYPE_CSZZ)

		if arg2 then
			arg2()
		else
			return
		end

		var0(var3, function()
			arg2 = nil
		end)
	end)
	onButton(arg0, arg0.backBtn, function()
		if arg0.isPlaying then
			return
		end

		arg0.createProcess = nil

		setActive(arg0.createPanel, true)
		setActive(arg0.factionPanel, false)
		onButton(arg0, arg0.backBtn, function()
			arg0:emit(var0.ON_BACK)
		end, SFX_CANCEL)
	end, SFX_CANCEL)
	setActive(arg0.topPanel, true)
end

function var0.setDescInfo(arg0, arg1)
	local var0 = arg1:getFaction()

	if var0 == GuildConst.FACTION_TYPE_BLHX then
		arg0.mainPage = arg0.mainBluePage
	elseif var0 == GuildConst.FACTION_TYPE_CSZZ then
		arg0.mainPage = arg0.mainRedPage
	end

	local function var1()
		if not arg0.mainPage:GetLoaded() or arg0.mainPage:IsPlaying() then
			return
		end

		arg0.createProcess = nil

		arg0:createGuild()
		arg0.mainPage:Hide()
	end

	arg0.mainPage:ExecuteAction("Show", arg1, arg0.playerVO, function()
		setActive(arg0.factionPanel, false)
	end, var1)
	onButton(arg0, arg0.backBtn, var1, SFX_CANCEL)
end

function var0.ClosePage(arg0)
	if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
		arg0.page:Hide()
	end
end

function var0.onBackPressed(arg0)
	if arg0.createProcess ~= nil then
		triggerButton(arg0.backBtn)
	else
		triggerButton(arg0.createPanel)
	end
end

function var0.willExit(arg0)
	arg0.mainRedPage:Destroy()
	arg0.mainBluePage:Destroy()
end

return var0
