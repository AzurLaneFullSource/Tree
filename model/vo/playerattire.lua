local var0_0 = class("PlayerAttire", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = arg1_1.display or {}

	arg0_1.icon = arg1_1.icon or var0_1.icon
	arg0_1.character = arg1_1.character or var0_1.character
	arg0_1.skinId = arg1_1.skin_id or var0_1.skin or 0

	if arg0_1.skinId == 0 then
		local var1_1 = pg.ship_data_statistics[arg0_1.icon]

		if var1_1 then
			arg0_1.skinId = var1_1.skin_id
		end
	end

	arg0_1.remoulded = false

	if arg1_1.remoulded and arg1_1.remoulded == 1 or var0_1.transform_flag and var0_1.transform_flag == 1 then
		arg0_1.remoulded = true
	end

	arg0_1.propose = arg1_1.propose and arg1_1.propose > 0 or var0_1.marry_flag and var0_1.marry_flag > 0
	arg0_1.proposeTime = arg1_1.propose or var0_1.marry_flag
	arg0_1.iconFrame = arg1_1.icon_frame or var0_1.icon_frame or 0
	arg0_1.chatFrame = arg1_1.chat_frame or var0_1.chat_frame or 0
	arg0_1.iconTheme = arg1_1.icon_theme or var0_1.icon_theme or 0
end

return var0_0
