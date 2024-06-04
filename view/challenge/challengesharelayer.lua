local var0 = class("ChallengeShareLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ChallengeShareUI"
end

function var0.init(arg0)
	arg0.painting = arg0:findTF("main/Painting")
	arg0.shipList = arg0:findTF("main/ship_list")
	arg0.cardTF = arg0:findTF("ship_card", arg0.shipList)
	arg0.itemList = UIItemList.New(arg0.shipList, arg0.cardTF)
	arg0.wordTF = arg0:findTF("main/word")
	arg0.touchBtn = arg0:findTF("touch_btn")

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.setLevel(arg0, arg1)
	arg0.level = arg1
end

function var0.setShipPaintList(arg0, arg1)
	arg0.shipPaintList = arg1
end

function var0.setFlagShipPaint(arg0, arg1)
	arg0.flagShipPaint = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.touchBtn, function()
		if arg0.isLoading then
			return
		end

		arg0:closeView()
	end, SFX_PANEL)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			table.insert(arg0.funcs, function(arg0)
				LoadSpriteAsync("shipYardIcon/" .. arg0.shipPaintList[arg1 + 1], function(arg0)
					if not IsNil(arg2) then
						setImageSprite(arg2:Find("back/Image"), arg0)
					end

					arg0()
				end)
			end)
		end
	end)
	arg0:flush()
end

function var0.flush(arg0)
	arg0.funcs = {}

	arg0.itemList:align(#arg0.shipPaintList)
	table.insert(arg0.funcs, function(arg0)
		setPaintingPrefabAsync(arg0.painting, arg0.flagShipPaint, "chuanwu", arg0)
	end)

	arg0.isLoading = true

	parallelAsync(arg0.funcs, function()
		arg0.isLoading = false

		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end)
	setText(arg0.wordTF:Find("Text"), i18n("challenge_share_progress"))
	setText(arg0.wordTF:Find("number/Text"), arg0.level)
	setText(arg0.wordTF:Find("Text2"), i18n("challenge_share"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
