local var0_0 = class("PlayerAttire", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:Flush(arg1_1)
end

function var0_0.Flush(arg0_2, arg1_2)
	local var0_2 = arg1_2.display or {}

	arg0_2.icon = arg1_2.icon or var0_2.icon

	if arg1_2.character then
		arg0_2.characters = underscore.map(arg1_2.character, function(arg0_3)
			return arg0_3.key
		end)
		arg0_2.phantoms = underscore.map(arg1_2.character, function(arg0_4)
			return arg0_4.value
		end)
		arg0_2.character = arg0_2.characters[1]
		arg0_2.phantomId = arg0_2.phantoms[1] or 0
	end

	arg0_2.skinId = arg1_2.skin_id or var0_2.skin or 0

	if arg0_2.skinId == 0 then
		local var1_2 = pg.ship_data_statistics[arg0_2.icon]

		if var1_2 then
			arg0_2.skinId = var1_2.skin_id
		end
	end

	arg0_2.remoulded = false

	if arg1_2.remoulded and arg1_2.remoulded == 1 or var0_2.transform_flag and var0_2.transform_flag == 1 then
		arg0_2.remoulded = true
	end

	arg0_2.propose = arg1_2.propose and arg1_2.propose > 0 or var0_2.marry_flag and var0_2.marry_flag > 0
	arg0_2.proposeTime = arg1_2.propose or var0_2.marry_flag
	arg0_2.iconFrame = arg1_2.icon_frame or var0_2.icon_frame or 0
	arg0_2.chatFrame = arg1_2.chat_frame or var0_2.chat_frame or 0
	arg0_2.iconTheme = arg1_2.icon_theme or var0_2.icon_theme or 0
end

return var0_0
