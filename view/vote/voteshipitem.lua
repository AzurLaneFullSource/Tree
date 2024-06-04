local var0 = class("VoteShipItem")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tf = arg1.transform
	arg0.icon = findTF(arg0.tf, "mask/icon")
	arg0.name = findTF(arg0.tf, "name/Text"):GetComponent("ScrollText")
	arg0.rank = findTF(arg0.tf, "Text"):GetComponent("RichText")
	arg0.riseNext = findTF(arg0.tf, "rise_next")
	arg0.riseResurgence = findTF(arg0.tf, "rise_resurgence")

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1, arg2)
	TweenItemAlphaAndWhite(arg0.go)

	if arg0.voteShip ~= arg1 then
		arg0.voteShip = arg1

		arg0:flush()
	end

	arg0.rank.text = arg0:wrapRankTxt(arg2 and arg2.rank)

	if not IsNil(arg0.riseNext) then
		setActive(arg0.riseNext, arg2 and arg2.riseFlag)
	end

	if not IsNil(arg0.riseResurgence) then
		setActive(arg0.riseResurgence, arg2 and arg2.resurgenceFlag)
	end
end

function var0.flush(arg0)
	LoadSpriteAsync("ShipYardIcon/" .. arg0.voteShip:getPainting(), function(arg0)
		if IsNil(arg0.icon) then
			return
		end

		setImageSprite(arg0.icon, arg0, false)
	end)

	if PLATFORM_CODE == PLATFORM_US then
		arg0.name:SetText(arg0.voteShip:getShipName())
	else
		setText(go(arg0.name), shortenString(arg0.voteShip:getShipName(), 5))
	end
end

local var1 = {
	"st",
	"nd",
	"rd"
}

function var0.wrapRankTxt(arg0, arg1)
	if arg1 and arg1 <= 3 then
		local var0 = var1[arg1]

		return string.format("<material=gradient from=#FF8c1c to=#ff0000 x=0 y=-1>%s<size=30>%s</size></material>", arg1, var0)
	else
		return ""
	end
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)
end

return var0
