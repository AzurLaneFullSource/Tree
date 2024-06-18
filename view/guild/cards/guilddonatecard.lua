local var0_0 = class("GuildDonateCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.title = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.awardTF = arg0_1._tf:Find("item")
	arg0_1.awardTxtTF = arg0_1._tf:Find("item/Text")
	arg0_1.res = arg0_1._tf:Find("award/Text"):GetComponent(typeof(Text))
	arg0_1.commitBtn = arg0_1._tf:Find("submit")
end

function var0_0.update(arg0_2, arg1_2)
	arg0_2.dtask = arg1_2

	local var0_2 = arg1_2:getCommitItem()

	updateDrop(arg0_2.awardTF, {
		type = var0_2[1],
		id = var0_2[2],
		count = var0_2[3]
	})

	arg0_2.title.text = arg1_2:getConfig("name")

	local var1_2 = arg0_2:GetResCntByAward(var0_2)
	local var2_2 = var0_2[3]

	setText(arg0_2.awardTxtTF, string.format(var1_2 < var2_2 and "<color=" .. COLOR_RED .. ">%s</color>/%s" or "%s/%s", arg0_2:WrapNum(var1_2), arg0_2:WrapNum(var2_2)))

	arg0_2.res.text = arg1_2:getConfig("award_contribution")
end

function var0_0.GetResCntByAward(arg0_3, arg1_3)
	if arg1_3[1] == DROP_TYPE_RESOURCE then
		return getProxy(PlayerProxy):getRawData():getResource(arg1_3[2])
	elseif arg1_3[1] == DROP_TYPE_ITEM then
		return getProxy(BagProxy):getItemCountById(arg1_3[2])
	else
		assert(false)
	end
end

function var0_0.WrapNum(arg0_4, arg1_4)
	if arg1_4 > 1000000 then
		return math.floor(arg1_4 / 1000000) .. "M"
	elseif arg1_4 > 1000 then
		return math.floor(arg1_4 / 1000) .. "K"
	end

	return arg1_4
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
