local var0_0 = class("ChatBubbleWorldBoss")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.tf = tf(arg1_1)
	arg0_1.interactable = defaultValue(arg2_1, true)
	arg0_1.nameTF = findTF(arg0_1.tf, "desc/name"):GetComponent("Text")
	arg0_1.face = findTF(arg0_1.tf, "face/content")
	arg0_1.circle = findTF(arg0_1.tf, "shipicon/frame")
	arg0_1.timeTF = findTF(arg0_1.tf, "time"):GetComponent("Text")
	arg0_1.headTF = findTF(arg0_1.tf, "shipicon/icon"):GetComponent("Image")
	arg0_1.stars = findTF(arg0_1.tf, "shipicon/stars")
	arg0_1.star = findTF(arg0_1.stars, "star")
	arg0_1.dutyTF = findTF(arg0_1.tf, "desc/duty")
	arg0_1.channel = findTF(arg0_1.tf, "desc/channel")
	arg0_1.chatframe = findTF(arg0_1.tf, "chat_fram")
	arg0_1.chatContent = findTF(arg0_1.tf, "chat_fram/Text"):GetComponent("Text")
	arg0_1.chatframeSel = findTF(arg0_1.tf, "chat_fram/sel")
	arg0_1.chatframeUnsel = findTF(arg0_1.tf, "chat_fram/unsel")

	setActive(arg0_1.chatframeSel, true)
	setActive(arg0_1.chatframeUnsel, false)
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.data == arg1_2 then
		return
	end

	arg0_2.data = arg1_2

	local var0_2 = false
	local var1_2 = arg1_2.player

	if var1_2.icon == 0 then
		var1_2.icon = 101171
	end

	local var2_2 = var1_2.propose

	arg0_2.nameTF.text = var1_2.name

	local var3_2 = arg1_2.timestamp
	local var4_2 = getOfflineTimeStamp(var3_2)

	arg0_2.timeTF.text = var4_2

	local var5_2 = pg.ship_data_statistics[var1_2.icon]
	local var6_2 = Ship.New({
		configId = var5_2.id
	})
	local var7_2 = arg0_2.stars.childCount
	local var8_2 = var6_2:getStar()

	for iter0_2 = var7_2, var8_2 - 1 do
		cloneTplTo(arg0_2.star, arg0_2.stars)
	end

	local var9_2 = arg0_2.stars.childCount

	for iter1_2 = 0, var9_2 - 1 do
		arg0_2.stars:GetChild(iter1_2).gameObject:SetActive(iter1_2 < var5_2.star)
	end

	if arg0_2.channel then
		local var10_2 = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_2.type) .. "_1920")

		setImageSprite(arg0_2.channel, var10_2, true)
	end

	arg0_2.headTF.color = Color.New(1, 1, 1, 0)

	LoadSpriteAsync("qicon/" .. var1_2:getPainting(), function(arg0_3)
		if not IsNil(arg0_2.headTF) then
			arg0_2.headTF.color = Color.white
			arg0_2.headTF.sprite = arg0_3 or LoadSprite("heroicon/unknown")
		end
	end)

	if arg0_2.dutyTF then
		setActive(arg0_2.dutyTF, var1_2.duty)

		if var1_2.duty then
			local var11_2 = GetSpriteFromAtlas("dutyicon", var1_2.duty)

			setImageSprite(arg0_2.dutyTF, var11_2, true)
		end
	end

	local var12_2 = AttireFrame.attireFrameRes(var1_2, var0_2, AttireConst.TYPE_ICON_FRAME, var2_2)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var12_2, var12_2, true, function(arg0_4)
		if IsNil(arg0_2.tf) then
			return
		end

		if arg0_2.circle and arg0_2.data then
			arg0_4.name = var12_2
			findTF(arg0_4.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_4, arg0_2.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var12_2, var12_2, arg0_4)
		end
	end)

	local var13_2 = arg1_2.args.wordBossId

	onButton(nil, arg0_2.chatframe, function()
		if not arg0_2.interactable then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_inbattle"))

			return
		end

		if arg1_2.args.isDeath then
			arg0_2:SetGray()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))

			return
		end

		pg.WorldBossTipMgr.GetInstance():OnClick("", var13_2, arg1_2.args.lastTime, function()
			arg0_2:SetGray()
		end)
	end, SFX_PANEL)

	if arg1_2.args.isDeath then
		arg0_2:SetGray()
	end

	arg0_2.chatContent.text = i18n("world_boss_ad", arg1_2.args.bossName, arg1_2.args.level)
end

function var0_0.SetGray(arg0_7)
	setActive(arg0_7.chatframeSel, false)
	setActive(arg0_7.chatframeUnsel, true)
end

function var0_0.dispose(arg0_8)
	removeOnButton(arg0_8.chatframe)

	if arg0_8.circle.childCount > 0 then
		local var0_8 = arg0_8.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_8.name, var0_8.name, var0_8)
	end
end

return var0_0
