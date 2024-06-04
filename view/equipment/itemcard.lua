local var0 = class("ItemCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.bg = findTF(arg1, "bg")
	arg0.countTF = findTF(arg1, "bg/icon_bg/count"):GetComponent(typeof(Text))
	arg0.nameTF = findTF(arg1, "bg/name"):GetComponent(typeof(Text))
	arg0.timeLimitTag = findTF(arg1, "bg/timeline")

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1)
	arg0.itemVO = arg1

	if not IsNil(arg0.timeLimitTag) then
		setActive(arg0.timeLimitTag, arg1:getConfig("time_limit") == 1 or Item.InTimeLimitSkinAssigned(arg1.id))
	end

	updateItem(rtf(arg0.bg), arg1)
	TweenItemAlphaAndWhite(arg0.go)

	arg0.countTF.text = arg1.count > 0 and arg1.count or ""
	arg0.nameTF.text = arg0:ShortenString(arg1:getConfig("name"), 6)
end

function var0.ShortenString(arg0, arg1, arg2)
	local var0 = 1
	local var1 = 0
	local var2 = 0
	local var3 = #arg1
	local var4 = false

	while var0 <= var3 do
		local var5 = string.byte(arg1, var0)
		local var6, var7 = GetPerceptualSize(var5)

		var0 = var0 + var6
		var1 = var1 + var7

		local var8 = math.ceil(var1)

		if var8 == arg2 - 1 then
			var2 = var0
		elseif arg2 < var8 then
			var4 = true

			break
		end
	end

	if var2 == 0 or var3 < var2 or not var4 then
		return arg1
	end

	return string.sub(arg1, 1, var2 - 1) .. ".."
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.dispose(arg0)
	return
end

return var0
