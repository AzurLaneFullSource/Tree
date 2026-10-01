local var0_0 = class("IslandOtherCardLayer", import(".IslandSelfCardLayer"))

var0_0.DOUBLE_CLICK_TIME = 0.5

function var0_0.getUIName(arg0_1)
	return "IslandOtherCardUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.userId

	seriesAsync({
		function(arg0_3)
			local var0_3 = getProxy(IslandProxy):GetIsland()

			if var0_3 then
				arg0_2.island = var0_3

				arg0_3()
			else
				pg.m02:sendNotification(GAME.ISLAND_GET_DATA, {
					isCardRequest = true,
					id = var0_2,
					list = {},
					callback = function()
						arg0_2.island = getProxy(IslandProxy):GetIsland()

						arg0_3()
					end
				})
			end
		end,
		function(arg0_5)
			pg.m02:sendNotification(GAME.ISLAND_GET_CARD_DATA, {
				userId = var0_2,
				callback = function(arg0_6)
					arg0_2.card = arg0_6

					arg0_5()
				end
			})
		end
	}, function()
		arg1_2()
	end)
end

function var0_0.getResource(arg0_8)
	local var0_8 = var0_0.super.getResource(arg0_8)
	local var1_8 = {
		"ui/islandcardui_atlas"
	}

	for iter0_8, iter1_8 in ipairs(var1_8 or {}) do
		if not table.contains(var0_8, iter1_8) then
			table.insert(var0_8, iter1_8)
		end
	end

	return var0_8
end

function var0_0.init(arg0_9)
	var0_0.super.init(arg0_9)
	setText(arg0_9._tf:Find("panel/achvs/tpl/empty/Text"), i18n("island_card_no_achv_other"))

	arg0_9.likeGreyTF = arg0_9._tf:Find("panel/photo/like_grey")

	local var0_9 = {
		arg0_9.photoSwitchBtn,
		arg0_9.editBtn,
		arg0_9.diyBtn,
		arg0_9.setAchvsBtn
	}

	for iter0_9, iter1_9 in ipairs(var0_9) do
		setActive(iter1_9, false)
		removeOnButton(iter1_9)
	end

	arg0_9.lableFlagLinkTFs = {
		arg0_9.labelsTF
	}
	arg0_9.socialFlagLinkTFs = {
		arg0_9.likeTF,
		arg0_9.likeGreyTF,
		arg0_9._tf:Find("panel/btns/visit")
	}
end

function var0_0.didEnter(arg0_10)
	var0_0.super.didEnter(arg0_10)
	onButton(arg0_10, arg0_10._tf:Find("panel/photo/like_btn"), function()
		if not arg0_10.card:ShowSocial() then
			return
		end

		arg0_10:GiveLike()
	end)
	onButton(arg0_10, arg0_10.addBtn, function()
		if arg0_10.isFriend then
			return
		end

		arg0_10.requestFriendBox:ExecuteAction("Show", arg0_10.card.userId)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.removeBtn, function()
		if not arg0_10.isFriend then
			return
		end

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("remove_friend_tip"),
			onConfirm = function()
				arg0_10:emit(IslandOtherCardMediator.REMOVE_FRIEND, arg0_10.card.userId)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.whitelistBtn, function()
		if arg0_10.card.whiteMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_vip"))

			return
		end

		arg0_10:emit(IslandOtherCardMediator.ADD_WHITE_LIST, arg0_10.card.userId)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.blacklistBtn, function()
		if arg0_10.card.blackMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_blacklist"))

			return
		end

		arg0_10:emit(IslandOtherCardMediator.ADD_BLACK_LIST, arg0_10.card.userId)
	end, SFX_PANEL)
end

function var0_0.InitAchvUIList(arg0_17)
	arg0_17.achvUIList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg0_17:UpdataAchvItem(arg1_18, arg2_18)
		end
	end)
end

function var0_0.InitBoxs(arg0_19)
	arg0_19.setLabelBox = IslandSetCardLabelBox.New(arg0_19._tf, arg0_19.event)
	arg0_19.requestFriendBox = IslandRequestFriendBox.New(arg0_19._tf, arg0_19.event)
end

function var0_0.Flush(arg0_20)
	arg0_20:UpdataPhoto()
	arg0_20:UpdataLabels()
	arg0_20:UpdataInfos()
	arg0_20:FlushFlagTFs()

	arg0_20.isFriend = getProxy(FriendProxy):isFriend(arg0_20.card.userId)

	arg0_20:FlushFriendBtns()
	arg0_20:FlushLikeTFs()
	setText(arg0_20.likeGreyTF, arg0_20.card.likeCnt)
end

function var0_0.OnSetAchvsDone(arg0_21, arg1_21)
	arg0_21.setAchvsBox:ExecuteAction("Hide")

	arg0_21.card.achvList = arg1_21

	arg0_21.achvUIList:align(var0_0.ACHV_SHOW_CNT)

	local var0_21 = {}

	arg0_21.achvUIList:eachActive(function(arg0_22, arg1_22)
		if arg0_21.card.achvList[arg0_22 + 1] then
			local var0_22 = arg1_22:Find("content/Image")

			var0_22:GetComponent(typeof(CanvasGroup)).alpha = 0

			table.insert(var0_21, function(arg0_23)
				arg1_22:GetComponent(typeof(Animation)):Play()

				var0_22:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_21:managedTween(LeanTween.delayedCall, function()
					arg0_23()
				end, 0.08, nil)
			end)
		end
	end)
	seriesAsync(var0_21)
end

function var0_0.FlushFlagTFs(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.lableFlagLinkTFs) do
		setActive(iter1_25, arg0_25.card:ShowLabel())
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.socialFlagLinkTFs) do
		setActive(iter3_25, arg0_25.card:ShowSocial())
	end
end

function var0_0.FlushFriendBtns(arg0_26)
	setActive(arg0_26.addBtn, not arg0_26.isFriend)
	setActive(arg0_26.removeBtn, arg0_26.isFriend)
end

function var0_0.FlushLikeTFs(arg0_27)
	if not arg0_27.card:ShowSocial() then
		return
	end

	setActive(arg0_27.likeTF, arg0_27.card.likeMark)
	setActive(arg0_27.likeGreyTF, not arg0_27.card.likeMark)
end

function var0_0.UpdateGrayLabel(arg0_28, arg1_28)
	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "bg_label_gray", arg1_28, true)
	setTextColor(arg1_28:Find("name"), Color.NewHex("#F7F7F7"))
	setText(arg1_28:Find("name"), i18n("island_card_edit_label"))
	setText(arg1_28:Find("value"), "")
	onButton(arg0_28, arg1_28, function()
		if arg0_28.card.labelMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_label_done"))

			return
		end

		arg0_28.setLabelBox:ExecuteAction("Show", arg0_28.card.userId, arg0_28.card.labelData)
	end, SFX_PANEL)
end

function var0_0.GiveLike(arg0_30)
	if arg0_30.card.likeMark then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_like_done"))

		return
	end

	arg0_30:emit(IslandOtherCardMediator.GIVE_CARD_LIKE, arg0_30.card.userId)
end

function var0_0.OnGiveLikeDone(arg0_31)
	arg0_31.card.likeCnt = arg0_31.card.likeCnt + 1

	setText(arg0_31.likeTF, arg0_31.card.likeCnt)
	setText(arg0_31.likeGreyTF, arg0_31.card.likeCnt)

	arg0_31.card.likeMark = true

	arg0_31:FlushLikeTFs()
	arg0_31.likeTF:GetComponent(typeof(Animation)):Play()
end

function var0_0.OnGiveLabelDone(arg0_32, arg1_32)
	arg0_32.setLabelBox:ExecuteAction("Hide")
	arg0_32.card:AddLabel(arg1_32)

	arg0_32.card.labelMark = true

	arg0_32:UpdataLabels()
end

function var0_0.OnAddFriendDone(arg0_33, arg1_33)
	arg0_33.requestFriendBox:ExecuteAction("Hide")
end

function var0_0.OnAddFriendPass(arg0_34, arg1_34)
	if arg0_34.card.userId ~= arg1_34 then
		return
	end

	arg0_34.isFriend = true

	arg0_34:FlushFriendBtns()
end

function var0_0.OnRemoveFriendDone(arg0_35, arg1_35)
	arg0_35.isFriend = false

	arg0_35:FlushFriendBtns()
end

function var0_0.OnAccessOpDone(arg0_36, arg1_36)
	if arg1_36 == IslandConst.ACCESS_OP_ADD_WHITELIST then
		arg0_36.card.whiteMark = true
	elseif arg1_36 == IslandConst.ACCESS_OP_ADD_BLACKLIST then
		arg0_36.card.blackMark = true
	end
end

function var0_0.willExit(arg0_37)
	if not arg0_37.contextData.isIslandPage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37._tf)
	end

	if arg0_37.setLabelBox then
		arg0_37.setLabelBox:Destroy()

		arg0_37.setLabelBox = nil
	end

	if arg0_37.requestFriendBox then
		arg0_37.requestFriendBox:Destroy()

		arg0_37.requestFriendBox = nil
	end
end

return var0_0
