local var0 = class("FeastGiveTicketPage", import(".FeastGiveGiftPage"))

function var0.BindEvents(arg0)
	arg0.eventId = arg0:bind(FeastScene.ON_GOT_TICKET, function(arg0, arg1)
		arg0:OnGotGift(arg1)
	end)
end

function var0.OnGotGift(arg0, arg1)
	if arg0.feastShip then
		arg0:BlockEvents()
		seriesAsync({
			function(arg0)
				arg0:UpdateGiftState(arg0.feastShip, arg0)
			end,
			function(arg0)
				arg0:emit(BaseUI.ON_ACHIEVE, arg1, arg0)
			end,
			function(arg0)
				local var0 = arg0.feastShip:GetInvitationStory()

				pg.NewStoryMgr.GetInstance():Play(var0, arg0)
			end
		}, function()
			arg0:emit(FeastMediator.ON_SHIP_ENTER_FEAST, arg0.feastShip.id)
			arg0:emit(FeastScene.ON_BACK_FEAST)
		end)
	end
end

function var0.ClearBindEvents(arg0)
	if arg0.eventId then
		arg0:disconnect(arg0.eventId)

		arg0.eventId = nil
	end
end

function var0.LoadItem(arg0, arg1, arg2)
	GetSpriteFromAtlasAsync("ui/FeastInvitation_atlas", "res_icon", function(arg0)
		local var0 = arg0.giftTr:GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
		arg2()
	end)
end

function var0.UpdateGiftState(arg0, arg1, arg2)
	arg0:ClearGiftEvent()
	parallelAsync({
		function(arg0)
			arg0:UpdateContent(arg1:GetDialogueForTicket(), 3, arg0)
		end,
		function(arg0)
			local var0 = arg0.loadedChar.spineAnimUI

			if not arg1:GotTicket() then
				setActive(arg0.giftTr, true)
				arg0:AddGiftEvent()
				var0:SetAction("activity_wait", 0)
			else
				setActive(arg0.giftTr, false)
				var0:SetActionCallBack(function(arg0)
					if arg0 == "finish" then
						var0:SetActionCallBack(nil)
						setActive(var0.gameObject, false)
						arg0()
					end
				end)
				var0:SetAction("activity_getletter", 0)
			end
		end
	}, function()
		if arg2 then
			arg2()
		end
	end)
end

function var0.Send(arg0)
	local var0 = arg0.feastShip

	arg0:emit(FeastMediator.GIVE_TICKET, var0.tid)
end

function var0.SetTipContent(arg0)
	arg0.tipTr.text = i18n("feast_drag_invitation_tip")
end

return var0
