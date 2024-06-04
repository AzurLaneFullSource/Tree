local var0 = class("GuildMainScene", import("..base.BaseUI"))

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "GuildMainUI"
end

function var0.getGroupName(arg0)
	return "group_GuildMainUI"
end

function var0.setGuildVO(arg0, arg1)
	arg0.guildVO = arg1

	if arg0.guildRes and arg0.guildRes:GetLoaded() then
		arg0.guildRes:Update(arg0.playerVO, arg1)
	end

	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:UpdateGuild(arg0.guildVO)
	end
end

function var0.setPlayerVO(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.setChatMsgs(arg0, arg1)
	arg0.chatMsgs = arg1
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.setGuildEvent(arg0, arg1)
	arg0.guildEvent = arg1
end

function var0.UpdateRes(arg0)
	if arg0.guildRes and arg0.guildRes:GetLoaded() then
		arg0.guildRes:Update(arg0.playerVO, arg0.guildVO)
	end
end

function var0.OnReportUpdated(arg0)
	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:RefreshReportBtn()
	end
end

local var1 = "main"
local var2 = "member"
local var3 = "apply"
local var4 = "office"
local var5 = "technology"
local var6 = "battle"

var0.TOGGLE_TAG = {
	var1,
	var2,
	var3,
	var4,
	var5,
	var6
}
var0.NOTIFY_TYPE_ALL = 0
var0.NOTIFY_TYPE_MAIN = 1
var0.NOTIFY_TYPE_APPLY = 2
var0.NOTIFY_TYPE_OFFICE = 3
var0.NOTIFY_TYPE_BATTLE = 4
var0.NOTIFY_TYPE_TECH = 5

function var0.init(arg0)
	arg0._bg = arg0:findTF("bg")

	pg.GuildPaintingMgr:GetInstance():Enter(arg0._bg:Find("painting"))

	arg0._playerResOb = arg0:findTF("blur_panel/adapt/top/res")
	arg0.guildRes = GuildResPage.New(arg0._playerResOb, arg0.event)
	arg0.toggleRoot = arg0:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot")
	arg0.mainTip = arg0:findTF("main/tip", arg0.toggleRoot)
	arg0.applyTip = arg0:findTF("apply/tip", arg0.toggleRoot)
	arg0.officeTip = arg0:findTF("office/tip", arg0.toggleRoot)
	arg0.techTip = arg0:findTF("technology/tip", arg0.toggleRoot)
	arg0.battleTip = arg0:findTF("battle/tip", arg0.toggleRoot)
	arg0.back = arg0:findTF("blur_panel/adapt/top/back")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.mainTF = arg0:findTF("main")
	arg0.eyeTF = arg0:findTF("blur_panel/adapt/eye")
	arg0._leftLength = findTF(arg0.blurPanel, "adapt/left_length")
	arg0._topPanel = findTF(arg0.blurPanel, "adapt/top")
	arg0.topBg = arg0:findTF("blur_panel/top_bg")
	arg0.topBgWidth = arg0.topBg.rect.height
	arg0.topWidth = arg0._topPanel.rect.height
	arg0.letfWidth = -1 * (arg0._leftLength.rect.width + 300)
	arg0.logPage = GuildOfficeLogPage.New(arg0._tf, arg0.event)
	arg0.dynamicBg = GuildDynamicBG.New(arg0:findTF("dynamic_bg"))
	Input.multiTouchEnabled = false
end

function var0.preload(arg0, arg1)
	seriesAsync({
		function(arg0)
			pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
				callback = arg0
			})
		end,
		function(arg0)
			local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

			if not var0 then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = false,
					callback = arg0
				})
			elseif var0 and var0:IsExpired() then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = arg0
				})
			else
				arg0()
			end
		end
	}, arg1)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.back, function()
		arg0:emit(GuildMainMediator.ON_BACK)
	end, SOUND_BACK)

	arg0.hideFlag = false

	onButton(arg0, arg0.eyeTF, function()
		arg0.hideFlag = not arg0.hideFlag

		arg0:EnterOrExitPreView()
	end, SFX_PANEL)
	arg0.guildRes:ExecuteAction("Update", arg0.playerVO, arg0.guildVO)
	arg0:initToggles()
	arg0:UpdateRes()
	pg.GuildLayerMgr:GetInstance():BlurTopPanel(arg0.blurPanel)

	if arg0.guildVO:shouldRefreshCaptial() then
		arg0:emit(GuildMainMediator.ON_FETCH_CAPITAL)
	end

	local var0 = arg0.guildVO:GetMemberShips(GuildConst.MAX_DISPLAY_MEMBER_SHIP)

	arg0.dynamicBg:Init(var0)
	arg0:UpdateNotices(var0.NOTIFY_TYPE_ALL)
end

function var0.OnDeleteMember(arg0, arg1)
	local var0 = arg1:GetShip()

	arg0.dynamicBg:ExitShip(var0.name)
end

function var0.OnAddMember(arg0, arg1)
	local var0 = arg1:GetShip()

	arg0.dynamicBg:AddShip(var0, function()
		return
	end)
end

function var0.EnterOrExitPreView(arg0)
	if LeanTween.isTweening(go(arg0._topPanel)) or LeanTween.isTweening(go(arg0._leftLength)) or LeanTween.isTweening(go(arg0.topBg)) then
		return
	end

	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:EnterOrExitPreView(arg0.hideFlag)
	end

	local var0 = arg0.hideFlag and {
		0,
		arg0.topWidth
	} or {
		arg0.topWidth,
		0
	}

	LeanTween.value(go(arg0._topPanel), var0[1], var0[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0._topPanel, {
			y = arg0
		})
	end))

	local var1 = arg0.hideFlag and {
		0,
		arg0.letfWidth
	} or {
		arg0.letfWidth,
		0
	}

	LeanTween.value(go(arg0._leftLength), var1[1], var1[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0._leftLength, {
			x = arg0
		})
	end))

	local var2 = arg0.hideFlag and {
		0,
		arg0.topBgWidth
	} or {
		arg0.topBgWidth,
		0
	}

	LeanTween.value(go(arg0.topBg), var2[1], var2[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.topBg, {
			y = arg0
		})
	end))
end

function var0.UpdateBg(arg0)
	local var0 = arg0.guildVO:getBgName()

	if arg0.bgName ~= var0 then
		GetSpriteFromAtlasAsync(var0, "", function(arg0)
			if not IsNil(arg0._tf) then
				setImageSprite(arg0._bg, arg0, false)
			end
		end)

		arg0.bgName = var0
	end
end

function var0.UpdateNotices(arg0, arg1)
	local var0 = getProxy(GuildProxy)
	local var1 = arg0.guildVO

	if arg1 == var0.NOTIFY_TYPE_ALL or arg1 == var0.NOTIFY_TYPE_MAIN then
		setActive(arg0.mainTip, var0:ShouldShowMainTip())
	end

	if arg1 == var0.NOTIFY_TYPE_ALL or arg1 == var0.NOTIFY_TYPE_APPLY then
		setActive(arg0.applyTip, var0:ShouldShowApplyTip())
	end

	if arg1 == var0.NOTIFY_TYPE_ALL or arg1 == var0.NOTIFY_TYPE_OFFICE then
		setActive(arg0.officeTip, var1:ShouldShowOfficeTip())
	end

	if arg1 == var0.NOTIFY_TYPE_ALL or arg1 == var0.NOTIFY_TYPE_BATTLE then
		setActive(arg0.battleTip, var0:ShouldShowBattleTip())
	end

	if arg1 == var0.NOTIFY_TYPE_ALL or arg1 == var0.NOTIFY_TYPE_TECH then
		setActive(arg0.techTip, var1:ShouldShowTechTip())
	end
end

function var0.initTheme(arg0)
	local var0 = arg0.guildVO:getFaction()

	if not arg0.faction or arg0.faction ~= var0 then
		if arg0.themePage then
			arg0.themePage:Destroy()
		end

		arg0.themePage = GuildThemePage.New(arg0.mainTF, arg0.event, arg0.contextData)

		arg0.themePage:ExecuteAction("Update", arg0.guildVO, arg0.playerVO, arg0.chatMsgs)

		arg0.faction = var0
	else
		arg0.themePage:ActionInvoke("Update", arg0.guildVO, arg0.playerVO, arg0.chatMsgs)
	end
end

function var0.OpenMainPage(arg0)
	if not arg0.themePage or not arg0.themePage:GetLoaded() then
		arg0:initTheme()
	else
		arg0.themePage:Show()
	end
end

function var0.initToggles(arg0)
	arg0.contextData.toggles = {}

	for iter0, iter1 in ipairs(var0.TOGGLE_TAG) do
		arg0.contextData.toggles[iter1] = arg0.toggleRoot:Find(iter1)

		assert(arg0.contextData.toggles[iter1], "transform canot be nil" .. iter1)
		onToggle(arg0, arg0.contextData.toggles[iter1], function(arg0)
			if arg0 then
				arg0:openPage(iter1)
				setActive(arg0._bg, iter1 ~= var1)
			else
				arg0:closePage(iter1)
			end
		end, SFX_PANEL)
	end

	if LOCK_GUILD_BATTLE then
		setActive(arg0.contextData.toggles[var6], false)
	end

	local var0 = arg0.guildVO:getDutyByMemberId(arg0.playerVO.id)

	setActive(arg0.contextData.toggles[var3], var0 == GuildConst.DUTY_COMMANDER or var0 == GuildConst.DUTY_DEPUTY_COMMANDER)

	local var1 = arg0.contextData.page or var1

	arg0.contextData.page = nil

	assert(arg0.contextData.toggles[var1])
	triggerToggle(arg0.contextData.toggles[var1], true)
end

function var0.TriggerOfficePage(arg0)
	triggerToggle(arg0.contextData.toggles[var4], true)
end

function var0.openPage(arg0, arg1)
	setActive(arg0.eyeTF, arg1 == var1)

	if arg1 == var4 or arg1 == var5 then
		arg0.guildRes:Show()
	elseif arg1 == var6 or arg1 == var3 or arg1 == var2 then
		arg0.guildRes:Hide()
	else
		arg0.guildRes:Hide()
	end

	if arg0.themePage and arg0.themePage:GetLoaded() and arg0.themePage.isShowChatWindow then
		arg0.themePage:ShowOrHideChatWindow(false)
	end

	if arg0.contextData.page == arg1 then
		return
	end

	if arg1 == var1 then
		arg0:OpenMainPage()
		arg0:emit(GuildMainMediator.OPEN_MAIN)
	elseif arg1 == var2 then
		arg0:emit(GuildMainMediator.OPEN_MEMBER)
	elseif arg1 == var3 then
		arg0:emit(GuildMainMediator.OPEN_APPLY)
	elseif arg1 == var4 then
		arg0:emit(GuildMainMediator.OPEN_OFFICE)
	elseif arg1 == var5 then
		arg0:emit(GuildMainMediator.OPEN_TECH)
	elseif arg1 == var6 then
		arg0:emit(GuildMainMediator.OPEN_BATTLE)
	end

	arg0:UpdateBg()

	arg0.contextData.page = arg1
end

function var0.closePage(arg0, arg1)
	if arg1 == var1 then
		if arg0.themePage then
			arg0.themePage:ExecuteAction("Hide")
		end
	elseif arg1 == var2 then
		arg0:emit(GuildMainMediator.CLOSE_MEMBER)
	elseif arg1 == var3 then
		arg0:emit(GuildMainMediator.CLOSE_APPLY)
	elseif arg1 == var4 then
		arg0:emit(GuildMainMediator.CLOSE_OFFICE)
	elseif arg1 == var5 then
		arg0:emit(GuildMainMediator.CLOSE_TECH)
	elseif arg1 == var6 then
		arg0:emit(GuildMainMediator.CLOSE_BATTLE)
	end
end

function var0.BlurView(arg0, arg1)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg1, {
		pbList = {
			arg1:Find("Image1/Image1")
		}
	})
end

function var0.UnBlurView(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg1, arg2)
end

function var0.Append(arg0, arg1, arg2)
	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:Append(arg1, arg2)
	end
end

function var0.UpdateAllChat(arg0, arg1)
	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:UpdateAllChat(arg1)
	end
end

function var0.UpdateAllLog(arg0, arg1)
	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:UpdateAllChat(arg1)
	end
end

function var0.AppendLog(arg0, arg1, arg2)
	if arg0.themePage and arg0.themePage:GetLoaded() then
		arg0.themePage:AppendLog(arg1, arg2)
	end
end

function var0.openResourceLog(arg0)
	arg0.logPage:ExecuteAction("Show", arg0.guildVO)
end

function var0.willExit(arg0)
	arg0.dynamicBg:Dispose()
	arg0.logPage:Destroy()
	arg0.guildRes:Destroy()

	if arg0.themePage then
		arg0.themePage:Destroy()
	end

	pg.GuildLayerMgr:GetInstance():Clear()
	pg.GuildPaintingMgr:GetInstance():Exit()

	if arg0.contextData.page then
		arg0:closePage(arg0.contextData.page)
	end

	Input.multiTouchEnabled = true
end

function var0.insertEmojiToInputText(arg0, arg1)
	if arg0.themePage then
		arg0.themePage:InsertEmojiToInputText(arg1)
	end
end

return var0
