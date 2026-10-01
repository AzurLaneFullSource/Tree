local var0_0 = class("GuildMainScene", import("..base.BaseUI"))

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "GuildMainUI"
end

function var0_0.getGroupName(arg0_3)
	return "group_GuildMainUI"
end

function var0_0.setGuildVO(arg0_4, arg1_4)
	arg0_4.guildVO = arg1_4

	if arg0_4.guildRes and arg0_4.guildRes:GetLoaded() then
		arg0_4.guildRes:Update(arg0_4.playerVO, arg1_4)
	end

	if arg0_4.themePage and arg0_4.themePage:GetLoaded() then
		arg0_4.themePage:UpdateGuild(arg0_4.guildVO)
	end
end

function var0_0.setPlayerVO(arg0_5, arg1_5)
	arg0_5.playerVO = arg1_5
end

function var0_0.setChatMsgs(arg0_6, arg1_6)
	arg0_6.chatMsgs = arg1_6
end

function var0_0.setActivity(arg0_7, arg1_7)
	arg0_7.activity = arg1_7
end

function var0_0.setGuildEvent(arg0_8, arg1_8)
	arg0_8.guildEvent = arg1_8
end

function var0_0.UpdateRes(arg0_9)
	if arg0_9.guildRes and arg0_9.guildRes:GetLoaded() then
		arg0_9.guildRes:Update(arg0_9.playerVO, arg0_9.guildVO)
	end
end

function var0_0.OnReportUpdated(arg0_10)
	if arg0_10.themePage and arg0_10.themePage:GetLoaded() then
		arg0_10.themePage:RefreshReportBtn()
	end
end

local var1_0 = "main"
local var2_0 = "member"
local var3_0 = "apply"
local var4_0 = "office"
local var5_0 = "technology"
local var6_0 = "battle"

var0_0.TOGGLE_TAG = {
	var1_0,
	var2_0,
	var3_0,
	var4_0,
	var5_0,
	var6_0
}
var0_0.NOTIFY_TYPE_ALL = 0
var0_0.NOTIFY_TYPE_MAIN = 1
var0_0.NOTIFY_TYPE_APPLY = 2
var0_0.NOTIFY_TYPE_OFFICE = 3
var0_0.NOTIFY_TYPE_BATTLE = 4
var0_0.NOTIFY_TYPE_TECH = 5

function var0_0.init(arg0_11)
	arg0_11._bg = arg0_11._tf:Find("bg")

	pg.GuildPaintingMgr.GetInstance():Enter(arg0_11._bg:Find("painting"))

	arg0_11._playerResOb = arg0_11._tf:Find("blur_panel/adapt/top/res")
	arg0_11.guildRes = GuildResPage.New(arg0_11._playerResOb, arg0_11.event)
	arg0_11.toggleRoot = arg0_11._tf:Find("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot")
	arg0_11.mainTip = arg0_11.toggleRoot:Find("main/tip")
	arg0_11.applyTip = arg0_11.toggleRoot:Find("apply/tip")
	arg0_11.officeTip = arg0_11.toggleRoot:Find("office/tip")
	arg0_11.techTip = arg0_11.toggleRoot:Find("technology/tip")
	arg0_11.battleTip = arg0_11.toggleRoot:Find("battle/tip")
	arg0_11.back = arg0_11._tf:Find("blur_panel/adapt/top/back")
	arg0_11.blurPanel = arg0_11._tf:Find("blur_panel")
	arg0_11.mainTF = arg0_11._tf:Find("main")
	arg0_11.eyeTF = arg0_11._tf:Find("blur_panel/adapt/eye")
	arg0_11._leftLength = findTF(arg0_11.blurPanel, "adapt/left_length")
	arg0_11._topPanel = findTF(arg0_11.blurPanel, "adapt/top")
	arg0_11.topBg = arg0_11._tf:Find("blur_panel/top_bg")
	arg0_11.topBgWidth = arg0_11.topBg.rect.height
	arg0_11.topWidth = arg0_11._topPanel.rect.height
	arg0_11.letfWidth = -1 * (arg0_11._leftLength.rect.width + 300)
	arg0_11.logPage = GuildOfficeLogPage.New(arg0_11._tf, arg0_11.event)
	arg0_11.dynamicBg = GuildDynamicBG.New(arg0_11._tf:Find("dynamic_bg"))
	Input.multiTouchEnabled = false
end

function var0_0.preload(arg0_12, arg1_12)
	seriesAsync({
		function(arg0_13)
			pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
				callback = arg0_13
			})
		end,
		function(arg0_14)
			local var0_14 = getProxy(GuildProxy):getRawData():GetActiveEvent()

			if not var0_14 then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = false,
					callback = arg0_14
				})
			elseif var0_14 and var0_14:IsExpired() then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = arg0_14
				})
			else
				arg0_14()
			end
		end
	}, arg1_12)
end

function var0_0.getResource(arg0_15)
	local var0_15 = var0_0.super.getResource(arg0_15)
	local var1_15 = {
		"ui/GuildResPanel",
		"furnitrues/guild/chair",
		"furnitrues/guild/chair1",
		"ui/guildmainui_atlas",
		"dutyicon",
		"guildpainting/guild_office_blue",
		"guildpainting/guild_office_red",
		"guildpainting/guild_event_boss_2",
		"guildpainting/guild_event_boss_3",
		"guildpainting/guild_event_boss_4",
		"guildtechnology",
		"ui/guildtechnologyredui_atlas",
		"ui/guildtechnologyblueui_atlas",
		"ui/guildtechnologyui_atlas",
		"commonbg/guild_event_bg",
		"guildevent/1",
		"guildevent/2",
		"guildevent/3",
		"guildevent/4",
		"guildevent/5",
		"guildevent/0_0",
		"guildevent/0",
		"guildevent/i_1",
		"guildevent/i_2",
		"guildevent/i_3",
		"guildevent/i_4",
		"guildevent/i_5",
		"ui/guildeventui_atlas",
		"guildeventicon",
		"ui/guildmissionui_atlas",
		"guildmission/midway",
		"guildmission/1_4"
	}

	local function var2_15(arg0_16)
		if noEmptyStr(arg0_16) and not table.contains(var1_15, arg0_16) then
			table.insert(var1_15, arg0_16)
		end
	end

	local var3_15 = getProxy(GuildProxy):getRawData()

	if var3_15 then
		var2_15(var3_15:getBgName())

		local var4_15 = getProxy(SettingsProxy):IsMellowStyle()
		local var5_15 = var3_15:getFaction()

		if var5_15 == GuildConst.FACTION_TYPE_BLHX then
			var2_15(var4_15 and "ui/GuildThemeBlueUI4Mellow" or "ui/GuildThemeBlueUI")
		elseif var5_15 == GuildConst.FACTION_TYPE_CSZZ then
			var2_15(var4_15 and "ui/GuildThemeRedUI4Mellow" or "ui/GuildThemeRedUI")
		end
	end

	local var6_15 = pg.item_data_frame.all

	for iter0_15, iter1_15 in ipairs(var6_15) do
		local var7_15 = pg.item_data_frame[iter1_15]

		var2_15("iconframe/" .. var7_15.id)
	end

	if not arg0_15.memberShips then
		arg0_15.memberShips = getProxy(GuildProxy):getData():GetMemberShips(GuildConst.MAX_DISPLAY_MEMBER_SHIP)
	end

	if arg0_15.memberShips and #arg0_15.memberShips > 0 then
		for iter2_15, iter3_15 in ipairs(arg0_15.memberShips) do
			var2_15("char/" .. iter3_15:getPainting())
		end
	end

	for iter4_15, iter5_15 in ipairs(var1_15) do
		if not table.contains(var0_15, iter5_15) then
			table.insert(var0_15, iter5_15)
		end
	end

	return var0_15
end

function var0_0.didEnter(arg0_17)
	onButton(arg0_17, arg0_17.back, function()
		arg0_17:emit(GuildMainMediator.ON_BACK)
	end, SOUND_BACK)

	arg0_17.hideFlag = false

	onButton(arg0_17, arg0_17.eyeTF, function()
		arg0_17.hideFlag = not arg0_17.hideFlag

		arg0_17:EnterOrExitPreView()
	end, SFX_PANEL)
	arg0_17.guildRes:ExecuteAction("Update", arg0_17.playerVO, arg0_17.guildVO)
	arg0_17:initToggles()
	arg0_17:UpdateRes()
	pg.GuildLayerMgr.GetInstance():BlurTopPanel(arg0_17.blurPanel)

	if arg0_17.guildVO:shouldRefreshCaptial() then
		arg0_17:emit(GuildMainMediator.ON_FETCH_CAPITAL)
	end

	if not arg0_17.memberShips then
		arg0_17.memberShips = arg0_17.guildVO:GetMemberShips(GuildConst.MAX_DISPLAY_MEMBER_SHIP)
	end

	arg0_17.dynamicBg:Init(arg0_17.memberShips)
	arg0_17:UpdateNotices(var0_0.NOTIFY_TYPE_ALL)
end

function var0_0.OnDeleteMember(arg0_20, arg1_20)
	local var0_20 = arg1_20:GetShip()

	arg0_20.dynamicBg:ExitShip(var0_20.name)
end

function var0_0.OnAddMember(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetShip()

	arg0_21.dynamicBg:AddShip(var0_21, function()
		return
	end)
end

function var0_0.EnterOrExitPreView(arg0_23)
	if LeanTween.isTweening(go(arg0_23._topPanel)) or LeanTween.isTweening(go(arg0_23._leftLength)) or LeanTween.isTweening(go(arg0_23.topBg)) then
		return
	end

	if arg0_23.themePage and arg0_23.themePage:GetLoaded() then
		arg0_23.themePage:EnterOrExitPreView(arg0_23.hideFlag)
	end

	local var0_23 = arg0_23.hideFlag and {
		0,
		arg0_23.topWidth
	} or {
		arg0_23.topWidth,
		0
	}

	LeanTween.value(go(arg0_23._topPanel), var0_23[1], var0_23[2], 0.3):setOnUpdate(System.Action_float(function(arg0_24)
		setAnchoredPosition(arg0_23._topPanel, {
			y = arg0_24
		})
	end))

	local var1_23 = arg0_23.hideFlag and {
		0,
		arg0_23.letfWidth
	} or {
		arg0_23.letfWidth,
		0
	}

	LeanTween.value(go(arg0_23._leftLength), var1_23[1], var1_23[2], 0.3):setOnUpdate(System.Action_float(function(arg0_25)
		setAnchoredPosition(arg0_23._leftLength, {
			x = arg0_25
		})
	end))

	local var2_23 = arg0_23.hideFlag and {
		0,
		arg0_23.topBgWidth
	} or {
		arg0_23.topBgWidth,
		0
	}

	LeanTween.value(go(arg0_23.topBg), var2_23[1], var2_23[2], 0.3):setOnUpdate(System.Action_float(function(arg0_26)
		setAnchoredPosition(arg0_23.topBg, {
			y = arg0_26
		})
	end))
end

function var0_0.UpdateBg(arg0_27)
	local var0_27 = arg0_27.guildVO:getBgName()

	if arg0_27.bgName ~= var0_27 then
		GetSpriteFromAtlasAsync(var0_27, "", function(arg0_28)
			if not IsNil(arg0_27._tf) then
				setImageSprite(arg0_27._bg, arg0_28, false)
			end
		end)

		arg0_27.bgName = var0_27
	end
end

function var0_0.UpdateNotices(arg0_29, arg1_29)
	local var0_29 = getProxy(GuildProxy)
	local var1_29 = arg0_29.guildVO

	if arg1_29 == var0_0.NOTIFY_TYPE_ALL or arg1_29 == var0_0.NOTIFY_TYPE_MAIN then
		setActive(arg0_29.mainTip, var0_29:ShouldShowMainTip())
	end

	if arg1_29 == var0_0.NOTIFY_TYPE_ALL or arg1_29 == var0_0.NOTIFY_TYPE_APPLY then
		setActive(arg0_29.applyTip, var0_29:ShouldShowApplyTip())
	end

	if arg1_29 == var0_0.NOTIFY_TYPE_ALL or arg1_29 == var0_0.NOTIFY_TYPE_OFFICE then
		setActive(arg0_29.officeTip, var1_29:ShouldShowOfficeTip())
	end

	if arg1_29 == var0_0.NOTIFY_TYPE_ALL or arg1_29 == var0_0.NOTIFY_TYPE_BATTLE then
		setActive(arg0_29.battleTip, var0_29:ShouldShowBattleTip())
	end

	if arg1_29 == var0_0.NOTIFY_TYPE_ALL or arg1_29 == var0_0.NOTIFY_TYPE_TECH then
		setActive(arg0_29.techTip, var1_29:ShouldShowTechTip())
	end
end

function var0_0.initTheme(arg0_30)
	local var0_30 = arg0_30.guildVO:getFaction()

	if not arg0_30.faction or arg0_30.faction ~= var0_30 then
		if arg0_30.themePage then
			arg0_30.themePage:Destroy()
		end

		arg0_30.themePage = GuildThemePage.New(arg0_30.mainTF, arg0_30.event, arg0_30.contextData)

		arg0_30.themePage:ExecuteAction("Update", arg0_30.guildVO, arg0_30.playerVO, arg0_30.chatMsgs)

		arg0_30.faction = var0_30
	else
		arg0_30.themePage:ActionInvoke("Update", arg0_30.guildVO, arg0_30.playerVO, arg0_30.chatMsgs)
	end
end

function var0_0.OpenMainPage(arg0_31)
	if not arg0_31.themePage or not arg0_31.themePage:GetLoaded() then
		arg0_31:initTheme()
	else
		arg0_31.themePage:Show()
	end
end

function var0_0.initToggles(arg0_32)
	arg0_32.contextData.toggles = {}

	for iter0_32, iter1_32 in ipairs(var0_0.TOGGLE_TAG) do
		arg0_32.contextData.toggles[iter1_32] = arg0_32.toggleRoot:Find(iter1_32)

		assert(arg0_32.contextData.toggles[iter1_32], "transform canot be nil" .. iter1_32)
		onToggle(arg0_32, arg0_32.contextData.toggles[iter1_32], function(arg0_33)
			if arg0_33 then
				arg0_32:openPage(iter1_32)
				setActive(arg0_32._bg, iter1_32 ~= var1_0)
			else
				arg0_32:closePage(iter1_32)
			end
		end, SFX_PANEL)
	end

	if LOCK_GUILD_BATTLE then
		setActive(arg0_32.contextData.toggles[var6_0], false)
	end

	local var0_32 = arg0_32.guildVO:getDutyByMemberId(arg0_32.playerVO.id)

	setActive(arg0_32.contextData.toggles[var3_0], var0_32 == GuildConst.DUTY_COMMANDER or var0_32 == GuildConst.DUTY_DEPUTY_COMMANDER)

	local var1_32 = arg0_32.contextData.page or var1_0

	arg0_32.contextData.page = nil

	assert(arg0_32.contextData.toggles[var1_32])
	triggerToggle(arg0_32.contextData.toggles[var1_32], true)
end

function var0_0.TriggerOfficePage(arg0_34)
	triggerToggle(arg0_34.contextData.toggles[var4_0], true)
end

function var0_0.openPage(arg0_35, arg1_35)
	setActive(arg0_35.eyeTF, arg1_35 == var1_0)

	if arg1_35 == var4_0 or arg1_35 == var5_0 then
		arg0_35.guildRes:Show()
	elseif arg1_35 == var6_0 or arg1_35 == var3_0 or arg1_35 == var2_0 then
		arg0_35.guildRes:Hide()
	else
		arg0_35.guildRes:Hide()
	end

	if arg0_35.themePage and arg0_35.themePage:GetLoaded() and arg0_35.themePage.isShowChatWindow then
		arg0_35.themePage:ShowOrHideChatWindow(false)
	end

	if arg0_35.contextData.page == arg1_35 then
		return
	end

	if arg1_35 == var1_0 then
		arg0_35:OpenMainPage()
		arg0_35:emit(GuildMainMediator.OPEN_MAIN)
	elseif arg1_35 == var2_0 then
		arg0_35:emit(GuildMainMediator.OPEN_MEMBER)
	elseif arg1_35 == var3_0 then
		arg0_35:emit(GuildMainMediator.OPEN_APPLY)
	elseif arg1_35 == var4_0 then
		arg0_35:emit(GuildMainMediator.OPEN_OFFICE)
	elseif arg1_35 == var5_0 then
		arg0_35:emit(GuildMainMediator.OPEN_TECH)
	elseif arg1_35 == var6_0 then
		arg0_35:emit(GuildMainMediator.OPEN_BATTLE)
	end

	arg0_35:UpdateBg()

	arg0_35.contextData.page = arg1_35
end

function var0_0.closePage(arg0_36, arg1_36)
	if arg1_36 == var1_0 then
		if arg0_36.themePage then
			arg0_36.themePage:ExecuteAction("Hide")
		end
	elseif arg1_36 == var2_0 then
		arg0_36:emit(GuildMainMediator.CLOSE_MEMBER)
	elseif arg1_36 == var3_0 then
		arg0_36:emit(GuildMainMediator.CLOSE_APPLY)
	elseif arg1_36 == var4_0 then
		arg0_36:emit(GuildMainMediator.CLOSE_OFFICE)
	elseif arg1_36 == var5_0 then
		arg0_36:emit(GuildMainMediator.CLOSE_TECH)
	elseif arg1_36 == var6_0 then
		arg0_36:emit(GuildMainMediator.CLOSE_BATTLE)
	end
end

function var0_0.BlurView(arg0_37, arg1_37)
	pg.UIMgr.GetInstance():OverlayPanel(arg1_37, {
		pbList = {
			arg1_37:Find("Image1/Image1")
		}
	})
end

function var0_0.UnBlurView(arg0_38, arg1_38, arg2_38)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg1_38, arg2_38)
end

function var0_0.Append(arg0_39, arg1_39, arg2_39)
	if arg0_39.themePage and arg0_39.themePage:GetLoaded() then
		arg0_39.themePage:Append(arg1_39, arg2_39)
	end
end

function var0_0.UpdateAllChat(arg0_40, arg1_40)
	if arg0_40.themePage and arg0_40.themePage:GetLoaded() then
		arg0_40.themePage:UpdateAllChat(arg1_40)
	end
end

function var0_0.UpdateAllLog(arg0_41, arg1_41)
	if arg0_41.themePage and arg0_41.themePage:GetLoaded() then
		arg0_41.themePage:UpdateAllChat(arg1_41)
	end
end

function var0_0.AppendLog(arg0_42, arg1_42, arg2_42)
	if arg0_42.themePage and arg0_42.themePage:GetLoaded() then
		arg0_42.themePage:AppendLog(arg1_42, arg2_42)
	end
end

function var0_0.openResourceLog(arg0_43)
	arg0_43.logPage:ExecuteAction("Show", arg0_43.guildVO)
end

function var0_0.willExit(arg0_44)
	arg0_44.dynamicBg:Dispose()
	arg0_44.logPage:Destroy()
	arg0_44.guildRes:Destroy()

	if arg0_44.themePage then
		arg0_44.themePage:Destroy()
	end

	pg.GuildLayerMgr.GetInstance():Clear()
	pg.GuildPaintingMgr.GetInstance():Exit()

	if arg0_44.contextData.page then
		arg0_44:closePage(arg0_44.contextData.page)
	end

	Input.multiTouchEnabled = true
end

function var0_0.insertEmojiToInputText(arg0_45, arg1_45)
	if arg0_45.themePage then
		arg0_45.themePage:InsertEmojiToInputText(arg1_45)
	end
end

return var0_0
