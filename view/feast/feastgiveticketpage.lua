local var0_0 = class("FeastGiveTicketPage", import(".FeastGiveGiftPage"))

function var0_0.BindEvents(arg0_1)
	arg0_1.eventId = arg0_1:bind(FeastScene.ON_GOT_TICKET, function(arg0_2, arg1_2)
		arg0_1:OnGotGift(arg1_2)
	end)
end

function var0_0.OnGotGift(arg0_3, arg1_3)
	if arg0_3.feastShip then
		arg0_3:BlockEvents()
		seriesAsync({
			function(arg0_4)
				arg0_3:UpdateGiftState(arg0_3.feastShip, arg0_4)
			end,
			function(arg0_5)
				arg0_3:emit(BaseUI.ON_ACHIEVE, arg1_3, arg0_5)
			end,
			function(arg0_6)
				local var0_6 = arg0_3.feastShip:GetInvitationStory()

				pg.NewStoryMgr.GetInstance():Play(var0_6, arg0_6)
			end
		}, function()
			arg0_3:emit(FeastMediator.ON_SHIP_ENTER_FEAST, arg0_3.feastShip.id)
			arg0_3:emit(FeastScene.ON_BACK_FEAST)
		end)
	end
end

function var0_0.ClearBindEvents(arg0_8)
	if arg0_8.eventId then
		arg0_8:disconnect(arg0_8.eventId)

		arg0_8.eventId = nil
	end
end

function var0_0.LoadItem(arg0_9, arg1_9, arg2_9)
	GetSpriteFromAtlasAsync("ui/FeastInvitation_atlas", "res_icon", function(arg0_10)
		local var0_10 = arg0_9.giftTr:GetComponent(typeof(Image))

		var0_10.sprite = arg0_10

		var0_10:SetNativeSize()
		arg2_9()
	end)
end

function var0_0.UpdateGiftState(arg0_11, arg1_11, arg2_11)
	arg0_11:ClearGiftEvent()
	parallelAsync({
		function(arg0_12)
			arg0_11:UpdateContent(arg1_11:GetDialogueForTicket(), 3, arg0_12)
		end,
		function(arg0_13)
			local var0_13 = arg0_11.loadedChar.spineAnimUI

			if not arg1_11:GotTicket() then
				setActive(arg0_11.giftTr, true)
				arg0_11:AddGiftEvent()
				var0_13:SetAction("activity_wait", 0)
			else
				setActive(arg0_11.giftTr, false)
				var0_13:SetActionCallBack(function(arg0_14)
					if arg0_14 == "finish" then
						var0_13:SetActionCallBack(nil)
						setActive(var0_13.gameObject, false)
						arg0_13()
					end
				end)
				var0_13:SetAction("activity_getletter", 0)
			end
		end
	}, function()
		if arg2_11 then
			arg2_11()
		end
	end)
end

function var0_0.Send(arg0_16)
	local var0_16 = arg0_16.feastShip

	arg0_16:emit(FeastMediator.GIVE_TICKET, var0_16.tid)
end

function var0_0.SetTipContent(arg0_17)
	arg0_17.tipTr.text = i18n("feast_drag_invitation_tip")
end

return var0_0
