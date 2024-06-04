local var0 = class("Notice", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.title = arg1.title
	arg0.content = arg1.content
	arg0.isRead = PlayerPrefs.GetInt(arg0:prefKey()) == 1
end

function var0.prefKey(arg0)
	return "notice" .. arg0.id
end

function var0.markAsRead(arg0)
	if not arg0.isRead then
		arg0.isRead = true

		PlayerPrefs.SetInt(arg0:prefKey(), 1)
		PlayerPrefs.Save()
	end
end

function var0.getUniqueCode(arg0)
	local var0 = (arg0.title or "*") .. arg0.id .. (arg0.content or "*")
	local var1 = string.len(var0)
	local var2 = math.min(10, var1)
	local var3 = math.floor(var1 / var2)
	local var4 = var1

	for iter0 = 1, var1, var3 do
		var4 = var4 + string.byte(var0, iter0)
	end

	return var4
end

return var0
