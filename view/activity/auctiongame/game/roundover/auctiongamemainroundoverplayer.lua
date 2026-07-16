local var0_0 = class("AuctionGameMainRoundOverPlayer", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiSuccessStateText, i18n("auction_main_win"))
	setText(arg0_2.uiFailStateText, i18n("auction_main_fail"))
end

function var0_0.didEnter(arg0_3, arg1_3)
	local var0_3 = getProxy(AuctionGameProxy)
	local var1_3 = var0_3:GetPlayerVO(arg1_3.playerID)

	setScrollText(arg0_3.uiNameText, var1_3.name)

	local var2_3

	if var1_3.icon == AuctionGameConst.TB_NPC_ID then
		var2_3 = pg.ship_skin_template[var1_3.icon].prefab
	else
		var2_3 = Ship.New({
			configId = var1_3.icon,
			skin_id = var1_3.skinId
		}):getPrefab()
	end

	LoadSpriteAsync("qicon/" .. var2_3, function(arg0_4)
		if not IsNil(arg0_3.uiIconImage) then
			arg0_3.uiIconImage.sprite = arg0_4
		end
	end)

	local var3_3 = AttireFrame.attireFrameRes(var1_3, false, AttireConst.TYPE_ICON_FRAME, var1_3.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var3_3, var3_3, true, function(arg0_5)
		if IsNil(arg0_3.uiFrameGo) then
			return
		end

		if arg0_3.uiFrameGo then
			arg0_5.name = var3_3
			findTF(arg0_5.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_5, tf(arg0_3.uiFrameGo), false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var3_3, var3_3, arg0_5)
		end
	end)

	local var4_3 = var0_3:GetRound()
	local var5_3 = var1_3.id
	local var6_3 = var0_3:GetRoundEventAndBidInfo(var4_3, var5_3) or {}

	setText(arg0_3.uiBidText, StringHelper.ForamtNumber(var6_3.bidValue))

	if AuctionGameTools.IsNoBid() then
		setActive(arg0_3.uiFailStateGo, true)
		setActive(arg0_3.uiSuccessStateGo, false)
	elseif AuctionGameTools.IsBidSuccess() then
		setActive(arg0_3.uiFailStateGo, false)
		setActive(arg0_3.uiSuccessStateGo, var6_3.state == 1)
	else
		setActive(arg0_3.uiFailStateGo, false)
		setActive(arg0_3.uiSuccessStateGo, false)
	end

	LoadSpriteAtlasAsync("ui/auctiongameui_atlas", arg1_3.num, function(arg0_6)
		if not IsNil(arg0_3.uiNumImage) then
			arg0_3.uiNumImage.sprite = arg0_6
		end
	end)

	local var7_3 = var0_3:GetRound()
	local var8_3 = var6_3.eventID or 501
	local var9_3 = pg.auction_event[var8_3]

	LoadSpriteAsync(var9_3.icon, function(arg0_7)
		if not IsNil(arg0_3.uiEventImage) then
			arg0_3.uiEventImage.sprite = arg0_7
		end
	end)
end

function var0_0.willExit(arg0_8)
	if not IsNil(arg0_8.uiFrameGo) then
		local var0_8 = tf(arg0_8.uiFrameGo)

		if var0_8.childCount > 0 then
			local var1_8 = var0_8:GetChild(0)
			local var2_8 = var1_8.gameObject.name

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_8, var2_8, var1_8.gameObject)
		end
	end

	arg0_8:detach()
end

return var0_0
