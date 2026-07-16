local var0_0 = class("AuctionGameMainRightPlayerInfo", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiCompleteText, i18n("auction_main_done"))
	setText(arg0_2.uiOperateText, i18n("auction_main_doing"))
	LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("main_emoji_open"), function(arg0_3)
		if not IsNil(arg0_2.uiEmojiImage) then
			arg0_2.uiEmojiImage.sprite = arg0_3
		end
	end)
	onButton(arg0_2, arg0_2.uiEmojiBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainEmojiLayer,
			mediator = AuctionGameMainEmojiMediator
		}))
	end)
end

function var0_0.didEnter(arg0_5, arg1_5)
	arg0_5.playerVO = arg1_5

	setScrollText(arg0_5.uiNameText, arg1_5.name)

	local var0_5

	if arg1_5.icon == AuctionGameConst.TB_NPC_ID then
		var0_5 = pg.ship_skin_template[arg1_5.icon].prefab
	else
		var0_5 = Ship.New({
			configId = arg1_5.icon,
			skin_id = arg1_5.skinId
		}):getPrefab()
	end

	LoadSpriteAsync("qicon/" .. var0_5, function(arg0_6)
		if not IsNil(arg0_5.uiIconImage) then
			arg0_5.uiIconImage.sprite = arg0_6
		end
	end)

	local var1_5 = AttireFrame.attireFrameRes(arg1_5, false, AttireConst.TYPE_ICON_FRAME, arg1_5.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var1_5, var1_5, true, function(arg0_7)
		if IsNil(arg0_5.uiFrameGo) then
			return
		end

		if arg0_5.uiFrameGo then
			arg0_7.name = var1_5
			findTF(arg0_7.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_7, tf(arg0_5.uiFrameGo), false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1_5, var1_5, arg0_7)
		end
	end)
	setActive(arg0_5.uiEmojiBtn, arg1_5.id == getProxy(PlayerProxy):getPlayerId())
	arg0_5:RefreshUI()
	arg0_5:RefreshEmojiBtn()
end

function var0_0.RefreshUI(arg0_8)
	local var0_8 = getProxy(AuctionGameProxy)
	local var1_8 = arg0_8.playerVO
	local var2_8 = var0_8:GetPlayerOptStateList()[var1_8.id]
	local var3_8 = table.keyof(var0_8:GetLeaverList(), var1_8.id) or table.keyof(var0_8:GetForfeitList(), var1_8.id) and var0_8:GetAuctionState() ~= AuctionGameConst.AUCTION_PHASE.PERSONAL_EVENT or var2_8 == 1 or var2_8 == 2

	setActive(arg0_8.uiCompleteGo, var3_8)
	setActive(arg0_8.uiOperateGo, not var3_8)
end

function var0_0.RefreshEmojiBtn(arg0_9)
	local var0_9 = getProxy(AuctionGameProxy):GetSwitchEmojiFlag()

	if arg0_9.playerVO.id == getProxy(PlayerProxy):getPlayerId() then
		LoadSpriteAtlasAsync("ui/auctiongameui_atlas", var0_9 == 1 and "main_emoji_close" or "main_emoji_open", function(arg0_10)
			if not IsNil(arg0_9.uiEmojiImage) then
				arg0_9.uiEmojiImage.sprite = arg0_10
			end
		end)
	end
end

function var0_0.ShowEmoji(arg0_11, arg1_11, arg2_11)
	if arg0_11.playerVO.id ~= arg1_11 then
		return
	end

	arg0_11:ReturnEmoji()

	arg0_11.emojiID = arg2_11

	local var0_11 = pg.emoji_template[arg2_11]

	PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_11.pic, var0_11.pic, true, function(arg0_12)
		if not IsNil(arg0_11.uiEmojiTf) then
			arg0_12.name = var0_11.pic

			local var0_12 = arg0_12:GetComponent(typeof(Image))

			if var0_12 then
				var0_12.preserveAspect = true
			end

			tf(arg0_12).anchoredPosition = Vector2.zero
			rtf(arg0_12).sizeDelta = Vector2.New(210, 210)

			local var1_12 = arg0_12:GetComponent("Animator")

			if var1_12 then
				var1_12.enabled = false
			end

			local var2_12 = arg0_12:GetComponent("CriManaEffectUI")

			if var2_12 then
				var2_12:Pause(true)
			end

			setParent(arg0_12, arg0_11.uiEmojiTf)

			arg0_11.emojiTf = arg0_12
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_11.pic, var0_11.pic, arg0_12)
		end
	end)
	arg0_11:AddEmojiTimer()
end

function var0_0.ReturnEmoji(arg0_13)
	if not arg0_13.emojiID then
		return
	end

	if not IsNil(arg0_13.emojiTf) then
		local var0_13 = pg.emoji_template[arg0_13.emojiID]

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_13.pic, var0_13.pic, arg0_13.emojiTf)

		arg0_13.emojiTf = nil
	end
end

function var0_0.AddEmojiTimer(arg0_14)
	arg0_14:StopEmojiTimer()
	setActive(arg0_14.uiEmojiGo, true)

	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_emoji_duration.key_value

	arg0_14.emojiTimer = Timer.New(function()
		if var0_14 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			arg0_14:StopEmojiTimer()
		end
	end, 1, -1)

	arg0_14.emojiTimer:Start()
end

function var0_0.StopEmojiTimer(arg0_16)
	setActive(arg0_16.uiEmojiGo, false)

	if arg0_16.emojiTimer then
		arg0_16.emojiTimer:Stop()

		arg0_16.emojiTimer = nil
	end
end

function var0_0.willExit(arg0_17)
	arg0_17:StopEmojiTimer()
	arg0_17:ReturnEmoji()

	if not IsNil(arg0_17.uiFrameGo) then
		local var0_17 = tf(arg0_17.uiFrameGo)

		if var0_17.childCount > 0 then
			local var1_17 = var0_17:GetChild(0)
			local var2_17 = var1_17.gameObject.name

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_17, var2_17, var1_17.gameObject)
		end
	end

	arg0_17:detach()
end

return var0_0
