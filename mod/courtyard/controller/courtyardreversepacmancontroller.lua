local var0_0 = class("CourtYardReversePacmanController", import(".CourtYardController"))

function var0_0.SetUp(arg0_1)
	var0_0.super.SetUp(arg0_1)
	arg0_1:AddChatTimer()
end

function var0_0.Dispose(arg0_2)
	arg0_2:RemoveChatTimer()
	var0_0.super.Dispose(arg0_2)
end

function var0_0.AddChatTimer(arg0_3)
	local var0_3 = math.random(CourtYardConst.REVERSE_PACMAN_CHAT_TIME[1], CourtYardConst.REVERSE_PACMAN_CHAT_TIME[2])

	arg0_3.chatTimer = Timer.New(function()
		local var0_4 = arg0_3:GetShipChat()

		if var0_4 == 0 then
			return
		end

		local var1_4 = pg.activity_chasing_character[var0_4]
		local var2_4 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var1_4.skin_id].ship_group).id
		local var3_4 = arg0_3.storey:GetShip(var2_4)

		if var3_4 then
			var3_4:ShowChatBubble()
		end
	end, var0_3, -1)

	arg0_3.chatTimer:Start()
end

function var0_0.GetShipChat(arg0_5)
	local var0_5 = {}
	local var1_5 = ReversePacmanTools.GetActivity()

	for iter0_5, iter1_5 in pairs(var1_5:GetFavorabilityList()) do
		table.insert(var0_5, iter0_5)
	end

	if #var0_5 <= 0 then
		return 0
	end

	return var0_5[math.random(1, #var0_5)]
end

function var0_0.RemoveChatTimer(arg0_6)
	if arg0_6.chatTimer then
		arg0_6.chatTimer:Stop()

		arg0_6.chatTimer = nil
	end
end

return var0_0
