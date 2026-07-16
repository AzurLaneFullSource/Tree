local var0_0 = class("AuctionGamePtPage", import("view.activity.CorePage.CorePageNewPtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.get = arg0_1.bg:Find("PT_bg/Text")
	arg0_1.playerInfo = arg0_1.bg:Find("playerInfo")
	arg0_1.playerFrame = arg0_1.playerInfo:Find("frame")
	arg0_1.playerIcon = arg0_1.playerInfo:Find("frame/icon")
	arg0_1.playerName = arg0_1.playerInfo:Find("name")
	arg0_1.playerCount = arg0_1.playerInfo:Find("count")

	setText(arg0_1.bg:Find("tip"), i18n("auction_pt_info"))
	setText(arg0_1.bg:Find("get_btn/text"), i18n("auction_signin_collect"))
	setText(arg0_1.bg:Find("PT_bg/Text"), i18n("auction_pt_tip"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)
	arg0_3:setPlayerInfo()
	setActive(arg0_3.getBtnGray, false)
	setActive(arg0_3.getBtn, true)
	setGray(arg0_3.getBtn, arg0_3.ptData:GetMaxAvailableTargetIndex() == arg0_3.ptData:GetLevel())
end

function var0_0.setPlayerInfo(arg0_4)
	local var0_4 = getProxy(PlayerProxy):getRawData()
	local var1_4 = var0_4:GetShipPhantomMarks()[1]
	local var2_4 = getProxy(BayProxy):GetShipPhantom(var1_4)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var2_4:getPainting(), "", arg0_4.playerIcon)
	setText(arg0_4.playerName, var0_4.name)
	setText(arg0_4.playerCount, StringHelper.ForamtNumberK(AuctionGameTools.GetCurrencyCnt()))
end

return var0_0
