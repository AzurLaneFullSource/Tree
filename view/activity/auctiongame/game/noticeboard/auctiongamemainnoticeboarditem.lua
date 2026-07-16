local var0_0 = class("AuctionGameMainNoticeBoardItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiEventBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainEventMsgLayer,
			mediator = AuctionGameMainEventMsgMediator,
			data = {
				eventID = arg0_2.data.eventID
			}
		}))
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4.data = arg1_4

	if arg1_4 == nil then
		return
	end

	setText(arg0_4.uiBidText, StringHelper.ForamtNumber(arg1_4.bidValue or 0))

	local var0_4 = arg1_4.eventID

	if var0_4 ~= nil then
		local var1_4 = pg.auction_event[var0_4]

		LoadSpriteAsync(var1_4.icon, function(arg0_5)
			if not IsNil(arg0_4.uiEventImage) then
				arg0_4.uiEventImage.sprite = arg0_5
			end
		end)
	end
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
	Object.Destroy(arg0_6._go)
end

return var0_0
