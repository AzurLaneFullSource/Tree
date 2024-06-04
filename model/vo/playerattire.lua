local var0 = class("PlayerAttire", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	local var0 = arg1.display or {}

	arg0.icon = arg1.icon or var0.icon
	arg0.character = arg1.character or var0.character
	arg0.skinId = arg1.skin_id or var0.skin or 0

	if arg0.skinId == 0 then
		local var1 = pg.ship_data_statistics[arg0.icon]

		if var1 then
			arg0.skinId = var1.skin_id
		end
	end

	arg0.remoulded = false

	if arg1.remoulded and arg1.remoulded == 1 or var0.transform_flag and var0.transform_flag == 1 then
		arg0.remoulded = true
	end

	arg0.propose = arg1.propose and arg1.propose > 0 or var0.marry_flag and var0.marry_flag > 0
	arg0.proposeTime = arg1.propose or var0.marry_flag
	arg0.iconFrame = arg1.icon_frame or var0.icon_frame or 0
	arg0.chatFrame = arg1.chat_frame or var0.chat_frame or 0
	arg0.iconTheme = arg1.icon_theme or var0.icon_theme or 0
end

return var0
