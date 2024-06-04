local var0 = class("GuildDonateCard")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.title = arg0._tf:Find("name"):GetComponent(typeof(Text))
	arg0.awardTF = arg0._tf:Find("item")
	arg0.awardTxtTF = arg0._tf:Find("item/Text")
	arg0.res = arg0._tf:Find("award/Text"):GetComponent(typeof(Text))
	arg0.commitBtn = arg0._tf:Find("submit")
end

function var0.update(arg0, arg1)
	arg0.dtask = arg1

	local var0 = arg1:getCommitItem()

	updateDrop(arg0.awardTF, {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	})

	arg0.title.text = arg1:getConfig("name")

	local var1 = arg0:GetResCntByAward(var0)
	local var2 = var0[3]

	setText(arg0.awardTxtTF, string.format(var1 < var2 and "<color=" .. COLOR_RED .. ">%s</color>/%s" or "%s/%s", arg0:WrapNum(var1), arg0:WrapNum(var2)))

	arg0.res.text = arg1:getConfig("award_contribution")
end

function var0.GetResCntByAward(arg0, arg1)
	if arg1[1] == DROP_TYPE_RESOURCE then
		return getProxy(PlayerProxy):getRawData():getResource(arg1[2])
	elseif arg1[1] == DROP_TYPE_ITEM then
		return getProxy(BagProxy):getItemCountById(arg1[2])
	else
		assert(false)
	end
end

function var0.WrapNum(arg0, arg1)
	if arg1 > 1000000 then
		return math.floor(arg1 / 1000000) .. "M"
	elseif arg1 > 1000 then
		return math.floor(arg1 / 1000) .. "K"
	end

	return arg1
end

function var0.Dispose(arg0)
	return
end

return var0
