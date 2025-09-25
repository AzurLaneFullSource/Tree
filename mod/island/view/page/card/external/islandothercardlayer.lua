local var0_0 = class("IslandOtherCardLayer", import(".IslandSelfCardLayer"))

var0_0.DOUBLE_CLICK_TIME = 0.5

function var0_0.getUIName(arg0_1)
	return "IslandOtherCardUI"
end

function var0_0.preload(arg0_2, arg1_2)
	seriesAsync({
		function(arg0_3)
			pg.m02:sendNotification(GAME.ISLAND_GET_CARD_DATA, {
				userId = arg0_2.contextData.userId,
				callback = function(arg0_4)
					arg0_2.card = arg0_4

					arg0_3()
				end
			})
		end
	}, function()
		arg1_2()
	end)
end

function var0_0.init(arg0_6)
	var0_0.super.init(arg0_6)
	setText(arg0_6._tf:Find("panel/achvs/tpl/empty/Text"), i18n("island_card_no_achv_other"))

	arg0_6.likeGreyTF = arg0_6._tf:Find("panel/photo/like_grey")

	local var0_6 = {
		arg0_6.photoSwitchBtn,
		arg0_6.editBtn,
		arg0_6.diyBtn,
		arg0_6.setAchvsBtn
	}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		setActive(iter1_6, false)
		removeOnButton(iter1_6)
	end

	arg0_6.lableFlagLinkTFs = {
		arg0_6.labelsTF
	}
	arg0_6.socialFlagLinkTFs = {
		arg0_6.likeTF,
		arg0_6.likeGreyTF,
		arg0_6._tf:Find("panel/btns/visit")
	}
end

function var0_0.didEnter(arg0_7)
	var0_0.super.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("panel/photo/like_btn"), function()
		if not arg0_7.card:ShowSocial() then
			return
		end

		arg0_7:GiveLike()
	end)
	onButton(arg0_7, arg0_7.addBtn, function()
		if arg0_7.isFriend then
			return
		end

		arg0_7.requestFriendBox:ExecuteAction("Show", arg0_7.card.userId)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.removeBtn, function()
		if not arg0_7.isFriend then
			return
		end

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("remove_friend_tip"),
			onConfirm = function()
				arg0_7:emit(IslandOtherCardMediator.REMOVE_FRIEND, arg0_7.card.userId)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.whitelistBtn, function()
		if arg0_7.card.whiteMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_vip"))

			return
		end

		arg0_7:emit(IslandOtherCardMediator.ADD_WHITE_LIST, arg0_7.card.userId)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.blacklistBtn, function()
		if arg0_7.card.blackMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_blacklist"))

			return
		end

		arg0_7:emit(IslandOtherCardMediator.ADD_BLACK_LIST, arg0_7.card.userId)
	end, SFX_PANEL)
end

function var0_0.InitAchvUIList(arg0_14)
	arg0_14.achvUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_14:UpdataAchvItem(arg1_15, arg2_15)
		end
	end)
end

function var0_0.InitBoxs(arg0_16)
	arg0_16.setLabelBox = IslandSetCardLabelBox.New(arg0_16._tf, arg0_16.event)
	arg0_16.requestFriendBox = IslandRequestFriendBox.New(arg0_16._tf, arg0_16.event)
end

function var0_0.Flush(arg0_17)
	var0_0.super.Flush(arg0_17)
	arg0_17:FlushFlagTFs()

	arg0_17.isFriend = getProxy(FriendProxy):isFriend(arg0_17.card.userId)

	arg0_17:FlushFriendBtns()
	arg0_17:FlushLikeTFs()
	setText(arg0_17.likeGreyTF, arg0_17.card.likeCnt)
end

function var0_0.FlushFlagTFs(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.lableFlagLinkTFs) do
		setActive(iter1_18, arg0_18.card:ShowLabel())
	end

	for iter2_18, iter3_18 in ipairs(arg0_18.socialFlagLinkTFs) do
		setActive(iter3_18, arg0_18.card:ShowSocial())
	end
end

function var0_0.FlushFriendBtns(arg0_19)
	setActive(arg0_19.addBtn, not arg0_19.isFriend)
	setActive(arg0_19.removeBtn, arg0_19.isFriend)
end

function var0_0.FlushLikeTFs(arg0_20)
	if not arg0_20.card:ShowSocial() then
		return
	end

	setActive(arg0_20.likeTF, arg0_20.card.likeMark)
	setActive(arg0_20.likeGreyTF, not arg0_20.card.likeMark)
end

function var0_0.UpdateGrayLabel(arg0_21, arg1_21)
	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "bg_label_gray", arg1_21, true)
	setTextColor(arg1_21:Find("name"), Color.NewHex("#F7F7F7"))
	setText(arg1_21:Find("name"), i18n("island_card_edit_label"))
	setText(arg1_21:Find("value"), "")
	onButton(arg0_21, arg1_21, function()
		if arg0_21.card.labelMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_label_done"))

			return
		end

		arg0_21.setLabelBox:ExecuteAction("Show", arg0_21.card.userId, arg0_21.card.labelData)
	end, SFX_PANEL)
end

function var0_0.GiveLike(arg0_23)
	if arg0_23.card.likeMark then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_like_done"))

		return
	end

	arg0_23:emit(IslandOtherCardMediator.GIVE_CARD_LIKE, arg0_23.card.userId)
end

function var0_0.OnGiveLikeDone(arg0_24)
	arg0_24.card.likeCnt = arg0_24.card.likeCnt + 1

	setText(arg0_24.likeTF, arg0_24.card.likeCnt)
	setText(arg0_24.likeGreyTF, arg0_24.card.likeCnt)

	arg0_24.card.likeMark = true

	arg0_24:FlushLikeTFs()
	arg0_24.likeTF:GetComponent(typeof(Animation)):Play()
end

function var0_0.OnGiveLabelDone(arg0_25, arg1_25)
	arg0_25.setLabelBox:ExecuteAction("Hide")
	arg0_25.card:AddLabel(arg1_25)

	arg0_25.card.labelMark = true

	arg0_25:UpdataLabels()
end

function var0_0.OnAddFriendDone(arg0_26, arg1_26)
	arg0_26.requestFriendBox:ExecuteAction("Hide")
end

function var0_0.OnAddFriendPass(arg0_27, arg1_27)
	if arg0_27.card.userId ~= arg1_27 then
		return
	end

	arg0_27.isFriend = true

	arg0_27:FlushFriendBtns()
end

function var0_0.OnRemoveFriendDone(arg0_28, arg1_28)
	arg0_28.isFriend = false

	arg0_28:FlushFriendBtns()
end

function var0_0.OnAccessOpDone(arg0_29, arg1_29)
	if arg1_29 == IslandConst.ACCESS_OP_ADD_WHITELIST then
		arg0_29.card.whiteMark = true
	elseif arg1_29 == IslandConst.ACCESS_OP_ADD_BLACKLIST then
		arg0_29.card.blackMark = true
	end
end

function var0_0.willExit(arg0_30)
	if not arg0_30.contextData.isIslandPage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf)
	end

	if arg0_30.setLabelBox then
		arg0_30.setLabelBox:Destroy()

		arg0_30.setLabelBox = nil
	end

	if arg0_30.requestFriendBox then
		arg0_30.requestFriendBox:Destroy()

		arg0_30.requestFriendBox = nil
	end
end

return var0_0
