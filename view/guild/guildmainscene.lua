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
	arg0_11._bg = arg0_11:findTF("bg")

	pg.GuildPaintingMgr:GetInstance():Enter(arg0_11._bg:Find("painting"))

	arg0_11._playerResOb = arg0_11:findTF("blur_panel/adapt/top/res")
	arg0_11.guildRes = GuildResPage.New(arg0_11._playerResOb, arg0_11.event)
	arg0_11.toggleRoot = arg0_11:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot")
	arg0_11.mainTip = arg0_11:findTF("main/tip", arg0_11.toggleRoot)
	arg0_11.applyTip = arg0_11:findTF("apply/tip", arg0_11.toggleRoot)
	arg0_11.officeTip = arg0_11:findTF("office/tip", arg0_11.toggleRoot)
	arg0_11.techTip = arg0_11:findTF("technology/tip", arg0_11.toggleRoot)
	arg0_11.battleTip = arg0_11:findTF("battle/tip", arg0_11.toggleRoot)
	arg0_11.back = arg0_11:findTF("blur_panel/adapt/top/back")
	arg0_11.blurPanel = arg0_11:findTF("blur_panel")
	arg0_11.mainTF = arg0_11:findTF("main")
	arg0_11.eyeTF = arg0_11:findTF("blur_panel/adapt/eye")
	arg0_11._leftLength = findTF(arg0_11.blurPanel, "adapt/left_length")
	arg0_11._topPanel = findTF(arg0_11.blurPanel, "adapt/top")
	arg0_11.topBg = arg0_11:findTF("blur_panel/top_bg")
	arg0_11.topBgWidth = arg0_11.topBg.rect.height
	arg0_11.topWidth = arg0_11._topPanel.rect.height
	arg0_11.letfWidth = -1 * (arg0_11._leftLength.rect.width + 300)
	arg0_11.logPage = GuildOfficeLogPage.New(arg0_11._tf, arg0_11.event)
	arg0_11.dynamicBg = GuildDynamicBG.New(arg0_11:findTF("dynamic_bg"))
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

function var0_0.didEnter(arg0_15)
	onButton(arg0_15, arg0_15.back, function()
		arg0_15:emit(GuildMainMediator.ON_BACK)
	end, SOUND_BACK)

	arg0_15.hideFlag = false

	onButton(arg0_15, arg0_15.eyeTF, function()
		arg0_15.hideFlag = not arg0_15.hideFlag

		arg0_15:EnterOrExitPreView()
	end, SFX_PANEL)
	arg0_15.guildRes:ExecuteAction("Update", arg0_15.playerVO, arg0_15.guildVO)
	arg0_15:initToggles()
	arg0_15:UpdateRes()
	pg.GuildLayerMgr:GetInstance():BlurTopPanel(arg0_15.blurPanel)

	if arg0_15.guildVO:shouldRefreshCaptial() then
		arg0_15:emit(GuildMainMediator.ON_FETCH_CAPITAL)
	end

	local var0_15 = arg0_15.guildVO:GetMemberShips(GuildConst.MAX_DISPLAY_MEMBER_SHIP)

	arg0_15.dynamicBg:Init(var0_15)
	arg0_15:UpdateNotices(var0_0.NOTIFY_TYPE_ALL)
end

function var0_0.OnDeleteMember(arg0_18, arg1_18)
	local var0_18 = arg1_18:GetShip()

	arg0_18.dynamicBg:ExitShip(var0_18.name)
end

function var0_0.OnAddMember(arg0_19, arg1_19)
	local var0_19 = arg1_19:GetShip()

	arg0_19.dynamicBg:AddShip(var0_19, function()
		return
	end)
end

function var0_0.EnterOrExitPreView(arg0_21)
	if LeanTween.isTweening(go(arg0_21._topPanel)) or LeanTween.isTweening(go(arg0_21._leftLength)) or LeanTween.isTweening(go(arg0_21.topBg)) then
		return
	end

	if arg0_21.themePage and arg0_21.themePage:GetLoaded() then
		arg0_21.themePage:EnterOrExitPreView(arg0_21.hideFlag)
	end

	local var0_21 = arg0_21.hideFlag and {
		0,
		arg0_21.topWidth
	} or {
		arg0_21.topWidth,
		0
	}

	LeanTween.value(go(arg0_21._topPanel), var0_21[1], var0_21[2], 0.3):setOnUpdate(System.Action_float(function(arg0_22)
		setAnchoredPosition(arg0_21._topPanel, {
			y = arg0_22
		})
	end))

	local var1_21 = arg0_21.hideFlag and {
		0,
		arg0_21.letfWidth
	} or {
		arg0_21.letfWidth,
		0
	}

	LeanTween.value(go(arg0_21._leftLength), var1_21[1], var1_21[2], 0.3):setOnUpdate(System.Action_float(function(arg0_23)
		setAnchoredPosition(arg0_21._leftLength, {
			x = arg0_23
		})
	end))

	local var2_21 = arg0_21.hideFlag and {
		0,
		arg0_21.topBgWidth
	} or {
		arg0_21.topBgWidth,
		0
	}

	LeanTween.value(go(arg0_21.topBg), var2_21[1], var2_21[2], 0.3):setOnUpdate(System.Action_float(function(arg0_24)
		setAnchoredPosition(arg0_21.topBg, {
			y = arg0_24
		})
	end))
end

function var0_0.UpdateBg(arg0_25)
	local var0_25 = arg0_25.guildVO:getBgName()

	if arg0_25.bgName ~= var0_25 then
		GetSpriteFromAtlasAsync(var0_25, "", function(arg0_26)
			if not IsNil(arg0_25._tf) then
				setImageSprite(arg0_25._bg, arg0_26, false)
			end
		end)

		arg0_25.bgName = var0_25
	end
end

function var0_0.UpdateNotices(arg0_27, arg1_27)
	local var0_27 = getProxy(GuildProxy)
	local var1_27 = arg0_27.guildVO

	if arg1_27 == var0_0.NOTIFY_TYPE_ALL or arg1_27 == var0_0.NOTIFY_TYPE_MAIN then
		setActive(arg0_27.mainTip, var0_27:ShouldShowMainTip())
	end

	if arg1_27 == var0_0.NOTIFY_TYPE_ALL or arg1_27 == var0_0.NOTIFY_TYPE_APPLY then
		setActive(arg0_27.applyTip, var0_27:ShouldShowApplyTip())
	end

	if arg1_27 == var0_0.NOTIFY_TYPE_ALL or arg1_27 == var0_0.NOTIFY_TYPE_OFFICE then
		setActive(arg0_27.officeTip, var1_27:ShouldShowOfficeTip())
	end

	if arg1_27 == var0_0.NOTIFY_TYPE_ALL or arg1_27 == var0_0.NOTIFY_TYPE_BATTLE then
		setActive(arg0_27.battleTip, var0_27:ShouldShowBattleTip())
	end

	if arg1_27 == var0_0.NOTIFY_TYPE_ALL or arg1_27 == var0_0.NOTIFY_TYPE_TECH then
		setActive(arg0_27.techTip, var1_27:ShouldShowTechTip())
	end
end

function var0_0.initTheme(arg0_28)
	local var0_28 = arg0_28.guildVO:getFaction()

	if not arg0_28.faction or arg0_28.faction ~= var0_28 then
		if arg0_28.themePage then
			arg0_28.themePage:Destroy()
		end

		arg0_28.themePage = GuildThemePage.New(arg0_28.mainTF, arg0_28.event, arg0_28.contextData)

		arg0_28.themePage:ExecuteAction("Update", arg0_28.guildVO, arg0_28.playerVO, arg0_28.chatMsgs)

		arg0_28.faction = var0_28
	else
		arg0_28.themePage:ActionInvoke("Update", arg0_28.guildVO, arg0_28.playerVO, arg0_28.chatMsgs)
	end
end

function var0_0.OpenMainPage(arg0_29)
	if not arg0_29.themePage or not arg0_29.themePage:GetLoaded() then
		arg0_29:initTheme()
	else
		arg0_29.themePage:Show()
	end
end

function var0_0.initToggles(arg0_30)
	arg0_30.contextData.toggles = {}

	for iter0_30, iter1_30 in ipairs(var0_0.TOGGLE_TAG) do
		arg0_30.contextData.toggles[iter1_30] = arg0_30.toggleRoot:Find(iter1_30)

		assert(arg0_30.contextData.toggles[iter1_30], "transform canot be nil" .. iter1_30)
		onToggle(arg0_30, arg0_30.contextData.toggles[iter1_30], function(arg0_31)
			if arg0_31 then
				arg0_30:openPage(iter1_30)
				setActive(arg0_30._bg, iter1_30 ~= var1_0)
			else
				arg0_30:closePage(iter1_30)
			end
		end, SFX_PANEL)
	end

	if LOCK_GUILD_BATTLE then
		setActive(arg0_30.contextData.toggles[var6_0], false)
	end

	local var0_30 = arg0_30.guildVO:getDutyByMemberId(arg0_30.playerVO.id)

	setActive(arg0_30.contextData.toggles[var3_0], var0_30 == GuildConst.DUTY_COMMANDER or var0_30 == GuildConst.DUTY_DEPUTY_COMMANDER)

	local var1_30 = arg0_30.contextData.page or var1_0

	arg0_30.contextData.page = nil

	assert(arg0_30.contextData.toggles[var1_30])
	triggerToggle(arg0_30.contextData.toggles[var1_30], true)
end

function var0_0.TriggerOfficePage(arg0_32)
	triggerToggle(arg0_32.contextData.toggles[var4_0], true)
end

function var0_0.openPage(arg0_33, arg1_33)
	setActive(arg0_33.eyeTF, arg1_33 == var1_0)

	if arg1_33 == var4_0 or arg1_33 == var5_0 then
		arg0_33.guildRes:Show()
	elseif arg1_33 == var6_0 or arg1_33 == var3_0 or arg1_33 == var2_0 then
		arg0_33.guildRes:Hide()
	else
		arg0_33.guildRes:Hide()
	end

	if arg0_33.themePage and arg0_33.themePage:GetLoaded() and arg0_33.themePage.isShowChatWindow then
		arg0_33.themePage:ShowOrHideChatWindow(false)
	end

	if arg0_33.contextData.page == arg1_33 then
		return
	end

	if arg1_33 == var1_0 then
		arg0_33:OpenMainPage()
		arg0_33:emit(GuildMainMediator.OPEN_MAIN)
	elseif arg1_33 == var2_0 then
		arg0_33:emit(GuildMainMediator.OPEN_MEMBER)
	elseif arg1_33 == var3_0 then
		arg0_33:emit(GuildMainMediator.OPEN_APPLY)
	elseif arg1_33 == var4_0 then
		arg0_33:emit(GuildMainMediator.OPEN_OFFICE)
	elseif arg1_33 == var5_0 then
		arg0_33:emit(GuildMainMediator.OPEN_TECH)
	elseif arg1_33 == var6_0 then
		arg0_33:emit(GuildMainMediator.OPEN_BATTLE)
	end

	arg0_33:UpdateBg()

	arg0_33.contextData.page = arg1_33
end

function var0_0.closePage(arg0_34, arg1_34)
	if arg1_34 == var1_0 then
		if arg0_34.themePage then
			arg0_34.themePage:ExecuteAction("Hide")
		end
	elseif arg1_34 == var2_0 then
		arg0_34:emit(GuildMainMediator.CLOSE_MEMBER)
	elseif arg1_34 == var3_0 then
		arg0_34:emit(GuildMainMediator.CLOSE_APPLY)
	elseif arg1_34 == var4_0 then
		arg0_34:emit(GuildMainMediator.CLOSE_OFFICE)
	elseif arg1_34 == var5_0 then
		arg0_34:emit(GuildMainMediator.CLOSE_TECH)
	elseif arg1_34 == var6_0 then
		arg0_34:emit(GuildMainMediator.CLOSE_BATTLE)
	end
end

function var0_0.BlurView(arg0_35, arg1_35)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg1_35, {
		pbList = {
			arg1_35:Find("Image1/Image1")
		}
	})
end

function var0_0.UnBlurView(arg0_36, arg1_36, arg2_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg1_36, arg2_36)
end

function var0_0.Append(arg0_37, arg1_37, arg2_37)
	if arg0_37.themePage and arg0_37.themePage:GetLoaded() then
		arg0_37.themePage:Append(arg1_37, arg2_37)
	end
end

function var0_0.UpdateAllChat(arg0_38, arg1_38)
	if arg0_38.themePage and arg0_38.themePage:GetLoaded() then
		arg0_38.themePage:UpdateAllChat(arg1_38)
	end
end

function var0_0.UpdateAllLog(arg0_39, arg1_39)
	if arg0_39.themePage and arg0_39.themePage:GetLoaded() then
		arg0_39.themePage:UpdateAllChat(arg1_39)
	end
end

function var0_0.AppendLog(arg0_40, arg1_40, arg2_40)
	if arg0_40.themePage and arg0_40.themePage:GetLoaded() then
		arg0_40.themePage:AppendLog(arg1_40, arg2_40)
	end
end

function var0_0.openResourceLog(arg0_41)
	arg0_41.logPage:ExecuteAction("Show", arg0_41.guildVO)
end

function var0_0.willExit(arg0_42)
	arg0_42.dynamicBg:Dispose()
	arg0_42.logPage:Destroy()
	arg0_42.guildRes:Destroy()

	if arg0_42.themePage then
		arg0_42.themePage:Destroy()
	end

	pg.GuildLayerMgr:GetInstance():Clear()
	pg.GuildPaintingMgr:GetInstance():Exit()

	if arg0_42.contextData.page then
		arg0_42:closePage(arg0_42.contextData.page)
	end

	Input.multiTouchEnabled = true
end

function var0_0.insertEmojiToInputText(arg0_43, arg1_43)
	if arg0_43.themePage then
		arg0_43.themePage:InsertEmojiToInputText(arg1_43)
	end
end

return var0_0
