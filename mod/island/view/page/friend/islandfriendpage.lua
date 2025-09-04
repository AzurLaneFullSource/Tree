local var0_0 = class("IslandFriendPage", import("...base.IslandBasePage"))

var0_0.EVENT_MSG = "IslandFriendPage:EVENT_MSG"

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = 8

local function var9_0(arg0_1)
	return ({
		i18n("island_friend"),
		i18n("island_guild"),
		i18n("island_code"),
		i18n("island_search"),
		i18n("island_request"),
		i18n("island_whiteList"),
		i18n("island_blackList"),
		i18n("island_settings")
	})[arg0_1]
end

function var0_0.getUIName(arg0_2)
	return "IslandFriendUI"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.backBtn = arg0_3:findTF("top/back")
	arg0_3.giftTipTxt = arg0_3:findTF("top/gift_tip/Text"):GetComponent(typeof(Text))
	arg0_3.uiToggleList = UIItemList.New(arg0_3._tf:Find("toggles/content"), arg0_3._tf:Find("toggles/content/tpl"))
	arg0_3.mainTr = arg0_3._tf:Find("main")
	arg0_3.pages = {
		[var1_0] = IslandFriendListPage.New(arg0_3.mainTr, arg0_3.event),
		[var2_0] = IslandFriendList4GuildPage.New(arg0_3.mainTr, arg0_3.event),
		[var3_0] = IslandFriendCodePage.New(arg0_3.mainTr, arg0_3.event),
		[var4_0] = IslandFriendSearchPage.New(arg0_3.mainTr, arg0_3.event),
		[var5_0] = IslandFriendRequestPage.New(arg0_3.mainTr, arg0_3.event),
		[var6_0] = IslandFriendWhiteListPage.New(arg0_3.mainTr, arg0_3.event),
		[var7_0] = IslandFriendBlackListPage.New(arg0_3.mainTr, arg0_3.event),
		[var8_0] = IslandFriendSettingPage.New(arg0_3.mainTr, arg0_3.event)
	}

	setText(arg0_3:findTF("top/title/Text"), i18n("island_btn_label_visit"))
end

function var0_0.AddListeners(arg0_4)
	arg0_4:AddListener(GAME.FRIEND_SEARCH_DONE, arg0_4.OnSearch)
	arg0_4:AddListener(GAME.ISLAND_REFRESH_INVITECODE_DONE, arg0_4.OnRefreshInviteCode)
	arg0_4:AddListener(GAME.ISLAND_ACCESS_OP_DONE, arg0_4.OnAccessOp)
	arg0_4:AddListener(GAME.FRIEND_DELETE_DONE, arg0_4.OnDelFriend)
	arg0_4:AddListener(var0_0.EVENT_MSG, arg0_4.OnShowMsg)
	arg0_4:AddListener(IslandSignInAgency.OTHER_FETCH_CNT_UPDATE, arg0_4.OnOtherFetchCntUpdate)
	arg0_4:AddListener(NotificationProxy.FRIEND_REQUEST_REMOVED, arg0_4.OnRequestChange)
	arg0_4:AddListener(NotificationProxy.FRIEND_REQUEST_ADDED, arg0_4.OnRequestChange)
end

function var0_0.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(GAME.FRIEND_SEARCH_DONE, arg0_5.OnSearch)
	arg0_5:RemoveListener(GAME.ISLAND_REFRESH_INVITECODE_DONE, arg0_5.OnRefreshInviteCode)
	arg0_5:RemoveListener(GAME.ISLAND_ACCESS_OP_DONE, arg0_5.OnAccessOp)
	arg0_5:RemoveListener(GAME.FRIEND_DELETE_DONE, arg0_5.OnDelFriend)
	arg0_5:RemoveListener(var0_0.EVENT_MSG, arg0_5.OnShowMsg)
	arg0_5:RemoveListener(IslandSignInAgency.OTHER_FETCH_CNT_UPDATE, arg0_5.OnOtherFetchCntUpdate)
	arg0_5:RemoveListener(NotificationProxy.FRIEND_REQUEST_REMOVED, arg0_5.OnRequestChange)
	arg0_5:RemoveListener(NotificationProxy.FRIEND_REQUEST_ADDED, arg0_5.OnRequestChange)
end

function var0_0.OnRequestChange(arg0_6)
	local var0_6 = arg0_6.pages[var5_0]

	if var0_6 and var0_6:GetLoaded() and var0_6:isShowing() then
		var0_6:Flush()
	end

	arg0_6:UpdateTip()
end

function var0_0.OnOtherFetchCntUpdate(arg0_7)
	arg0_7:UpdateGiftTxt()
end

function var0_0.OnDelFriend(arg0_8)
	local var0_8 = arg0_8.pages[var1_0]

	if var0_8 and var0_8:GetLoaded() and var0_8:isShowing() then
		var0_8:Flush()
	end
end

function var0_0.OnAccessOp(arg0_9)
	local var0_9 = arg0_9.pages[var6_0]

	if var0_9 and var0_9:GetLoaded() and var0_9:isShowing() then
		var0_9:Flush()
	end

	local var1_9 = arg0_9.pages[var7_0]

	if var1_9 and var1_9:GetLoaded() and var1_9:isShowing() then
		var1_9:Flush()
	end

	local var2_9 = arg0_9.pages[var4_0]

	if var2_9 and var2_9:GetLoaded() and var2_9:isShowing() then
		var2_9:Flush()
	end
end

function var0_0.OnRefreshInviteCode(arg0_10)
	local var0_10 = arg0_10.pages[var8_0]

	if var0_10 and var0_10:GetLoaded() and var0_10:isShowing() then
		var0_10:OnRefreshInviteCode()
	end
end

function var0_0.OnSearch(arg0_11, arg1_11)
	local var0_11 = arg0_11.pages[var4_0]

	if var0_11 and var0_11:GetLoaded() and var0_11:isShowing() then
		var0_11:OnSearch(arg1_11)
	end
end

function var0_0.OnShowMsg(arg0_12, arg1_12)
	arg0_12:ShowMsgBox({
		content = arg1_12,
		type = IslandMsgBox.TYPE_WHITOUT_BTN
	})
end

function var0_0.OnInit(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:Hide()
	end, SFX_PANEL)

	arg0_13.toggles = {}

	arg0_13.uiToggleList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			onToggle(arg0_13, arg2_15, function(arg0_16)
				if arg0_16 then
					arg0_13:SwitchPage(arg1_15 + 1)
				end
			end, SF_PANEL)
			setText(arg2_15:Find("unsel"), var9_0(arg1_15 + 1))
			setText(arg2_15:Find("sel/content/Text"), var9_0(arg1_15 + 1))
			table.insert(arg0_13.toggles, arg2_15)
		end
	end)
	arg0_13.uiToggleList:align(#arg0_13.pages)
	arg0_13:UpdateTip()
end

function var0_0.UpdateTip(arg0_17)
	local var0_17 = arg0_17.toggles[var5_0]

	setActive(var0_17:Find("tip"), getProxy(NotificationProxy):getRequestCount() > 0)
end

function var0_0.SwitchPage(arg0_18, arg1_18)
	if arg0_18.page then
		arg0_18.page:ExecuteAction("Hide")

		arg0_18.page = nil
	end

	local var0_18 = arg0_18.pages[arg1_18]

	var0_18:ExecuteAction("Show")

	arg0_18.page = var0_18
end

function var0_0.OnShow(arg0_19)
	arg0_19:UpdateGiftTxt()
	triggerToggle(arg0_19.toggles[var1_0], true)
	arg0_19:BlurPanel()
end

function var0_0.UpdateGiftTxt(arg0_20)
	local var0_20 = getProxy(IslandProxy):GetIsland():GetSignInAgency()
	local var1_20 = var0_20:GetLeftOtherFetchCnt()
	local var2_20 = var0_20:GetMaxOtheFetchcnt()

	arg0_20.giftTipTxt.text = i18n("island_git_cnt_tip") .. var1_20 .. "/" .. var2_20
end

function var0_0.OnHide(arg0_21)
	arg0_21:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.pages) do
		iter1_22:Destroy()
	end

	arg0_22.pages = nil
end

return var0_0
