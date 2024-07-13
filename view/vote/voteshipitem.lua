local var0_0 = class("VoteShipItem")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.icon = findTF(arg0_1.tf, "mask/icon")
	arg0_1.name = findTF(arg0_1.tf, "name/Text"):GetComponent("ScrollText")
	arg0_1.rank = findTF(arg0_1.tf, "Text"):GetComponent("RichText")
	arg0_1.riseNext = findTF(arg0_1.tf, "rise_next")
	arg0_1.riseResurgence = findTF(arg0_1.tf, "rise_resurgence")

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	if arg0_2.voteShip ~= arg1_2 then
		arg0_2.voteShip = arg1_2

		arg0_2:flush()
	end

	arg0_2.rank.text = arg0_2:wrapRankTxt(arg2_2 and arg2_2.rank)

	if not IsNil(arg0_2.riseNext) then
		setActive(arg0_2.riseNext, arg2_2 and arg2_2.riseFlag)
	end

	if not IsNil(arg0_2.riseResurgence) then
		setActive(arg0_2.riseResurgence, arg2_2 and arg2_2.resurgenceFlag)
	end
end

function var0_0.flush(arg0_3)
	LoadSpriteAsync("ShipYardIcon/" .. arg0_3.voteShip:getPainting(), function(arg0_4)
		if IsNil(arg0_3.icon) then
			return
		end

		setImageSprite(arg0_3.icon, arg0_4, false)
	end)

	if PLATFORM_CODE == PLATFORM_US then
		arg0_3.name:SetText(arg0_3.voteShip:getShipName())
	else
		setText(go(arg0_3.name), shortenString(arg0_3.voteShip:getShipName(), 5))
	end
end

local var1_0 = {
	"st",
	"nd",
	"rd"
}

function var0_0.wrapRankTxt(arg0_5, arg1_5)
	if arg1_5 and arg1_5 <= 3 then
		local var0_5 = var1_0[arg1_5]

		return string.format("<material=gradient from=#FF8c1c to=#ff0000 x=0 y=-1>%s<size=30>%s</size></material>", arg1_5, var0_5)
	else
		return ""
	end
end

function var0_0.clear(arg0_6)
	ClearTweenItemAlphaAndWhite(arg0_6.go)
end

return var0_0
