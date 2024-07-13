local var0_0 = class("ChallengeShareLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChallengeShareUI"
end

function var0_0.init(arg0_2)
	arg0_2.painting = arg0_2:findTF("main/Painting")
	arg0_2.shipList = arg0_2:findTF("main/ship_list")
	arg0_2.cardTF = arg0_2:findTF("ship_card", arg0_2.shipList)
	arg0_2.itemList = UIItemList.New(arg0_2.shipList, arg0_2.cardTF)
	arg0_2.wordTF = arg0_2:findTF("main/word")
	arg0_2.touchBtn = arg0_2:findTF("touch_btn")

	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)
end

function var0_0.setLevel(arg0_3, arg1_3)
	arg0_3.level = arg1_3
end

function var0_0.setShipPaintList(arg0_4, arg1_4)
	arg0_4.shipPaintList = arg1_4
end

function var0_0.setFlagShipPaint(arg0_5, arg1_5)
	arg0_5.flagShipPaint = arg1_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.touchBtn, function()
		if arg0_6.isLoading then
			return
		end

		arg0_6:closeView()
	end, SFX_PANEL)
	arg0_6.itemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			table.insert(arg0_6.funcs, function(arg0_9)
				LoadSpriteAsync("shipYardIcon/" .. arg0_6.shipPaintList[arg1_8 + 1], function(arg0_10)
					if not IsNil(arg2_8) then
						setImageSprite(arg2_8:Find("back/Image"), arg0_10)
					end

					arg0_9()
				end)
			end)
		end
	end)
	arg0_6:flush()
end

function var0_0.flush(arg0_11)
	arg0_11.funcs = {}

	arg0_11.itemList:align(#arg0_11.shipPaintList)
	table.insert(arg0_11.funcs, function(arg0_12)
		setPaintingPrefabAsync(arg0_11.painting, arg0_11.flagShipPaint, "chuanwu", arg0_12)
	end)

	arg0_11.isLoading = true

	parallelAsync(arg0_11.funcs, function()
		arg0_11.isLoading = false

		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end)
	setText(arg0_11.wordTF:Find("Text"), i18n("challenge_share_progress"))
	setText(arg0_11.wordTF:Find("number/Text"), arg0_11.level)
	setText(arg0_11.wordTF:Find("Text2"), i18n("challenge_share"))
end

function var0_0.willExit(arg0_14)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
end

return var0_0
