local var0_0 = class("ItemCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.bg = findTF(arg1_1, "bg")
	arg0_1.countTF = findTF(arg1_1, "bg/icon_bg/count"):GetComponent(typeof(Text))
	arg0_1.nameTF = findTF(arg1_1, "bg/name"):GetComponent(typeof(Text))
	arg0_1.timeLimitTag = findTF(arg1_1, "bg/timeline")

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2)
	arg0_2.itemVO = arg1_2

	if not IsNil(arg0_2.timeLimitTag) then
		setActive(arg0_2.timeLimitTag, arg1_2:getConfig("time_limit") == 1 or Item.InTimeLimitSkinAssigned(arg1_2.id))
	end

	updateItem(rtf(arg0_2.bg), arg1_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	arg0_2.countTF.text = arg1_2.count > 0 and arg1_2.count or ""
	arg0_2.nameTF.text = arg0_2:ShortenString(arg1_2:getConfig("name"), 6)
end

function var0_0.ShortenString(arg0_3, arg1_3, arg2_3)
	local var0_3 = 1
	local var1_3 = 0
	local var2_3 = 0
	local var3_3 = #arg1_3
	local var4_3 = false

	while var0_3 <= var3_3 do
		local var5_3 = string.byte(arg1_3, var0_3)
		local var6_3, var7_3 = GetPerceptualSize(var5_3)

		var0_3 = var0_3 + var6_3
		var1_3 = var1_3 + var7_3

		local var8_3 = math.ceil(var1_3)

		if var8_3 == arg2_3 - 1 then
			var2_3 = var0_3
		elseif arg2_3 < var8_3 then
			var4_3 = true

			break
		end
	end

	if var2_3 == 0 or var3_3 < var2_3 or not var4_3 then
		return arg1_3
	end

	return string.sub(arg1_3, 1, var2_3 - 1) .. ".."
end

function var0_0.clear(arg0_4)
	ClearTweenItemAlphaAndWhite(arg0_4.go)
end

function var0_0.dispose(arg0_5)
	return
end

return var0_0
