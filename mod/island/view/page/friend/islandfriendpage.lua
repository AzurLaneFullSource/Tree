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

local function var10_0(arg0_2)
	return ({
		"tag_friend",
		"tag_guild",
		"tag_code",
		"tag_search",
		"tag_request",
		"tag_white",
		"tag_black",
		"tag_settings"
	})[arg0_2]
end

function var0_0.getUIName(arg0_3)
	return "IslandFriendUI"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.backBtn = arg0_4:findTF("top/back")
	arg0_4.giftTipTxt = arg0_4:findTF("top/gift_tip/Text"):GetComponent(typeof(Text))
	arg0_4.uiToggleList = UIItemList.New(arg0_4._tf:Find("adapt/toggles/content"), arg0_4._tf:Find("adapt/toggles/content/tpl"))
	arg0_4.mainTr = arg0_4._tf:Find("adapt/main")
	arg0_4.pages = {
		[var1_0] = IslandFriendListPage.New(arg0_4.mainTr, arg0_4.event),
		[var2_0] = IslandFriendList4GuildPage.New(arg0_4.mainTr, arg0_4.event),
		[var3_0] = IslandFriendCodePage.New(arg0_4.mainTr, arg0_4.event),
		[var4_0] = IslandFriendSearchPage.New(arg0_4.mainTr, arg0_4.event),
		[var5_0] = IslandFriendRequestPage.New(arg0_4.mainTr, arg0_4.event),
		[var6_0] = IslandFriendWhiteListPage.New(arg0_4.mainTr, arg0_4.event),
		[var7_0] = IslandFriendBlackListPage.New(arg0_4.mainTr, arg0_4.event),
		[var8_0] = IslandFriendSettingPage.New(arg0_4.mainTr, arg0_4.event)
	}

	setText(arg0_4:findTF("top/title/Text"), i18n("island_btn_label_visit"))
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddListener(GAME.FRIEND_SEARCH_DONE, arg0_5.OnSearch)
	arg0_5:AddListener(GAME.ISLAND_REFRESH_INVITECODE_DONE, arg0_5.OnRefreshInviteCode)
	arg0_5:AddListener(GAME.ISLAND_ACCESS_OP_DONE, arg0_5.OnAccessOp)
	arg0_5:AddListener(GAME.FRIEND_DELETE_DONE, arg0_5.OnDelFriend)
	arg0_5:AddListener(var0_0.EVENT_MSG, arg0_5.OnShowMsg)
	arg0_5:AddListener(IslandSignInAgency.OTHER_FETCH_CNT_UPDATE, arg0_5.OnOtherFetchCntUpdate)
	arg0_5:AddListener(NotificationProxy.FRIEND_REQUEST_REMOVED, arg0_5.OnRequestChange)
	arg0_5:AddListener(NotificationProxy.FRIEND_REQUEST_ADDED, arg0_5.OnRequestChange)
	arg0_5:AddListener(GAME.FRIEND_SEND_REQUEST_DONE, arg0_5.OnAddFriendDone)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveListener(GAME.FRIEND_SEARCH_DONE, arg0_6.OnSearch)
	arg0_6:RemoveListener(GAME.ISLAND_REFRESH_INVITECODE_DONE, arg0_6.OnRefreshInviteCode)
	arg0_6:RemoveListener(GAME.ISLAND_ACCESS_OP_DONE, arg0_6.OnAccessOp)
	arg0_6:RemoveListener(GAME.FRIEND_DELETE_DONE, arg0_6.OnDelFriend)
	arg0_6:RemoveListener(var0_0.EVENT_MSG, arg0_6.OnShowMsg)
	arg0_6:RemoveListener(IslandSignInAgency.OTHER_FETCH_CNT_UPDATE, arg0_6.OnOtherFetchCntUpdate)
	arg0_6:RemoveListener(NotificationProxy.FRIEND_REQUEST_REMOVED, arg0_6.OnRequestChange)
	arg0_6:RemoveListener(NotificationProxy.FRIEND_REQUEST_ADDED, arg0_6.OnRequestChange)
	arg0_6:RemoveListener(GAME.FRIEND_SEND_REQUEST_DONE, arg0_6.OnAddFriendDone)
end

function var0_0.OnAddFriendDone(arg0_7)
	local var0_7 = arg0_7.pages[var4_0]

	if var0_7 and var0_7:GetLoaded() and var0_7:isShowing() then
		var0_7:HideRequestBox()
	end
end

function var0_0.OnRequestChange(arg0_8)
	local var0_8 = arg0_8.pages[var5_0]

	if var0_8 and var0_8:GetLoaded() and var0_8:isShowing() then
		var0_8:Flush()
	end

	arg0_8:UpdateTip()
end

function var0_0.OnOtherFetchCntUpdate(arg0_9)
	arg0_9:UpdateGiftTxt()
end

function var0_0.OnDelFriend(arg0_10)
	local var0_10 = arg0_10.pages[var1_0]

	if var0_10 and var0_10:GetLoaded() and var0_10:isShowing() then
		var0_10:Flush()
	end
end

function var0_0.OnAccessOp(arg0_11)
	local var0_11 = arg0_11.pages[var6_0]

	if var0_11 and var0_11:GetLoaded() and var0_11:isShowing() then
		var0_11:Flush()
	end

	local var1_11 = arg0_11.pages[var7_0]

	if var1_11 and var1_11:GetLoaded() and var1_11:isShowing() then
		var1_11:Flush()
	end

	local var2_11 = arg0_11.pages[var4_0]

	if var2_11 and var2_11:GetLoaded() and var2_11:isShowing() then
		var2_11:Flush()
	end
end

function var0_0.OnRefreshInviteCode(arg0_12)
	local var0_12 = arg0_12.pages[var8_0]

	if var0_12 and var0_12:GetLoaded() and var0_12:isShowing() then
		var0_12:OnRefreshInviteCode()
	end
end

function var0_0.OnSearch(arg0_13, arg1_13)
	local var0_13 = arg0_13.pages[var4_0]

	if var0_13 and var0_13:GetLoaded() and var0_13:isShowing() then
		var0_13:OnSearch(arg1_13)
	end
end

function var0_0.OnShowMsg(arg0_14, arg1_14)
	arg0_14:ShowMsgBox({
		content = arg1_14,
		type = IslandMsgBox.TYPE_WHITOUT_BTN
	})
end

function var0_0.OnInit(arg0_15)
	onButton(arg0_15, arg0_15.backBtn, function()
		arg0_15:Hide()
	end, SFX_PANEL)

	arg0_15.toggles = {}

	arg0_15.uiToggleList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			onToggle(arg0_15, arg2_17, function(arg0_18)
				if arg0_18 then
					arg0_15:SwitchPage(arg1_17 + 1)
				end
			end, SF_PANEL)
			setText(arg2_17:Find("unsel"), var9_0(arg1_17 + 1))
			setText(arg2_17:Find("sel/content/Text"), var9_0(arg1_17 + 1))

			local var0_17 = GetSpriteFromAtlas("ui/IslandFriendUI_atlas", var10_0(arg1_17 + 1))

			setImageSprite(arg2_17:Find("sel/content/Image"), var0_17, true)
			table.insert(arg0_15.toggles, arg2_17)
		end
	end)
	arg0_15.uiToggleList:align(#arg0_15.pages)
	arg0_15:UpdateTip()
end

function var0_0.UpdateTip(arg0_19)
	local var0_19 = arg0_19.toggles[var5_0]

	setActive(var0_19:Find("tip"), getProxy(NotificationProxy):getRequestCount() > 0)
end

function var0_0.SwitchPage(arg0_20, arg1_20)
	if arg0_20.page then
		arg0_20.page:ExecuteAction("Hide")

		arg0_20.page = nil
	end

	local var0_20 = arg0_20.pages[arg1_20]

	var0_20:ExecuteAction("Show")

	arg0_20.page = var0_20
end

function var0_0.OnShow(arg0_21)
	arg0_21:UpdateGiftTxt()
	triggerToggle(arg0_21.toggles[var1_0], true)
	arg0_21:BlurPanel()
end

function var0_0.UpdateGiftTxt(arg0_22)
	local var0_22 = getProxy(IslandProxy):GetIsland():GetSignInAgency()
	local var1_22 = var0_22:GetLeftOtherFetchCnt()
	local var2_22 = var0_22:GetMaxOtheFetchcnt()

	arg0_22.giftTipTxt.text = i18n("island_git_cnt_tip") .. var1_22 .. "/" .. var2_22
end

function var0_0.OnHide(arg0_23)
	arg0_23:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_24)
	arg0_24:UnBlurPanel()

	for iter0_24, iter1_24 in ipairs(arg0_24.pages) do
		iter1_24:Destroy()
	end

	arg0_24.pages = nil
end

return var0_0
