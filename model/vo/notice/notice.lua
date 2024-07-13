local var0_0 = class("Notice", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.title = arg1_1.title
	arg0_1.content = arg1_1.content
	arg0_1.isRead = PlayerPrefs.GetInt(arg0_1:prefKey()) == 1
end

function var0_0.prefKey(arg0_2)
	return "notice" .. arg0_2.id
end

function var0_0.markAsRead(arg0_3)
	if not arg0_3.isRead then
		arg0_3.isRead = true

		PlayerPrefs.SetInt(arg0_3:prefKey(), 1)
		PlayerPrefs.Save()
	end
end

function var0_0.getUniqueCode(arg0_4)
	local var0_4 = (arg0_4.title or "*") .. arg0_4.id .. (arg0_4.content or "*")
	local var1_4 = string.len(var0_4)
	local var2_4 = math.min(10, var1_4)
	local var3_4 = math.floor(var1_4 / var2_4)
	local var4_4 = var1_4

	for iter0_4 = 1, var1_4, var3_4 do
		var4_4 = var4_4 + string.byte(var0_4, iter0_4)
	end

	return var4_4
end

return var0_0
