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

function var0_0.init(arg0_8)
	var0_0.super.init(arg0_8)
	setText(arg0_8._tf:Find("panel/achvs/tpl/empty/Text"), i18n("island_card_no_achv_other"))

	arg0_8.likeGreyTF = arg0_8._tf:Find("panel/photo/like_grey")

	local var0_8 = {
		arg0_8.photoSwitchBtn,
		arg0_8.editBtn,
		arg0_8.diyBtn,
		arg0_8.setAchvsBtn
	}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		setActive(iter1_8, false)
		removeOnButton(iter1_8)
	end

	arg0_8.lableFlagLinkTFs = {
		arg0_8.labelsTF
	}
	arg0_8.socialFlagLinkTFs = {
		arg0_8.likeTF,
		arg0_8.likeGreyTF,
		arg0_8._tf:Find("panel/btns/visit")
	}
end

function var0_0.didEnter(arg0_9)
	var0_0.super.didEnter(arg0_9)
	onButton(arg0_9, arg0_9._tf:Find("panel/photo/like_btn"), function()
		if not arg0_9.card:ShowSocial() then
			return
		end

		arg0_9:GiveLike()
	end)
	onButton(arg0_9, arg0_9.addBtn, function()
		if arg0_9.isFriend then
			return
		end

		arg0_9.requestFriendBox:ExecuteAction("Show", arg0_9.card.userId)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.removeBtn, function()
		if not arg0_9.isFriend then
			return
		end

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("remove_friend_tip"),
			onConfirm = function()
				arg0_9:emit(IslandOtherCardMediator.REMOVE_FRIEND, arg0_9.card.userId)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.whitelistBtn, function()
		if arg0_9.card.whiteMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_vip"))

			return
		end

		arg0_9:emit(IslandOtherCardMediator.ADD_WHITE_LIST, arg0_9.card.userId)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.blacklistBtn, function()
		if arg0_9.card.blackMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_repeat_blacklist"))

			return
		end

		arg0_9:emit(IslandOtherCardMediator.ADD_BLACK_LIST, arg0_9.card.userId)
	end, SFX_PANEL)
end

function var0_0.InitAchvUIList(arg0_16)
	arg0_16.achvUIList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			arg0_16:UpdataAchvItem(arg1_17, arg2_17)
		end
	end)
end

function var0_0.InitBoxs(arg0_18)
	arg0_18.setLabelBox = IslandSetCardLabelBox.New(arg0_18._tf, arg0_18.event)
	arg0_18.requestFriendBox = IslandRequestFriendBox.New(arg0_18._tf, arg0_18.event)
end

function var0_0.Flush(arg0_19)
	arg0_19:UpdataPhoto()
	arg0_19:UpdataLabels()
	arg0_19:UpdataInfos()
	arg0_19:FlushFlagTFs()

	arg0_19.isFriend = getProxy(FriendProxy):isFriend(arg0_19.card.userId)

	arg0_19:FlushFriendBtns()
	arg0_19:FlushLikeTFs()
	setText(arg0_19.likeGreyTF, arg0_19.card.likeCnt)
end

function var0_0.OnSetAchvsDone(arg0_20, arg1_20)
	arg0_20.setAchvsBox:ExecuteAction("Hide")

	arg0_20.card.achvList = arg1_20

	arg0_20.achvUIList:align(var0_0.ACHV_SHOW_CNT)

	local var0_20 = {}

	arg0_20.achvUIList:eachActive(function(arg0_21, arg1_21)
		if arg0_20.card.achvList[arg0_21 + 1] then
			local var0_21 = arg1_21:Find("content/Image")

			var0_21:GetComponent(typeof(CanvasGroup)).alpha = 0

			table.insert(var0_20, function(arg0_22)
				arg1_21:GetComponent(typeof(Animation)):Play()

				var0_21:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_20:managedTween(LeanTween.delayedCall, function()
					arg0_22()
				end, 0.08, nil)
			end)
		end
	end)
	seriesAsync(var0_20)
end

function var0_0.FlushFlagTFs(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.lableFlagLinkTFs) do
		setActive(iter1_24, arg0_24.card:ShowLabel())
	end

	for iter2_24, iter3_24 in ipairs(arg0_24.socialFlagLinkTFs) do
		setActive(iter3_24, arg0_24.card:ShowSocial())
	end
end

function var0_0.FlushFriendBtns(arg0_25)
	setActive(arg0_25.addBtn, not arg0_25.isFriend)
	setActive(arg0_25.removeBtn, arg0_25.isFriend)
end

function var0_0.FlushLikeTFs(arg0_26)
	if not arg0_26.card:ShowSocial() then
		return
	end

	setActive(arg0_26.likeTF, arg0_26.card.likeMark)
	setActive(arg0_26.likeGreyTF, not arg0_26.card.likeMark)
end

function var0_0.UpdateGrayLabel(arg0_27, arg1_27)
	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "bg_label_gray", arg1_27, true)
	setTextColor(arg1_27:Find("name"), Color.NewHex("#F7F7F7"))
	setText(arg1_27:Find("name"), i18n("island_card_edit_label"))
	setText(arg1_27:Find("value"), "")
	onButton(arg0_27, arg1_27, function()
		if arg0_27.card.labelMark then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_label_done"))

			return
		end

		arg0_27.setLabelBox:ExecuteAction("Show", arg0_27.card.userId, arg0_27.card.labelData)
	end, SFX_PANEL)
end

function var0_0.GiveLike(arg0_29)
	if arg0_29.card.likeMark then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_card_like_done"))

		return
	end

	arg0_29:emit(IslandOtherCardMediator.GIVE_CARD_LIKE, arg0_29.card.userId)
end

function var0_0.OnGiveLikeDone(arg0_30)
	arg0_30.card.likeCnt = arg0_30.card.likeCnt + 1

	setText(arg0_30.likeTF, arg0_30.card.likeCnt)
	setText(arg0_30.likeGreyTF, arg0_30.card.likeCnt)

	arg0_30.card.likeMark = true

	arg0_30:FlushLikeTFs()
	arg0_30.likeTF:GetComponent(typeof(Animation)):Play()
end

function var0_0.OnGiveLabelDone(arg0_31, arg1_31)
	arg0_31.setLabelBox:ExecuteAction("Hide")
	arg0_31.card:AddLabel(arg1_31)

	arg0_31.card.labelMark = true

	arg0_31:UpdataLabels()
end

function var0_0.OnAddFriendDone(arg0_32, arg1_32)
	arg0_32.requestFriendBox:ExecuteAction("Hide")
end

function var0_0.OnAddFriendPass(arg0_33, arg1_33)
	if arg0_33.card.userId ~= arg1_33 then
		return
	end

	arg0_33.isFriend = true

	arg0_33:FlushFriendBtns()
end

function var0_0.OnRemoveFriendDone(arg0_34, arg1_34)
	arg0_34.isFriend = false

	arg0_34:FlushFriendBtns()
end

function var0_0.OnAccessOpDone(arg0_35, arg1_35)
	if arg1_35 == IslandConst.ACCESS_OP_ADD_WHITELIST then
		arg0_35.card.whiteMark = true
	elseif arg1_35 == IslandConst.ACCESS_OP_ADD_BLACKLIST then
		arg0_35.card.blackMark = true
	end
end

function var0_0.willExit(arg0_36)
	if not arg0_36.contextData.isIslandPage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf)
	end

	if arg0_36.setLabelBox then
		arg0_36.setLabelBox:Destroy()

		arg0_36.setLabelBox = nil
	end

	if arg0_36.requestFriendBox then
		arg0_36.requestFriendBox:Destroy()

		arg0_36.requestFriendBox = nil
	end
end

return var0_0
