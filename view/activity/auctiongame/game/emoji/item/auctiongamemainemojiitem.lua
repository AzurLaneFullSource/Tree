local var0_0 = class("AuctionGameMainEmojiItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBtn, function()
		local var0_3 = getProxy(AuctionGameProxy)

		if var0_3:GetSwitchEmojiFlag() == 1 then
			return
		end

		if var0_3:GetSendEmojiTimestamp() + pg.gameset.auction_emoji_duration.key_value > pg.TimeMgr.GetInstance():GetServerTime() then
			pg.TipsMgr.GetInstance():ShowTips("请勿频繁发送表情")

			return
		end

		arg0_2:emit(AuctionGameMainEmojiMediator.ON_CLICK_EMOJI, arg0_2.id)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4:ReturnEmoji()

	arg0_4.id = arg1_4

	local var0_4 = pg.emoji_template[arg1_4]

	PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_4.pic, var0_4.pic, true, function(arg0_5)
		if not IsNil(arg0_4._tf) then
			arg0_5.name = var0_4.pic

			local var0_5 = arg0_5:GetComponent(typeof(Image))

			if var0_5 then
				var0_5.preserveAspect = true
			end

			tf(arg0_5).anchoredPosition = Vector2.zero
			rtf(arg0_5).sizeDelta = Vector2.New(210, 210)

			local var1_5 = arg0_5:GetComponent("Animator")

			if var1_5 then
				var1_5.enabled = false
			end

			local var2_5 = arg0_5:GetComponent("CriManaEffectUI")

			if var2_5 then
				var2_5:Pause(true)
			end

			setParent(arg0_5, arg0_4._tf)

			arg0_4.emojiTf = arg0_5
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_4.pic, var0_4.pic, arg0_5)
		end
	end)
	arg0_4:Show(true)
end

function var0_0.ReturnEmoji(arg0_6)
	if not arg0_6.id then
		return
	end

	if not IsNil(arg0_6.emojiTf) then
		local var0_6 = pg.emoji_template[arg0_6.id]

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_6.pic, var0_6.pic, arg0_6.emojiTf)

		arg0_6.emojiTf = nil
	end
end

function var0_0.Show(arg0_7, arg1_7)
	setActive(arg0_7._go, arg1_7)
end

function var0_0.willExit(arg0_8)
	arg0_8:ReturnEmoji()
	arg0_8:detach()
	Object.Destroy(arg0_8._go)
end

return var0_0
